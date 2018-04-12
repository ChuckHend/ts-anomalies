# Adam Hendel
# "Data Challenge"
# 31-Mar-2018

library(ggplot2)
library(AnomalyDetection)
library(lubridate)
library(gridExtra)

d <- read.csv('T:/Dropbox/Projects/ts_anomolies/Data/pca_df.csv',
              stringsAsFactors = F,
              header=T)

d$Date <- as.POSIXct(d$Date, format="%Y-%m-%d")

cus  <- AnomalyDetectionTs(d[,c('Date', 'rev')], max_anoms=0.02, direction='pos', plot=TRUE)
cus$plot
inv  <- AnomalyDetectionTs(d[,c('Date', 'CustomerID')], max_anoms=0.02, direction='pos', plot=TRUE)
inv$plot
prod  <- AnomalyDetectionTs(d[,c('Date', 'StockCode')], max_anoms=0.02, direction='pos', plot=TRUE, verbose = T)
prod$plot
pc1 <- AnomalyDetectionTs(d[,c('Date', 'PC1')], max_anoms=0.02, direction='pos', plot=TRUE, verbose = T, alpha = .09)
pc1$plot

set.seed(1121)
rev  <- AnomalyDetectionTs(d[,c('Date', 'rev')], max_anoms=0.02, direction='pos', plot=TRUE)
rev$plot

theme_black = function(base_size = 12, base_family = "") {
  
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
    
    theme(
      # Specify axis options
      axis.line = element_blank(),  
      axis.text.x = element_text(size = base_size*1.1, color = "white", lineheight = 0.9),  
      axis.text.y = element_text(size = base_size*1.1, color = "white", lineheight = 0.9),  
      axis.ticks = element_line(color = "white", size  =  0.2),  
      axis.title.x = element_text(size = base_size*1.2, color = "white", margin = margin(0, 10, 0, 0)),  
      axis.title.y = element_text(size = base_size*1.2, color = "white", angle = 90, margin = margin(0, 10, 0, 0)),  
      axis.ticks.length = unit(0.3, "lines"),   
      # Specify legend options
      legend.background = element_rect(color = NA, fill = "black"),  
      legend.key = element_rect(color = "white",  fill = "black"),  
      legend.key.size = unit(1.2, "lines"),  
      legend.key.height = NULL,  
      legend.key.width = NULL,      
      legend.text = element_text(size = base_size*1.1, color = "white"),  
      legend.title = element_text(size = base_size*1.1, face = "bold", hjust = 0, color = "white"),  
      legend.position = "right",  
      legend.text.align = NULL,  
      legend.title.align = NULL,  
      legend.direction = "vertical",  
      legend.box = NULL, 
      # Specify panel options
      panel.background = element_rect(fill = "black", color  =  NA),  
      panel.border = element_rect(fill = NA, color = "white"),  
      panel.grid.major = element_line(color = "grey35"),  
      panel.grid.minor = element_line(color = "grey20"),  
      panel.margin = unit(0.5, "lines"),   
      # Specify facetting options
      strip.background = element_rect(fill = "grey30", color = "grey10"),  
      strip.text.x = element_text(size = base_size*1.1, color = "white"),  
      strip.text.y = element_text(size = base_size*1.1, color = "white",angle = -90),  
      # Specify plot options
      plot.background = element_rect(color = "black", fill = "black"),  
      plot.title = element_text(size = base_size*1.2, color = "white"),  
      plot.margin = unit(rep(1, 4), "lines")
      
    )
  
}
ggplot(d, aes(x=Date, y=rev)) +
  geom_line(col='white') +
  geom_point(data=rev$anoms[c(1,3),], aes(x=timestamp, y=anoms), 
             col = 'red', size =5, shape = 1, stroke=2) +
  theme_black() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.title=element_text(size=24)) +
  annotate('text', x = rev$anoms[c(1,3),]$timestamp[1] - 25e5, 
           y=rev$anoms[c(1,3),]$anoms[1],
           label = paste(rev$anoms[c(1,3),]$timestamp[1]),
           col='white') +
  annotate('text', x = rev$anoms[c(1,3),]$timestamp[2] - 25e5, 
           y=rev$anoms[c(1,3),]$anoms[2],
           label = paste(rev$anoms[c(1,3),]$timestamp[2]),
           col='white') +
  ylab('Revenue (GBP)')

write.csv(rev$anoms, 'T:/Dropbox/Projects/ts_anomolies/Data/rev_anomalies.csv', row.names = F)
