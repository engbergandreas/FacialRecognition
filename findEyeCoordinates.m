function [eyecoords] = findEyeCoordinates(inputImage)
Settings
%Image input should be in uint8 for colorcorrectiona and mask to work?

image= inputImage;

%image = colorCorrection(inputImage);

%Get face mask
facemask = generateFaceMask(image);

%Get mouth mask
[mouthImg, mouthCenter] = mouthMask(image, facemask);

%Remove mouth from facemask
facemask = facemask - mouthImg;

%clamps from [0, 1]
facemask = min(max(facemask, -1),1);

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

%Normalize squared values between 0 and 1 - this guarantees that eyemapc
%has values between 0 and 1
cbcb = normalizeimg(cbcb);
crcr_c = normalizeimg(crcr_c);
cbcr = normalizeimg(cbcr);

eyemapc = 1/3 .* (cbcb + crcr_c + cbcr);

%histogram equalize to pop eyes better
eyemapc = histeq(eyemapc);

%compute luminance eye map, test different structure elements and sizes
%disk with radius 10 works fairly well for db1
se = strel('disk', LUMINANCE_EYE_MAP_DISK_SIZE);
eyemapl = imdilate(Y, se) ./ (imerode(Y, se) + 1);

%Combine both eye maps and mask with facemask
%using facemask here gives better result when normalizing the image
%facemask removes a lot of false eye candidates
eyemap = eyemapc .* eyemapl .* facemask;
%eyemap = eyemap .* facemask;
eyemap = imdilate(eyemap, se);
%normalize to bring the highest values to 1 -> easier to choose threshold 
eyemap = normalizeimg(eyemap);

%create binary eyemap
imbinary = eyemap > THRESHOLD_EYEMASK_BINARY; %0.75 works fairly well for db1


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
                
                %can also check distance in x-direction from the center of
                %mouth and make sure 1 eye candidate is on each side of the
                %mouth. Use mouthCenter as the center point of the mouth 
            end
        end
    end
    eyecoords = eyepoints;
else
    %found 2 or less eye candidates use the given candidates as eye points
    %should have a backup case here if we only find one eye 
    %eg take the given eye and another point to the left or right side of
    %the mouth at the same height
    eyecoords = centroid;
end

    %Make sure left and right eye are in correct order of matrix given the
    %x-coordinate of the eyes found, ie. [lefteye; righteye]
    if(eyecoords(1,1) < eyecoords(2,1))
        lefteye = eyecoords(1,:);
        righteye = eyecoords(2,:);
    else
        lefteye = eyecoords(2,:);
        righteye = eyecoords(1,:);
    end
    eyecoords = [lefteye; righteye];
end


