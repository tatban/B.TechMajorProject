function wordRegions=wordSegmentation(binImg)
%f1=imread('expImg1.tif');
binImg=imcomplement(binImg);
%figure('Name','Complemented Original');imshow(f1);
%w=fspecial('log',[3 3],0.5);
w1=fspecial('gaussian',[20 20],2.5*30);%gives better result.. parameters to be automatically optimized
w2=fspecial('motion',30,0);%gives good results.. parameters to be automatically optimized
grayImg=mat2gray(binImg);
filtered_img1=imfilter(grayImg,w1,'replicate');%gaussian blurr
filtered_img2=imfilter(grayImg,w2,'replicate');%motion blurr
gausBlurrBin=im2bw(filtered_img1,graythresh(filtered_img1));
motionBlurrBin=im2bw(filtered_img2,graythresh(filtered_img2));
%figure('Name','Effect of gaussian blur');imshow(filtered_img1);
%figure('Name','Effect of motion blur');imshow(filtered_img2);
%figure('Name','Effect of gaussian blur binarized');imshow(gausBlurrBin);
%figure('Name','Effect of motion blur binarized');imshow(motionBlurrBin);
mergedBin=gausBlurrBin | motionBlurrBin;%merging using or
%figure('Name','Merged Img');imshow(mergedBin);
se = strel('square',3);%structuring element
openedImg=imopen(mergedBin,se);
%figure('Name','Opened merged img');imshow(openedImg);
closedImg=imclose(openedImg,se);
%figure('Name','Closed Opened merged img');imshow(closedImg);
filledImg=imfill(closedImg,'holes');
%figure('Name','hole filled');imshow(filledImg);
img_noiseAreaRemoved=bwareaopen(filledImg,45);%removing areas with less than or equal to 45 pixel. value 45 is empirecal. to be automated
%figure('Name','noise removed');imshow(img_noiseAreaRemoved);
st = regionprops(img_noiseAreaRemoved, 'BoundingBox' );
wordRegions=reshape(floor(struct2array(st)),[4 length(st)])';
%---for visualisation----
% figure; imshow(f1);
% for k = 1 : length(st)
%   thisBB = st(k).BoundingBox;
%   rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','g','LineWidth',2 )
% end
end