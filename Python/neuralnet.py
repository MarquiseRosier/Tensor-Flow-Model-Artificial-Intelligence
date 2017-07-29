#!/bin/bash/python

import tensorflow as tf
import numpy as np

#BINARY CLASSIFICATION CASE
def read_data(Xname, Yname):
	X = np.loadtxt(Xname, dtype=np.float32);
	Y = np.loadtxt(Yname, dtype=np.float32);
	return X, Y;

Xd, Yd = read_data('../arcene/arcene_train.data', '../arcene/arcene_train.labels');

X = Xd;
Y = Yd;

print(X);
print(Y);

k = 256;

xShape = list(X.shape);
XinputShape = list(X.shape);
YinputShape = list(Y.shape);
xShape.reverse();
xShape.pop();
xShape.insert(1, k);
xShape = np.array(xShape);
yShape = list(Y.shape);
yShape.insert(1, k);
print(yShape);
reshapeofY = np.transpose(np.tile(Y, (k, 1)));
#Create Variable in TensorFlowGraph
Weights = tf.Variable(tf.ones(xShape));
B = tf.Variable(tf.ones(yShape));

def inputs():
	return tf.to_float(Xd), tf.to_float(Yd);

def handleOnGraph():
	return tf.get_default_graph();

def combine(input_data):
	return tf.matmul(input_data, Weights) + B;

def inference(input_data):
	return tf.tanh(tf.nn.relu(combine(input_data)));

def total_loss(input_data, input_labels):
	return tf.reduce_mean(tf.nn.sigmoid_cross_entropy_with_logits(combine(input_data), reshapeofY));

def train(total_loss):
	learning_rate = 0.0001;
	return tf.train.AdagradOptimizer(learning_rate).minimize(total_loss);
#MULTICLASS CASE
class MultiClass:
	MultiGraph = tf.Graph();
	with MultiGraph.as_default():

		def __init__(self,data, labels):
			self._X = data;
			self._Y = labels;
			pass;

		def returnDimensions(self):
			return X.shape;

		pass;

with tf.Session() as sess:
	tf.initialize_all_variables().run();

	print(Xd.shape);
	print(Yd.shape);

	input_data, input_labels = inputs();

	loss = total_loss(input_data, input_labels);
	train_op = train(loss);

	print(sess.run(inference(input_data)));

	coord = tf.train.Coordinator();
	threads = tf.train.start_queue_runners(sess=sess, coord=coord);

	for i in range(300):
		sess.run([train_op]);
		#for debugging
		if i % 10 == 0:
			print "loss: ", sess.run([loss]);

	print(sess.run(inference(input_data)));
	print(sess.run(Weights));

	coord.request_stop();
	coord.join(threads);
	sess.close();
		
