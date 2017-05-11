%this function averages the amount of pictures in a gui set by
%handles.NumberOfPicturesSet taken from the workspace

function [AverageData] = AverageNumberOfPicturesSet(NumberOfPicturesSet,ExposureTime,Top,Bottom,Left,Right)
TopToBottom = (Bottom - Top)+1;
LeftToRight = (Right - Left)+1;
 
for ii = 1:NumberOfPicturesSet
    if ii <= 1
        Data1 = zeros(TopToBottom,LeftToRight);
    end
    Data = TakePicture(ExposureTime,Left,Right,Top,Bottom);
    Data1 = Data + Data1;
end

assignin('base','Data1',Data1);

AverageData = flipud(Data1/NumberOfPicturesSet);
end

%AverageData = sum(Data1)/NumberOfPicturesSet;