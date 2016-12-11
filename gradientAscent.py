import numpy as np 
from sklearn.linear_model import LogisticRegression 
import pandas as pd 

def read_data(file1, file2):
	x = np.loadtxt(file1);
	y = np.loadtxt(file2);
	return x, y;

def loglike(X, Y, weights):
	lin = np.dot(X, weights);
	hyp = (1.)/(1 + np.exp(-1*lin));
	first = Y*np.log(hyp);
	second = (1 - Y)*np.log(1-hyp);

	return np.sum(first+second);
	
def log_reg(X, Y, learningr, shrinkage, iterations, model):
	model.fit(X, Y);
	weights = np.array([1]*n, 'float');
	lin = np.dot(X, weights);subl
	hyp = (1.)/(1 + np.exp(-1*lin));
	print(hyp);
	
	threshold = (np.amax(Y) + np.amin(Y))/2;
	
	iter = 0; 
	lik_list = [];
	totalCorrect = 0;
	size = list[lin.shape];
	
	for i in range(size):
		if(lin[i] > threshold):
			totalCorrect=totalCorrect+1;

	while(iter < iterations):
		for j in range(m):
			model.fit(X,Y);
			weights = weights - learningr*shrinkage*weights + learningr*(Y[j] - hyp[j])*X[j,:];
			negLog = loglike(X, Y, weights);
			print (negLog);
			lik_list.append(negLog);
		iter+=1;
	print(weights.shape);
	print(X[1,:].shape)
	
	plt.plot((np.arange(iterations)+1), lik_list);
    plt.xlabel('iteration number')
    plt.ylabel('negative log-likelihood')
    plt.savefig('image/'+image_name + str(lam).replace(".", "") +'.eps')
    plt.clf()
            
	return model, totalCorrect;

X, Y = read_data('../arcene/arcene_train.data', '../arcene/arcene_train.labels');
LRModel = LogisticRegression(max_iter=1, n_jobs=-1);


modelA, totalCorrect = log_reg(X, Y, 3, 4, 5);
Yshape = list[Y.shape];


misclassification_error = totalCorrect/Yshape[0];



