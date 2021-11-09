function [output_image] = eyeMask(input_image)
%eyeMask Return a mask made to find the eyes

%Make the image to chroma channels
imgChrome = rgb2ycbcr(input_image);

%Extract all color channels
Y = uint16(255 * mat2gray(imgChrome(:,:,1)));
Cb = uint16(255 * mat2gray(imgChrome(:,:,2)));
Cr = uint16(255 * mat2gray(imgChrome(:,:,3)));

Cr_neg = 255 - Cr;

%Calculate the first eyemap
EyeMapC = (1/3).*(Cb.^2 + Cr_neg.^2 + (Cb./Cr));
EyeMapC = im2double(EyeMapC);

%And the second blurry eyemap
se = strel('disk', 4);
EyeMapL = imdilate(Y, se) ./ (imerode(Y, se) + 1);
EyeMapL = im2double(histeq(EyeMapL));

%Multiply to get the final eyemap
EyeMap = EyeMapL.*EyeMapC;
EyeMap = histeq(EyeMap);

%Value greater_than need to be updated
output_image = EyeMap > 0.85;

end