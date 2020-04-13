function plotSAR(image)
XMIN = min(image(:));
XMAX = 0.1*max(image(:));
im =(image-XMIN)/(XMAX-XMIN);
imagesc(im);
colormap('bone')
axis equal
end