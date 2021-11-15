%%Tweak image
%Load faces, start with one face to test
img = imread(['..\DB1\DB1/db1_03.jpg']);
%Color correction

img = imrotate(img, 5);


imgD = im2double(img);
%Track facemask




%Eyemask
eyeMap = eyeMask(imgD);

mult = eyeMap.*faceMask;



%imshow(temp.*imgD);

%Normalize the face
eyeCoords=findEyeCoordinates(img);
%Eyes according to our viewpoint, eyeL is the person's right eye.
eyeL = eyeCoords(1, :);
eyeR = eyeCoords(2, :);

normalface = normalizeFace(eyeL, eyeR, imgD);
%imshow(normalface);
%figure(1)
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