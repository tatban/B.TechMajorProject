%featureExtraction
function featureVector = featureExtraction(img,codeBook)
    wordRegions=wordSegmentation(img);
    icomp=imcomplement(img);
    SURF_Descriptors=[];
    SURF_Scales=[];
    SURF_Orientations=[];%in radian
    count_wr=size(wordRegions,1);%number of word regions
    for i=1:count_wr
        subImg=imcrop(icomp,wordRegions(i,:));
        keyPoints=detectSURFFeatures(subImg);%no of octaves and sublevels values to be thought other than matlab default
        [descriptor, validPoints]=extractFeatures(subImg,keyPoints);
        SURF_Descriptors=[SURF_Descriptors;descriptor];%SURF descriptors for SDS
        SURF_Scales=[SURF_Scales;validPoints.Scale];%Scales for SOH
        SURF_Orientations=[SURF_Orientations;validPoints.Orientation];%Orientations for SOH in radian
    end
    SDS_Vector=SDS_featureExtractor(codeBook,SURF_Descriptors);
    SOH_Vector=SO_featureExtractor(SURF_Scales,SURF_Orientations);
    featureVector=[SDS_Vector,SOH_Vector];
end