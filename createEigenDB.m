function [topEigenFace] = createEigenDB(dbPath)
    imageFiles = dir('C:\Users\jakob\Documents\GitHub\DB1\*.jpg');
    
    length(imageFiles)
    allImgVector = zeros(120000,16);
    
    for i=1:length(imageFiles)
        temp = imageFiles(i,1).name;
        temp = strcat(dbPath,temp);
        thisImg = imread(temp);
        eyeCoords = findEyeCoordinates(thisImg);
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
    
    
    img = imread(['..\DB1/db1_05.jpg']);
    
    eyeCoords = findEyeCoordinates(img);
    normalizedFace = normalizeFace(eyeCoords(1,:),eyeCoords(2,:), img);
    imshow(img)
    thisSize = size(normalizedFace);
    
    imageVec = double(reshape(rgb2gray(normalizedFace), [thisSize(1)*thisSize(2), 1]));
    
    faceDiff = imageVec - meanFace; 
    testWeight = topEigenFace'*faceDiff
    
    for i=1:length(weights)
       weightDiff(:, i) = norm(testWeight - weights(:,i));
    end
    
   [kindaCuteDoe,imgNumber]=min(weightDiff);
   
   imgNumber
    
    
end

