%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture;
end
AverageData = (Data(:,:,:,1)+Data(:,:,:,2)+Data(:,:,:,3)+Data(:,:,:,4)+Data(:,:,:,5))/5;
