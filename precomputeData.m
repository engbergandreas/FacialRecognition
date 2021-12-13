function [meanFace, eigenFaces, weights] = precomputeData(database)
%[meanFace, eigenFace, weight] = precomputeData(database)
%meanFace is the mean of all faces in DB
%eigenFace 
%weights are the feature vector to compare incoming image to

Settings
height = NORMALIZED_FACE_HEIGHT;
width = NORMALIZED_FACE_WIDTH;

images = dir("../DB" + database + "/*.jpg");
%X images in db as M x N, 1 vector size 
X = zeros(height * width, length(images));
%Read every image from database and add them to the matrix X
for i = 1:length(images)
img = im2double(imread("../DB" + database + "/" + images(i).name));
img = colorCorrection(img);
%imgD = im2double(img);
%Normalize the face
eyeCoords=findEyeCoordinates(img);
%Eyes according to our viewpoint, eyeL is the person's right eye.
eyeL = eyeCoords(1, :);
eyeR = eyeCoords(2, :);
normalface = normalizeFace(eyeL, eyeR, img);

image = rgb2gray(normalface);
x = reshape(image, height * width, 1);

X(:,i) = x; %face vector
end

%create avg face 
meanFace = 1 / length(images) * sum(X,2); %mu
%imshow(reshape(avgFace, height, width));

diffFace = X - meanFace; %A where each col is phi = xi - mu

[eigenVectors, eigenValues] = eig(diffFace' * diffFace);
%Sort eigen values in descending order
[eigenValues, order] = sort(diag(eigenValues), 'descend');

%Compute eigen faces
eigenFaces = diffFace * eigenVectors; %u_i in slides
eigenFaces = eigenFaces(:, order);

%normalize eigenfaces
for i = 1:size(eigenFaces,2)
    eigenFaces(:,i) = eigenFaces(:,i) / norm(eigenFaces(:,i));
end

%feature vector 16x16, where each column represent each 
%image weights for the 16 eigenfaces
weights = eigenFaces' * diffFace; %feature vector 

save dataEigenFaces.mat meanFace eigenFaces weights;
end
