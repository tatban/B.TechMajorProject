%for author verification
%written by tat
%numMatch is the maximum size of the list of most matched author
%the most matched author list is ordered in the descending values of similarity measure
%function mostMatchedAuthorList=verifyAuthor(imageSample,codeBook,authorDB,numMatch)%use this when using distance (Manhatan and Chi square)
function [mostMatchedAuthorList,verificationTime]=verifyAuthor(imageSample,codeBook,elmModel)
    %if nargin < 4
        %numMatch=3;%by default it shows top three matches
    %end
    featureVector=featureExtraction(imageSample,codeBook);
   %% %the following code uses manhatan and chi square distance to find similarity
%    n=size(authorDB,1);%n is the number of entries in the author database
%    %SDS_Dist=[];
%    %SOH_Dist=[];
%    Dist=[];
%    w=0.6;%weight for combining the two distances of the two types of feature. value 0.06 is just assumption. Actual value to be optimized 
%    for i=1:n
%        authorId=authorDB(i,1);
%        SDS_new=featureVector(1:300);%SDS of the new or test sample
%        SOH_new=featureVector(301:612);%SOH of the new or test sample
%        SDS_enrolled=authorDB(i,2:301);%SDS of the ith touple of the author db
%        SOH_enrolled=authorDB(i,302:613);%SOH of the ith touple of the author db
%        SDS_dist_i=sum(abs(SDS_new-SDS_enrolled));%manhatan distance between new and ith touple SDS
%        SOH_dist_i=sum(((SOH_new-SOH_enrolled).^2)./(SOH_new+SOH_enrolled+0.000001));%chi-squared distance between new and ith touple SOH
%        %SDS_Dist=[SDS_Dist;SDS_dist_i];
%        %SOH_Dist=[SOH_Dist;SOH_dist_i];
%        dist_i=(w*SDS_dist_i)+(1-w)*SOH_dist_i;%combined ith distance
%        Dist=[Dist;[authorId,dist_i]];%distance matrix. contains distance or dissimilarities of the new image with the enrolled authors with corresponding author ids
%    end
%    Dist=sortrows(Dist,2);%sorting the distances values in ascending order with the corresponding author ids
%    %display(Dist);%for debug
%% following code calls ELM to predict  the author id from the image sample
    tic;
    [predictedId,~]=elm_predictSingle_authIdentification(featureVector,elmModel);
    verificationTime=toc;
%%
   %mostMatchedAuthorList=Dist(1:numMatch,:);%%use this when using distance (Manhatan and Chi square)
   mostMatchedAuthorList=predictedId;
end