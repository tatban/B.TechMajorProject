%creates the histograms of surf descriptors. SDS stands for SURF Descriptor Signature
%function written by tat
function SDS_Vector = SDS_featureExtractor(codeBook, SURF_Descriptors,t)
    if nargin<3
        t=10;%setting 10 as default value of t
    end
    N=size(codeBook,1);%N is the length of the code book
    n=size(SURF_Descriptors,1);%n is the number of surf descriptors
    SDS_Vector=zeros(1,N);%initializing the SDS vector with zeros
    for i= 1:n
        EDVi=[];
        for j=1:N
            v1=SURF_Descriptors(i,:);
            v2=codeBook(j,:);
            v=v1-v2;%calculating eucledian distance between v1 and v2
            EDij=sqrt(v*v');%EDij is the eucledian distance between v1 and v2
            EDVi=[EDVi,EDij];
        end
        [~,sortedIndex]=sort(EDVi,'ascend');
        IDX=sortedIndex(1:t);%selecting top t indeces
        SDS_Vector(IDX)=SDS_Vector(IDX)+1;%updating the sds vector
    end
    SDS_Vector=SDS_Vector./sum(SDS_Vector);%normalizing the sds feature vector
end
