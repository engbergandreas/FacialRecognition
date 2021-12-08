%%Tweak image
%Load faces, start with one face to test
Settings
%[meanFace, eigenFaces, weights] = precomputeData("1");
images = dir("../DB1/*.jpg");

img = im2double(imread('../DB1/db1_07.jpg'));
%img = im2double(imread('../DB2/cl_01.jpg'));
%img = im2double(imread("../DB0/db0_3.jpg"));
%img = im2double(imread("../DB3/image_0068.jpg"));



%img = imrotate(img, 5, 'bicubic', 'crop');
%img(:,:,:) = img(:,:,:) - 0.2;
%img(:,:,:) = img(:,:,:) - 0.3;


%figure(5)
%imshow(img);
img = colorCorrection(img);
%img = im2double(img);

%Normalize the face
eyeCoords=findEyeCoordinates(img);
%Eyes according to our viewpoint, eyeL is the person's right eye.
leftEye = eyeCoords(1, :);
rightEye = eyeCoords(2, :);

%img = im2double(img);

figure(1)
imshow(img);
hold on
plot(eyeCoords(:,1),eyeCoords(:,2), 'rx');
hold off

normalface = normalizeFace(leftEye, rightEye, img);
figure(2);
imshow(normalface)

normalface = rgb2gray(normalface);
%figure(5);
%imshow(normalface)

%{
%Find out if image is in DB 
height = NORMALIZED_FACE_HEIGHT;
width = NORMALIZED_FACE_WIDTH;
x = reshape(normalface, height * width, 1);

facedifference = x - meanFace;

featureVector =  eigenFaces' * facedifference;

k = 6;
%k = size(weights,2);
errors = zeros(size(weights,2), 1);
for i = 1:size(weights,2)
   error = norm(featureVector(1:k) - weights(1:k,i));
   errors(i,1) = error;
end
maxweight = max(errors);
[minWeight, index] = min(errors / maxweight);
errorThreshold = 0.3;
e = errors/maxweight;

if(minWeight < errorThreshold)
    figure(4);
    result = imread("../DB1/" + images(index).name);
    imshow(result);
else
    result = 0
end
%}

nrofweights = 8;
threshold = 0.25;

[id, minError] = recognizeFace(normalface, threshold);

if(id ~= 0) 
    figure(4);
    result = imread("../DB1/" + images(id).name);
    imshow(result);
end

% Plot cross at row 100, column 50

%Clip face

    %Take in a face

        
        
        %eye_mask = eyeMask(img);
        
    %Return facemask
%The image is tweaked

%imshow(faceMask);

%chroma_image=rgb2ycbcr(img);

%normalized_chroma_image = normalize(chroma_image);

%output_image = normalized_chroma_image;

%figure





%Return the right face