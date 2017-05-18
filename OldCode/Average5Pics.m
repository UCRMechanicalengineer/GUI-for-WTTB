%This function takes 5 pictures and averages them into one picture.
function [AverageData] = Average5Pics(ExposureTime)
%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(ExposureTime);
end
AverageData = (Data(:,:,:,1)+Data(:,:,:,2)+Data(:,:,:,3)+Data(:,:,:,4)+Data(:,:,:,5))/5;

