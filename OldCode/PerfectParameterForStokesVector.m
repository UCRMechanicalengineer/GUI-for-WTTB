%This script is using perfect parameters for a stokes vector

%Here is the total Intensity Matrix
TotalIntensityMatrix = [CP1Cir0DgrMinusBlSumRow/NoPolarizer;CP1Lin0DgrMinusBlSumRow/NoPolarizer;CP1Lin45DgrMinusBlSumRow/NoPolarizer;CP1Lin90DgrMinusBlSumRow/NoPolarizer];

%Mueller Matrix of CP1
MMCP1Cir0Dgr = evalin('base', 'MMCSAllDegCS(1,1:4,1)');
MMCP1Lin0Dgr = evalin('base','MMCSAllDegLS(1,1:4,1)');
MMCP1Lin45Dgr = evalin('base','MMCSAllDegLS(1,1:4,46)');
MMCP1Lin90Dgr = evalin('base','MMCSAllDegLS(1,1:4,91)');

%Here is the matrix for the inverse multiplication
CP1Matrix = [MMCP1Cir0Dgr;MMCP1Lin0Dgr;MMCP1Lin45Dgr;MMCP1Lin90Dgr];

%now multiply the sum of the images by the inverse of the polarization
%matrix
S = linsolve(CP1Matrix,TotalIntensityMatrix);

%normalizing the stokes vector
GeneratorPolarization = S/S(1,1)