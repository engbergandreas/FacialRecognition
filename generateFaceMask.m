function imgMask = generateFaceMask(imgIn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    YCbCr = im2double(rgb2ycbcr(imgIn));

    Cb = YCbCr(:,:,2);
    Cr = YCbCr(:,:,3);
    
    CrLb = 0.55;
    CrUb = 0.6;
    
    CbLb = 0.4;
    CbUb = 0.56;
    
    imgMask = zeros(size(Cb));
  
    for i = 1:length(imgMask(:,1))
        for j = 1:length(imgMask(1,:))
            if Cr(i,j) < CrUb && Cr(i,j) > CrLb && Cb(i,j) < CbUb && Cb(i,j) > CbLb
                imgMask(i,j) = 1;
            else
                imgMask(i,j) = 0;
            end
        end
    end
    
    
    SE = strel('disk',8);
    imgMask = imdilate(imgMask, SE);
    imgMask = imerode(imgMask, SE);

end

