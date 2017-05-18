for ii = 1:5
Data(:,:,:,ii) = TakePicture(ExposureTime);
end
Data1 = Data(:,:,:,1)+Data(:,:,:,2)+Data(:,:,:,3)+Data(:,:,:,4)+Data(:,:,:,5);
Data2 =  Data(:,:,:,1)+Data(:,:,:,2);
SumData1 = sum(Data(317:707,421:859,2,1));
SumData2 = sum(Data(317:707,421:859,2,2));
SumData3 = sum(Data(317:707,421:859,2,3));
SumData4 = sum(Data(317:707,421:859,2,4));
SumData5 = sum(Data(317:707,421:859,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;