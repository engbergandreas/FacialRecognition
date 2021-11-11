function [outputImg] = normalizeFace(eyeL, eyeR, inputImg)
%NORMALIZEFACE Summary of this function goes here
%   Detailed explanation goes here

% deltaX is the base of the triangle betwwen the eyes

deltaX = eyeR(1) - eyeL(1);
hypotenuse = norm(eyeL-eyeR);

%Angle betwwen eyes
degrees = asin(deltaX/hypotenuse);

%The way to rotate depends on which eye is the highest
if eyeL(2) > eyeR(2)
    
    %Padd image so eyeR is the center of the image and use imrotate
    rotatedImage=rotateAround(inputImg, eyeR(2), eyeR(1), degrees);
    center = eyeR - [hypotenuse/2, 0];

else

    %Padd image so the eyeL is the center of the image and rotate the other
    %way.
    rotatedImage=rotateAround(inputImg, eyeL(2), eyeL(1), degrees);
    center = eyeL + [hypotenuse/2, 0];

end

Ltop = center + [hypotenuse*-0.75, -hypotenuse*0.5];
Rbottom = center + [hypotenuse*0.75, hypotenuse*1.5];

outputImg = imresize(imcrop(rotatedImage, [Ltop Rbottom-Ltop]), [400, 300]);

end

