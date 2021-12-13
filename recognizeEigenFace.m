function [id, minError] = recognizeEigenFace(normalface,kWeights, threshold)
%return id of given normalised face
Settings
load dataEigenFaces.mat eigenFaces meanFace weights;
%load dataEigenFace.mat fisherFaces weights;
%Find out if image is in DB 
height = NORMALIZED_FACE_HEIGHT;
width = NORMALIZED_FACE_WIDTH;

%%%%
%reshape image to vector format
x = reshape(normalface, height * width, 1);

%compute the difference between the given face and mean face of all faces
%used in training
facedifference = x - meanFace;
%compute the feature vector from the precomputed eigenfaces
featureVector =  eigenFaces' * facedifference;

%nr of weights to use 
k = kWeights;

%compute the weights difference between given image and db
errors = zeros(size(weights,2), 1);
for i = 1:size(weights,2)
   error = norm(featureVector(1:k) - weights(1:k,i));
   errors(i,1) = error;
end
%normalize weights between 0-1 
maxweight = max(errors);
%get the smallest error and corresponding index 
[minWeight, index] = min(errors / maxweight);

%is the error less than given threshold
errorThreshold = threshold;
minError = minWeight;
if(minWeight < errorThreshold)
    id = index;
    %figure(4);
    %result = imread("../DB1/" + images(index).name);
    %imshow(result);
else
    id = 0;
end

end


