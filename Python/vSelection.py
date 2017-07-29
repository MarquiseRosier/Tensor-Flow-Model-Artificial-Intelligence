from sklearn.linear_model import LogisticRegression
from sklearn.linear_model import LogisticRegressionCV
from sklearn.linear_model import LassoLarsCV
from sklearn.feature_selection import SelectFromModel
from sklearn.preprocessing import StandardScaler
from multiprocessing import Process
import matplotlib.pyplot as plt
import numpy as np 
import sklearn as sk


def read_data(Xname, Yname):
	X = np.loadtxt(Xname);
	Y = np.loadtxt(Yname);
	return X, Y;

X, Y = read_data('../arcene/arcene_train.data', '../arcene/arcene_train.labels');
Xvalid, Yvalid = read_data('../arcene/arcene_valid.data', '../arcene/arcene_valid.labels');

#Scale Data!
X = StandardScaler().fit_transform(X);
Xvalid = StandardScaler().fit_transform(Xvalid);

print(X);


def run(k):
	i = 0;
	j = 0;
	mlist = [];

	i=1
	while i <= 10:
		print i;
		LogReg = LogisticRegression(C=10, max_iter=i, n_jobs=-1, penalty="l2", solver='sag');
		print(LogReg.fit(X,Y));
		train_error = 1 - LogReg.score(X, Y);
		test_error = 1 - LogReg.score(Xvalid, Yvalid);
		print('Test Error: ', test_error);
		print('Train Error: ', train_error);
		mlist.insert((i-1), train_error);
		i=i+1;

	mnp = np.array(mlist);
	plt.title('Error vs Iterations')
	axes = plt.gca();
	axes.set_ylim([min(mnp), max(mnp)]);
	plt.plot(np.arange(10)+1, mnp, 'b-',
	    label='Error Line');
	plt.legend(loc='upper right');
	plt.xlabel('Iterations');
	plt.ylabel('Misclassification Error');
	plt.show();
	pass;

run(5);