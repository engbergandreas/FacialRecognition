function outImg = colorCorrection(inImg)

    red = (inImg(:,:,1)); 
    green = (inImg(:,:,2)); 
    blue = (inImg(:,:,3));
    
    rMean = mean(red(:)); 
    gMean = mean(green(:)); 
    bMean = mean(blue(:)); 
    
    alpha = gMean/rMean; 
    beta = gMean/bMean;
    
    red = red.*alpha; 
    blue = blue.*beta; 
    
    sizeIn = size(red);
    rgbMax = 0;
    rgbMax = uint16(0);
    rMax = 0;
    gMax = 0;
    bMax = 0;
    for i = 1:(sizeIn(1)-1)
        for j = 1:(sizeIn(2)-1)
          
           if uint16(red(i,j))+uint16(green(i,j))+uint16(blue(i,j)) > rgbMax
               
            rgbMax = uint16(uint16(red(i,j))+uint16(green(i,j))+uint16(blue(i,j)));
            
            rMax = red(i,j);
            gMax = green(i,j);
            bMax = blue(i,j);
            
           end
        end
    end

    
    alfa2 = double(gMax)/double(rMax);
    beta2 = double(gMax)/double(bMax);
    
    red = red.*alfa2;
    blue = blue.*beta2;
 
    outImg(:,:,1)=red; 
    outImg(:,:,2)=green; 
    outImg(:,:,3)=blue;
    
end

