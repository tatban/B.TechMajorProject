%extracts scale and orientation histogram features.
%SOH stands for scale and orientation histogram
function SOH_Vector = SO_featureExtractor(scales, orientations, Numoctaves, NumSubLevels)
    if nargin<3
        Numoctaves=3;%matlab default
        NumSubLevels=4;%matlab default
    end
    if length(scales)~=length(orientations)
        error('Scales and Orientation must have same lengths');
    end
    orientations=rad2deg(orientations);%converting the orientations in degree unit from radians
    n=length(scales);
    angleStep_phi=15;%step angle for orientation in degrees. value 15 devides total 360 degrees in 24 bins
    %Z=Numoctaves*NumSubLevels;
    Z=Numoctaves*NumSubLevels+1;%modified adaptation. Reason for +1 to be defined
    Obin=ceil(360/angleStep_phi);%number of orientation bins
    M=Z*Obin;%M is the size of the SOH feature vector
    SOH_Vector=zeros(1,M);%initilazing the SOH feature vector with zeros.
    for i=1:n
        %display(i);%for debug
        bin=ceil(orientations(i)/angleStep_phi);
        scales=round(scales);
        idx=(Obin*(scales(i)-1))+bin;
        %idx=round(idx);%converting the index to integer
        SOH_Vector(idx)=SOH_Vector(idx)+1;%updating the SOH vector
    end
    SOH_Vector=SOH_Vector./sum(SOH_Vector);%normalizing the vector
end