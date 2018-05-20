#Import Important Libs
import tensorflow as tf
import numpy as np 
import matplotlib.pyplot as plt
#from tensorflow.examples.tutorials.mnist import input_data
import time
#mnist = input_data.read_data_sets("MNIST_data/", one_hot=True)

#Set The value of the parameters..

learning_rate = 0.02;
epochs = 20;
batch_size = 400;
num_batches = 145600/batch_size;
input_height = 28;
input_width = 28;
n_classes = 26;
dropout = 0.4;
display_step = 1;
filter_height = 7;
filter_width = 7;
depth_in = 1; #Because this is a grayscale image with one color channel
depth_out1 = 128; #We want to output 64 feature maps 
depth_out2 = 259; 
depth_out3 = 256;
depth_out4 = 512;
#We take in 64 feature maps and want to connect them via 
#weights of filters...to 128 feature maps...so we pass 128
#filters on the 64 feature maps....which are all probably

##Decode Images Function
def decode_image(image):
	image = tf.decode_raw(image, tf.uint8);
	image = tf.cast(image, tf.float32);
	image = tf.reshape(image, [784]);
	return image / 255.0;

def decode_labels(label):
	label = tf.decode_raw(label, tf.uint8);
	label = tf.reshape(label, []);
	return tf.one_hot(label,26);


#Input Output Definition..
CNN1 = tf.Graph();

with CNN1.as_default():

	x = tf.placeholder(dtype=tf.float32, shape=[None, 28*28]);
	#Here we see the dimensionality of the images is
	#Dynamic in the dimension regarding dataset size...
	#But 28*28 in the column direction..every pixel is a feature


	y = tf.placeholder(dtype=tf.float32, shape=[None, n_classes]);
	#Y is dynamic in the size dimension...regarding how many of 
	#Y there are..this actually corresponds to X's size in this 
	#dimension but we don't have X as it is dynamic. 
	#Something interesting is that there are n_classes columns
	#I believe this represents probabilities as the output of 
	#the neural network is a multiclass softmax...which 
	#would output probabilities of this class being the chosen
	#one...based on the input...

	keep_prob = tf.placeholder(dtype=tf.float32);
	'''This defines the dropout percentage'''

	#store the weights
	#number of weights of filters to be learned in 'wc1'
	#filter_height, filter_width, depth_in*depth_out1...
	#filter_height, filter_width, depth_out1*depth_out2

	max_pool_window_size = 2;
	max_pool_reduction = 1/(max_pool_window_size**2);
	new_img_size = int(max_pool_reduction*input_height*input_width*depth_out2*1024);

	#####Remember here theses are merely the filter weights!! These are not the exact same
	#####Dimensions as the data array....it is smaller...and the 64 filters are passed
	#####On the dataarray....then with that poor accuracy...adjusted...thus...it creates
	#####the best set of weights that when convolved with the image..gives the best accuracy
	#####By converging to the minima of the cost function...using minibatch gradient descent..
	#####allows us to escape local minima by adjusting the gradient...mostly in the direction of
	#####The global...this is because it has a bigger bastian of attraction...points start heading
	#####towards it from far away on the graph...So most of the batches will push us towards the global..
	'''weights = {'wc1' : tf.Variable(tf.random_normal([filter_height, filter_width, depth_in, depth_out1])),
			   'wc2' : tf.Variable(tf.random_normal([filter_height, filter_width, depth_out1, depth_out2])), 
			   'wd1' : tf.Variable(tf.random_normal([int((input_height/4)*(input_height/4)* depth_out2),1024])),
			   'out' : tf.Variable(tf.random_normal([1024, n_classes]))
			   };

	#bias definitions...first convolutional layer has 64 biases
	#I'm guessing using tensorflwo operations..scales the bias by however
	#many is necessary to be added to the weights!
	biases = {'bc1' : tf.Variable(tf.random_normal([128])),
			  'bc2' : tf.Variable(tf.random_normal([259])),
			  'bd1' : tf.Variable(tf.random_normal([1024])),
			  'out' : tf.Variable(tf.random_normal([n_classes]))
			  };
	'''

	images = tf.data.FixedLengthRecordDataset("C:/local/gzip/emnist-letters-train-images-idx3-ubyte", 28*28, header_bytes=16).map(decode_image);
	labels = tf.data.FixedLengthRecordDataset("C:/local/gzip/emnist-letters-train-labels-idx1-ubyte", 1, header_bytes=8).map(decode_labels);

	zippedSet = tf.data.Dataset.zip((images, labels));

	imagecache = zippedSet.cache().shuffle(buffer_size=145600).batch(300).repeat(1);
	image_iterator = zippedSet.make_one_shot_iterator();

