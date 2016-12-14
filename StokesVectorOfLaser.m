function [LaserPolarization] = StokesVectorOfLaser(...
    FinalPictureOrangeLinear,FinalPictureGreenLinear,...
    FinalPictureBlueLinear,FinalPictureBlueCircular)

%These are the top lines for the positions for CP1
Io = [0.25427 0.0309288 0 -0.236628];
Ig = [0.25427 0 0.0309288 -0.236628];
Ib = [0.25427 0 -0.0309288 -0.236628];
Ibc = [0.25427 0 -0.238641 0];
%Here is the matrix for the inverse multiplication(The top of every
%polarization matrix multipied with the stokes vector.)
matrixmult = [Io;Ig;Ib;Ibc]; 

%OrangeLinear sums 
SumOLCol = sum(FinalPictureOrangeLinear);
SumOLRow = sum(SumOLCol);
OrangeLnrGrnChnlSum = SumOLRow(:,:,2);

%GreenLinear sums
SumGLCol = sum(FinalPictureGreenLinear);
SumGLRow = sum(SumGLCol);
GreenLnrGrnChnlSum = SumGLRow(:,:,2);

%BlueLinear sums
SumBLCol = sum(FinalPictureBlueLinear);
SumBLRow = sum(SumBLCol);
BlueLnrGrnChnlSum = SumBLRow(:,:,2);

%BlueCircular sums
SumBCCol = sum(FinalPictureBlueCircular);
SumBCRow = sum(SumBCCol);
BlueCirGrnChnlSum = SumBCRow(:,:,2);

%Matrix of the total intensitys of the different polarization states
pixelsum = [OrangeLnrGrnChnlSum;GreenLnrGrnChnlSum;BlueLnrGrnChnlSum;BlueCirGrnChnlSum];

%now multiply the sum of the images by the inverse of the polarization
%matrix
S = linsolve(matrixmult,pixelsum);

%normalizing the stokes vector
LaserPolarization = S/S(1,1);