library(mixOmics)
library(RCurl)
library(bitops)
library(DiscriMiner)

input <- function(inputfile) {
  parameters <- read.table(inputfile, as.is=T);
  rownames(parameters) <- parameters[,1]
  
  metabolime <- read.csv(toString(parameters["samples",2]), header = F)

  obs_names=as.matrix(read.table(toString(parameters["categories", 2])))
  var_ID<<-as.matrix(read.table(toString(parameters["observables", 2])))
  #colnames(metabolime) <- obs_names
  rownames(metabolime) <- var_ID
  metabolime <- as.data.frame(t(metabolime))
  metabolime$obs_names<-as.factor(obs_names)


  names=levels(metabolime$obs_names)
  ind_total=c()
  for (j in 1:(length(names)-1)) {
  
    sub_met=metabolime[which(metabolime$obs_names==names[j]),]
  
    col_var=c()
    for(i in 1:(dim(sub_met)[2]-1)){
      col_var[i]=var(sub_met[,i])
    }
  
    ind=which(col_var<=0.01)
    ind_total=union(ind_total,ind)
  }

  metabolime=metabolime[,-ind_total]
  #print(metabolime)
  testers = read.delim(toString(parameters["targets", 2]), header=F, sep='\n', as.is=T)
  testindex=c()
  for (i in 1:length(testers[,1])) {
     testindex = c(testindex, which(metabolime$obs_names==testers[i,1]))
  }
  test = metabolime[testindex,] 
  X <<- subset(test,select = -obs_names)
  #print(X)
  Y <<- as.character(test$obs_names)
}

run <- function() {
   plsda.metabolite <<- plsda(X, Y, ncomp = 3)
   #print(plsda.metabolite)
   my_pls1 <<- plsDA(X, Y, autosel=FALSE, comps=2)
   #print(levels(my_pls1$classification))
   VIP <<- names(which(my_pls1$VIP[,2]>1))
}

output <- function(outputfile) {
   write.csv(VIP, paste(outputfile, ".VIP.csv", sep=""))
   x <- my_pls1$functions
   #print(nrow(x))
   #print(length(c("INTERCEPT", var_ID)))
   rownames(x) <- c("INTERCEPT", colnames(X))
   colnames(x) <- levels(my_pls1$classification)
   write.csv(x, paste(outputfile, ".functions.csv", sep=""))
   #print(my_pls1$scores)
   #print(str(my_pls1$scores))
   y <- my_pls1$scores
   colnames(y) <- levels(my_pls1$classification)
   write.csv(y, paste(outputfile, ".scores.csv", sep=""))
   #write.csv(my_pls1$scores, paste(outputfile, ".scores.csv", sep=""))

  # plotIndiv(plsda.metabolite, ind.names = F,
  #        add.legend =TRUE, plot.ellipse = TRUE,
  #        ellipse.level = 0.5, blocks = "lipid", main = 'PLSDA',
  #        plot.star = TRUE, plot.centroid = TRUE,style='3d')
}
