function [fisherFaces, weights] = precomputeFisherFaceData()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Settings
height = NORMALIZED_FACE_HEIGHT;
width = NORMALIZED_FACE_WIDTH;

database = 3;
nrofclasses = 16;
nrofTrainingImages = zeros(nrofclasses, 1);
meanFaces = zeros(height * width, nrofclasses);

%Read all images, compute mean image for each class (person) and compute a
%mean image for all images in training set also store all images as a n x m
%vector 
counter = 1;
for k = 1:nrofclasses
    subdb = k;
    images = dir("../DB" + database + "/" + subdb + "/*.jpg");
    nrofTrainingImages(k) = length(images);
    imlen = length(images);
    %Read every image from sub directory and store meanface of the class
    %and all of the images read
    meanface = zeros(height * width, 1);
    for i = 1:imlen
        img = im2double(imread("../DB" + database + "/" + subdb +"/" + images(i).name));
        %Color correct image
        img = colorCorrection(img);
        %Normalize the face from eye coordinates
        eyeCoords=findEyeCoordinates(img);
        %Eyes according to our viewpoint, eyeL is the person's right eye.
        if eyeCoords ~= 0
            eyeL = eyeCoords(1, :);
            eyeR = eyeCoords(2, :);
            normalface = normalizeFace(eyeL, eyeR, img);

            image = rgb2gray(normalface);
            x = reshape(image, height * width, 1);
            meanface = meanface + x; %class meanface 

            allfaces(:,counter) = x;
            counter = counter + 1;
        else
            nrofTrainingImages(k) = nrofTrainingImages(k)-1;
        end
    end
    
    meanFaces(:,k) = meanface ./ nrofTrainingImages(k);
    %figure
    %imshow(reshape(meanFaces(:,k), height, width));
end
%compute mean face image of all classes
meanfaceall = sum(meanFaces, 2) / nrofclasses;

%imshow(reshape(meanfaceall, height, width));

%Compute eigenface of all N images in the training set 
diffFace = allfaces - meanfaceall; %should we still take the difference of every image to the meanface?
[eigenVectors, eigenValues] = eig(diffFace' * diffFace);
%Sort eigen values in descending order
[eigenValues, order] = sort(diag(eigenValues), 'descend');

%Compute eigen faces
eigenFaces = diffFace * eigenVectors;
%Take the N - C major eigenfaces -> ie those with the largest eigenvalues
eigenFaces = eigenFaces(:, order); %sort them accordingly to eigenvalues 
eigenFaces = eigenFaces(:, 1 : sum(nrofTrainingImages) - nrofclasses); %take the N-C 

%normalize eigenfaces, is this still necessary?
for i = 1:size(eigenFaces,2)
    eigenFaces(:,i) = eigenFaces(:,i) / norm(eigenFaces(:,i));
end

%project training faces on the eigenface subspace to represent them as a N-C vector 
projectedFaces = eigenFaces' * allfaces;
meanfacesprojected = eigenFaces' * meanFaces;
meanfaceallprojected = eigenFaces' * meanfaceall;

%Compute between class scatter matrix 
Sb = 0;
for i = 1:nrofclasses
    Sb = Sb + nrofTrainingImages(i) * (meanfacesprojected(:,i) - meanfaceallprojected) * (meanfacesprojected(:,i) - meanfaceallprojected)';
end
%Compute within class scatter matrix 
counter = 1;
Sw = 0;
for i = 1:nrofclasses
    startindex = counter;
    endindex = counter + nrofTrainingImages(i) - 1;
    counter = counter + nrofTrainingImages(i);
    %x are the projected training images of class i 
    x = projectedFaces(:, startindex:endindex);
    
    A = x - meanfacesprojected(:,i);
    Sw = Sw + A*A';
end

%Compute fisher faces
%Compute the eigenvectors of matrices Sb, Sw and order them depending on
%largest eigenvalue
[eigenVectorsSbSw, eigenValuesSbSw] = eig(Sb, Sw);
%Sort eigen values in descending order
[eigenValuesSbSw, order] = sort(diag(eigenValuesSbSw), 'descend');
%take the C - 1 largest eigenvectors 
eigenVectorsSbSw = eigenVectorsSbSw(:, order);
eigenVectorsSbSw = eigenVectorsSbSw(:, 1:nrofclasses-1);

%fisher faces F, should they be normalized?
F = eigenFaces * eigenVectorsSbSw;
%Compute weights for each class C-1 x C weights
weights = F' * meanFaces;
%imshow(reshape(F(:,1), height, width), []);
fisherFaces = F;

save data.mat fisherFaces weights
end

