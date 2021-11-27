function [topEigenFace,dist] = createEigenDB(dbPath, img)
    imageFiles = dir('C:\Users\jakob\Documents\GitHub\DB1\*.jpg');

    allImgVector = zeros(120000,16);
    test = 0;
    for i=1:length(imageFiles)
        temp = imageFiles(i,1).name;
        temp = strcat(dbPath,temp);
        thisImg = imread(temp);
        
        eyeCoords = findEyeCoordinates(thisImg);
        thisImg = im2double(thisImg);
        normalizedFace = normalizeFace(eyeCoords(1,:),eyeCoords(2,:), thisImg);
       
        thisSize = size(normalizedFace);
        
        allImgVector(:,i) = double(reshape(rgb2gray(normalizedFace), [thisSize(1)*thisSize(2), 1]));

    end

    meanFace = mean(allImgVector,2);

    for i =1:length(imageFiles)
        A(:,i) = allImgVector(:,i) - meanFace;
    end
    C = A'*A;
    [eVec, ~] = eig(C);
    
    
    topEigenFace = A*eVec;
    
    weights = topEigenFace'*A;

    eyeCoords = findEyeCoordinates(img);
    
    imgCC = im2double(img);
    eyeSize = size(eyeCoords)
    
    if(eyeSize(1,1) ~= 1)
    
    normalizedFace = normalizeFace(eyeCoords(1,:),eyeCoords(2,:), imgCC);
    %imshowpair(normalizedFace, test, 'montage')
    
    thisSize = size(normalizedFace);
    
    imageVec = double(reshape(rgb2gray(normalizedFace), [thisSize(1)*thisSize(2), 1]));
    
    faceDiff = imageVec - meanFace; 
    testWeight = topEigenFace'*faceDiff;
    
    for i=1:length(weights)
       weightDiff(:, i) = norm(testWeight - weights(:,i));
    end
    weightDiff;
   [kindaCuteDoe,imgNumber]=min(weightDiff);
    imgNumber;
    threshold = 1000;
    topEigenFace = imgNumber;
    dist = kindaCuteDoe;
    if kindaCuteDoe < threshold
        topEigenFace = imgNumber;
    else
        topEigenFace = 0;
    end
    
    else
        topEigenFace = 0;
        dist = 99999999;
    end

    
end

