import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import threading as td
import multiprocessing as pc
from sklearn.ensemble import GradientBoostingClassifier as GBC
import sklearn.metrics as skm
from sklearn.cross_validation import cross_val_score
import math as m

def loadFiles(dataFile, labelFile):
    x = np.loadtxt(dataFile);
    y = np.loadtxt(labelFile);
    datasetList = [];
    datasetList.insert(0, x);
    datasetList.insert(1,y);
    return datasetList;

dList = loadFiles("../dexter/dexter_train.data", "../dexter/dexter_train.labels");
dListTest = loadFiles("../dexter/dexter_test.data", "../dexter/dexter_valid.data");
fileOps = open("outputHill.txt", "w");

#This is where we will load a gbr Instance and run a model on our data with 300 iteration#s or trees!

clf = GBC(loss='deviance', n_estimators=300);

clf.fit(dList[0], dList[1]);

#Graph Training Loss by Iterations
#Save Graph to Image for later use.
params={'n_estimators' : 300}

plt.figure(figsize=(12,6));
plt.subplot(1, 2, 1);
plt.title('Deviance')
plt.plot(np.arange(params['n_estimators']) + 1, clf.train_score_, 'b-',
    label='Training Set Deviance');
plt.legend(loc='upper right');
plt.xlabel('Boosting Iterations');
plt.ylabel('Deviance');
plt.show();

#print(clf.train_score_);

#This is part B of the project,
#produce misclassification errors
# with k={10,30,100,300}
clftrain10 = GBC(loss='deviance', n_estimators=10);
clftrain30 = GBC(loss='deviance', n_estimators=30);
clftrain100 = GBC(loss='deviance', n_estimators=100);
clftrain300 = GBC(loss='deviance', n_estimators=300);

clftrain10.fit(dList[0], dList[1]);
clftrain30.fit(dList[0], dList[1]);
clftrain100.fit(dList[0], dList[1]);
clftrain300.fit(dList[0], dList[1]);

clftrainList = [clftrain10, clftrain30, clftrain100, clftrain300];
auc_score_train_List = [];
auc_score_test_List = [];
counter1=0;
for i in clftrainList:
    auc_score_train_List.append(1-cross_val_score(estimator=i, X=dList[0], y=dList[1], cv=5, scoring='roc_auc').mean());
    print("Without Depth Training: ", auc_score_train_List);
for i in clftrainList:
    auc_score_test_List.append(1-cross_val_score(estimator=i, X=dListTest[0], y=i.predict(dListTest[0]), scoring='roc_auc').mean());  
    print("Without Depth Testing: ", auc_score_test_List);
    counter1=counter1+1;
############
############
#y_pred = clf.predict(dList[0]);
#print(skm.classification_report(dList[1],y_pred));
############
############

#Part C
clfDepth5 = GBC(loss='deviance', n_estimators=300, max_depth=5);
clfDepth5.fit(dList[0], dList[1]);

plt.figure(figsize=(12,6));
plt.subplot(1, 2, 1);
plt.title('Deviance')
plt.plot(np.arange(params['n_estimators']) + 1, clfDepth5.train_score_, 'r-',
    label='Training Set Depth 5');
plt.legend(loc='upper right');
plt.xlabel('Boosting Iterations');
plt.ylabel('Deviance');
plt.show();

clfWithDepthtrain10 = GBC(loss='deviance', n_estimators=10, max_depth=5);
clfWithDepthtrain30 = GBC(loss='deviance', n_estimators=30, max_depth=5);
clfWithDepthtrain100 = GBC(loss='deviance', n_estimators=100, max_depth=5);
clfWithDepthtrain300 = GBC(loss='deviance', n_estimators=300, max_depth=5);

clfWithDepthtrain10.fit(dList[0], dList[1]);
clfWithDepthtrain30.fit(dList[0], dList[1]);
clfWithDepthtrain100.fit(dList[0], dList[1]);
clfWithDepthtrain300.fit(dList[0], dList[1]);

clfWithDepthtrainList = [clfWithDepthtrain10, clfWithDepthtrain30, clfWithDepthtrain100, clfWithDepthtrain300];

auc_score_Depthtrain_List = [];
auc_score_Depthtest_List = [];

counter=0;

for i in clfWithDepthtrainList:
    auc_score_Depthtrain_List.append(1-cross_val_score(estimator=i, X=dList[0], y=dList[1], scoring='roc_auc').mean());
    print("With Depth Training: ", auc_score_Depthtrain_List);
for i in clfWithDepthtrainList:
    auc_score_Depthtest_List.append(1-cross_val_score(estimator=i, X=dListTest[0], y=i.predict(dListTest[0]), scoring='roc_auc').mean());
    print("With Depth Testing: ", auc_score_Depthtest_List);
    counter=counter+1;


plt.figure(figsize=(12,12));
plt.subplot(1, 2, 1);
plt.title('Misclassificaton Vs Iterations')
plt.plot(np.array([10,30,100,300]), np.array(auc_score_Depthtrain_List), 'r-',
    label='Training Depth 5');
plt.plot(np.array([10,30,100,300]), np.array(auc_score_Depthtest_List), 'b-',
    label='Testing Depth 5');
plt.plot(np.array([10,30,100,300]), np.array(auc_score_test_List), 'm-',
    label='Testing');
plt.plot(np.array([10,30,100,300]), np.array(auc_score_train_List), 'y-',
    label='Training');
plt.legend(loc='upper right');
plt.xlabel('Boosting Iterations');
plt.ylabel('Misclassification Rate');
plt.show();
