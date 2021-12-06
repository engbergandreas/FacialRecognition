function [outputImg] = unblurImage(imgD, strelSize)
%Unblur an image using inverse filtering

%Create the filter that you think "blurred the image"
PSF = fspecial('disk',strelSize);

%The larger the quantization, the less sharp an image
uniform_quantization_var = (1/64) / 12; %You can try what works here

signal_var = var(imgD(:));

NSR = uniform_quantization_var / signal_var;

%Inverse the blurring effect
outputImg = deconvwnr(imgD,PSF,NSR);

end