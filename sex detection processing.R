normals <- read.csv("normals_metadata.csv")
normals <- normals[order(normals$name),]
row.names(normals) <- 1:nrow(normals)
normals$x <- paste(normals$gender, "-", normals$case_id)

files <- p$file(name= ".ratio.txt$")
download(files, "~/ratiofiles")
filelist <- list.files(path="~/ratiofiles")
filelist <- unlist(lapply(filelist, function(x) paste0("~/ratiofiles", x)))
ratiofiles <- (lapply(filelist, read.table, sep = ""))

basefileslist <- unlist(lapply(filelist, basename))
basefileslist <- as.data.frame(basefileslist)
normals <- inner_join(normals, basefileslist, by = c("name" = "basefileslist"))

for (i in 1:length(filelist)) {
  normals[i,22] <- ratiofiles[[i]]$V2[5]
}
colnames(normals)[22] <- "Y_norm_reads_fraction"

for (i in 1:length(normals$gender)) {
  if (normals$Y_norm_reads_fraction[i] < 0.2) {
    normals[i,23] <- "Female"
  } else if (normals$Y_norm_reads_fraction[i] < 0.6 && normals$Y_norm_reads_fraction[i] > 0.4){
    normals[i,23] <- "Male"
  } else {
    normals[i,23] <- "Unknown"
  }
}

colnames(normals)[23] <- "Predicted Sex"
normals$gender <- unlist(lapply(normals$gender, function(x) gsub("^$|^ $", "Not Reported", x)))
normals$gender <- unlist(lapply(normals$gender, function(x) gsub("Not Available", "Not Reported", x)))
female <- normals[grep("Female", normals$gender),]
male <- normals[grep("Male", normals$gender),]
normals <- cbind(normals[2], normals[5], normals[8], normals[14], normals[22:23])



ggplot(data=normals, aes(x=gender, y=`Y_norm_reads_fraction`, colour = gender)) +
  geom_violin(alpha = 0.1, color = "black", trim = F) + geom_jitter(size = 0.5) + ggtitle("# Normalized Y reads / (# Normalized X reads + # Normalized Y reads)") + xlab("Reported Sex") + ylab("") + theme_Publication() + theme(plot.title = element_text(hjust = 0.5))

bools <- normals$gender != normals$`Predicted Sex`
question <- normals[bools, ]
write.table(question, "~kannans1/Desktop/question.txt", sep = "\t", row.names = F)



##theme
theme_Publication <- function(base_size=15, base_family="Helvetica") {
  library(grid)
  library(ggthemes)
  (theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(1.2), hjust = 0.5),
            text = element_text(),
            panel.background = element_rect(colour = NA),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(face = "bold",size = rel(1)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(), 
            axis.line = element_line(colour="black"),
            axis.ticks = element_line(),
            panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.key = element_rect(colour = NA),
            legend.position = "right",
            legend.direction = "vertical",
            legend.key.size= unit(0.5, "cm"),
            # legend.margin = unit(0.5, "cm"),
            legend.margin = margin(5,5,5,5),
            legend.title = element_text(face="bold"),
            #plot.margin=unit(c(10,5,5,5),"mm"),
            plot.margin=unit(c(10,5,5,10),"mm"),
            strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
            strip.text = element_text(face="bold")
    ))
}


