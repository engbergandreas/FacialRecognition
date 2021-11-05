function outImg = colorCorrection(inImg)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    outImg = inImg;

    red = inImg(:,:,1); 
    green = inImg(:,:,2); 
    blue = inImg(:,:,3);
    
    rMean = mean(red(:)); 
    gMean = mean(green(:)); 
    bMean = mean(blue(:)); 
    
    alpha = gMean/rMean; 
    beta = gMean/bMean; 
    
    red = red.*alpha; 
    blue = blue.*beta; 
    
    outImg(:,:,1)=red; 
    outImg(:,:,2)=green; 
    outImg(:,:,3)=blue;
    
end

