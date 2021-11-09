
%Load faces, start with one face to test
img = imread('..\DB2/cl_07.jpg');
img = colorCorrection(img);

imgD = im2double(img);
faceMask = generateFaceMask(img);

eyeMap = eyeMask(imgD);

mult = eyeMap.*faceMask;

imshow(mult.*imgD)

%Tweak image
    %Take in a face
        %Color correction
        %Track facemask
        %Eyemask
        %eye_mask = eyeMask(img);
        %Clip face
    %Return facemask
%The image is tweaked

%imshow(faceMask);

%chroma_image=rgb2ycbcr(img);

%normalized_chroma_image = normalize(chroma_image);

%output_image = normalized_chroma_image;

%figure





%Return the right face