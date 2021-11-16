%%Tweak image
%Load faces, start with one face to test
Settings

img = imread('..\DB2/cl_13.jpg');

eyecoords = findEyeCoordinates(img);
figure(1)
imshow(img);
hold on
plot(eyecoords(:,1), eyecoords(:,2), 'rx');
hold off

img = colorCorrection(img);

imgD = im2double(img);

%Normalize the face
eyeCoords=findEyeCoordinates(img);
%Eyes according to our viewpoint, eyeL is the person's right eye.
eyeL = eyeCoords(1, :);
eyeR = eyeCoords(2, :);

normalface = normalizeFace(eyeL, eyeR, imgD);
figure(3);
imshow(normalface)


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