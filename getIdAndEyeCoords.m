function [id, eyeCoords, dist] = getIdFromImg(imgIn)
%GETIDFROMIMG Summary of this function goes here
%   Detailed explanation goes here
id = 0;
img = im2double(imgIn);
img = colorCorrection(img);

eyeCoords = findEyeCoordinates(img);
dist = 1;


if eyeCoords ~= 0
    eyeL = eyeCoords(1, :);
    eyeR = eyeCoords(2, :);

    normalface = normalizeFace(eyeL, eyeR, img);
    %imshow(normalface)

    nrofweights = 8;
    threshold = 0.2;

    [id,dist] = recognizeFace(normalface, nrofweights, threshold);
end

end

