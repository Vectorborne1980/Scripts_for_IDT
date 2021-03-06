###################################################################################################
# PLOT RECUT DEEPSPLIT MODULES ALONG WITH CLINICAL TRAIT CORRELATIONS
###################################################################################################

# Correlate probe intensities / normalized gene counts to binary or continuous clinical traits
# and convert correlation values to a blue-white-red color palette for a color bar

#colnames(datTraits) # Display clinical traits that will be plotted as correlation bars 

traitBar <- colnames(datExpr)

for(i in 1:ncol(datTraits)) {
  trait <- as.data.frame(datTraits[,i])
  names(trait) <- colnames(datTraits)[i]
  trait.corr <- as.numeric(cor(datExpr, trait, use = "p")) # Here is the correlation work
  trait.corr.color <- data.frame(numbers2colors(trait.corr, signed = T))
  names(trait.corr.color) <- colnames(datTraits)[i]
  traitBar <- cbind(traitBar,trait.corr.color)
}

print(paste("Genes correlated to clinical traits have been encoded as color bars."))
rm(trait,trait.corr,trait.corr.color,i)

traitBar.recut <- data.frame(cbind(moduleColors.DS1,moduleColors.DS2,
                                   moduleColors.DS3,moduleColors.DS4))
names(traitBar.recut) <- c("DS1","DS2","DS3","DS4")
traitBar.recut <- cbind( traitBar.recut, traitBar[,2:ncol(traitBar)])


###################################################################################################
# Loop through the blocks generated by TOM network encoding of the adjacency network and
# generate a dendrogram with module colors and clinical traits bars
for (i in 1:length(net$TOMFiles)) {
  blockNumber = i
  title <- paste(experimentName.recut," DS 1-4 Block ",i,"/",length(net$TOMFiles),sep="")
  
  # Combine the gene correlation colors into a single frame
  datColors = traitBar.recut[net$blockGenes[[blockNumber]],]
  
  # Plot the dendrogram and the module colors underneath
  png(paste(experimentName.recut," block ",i," of ",length(net$TOMFiles),".png",sep=""),
      pngWidth, pngHeight, pointsize=20)
  
  datColors = traitBar.recut[net$blockGenes[[blockNumber]],]
  
  plotDendroAndColors(net$dendrograms[[blockNumber]], colors = datColors,
                      groupLabels = colnames(traitBar.recut),
                      dendroLabels = FALSE, hang = 0.03,
                      addGuide = TRUE, guideHang = 0.05,
                      marAll = marAll, saveMar = TRUE, # bottom, left, top and right 
                      main=title)
  print(paste("Block",i,"dendrogram with trait bars figure saved"))
  dev.off()
}
setwd(projectDir)
#rm(traitBar, i)

## Fix up maximal allowed permissions in the file tree
# Sys.chmod(list.dirs("."), "777")
# f <- list.files(".", all.files = TRUE, full.names = TRUE, recursive = TRUE)
# Sys.chmod(f, (file.info(f)$mode | "664"))
# rm(f)