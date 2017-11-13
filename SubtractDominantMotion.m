function mask = SubtractDominantMotion(image1, image2)
% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size
    image1 = im2double(image1);
    image2 = im2double(image2);
    M = LucasKanadeAffine(image1, image2);
    %M = InverseCompositionAffine(image1, image2);
    image_warped = warpIm(image1,M,size(image2),NaN);
    valid_areas = ~isnan(image_warped);
    image_warped(~valid_areas) = 0;
    subtract_image = abs(image2-image_warped).*valid_areas;
    thresh = graythresh(subtract_image);
    mask = im2bw(subtract_image, thresh);
    SE = strel('disk', 8);
    mask = imdilate(mask, SE);
    mask = imerode(mask, SE);
    mask = mask - bwareaopen(mask, 500);
end

