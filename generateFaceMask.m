function imgMask = generateFaceMask(imgIn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    R = imgIn(:,:,1);
    G = imgIn(:,:,2);
    B = imgIn(:,:,3); 

    YCbCr = rgb2ycbcr(imgIn);

    Y = YCbCr(:,:,1);
    Cb = YCbCr(:,:,2);
    Cr = YCbCr(:,:,3);
    
    %HSV = rgb2hsv(imgIn);
    
    %H = HSV(:,:,1);
    %S = HSV(:,:,2);

    imgMask = zeros(size(Cb));

    
    %R > 95 and
    %G > 40 and
    %B > 20 and
    %R > G and
    %R > B and
    %| R - G | > 15 and
    %A > 15 and
    %Cr > 135 and
    %Cb > 85 and
    %Y > 80 and
    %Cr <= (1.5862*Cb)+20 and
    %Cr>=(0.3448*Cb)+76.2069 and
    %Cr >= (-4.5652*Cb)+234.5652 and
    %Cr <= (-1.15*Cb)+301.75 and
    %Cr <= (-2.2857*Cb)+432.85
    %|| (abs(R(i,j) - G(i,j)) > 15 && R(i,j) > B(i,j) && R(i,j) > G(i,j) && B(i,j) > 20 && G(i,j) > 40 && R(i,j) > 95 && H(i,j)>= 0.0 && H(i,j)<= 0.5 && S(i,j)>=0.23 && S(i,j)<=0.68
    CrUb = 0.6*255;
    CrLb = 0.51*255;

    CbUb = 0.56*255;
    CbLb = 0.4*255;
    
    rLim = 95;
    bLim = 20;
   
    
     for i = 1:length(imgMask(:,1))
        for j = 1:length(imgMask(1,:))
            %if Cr(i,j) < CrUb && Cr(i,j) > CrLb && Cb(i,j) < CbUb && Cb(i,j) > CbLb
            %if (Cr(i,j) < 178 && Cr(i,j) > 125 && Cb(i,j) < 140 && Cb(i,j) > 80 && Cr(i,j) <= (1.5862*Cb(i,j))+20 && Cr(i,j)>=(0.3448*Cb(i,j))+76.2069 && Cr(i,j) <= (-1.15*Cb(i,j))+301.75 && Cr(i,j) <= (-2.2857*Cb(i,j))+432.85) 
            if abs(R(i,j) - G(i,j)) > 15 && ...
                    R(i,j) > B(i,j) && ...
                    R(i,j) > G(i,j) && ...
                    B(i,j) > bLim && ...
                    G(i,j) > 40 && ... 
                    R(i,j) > rLim && ...
                    Cr(i,j) >= (0.93*Cb(i,j))+16.21 && ...
                    Cr(i,j)<=(0.93*Cb(i,j))+93 && ...
                    Cr(i,j) <= (-0.94*Cb(i,j))+288.97 && ...
                    Cr(i,j) <= (-0.92*Cb(i,j))+ 231 && ...
                    Cr(i,j) < 178 && ...
                    Cr(i,j) > 125 && ...
                    Cb(i,j) < 140 && ...
                    Cb(i,j) > 80
            %if Cr(i,j) < 180 && Cr(i,j) > 125 && Cb(i,j) < 180 && Cb(i,j) > 116
             
                imgMask(i,j) = 1;
            else
                imgMask(i,j) = 0;
            end
        end
     end
    
    SE = strel('disk',3);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    
    
    SE = strel('square',90);
    imgMask = imerode(imgMask, SE);
    imgMask = imerode(imgMask, SE);
    
    SE = strel('disk',5);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
    imgMask = imdilate(imgMask, SE);
%     
    
   
    
    
    
   imgMask = imbinarize(imgMask, 0.5);
    
    
    
    %bweuler(imgMask)
    
end

