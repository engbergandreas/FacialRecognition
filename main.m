
%Load faces, start with one face to test
img = im2double(imread('..\DB1/db1_01.jpg'));

img = colorCorrection(img);
imshow(img)
faceMask = generateFaceMask(img);
%Tweak image
    %Take in a face
        %Color correction
        %Track facemask
        %Eyemask
        %eye_mask = eyeMask(img);
        %Mouthmask
        %Clip face
    %Return facemask
%The image is tweaked

%imshow(faceMask);

%chroma_image=rgb2ycbcr(img);

%normalized_chroma_image = normalize(chroma_image);

%output_image = normalized_chroma_image;

%figure





%Return the right face