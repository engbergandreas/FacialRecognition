%%Tweak image
%Load faces, start with one face to test
img = imread(['..\DB2/cl_08.jpg']);
%Color correction
img = colorCorrection(img);

imgD = im2double(img);
%Track facemask
faceMask = generateFaceMask(img);

%Eyemask
eyeMap = eyeMask(imgD);

mult = eyeMap.*faceMask;

imshow(mult.*imgD)

%Normalize the face
eyeCoords=findEyeCoordinates(img);
%Eyes according to our viewpoint, eyeL is the person's right eye.
eyeL = eyeCoords(1, :);
eyeR = eyeCoords(2, :);

normalface = normalizeFace(eyeL, eyeR, imgD);
figure(1)
imshow(normalface)
axis on
hold on;
% Plot cross at row 100, column 50
plot(eyeL(1), eyeL(2), 'r+', 'MarkerSize', 30, 'LineWidth', 2);

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