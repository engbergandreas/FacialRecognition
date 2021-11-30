function outImg = colorCorrection(inImg)

    sizeIn = size(inImg(:,:,1));
    meanVal = 0;
    meanValCounter = 0.0;
    rtot = 0;
    gtot = 0;
    btot = 0;
    
    for i = 1:(sizeIn(1)-1)
        for j = 1:(sizeIn(2)-1)

           if inImg(i,j,1) == 0 && inImg(i,j,2) == 0 && inImg(i,j,3) == 0 
           else
              meanVal = meanVal + inImg(i,j,1) + inImg(i,j,2) + inImg(i,j,3);
              meanValCounter = meanValCounter +3;
              rtot = rtot +inImg(i,j,1);
              gtot = gtot +inImg(i,j,2);
              btot = btot +inImg(i,j,3);
           end
        end
    end
    imgTotMean = meanVal/meanValCounter;
    inImg = inImg*((154.8769/255)/imgTotMean);
    
    red = (inImg(:,:,1));
    green = (inImg(:,:,2));
    blue = (inImg(:,:,3));
    

    rMean = rtot/((meanValCounter/3));
    gMean = gtot/((meanValCounter/3)); 
    bMean = btot/((meanValCounter/3));
    
    mL = 0.8;
    mU = 1.2;


  

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