#####
#Create Different Layers

def conv2d(x, filters, kernel_size=7, strides=1):
	x = tf.layers.conv2d(x, filters, kernel_size, strides, padding="same", trainable=True);
	return x;
def maxpool(x, strides=2):
	return tf.layers.max_pooling2d(x, pool_size=2, strides=2, padding='same');

def conv_net(x, dropout):
	'''
	Reshape input in the 4 dimensional image
	1st dimension = image index
	2nd dimension = height
	3rd dimension = width
	4th dimension = depth
	tf.reshape(-1, ) << infers the first dimension based on the second dimension...
	Because no matter the reshape, the same number of elements must be in the 
	reshaped array as was in the array before the dimensional transformation..

	'''
	x = tf.reshape(x, [-1, 28, 28, 1]);
	print("SHAPE OF X IS: ", np.shape(x));
	print("Shape of Y IS: ", np.shape(y));
#Convolutional Layer 1
	conv1 = conv2d(x, 64);
	conv1 = maxpool(conv1);

#Convolutional Layer 2
	conv2 = conv2d(conv1, 128);
	conv2 = maxpool(conv2);
#Convolutional Layer 3
	conv3 = conv2d(conv2, 256);
	conv3 = conv2d(conv3, 256);
	conv3 = maxpool(conv3);

#Now Comes the fully connected layer
	fc1 = tf.layers.dense(conv3, 1024, activation=tf.nn.relu);

#Apply Dropout
	fc1 = tf.layers.dropout(fc1, dropout);

#Output Class Prediction
	output = tf.layers.dense(fc1, 26);
	return output, conv1, conv2, conv3, fc1;

#Confine these ops to one graph for ensemble learning in the 
#future

with CNN1.as_default():

	pred, co1, co2, co3, fc11 = conv_net(x, keep_prob);

	print(np.shape(pred));

	#define loss function and optimizer
	cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits=pred, labels=y));
	optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost);

	#Evaluate Model
	correct_pred = tf.equal(tf.argmax(pred[1],0), tf.argmax(y[1],0));
	accuracy = tf.reduce_mean(tf.cast(correct_pred, tf.float32));

	init = tf.global_variables_initializer();

	CNN1Sess = tf.Session(graph=CNN1);

	filewriter = tf.summary.FileWriter("logs", CNN1Sess.graph);

	#Start Getting Data One by One

	image_op, label_op = image_iterator.get_next();

npdatacontainer = np.zeros((int(num_batches), batch_size,784));
nplabelcontainer = np.zeros((int(num_batches), batch_size, n_classes));


for index1 in range(int(num_batches)):
	for index2 in range(batch_size):
		try:
			curr_image, curr_label = CNN1Sess.run([image_op, label_op]);
			npdatacontainer[index1, index2] = curr_image;
			nplabelcontainer[index1, index2] = curr_label;
		except tf.errors.OutOfRangeError:
			break;


print(np.shape(npdatacontainer))
print(np.shape(nplabelcontainer))
CNN1Sess.run(init);

for i in range(epochs):
	for j in range(int(num_batches)):
		opt, c1, c2, c3, fc = CNN1Sess.run([pred, co1, co2, co3, fc11], feed_dict={x:npdatacontainer[j], y:nplabelcontainer[j], keep_prob:dropout});
		print(np.shape(opt));
		loss, acc = CNN1Sess.run([cost, accuracy], feed_dict={x:npdatacontainer[j], y:nplabelcontainer[j], keep_prob: 1});
		#print("Accuracy: " '%00f' % (acc));
		print(np.shape(c1));
		print(np.shape(c2));
		print(np.shape(c3));
		print(np.shape(fc));
		print(np.shape(opt));

#y1 = sess.run(pred,feed_dict={x:mnist.test.images[:256],keep_prob: 1})
#test_classes = np.argmax(y1,1)
#print('Testing Accuracy:',sess.run(accuracy,feed_dict={x:mnist.test.
#images[:256],y:mnist.test.labels[:256],keep_prob: 1}))
#f, a = plt.subplots(1, 10, figsize=(10, 2))
#for i in range(10):
#	a[i].imshow(np.reshape(mnist.test.images[i],(28, 28)))
#	print(test_classes[i])	
