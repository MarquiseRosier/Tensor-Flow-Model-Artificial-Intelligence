#load relevant libraries
library(pixmap)
library(reshape2)

file_names = list.files(path="C:\\Users\\thelaughingman\\Documents\\RCode\\faces\\", pattern="*.pgm")
index = 0
matlist = list()



for(i in file_names)
{
	tempPixMap = read.pnm(file=paste("C:\\Users\\thelaughingman\\Documents\\RCode\\faces\\", i, sep=""))
	pixMat = getChannels(tempPixMap)
	matlist[[length(matlist)+1]] = as.list(pixMat)
}

matMatrix <- matrix(unlist(matlist), ncol=2429)

face.pca <- prcomp(matMatrix)

eig <- (faces.pca$sdev)^2
variance <- eig*100/sum(eig)
cumvar <- cumsum(variance)

eig.decathlon2.active <- data.frame(eig=eig, variance=variance, cumvariance=cumvar)
head(eig.decathlon2.active)

numericInformationMatrix = face.pca$x
dim(numericInformationMatrix)
summary(face.pca)

sDevList = sort(face.pca$sdev)

png(filename="plotA.png")
plot(sDevList[1:359]^2, ylab="Variance", xlab="PC")
dev.off()

png(filename="plotB.png")
par(mfrow=c(2,1))
plot(face.pca$rotation[,3], ylab="Values in PC[3,1-361]", xlab="PC")
plot(face.pca$rotation[,4], col=("red"), ylab="Values in PCs[4,1-361]", xlab="PC")
dev.off()

par(mfcol=c(1,2), mar=c(1,1,2,1))
im <- matrix(data=rev(matMatrix[2,]), nrow=19, ncol=19)
image(1:19, 1:19, im, col=gray((0:255)/255))
restr <- face.pca$x[,1:20] %*% t(face.pca$rotation[,1:20])

rst <- matrix(data=rev(restr[2,]), nrow=19, ncol=19)
image(1:19, 1:19, rst, col=gray((0:255)/255))

file_names = list.files(path="C:\\Users\\thelaughingman\\Documents\\RCode\\background\\", pattern="*.pgm")

for(i in file_names)
{
	tempPixMap = read.pnm(file=paste("C:\\Users\\thelaughingman\\Documents\\RCode\\background\\", i, sep=""))
	pixMat = getChannels(tempPixMap)
	matlist[[length(matlist)+1]] = as.list(pixMat)
}

matBMatrix <- matrix(unlist(matlist), ncol=2429)

b.pca <- prcomp(matBMatrix)

png(filename="plotC.png")
plot(face.pca$rotation[,3], ylab="Values in PC[3,1-361]", xlab="PC")
points(b.pca$rotation[,3], col=("red"))
dev.off()

png(filename="plotC2.png")
plot(face.pca$rotation[,4], ylab="Values in PC[4,1-361]", xlab="PC")
points(b.pca$rotation[,4], col=("red"))
dev.off()

png(filename="plotD1.png")
plot(face.pca$rotation[,1], ylab="Values in PC[1]", xlab="PC")
points(b.pca$rotation[,1], col=("red"))
dev.off()

png(filename="plotD2.png")
plot(face.pca$rotation[,2], ylab="Values in PC[2]", xlab="PC")
points(b.pca$rotation[,2], col=("red"))
dev.off()

