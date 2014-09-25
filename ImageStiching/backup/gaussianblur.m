function [ imgblur ] = gaussianblur( img, sigma )
%GAUSSIANBLUR Summary of this function goes here
%   Detailed explanation goes here
    imgblur=imfilter(img,fspecial('gaussian',floor(5*sigma),sigma),'symmetric');
end

