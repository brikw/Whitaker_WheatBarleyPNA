CV <- function(x) {
    x1 <- na.omit(x)
    MEAN <- mean(x1)
    SD <- sd(x1)
    CV <- MEAN/SD
    CV
}
myMEAN <- function(x) {
    x1 <- na.omit(x)  #number of omitted values length(attr(test,"na.action"))
    MEAN <- mean(x1)
}
mySD <- function(x) {
    x1 <- na.omit(x)  #number of omitted values length(attr(test,"na.action"))
    SD <- sd(x1)
}

myREP <- function(x) {
    x1 <- na.omit(x)  #number of omitted values length(attr(test,"na.action"))
    REP <- length(x1) #number of values used in mean
}