MatPPRead <- function(fname){
  
  # Load necessary libraries
  library(R.matlab)
  library(spatstat)
  
  # Read in the matlab file
  matdat <- readMat(fname)
  
  # Extract the data from the matlab file.
  imraw <- matdat$binMask    # Binary Mask as numeric array.
  imWidth = matdat$imWidth   # Window Width.
  imHeight = matdat$imHeight # Window Height.
  xpts <- matdat$xpts        # X-coordinates of points.
  ypts <- matdat$ypts        # Y-coordinates of points.
  units <- matdat$units      # Units of the window
  units <- unlist(units)     # Convert to vector
  scale <- as.numeric(matdat$scale);
  
  # Convert the image into a logical array.
  immask <- as.logical(imraw) 
  # Convert into a logical matrix. 
  immask <- matrix(immask,nrow = nrow(imraw),ncol = ncol(imraw)) 
  #image(as.im(immask))
  #points(xpts,ypts,col="red")
  # Convert the mask into a window type object.
  win <- owin(c(0,ncol(immask)*scale),c(0,nrow(immask)*scale),mask = immask,unitname=units)
  # Combine the window and points into a point pattern object.
  pp = ppp(xpts*scale,ypts*scale,window = win) 

  return(pp)
}