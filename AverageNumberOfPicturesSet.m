%this function averages the amount of pictures in a gui set by
%handles.NumberOfPicturesSet taken from the workspace

function [AverageData] = AverageNumberOfPicturesSet(NumberOfPicturesSet,ExposureTime,Top,Bottom,Left,Right)
TopToBottom = Bottom - Top;
LeftToRight = Right - Left;
Data = zeros(TopToBottom,LeftToRight,NumberOfPicturesSet); 
for ii = 1:NumberOfPicturesSet
Data(:,:,:,ii) = TakePicture(ExposureTime,Left,Right,Top,Bottom);
end

for ii = 1:handles.NumberOfPicturesSet
    if ii <= 1 
        Data1 = 0;
    end
    Data1 = sum(Data(:,:,:,ii)) + Data1;
end

AverageData = sum(Data1)/NumberOfPicturesSet;