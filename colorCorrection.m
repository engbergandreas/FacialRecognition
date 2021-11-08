function outImg = colorCorrection(inImg)

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
    
    %rMax = max(red(:));
    %gMax = max(green(:));
    %bMax = max(blue(:));
    
    %alfa2 = gMax/rMax
    %beta2 = gMax/bMax
    
    %red = red.*alfa2;
    %blue = blue.*beta2;
 
    outImg(:,:,1)=red; 
    outImg(:,:,2)=green; 
    outImg(:,:,3)=blue;
    
end

