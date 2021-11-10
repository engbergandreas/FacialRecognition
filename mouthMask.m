function [output_image] = mouthMask(img, faceMask)
%MOUTHMASK Summary of this function goes here
%   Detailed explanation goes here
img = img.*faceMask;

imgChrome = rgb2ycbcr(img);
Cb = mat2gray(imgChrome(:,:,2)) + 1;
Cr = mat2gray(imgChrome(:,:,3)) + 1;

My = 0.95*mean(Cr(:).^2)./(mean(Cr(:)./Cb(:)));

MouthMap = (Cr.^2).*((Cr.^2) - My*(Cr./Cb)).^2;
MouthMap = (MouthMap- min(MouthMap(:)))/(max(MouthMap(:)) - min(MouthMap(:)));

se1 = strel('disk', 12);


MouthMap = MouthMap > 0.2;

MouthMap = bwareaopen(MouthMap, 200);
MouthMap = imdilate(MouthMap, se1);

output_image = MouthMap;

end

