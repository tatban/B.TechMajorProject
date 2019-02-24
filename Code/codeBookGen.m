%codebook generator written by tat
function SDcodeBook = codeBookGen(imgPath, codeBookSize)
%imgPath=input('Enter the path of the image folder: ','s');%put the path of the folder containing the images which should be included for code bookgeneration
    K=codeBookSize;
    fileArray = dir(strcat(imgPath,'\*.tif'));
    featureStore=[];
    for i=1:length(fileArray)
        img=imread(strcat(imgPath,'\',fileArray(i).name));
        imgComp=imcomplement(img);
        wordRegions=wordSegmentation(img);
        noOfRegions=size(wordRegions,1);
        for j=1:noOfRegions
            subImg=imcrop(imgComp,wordRegions(j,:));
            %figure;imshow(subImg);
            keyPoints=detectSURFFeatures(subImg);%detect the SURF features
            [SURF_Features, ~]=extractFeatures(subImg,keyPoints);%SURF descriptors
            featureStore=[featureStore;SURF_Features];
        end
    end
    [~,SDcodeBook]=kmeans(featureStore,K,'Replicates',3);
end