function [eyecoords] = findEyeCoordinates(inputImage)
%Image input should be in uint8 for colorcorrectiona and mask to work?
image = im2double(inputImage);
image = colorCorrection(image);


%Get face mask
facemask = generateFaceMask(image);

%imshow(im2double(inputImage).*facemask);

%Get mouth mask
% mouthImg = mouthMask(image, facemask);
% 
% %Remove mouth from facemask
% facemask = facemask - mouthImg;
% %imshow(mouthImg)
% %clamps from [0, 1]
% facemask = min(max(facemask, -1),1);

%transform to YCbCr color space 
chroma_img = rgb2ycbcr(image);

Y = chroma_img(:,:,1);
Cb = chroma_img(:,:,2);
Cr = chroma_img(:,:,3);
Cr_c = 1 - Cr; %complement of Cr

%precompute values for chroma eye mask
cbcb = Cb .* Cb;
crcr_c = Cr_c .* Cr_c;
cbcr = Cb./Cr;

%Normalize squared values between 0 and 1
cbcb = normalizeimg(cbcb);
crcr_c = normalizeimg(crcr_c);
cbcr = normalizeimg(cbcr);

eyemapc = 1/3 .* (cbcb + crcr_c + cbcr);

%histogram equalize to pop eyes better
eyemapc = histeq(eyemapc);

%compute luminance eye map, test different structure elements and sizes
%disk with radius 10 works fairly well for db1
se = strel('disk', 10);
eyemapl = imdilate(Y, se) ./ (imerode(Y, se) + 1);

%Combine both eye maps and mask with facemask
%using facemask here gives better result when normalizing the image
%facemask removes a lot of false eye candidates
eyemap = eyemapc .* eyemapl .* facemask;
%imshow(eyemap)
%eyemap = eyemap .* facemask;
eyemap = imdilate(eyemap, se);

%normalize to bring the highest values to 1 -> easier to choose threshold 
eyemap = normalizeimg(eyemap);

%create binary eyemap
imbinary = eyemap > 0.75; %0.75 works fairly well for db1

se = strel('disk', 3);
%close small gaps between objects, 
%useful for ex. when eyebrows are misstaken as eye candidates
imbinary = imclose(imbinary, se);

stats = regionprops(imbinary, "centroid");

%concatinate all centroids found in the image 
centroid = cat(1, stats.Centroid);

%If we have more than 2 eye candidates go through all pairs
%and compare their y-value differences, the pair of points with
%lowest y-diff are more probable to be the true eyes
if(length(centroid) > 2) 
    eyepoints = zeros(2);
    minY = realmax; %keep track of global y-minimum
    for i = 1:length(centroid)
        for j = i+1:length(centroid)
            y1 = centroid(i,2);
            y2 = centroid(j,2);
            heightdiff = abs(y1 - y2);
            
            if(heightdiff < minY)
                eyepoints(1,:) = centroid(i,:);
                eyepoints(2,:) = centroid(j,:);
                minY = heightdiff;
                %This can be improved further by checking the distance of the pair
                % of points to the middle in y-direction, the closer to the middle
                % the better and probably more accurate that those are the eyes
            end
        end
    end
    eyecoords = eyepoints;
else
    %found 2 or less eye candidates use the given candidates as eye points
    eyecoords = centroid;
end



