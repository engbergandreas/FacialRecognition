function [output_image] = eyeMask(input_image)
%eyeMask Return a mask consisting of two eyes
%   Detailed explanation goes here

chroma_image=rgb2ycbcr(input_image);

normalized_chroma_image = normalize(chroma_image);

output_image = normalized_chroma_image;

end