%For running a stokes vector with some data


%Subtract the black
CP1Cir0DgrMinusBl = (CP1Cir0Dgr-Black);
CP1Lin0DgrMinusBl = (CP1Lin0Dgr-Black);
CP1Lin45DgrMinusBl = (CP1Lin45Dgr-Black);
CP1Lin90DgrMinusBl = (CP1Lin90Dgr-Black);

%Sum for the total intensity
CP1Cir0DgrMinusBlSumCol = sum(CP1Cir0DgrMinusBl);
CP1Cir0DgrMinusBlSumRow = sum(CP1Cir0DgrMinusBlSumCol);

CP1Lin0DgrMinusBlSumCol = sum(CP1Lin0DgrMinusBl);
CP1Lin0DgrMinusBlSumRow = sum(CP1Lin0DgrMinusBlSumCol);

CP1Lin45DgrMinusBlSumCol = sum(CP1Lin45DgrMinusBl);
CP1Lin45DgrMinusBlSumRow = sum(CP1Lin45DgrMinusBlSumCol);

CP1Lin90DgrMinusBlSumCol = sum(CP1Lin90DgrMinusBl);
CP1Lin90DgrMinusBlSumRow = sum(CP1Lin90DgrMinusBlSumCol);



assignin('base','CP1Cir0DgrMinusBl',CP1Cir0DgrMinusBl)
assignin('base','CP1Lin0DgrMinusBl',CP1Lin0DgrMinusBl)
assignin('base','CP1Lin45DgrMinusBl',CP1Lin45DgrMinusBl)
assignin('base','CP1Lin90DgrMinusBl',CP1Lin90DgrMinusBl)

%Here is the total Intensity Matrix
TotalIntensityMatrix = [CP1Cir0DgrMinusBlSumRow;CP1Lin0DgrMinusBlSumRow;CP1Lin45DgrMinusBlSumRow;CP1Lin90DgrMinusBlSumRow];

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