function [output_image] = mouthMask(img, faceMask)
%MOUTHMASK Summary of this function goes here
%   Detailed explanation goes here

img = img.*faceMask;

number_of_pixels = sum(faceMask(:));

imshow(img)

imgChrome = rgb2ycbcr(img);
Y = mat2gray(imgChrome(:,:,1)) + 1;
Cb = mat2gray(imgChrome(:,:,2)) + 1;
Cr = mat2gray(imgChrome(:,:,3)) + 1;

mean_Cr_squared = sum(Cr(:).^2)./number_of_pixels;

mean_Cr_by_Cb = (sum(Cr(:)./sum(Cb(:))))./number_of_pixels;

My = 0.95*mean(Cr(:).^2)./(mean(Cr(:)./Cb(:)));

MouthMap = (Cr.^2).*((Cr.^2) - My*(Cr./Cb)).^2;
MouthMap = (MouthMap- min(MouthMap(:)))/(max(MouthMap(:)) - min(MouthMap(:)));

se1 = strel('disk', 12);


MouthMap = MouthMap > 0.2;

MouthMap = bwareaopen(MouthMap, 200);
MouthMap = imdilate(MouthMap, se1);

output_image = MouthMap;

end

