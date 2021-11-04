
%Load faces, start with one face to test
img = imread('..\DB2/cl_05.jpg');

faceMask = generateFaceMask(img)
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



%chroma_image=rgb2ycbcr(img);

%normalized_chroma_image = normalize(chroma_image);

%output_image = normalized_chroma_image;

%figure
imshow(faceMask)
imshow(faceMask)




%Return the right face