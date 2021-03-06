setwd("D:/Rfiles/tetfig1")
library(vegan)
library(permute)
library(lattice)
library(ggplot2)
library(reshape2)    #用于排列数据

##Species
#数据读取
species <- read.csv("species.csv", header = T, row.names = 1, sep = ",")
group <- read.csv("group.csv", sep = ",", header = T)
g <- group$group
#调整数据布局
species$ID <- factor(rownames(species), levels = rev(rownames(species)))
colnames(species) <- factor(colnames(species), levels = colnames(species))
species <- melt(species, id = 'ID')
#添加分组
names(group)[1] <- 'variable'
species <- merge(species, group, by = 'variable')
cols <- c("#447B66","#96CCA8","#C0EEDA","#CBD589","#86A845","#B3C648",
          "#FED46E","#FFDF6F","#F4D160","#8AC4D0","#58A3BC","#3E83A8",
          "#28527A","#134080","#1D6590","#A8D4E0","#537496","#55A6CB",
          "#A378B5","#766092","#DAB3DA","#D986B1","#F2A6C2","#FBC1AD",
          "#EF978F","#EFC2AD","#F56E4A","#F56E60","#F56E78","#808080")
p  <- ggplot(species, aes(variable, 100 * value, fill = ID)) +
  geom_col(position = 'stack', width = 0.6) +
  labs(x = '', y = 'Relative Abundance(%)') +
  theme(axis.text = element_text(size = 12, angle = 90), axis.title = element_text(size = 13)) +
  theme(legend.text = element_text(size = 9, ncol(1)),legend.key.size=unit(0.2,'cm', ncol(1)))+
  scale_fill_manual(values =  rev(cols)) +
  theme(panel.grid = element_blank(), panel.background = element_rect(color = 'black', fill = 'transparent')) +
  theme(legend.title = element_blank())+facet_wrap(~group, scales = 'free_x', ncol = 2) +
  theme(strip.text = element_text(size = 12))
#ggsave('species.pdf', p, width = 10.5, height = 9, dpi = 1080)

##pathway
pathway <- read.csv("pathway.csv", sep = ",", header = T, row.names = 1)
pathway$ID <- factor(rownames(pathway), levels = rev(rownames(pathway)))
colnames(pathway) <- factor(colnames(pathway), levels = colnames(pathway))
pathway <- melt(pathway, id = 'ID')
#添加分组
names(group)[1] <- 'variable'
pathway <- merge(pathway, group, by = 'variable')
col1s <- c("#447B66","#96CCA8","#2E8B57","#C0EEDA","#CBD589","#86A845","#B3C648",
           "#FED46E","#FFDF6F","#F4D160","#8AC4D0","#FFC86F","#58A3BC","#3E83A8",
           "#28527A","#134080","#323CC8","#1D6590","#A8D4E0","#537496","#55A6CB",
           "#A378B5","#766092","#DAB3DA","#D986B1","#F2A6C2","#FBC1AD",
           "#EF978F","#EFC2AD","#F56E4A","#F56E60","#F56E78","#808080")
p <- ggplot(pathway, aes(variable, 100 * value, fill = ID)) +
  geom_col(position = 'stack', width = 0.6) +
  labs(x = '', y = 'Relative Abundance(%)') +
  theme(axis.text = element_text(size = 12, angle = 90), axis.title = element_text(size = 13)) +
  theme(legend.text = element_text(size = 9, ncol(1)),legend.key.size=unit(0.2,'cm', ncol(1)))+
  scale_fill_manual(values =  rev(col1s)) +
  theme(panel.grid = element_blank(), panel.background = element_rect(color = 'black', fill = 'transparent')) +
  theme(legend.title = element_blank())+facet_wrap(~group, scales = 'free_x', ncol = 2) +
  theme(strip.text = element_text(size = 12))
#ggsave('pathway.pdf', p, width = 15, height = 9, dpi = 1080)

par(mfrow = c(1,2))
##mergespecies
mergespecies <- read.csv("spciesmerge.csv",row.names=1,header=T,sep=",")
mergespecies <- mergespecies+10^(-10)
mergespecies <- log10(mergespecies) 
plot(mergespecies$H1PreF_DNA,mergespecies$H1PreF_DNA,xlab="log10DNA",ylab = "log10RNA",col="white",xlim = c(-10,1),ylim = c(-10,0))
lines(lowess(mergespecies$H1PreF_DNA,mergespecies$H1PreF_DNA),col="grey",lty=2,lwd=1.5)
len <- ncol(mergespecies)/2
for (i in (1:5)){
  points(mergespecies[,i],mergespecies[,i+len], col="#FFDF6F", pch = 16, cex=0.5) #col = "#F4D160")
}
for (i in (6:28)){
  points(mergespecies[,i],mergespecies[,i+len], col="#D986B1", pch = 16, cex=0.5) #col = "#F4D160")
}
for (i in (29:71)){
  points(mergespecies[,i],mergespecies[,i+len], col="#7DABD0", pch = 16, cex=0.5) #col = "#F4D160")
}

##mergepathways
mergepathway <- read.csv("pathwaymerge.csv",sep = ",", header = T, row.names = 1)
mergepathway <- mergepathway+10^(-10)
mergepathway <- log10(mergepathway) 
x <- c(-10:0)
y <- c(-10:0)
plot(mergepathway$H1PreF_DNA,mergepathway$H1PreF_DNA,xlab="log10DNA",ylab = "log10RNA",col="white", xlim = c(-10,1),ylim = c(-10,0))
lines(x,y,col="grey",lty=2,lwd=1.5)
len <- ncol(mergepathway)/2
for (i in (1:5)){
  points(mergepathway[,i],mergepathway[,i+len], col="#FFDF6F", pch = 16, cex=0.5) #col = "#F4D160")
}
for (i in (6:28)){
  points(mergepathway[,i],mergepathway[,i+len], col="#D986B1", pch = 16, cex=0.5) #col = "#F4D160")
}
for (i in (29:71)){
  points(mergepathway[,i],mergepathway[,i+len], col="#7DABD0", pch = 16, cex=0.5) #col = "#F4D160")
}
legend('topright',col = c("#FFDF6F","#D986B1","#7DABD0"),pch=16,legend =c("PreF","PostF","PostC"))
#title("RNA vs DNA of Fecal and Ilealcecal Samples")


