function [GeneratorPolarization] = JustGeneratorPolarization(CP1Cir0Dgr,CP1Lin0Dgr,CP1Lin45Dgr,CP1Lin90Dgr)
%This Function Outputs GereatorPolarization

CP1Cir0DgrmBl = (CP1Cir0Dgr);
CP1Lin0DgrmBl = (CP1Lin0Dgr);
CP1Lin45DgrmBl = (CP1Lin45Dgr);
CP1Lin90DgrmBl = (CP1Lin90Dgr);

%Here is the total Intensity Matrix
TotalIntensityMatrix = [CP1Cir0DgrmBl;CP1Lin0DgrmBl;CP1Lin45DgrmBl;CP1Lin90DgrmBl];

%Mueller Matrix of CP1
MMCP1Cir0Dgr = [0.392439, 0, 0.386982, 0];
MMCP1Lin0Dgr = [0.392439, 0., -0.0140248, -0.386728];
MMCP1Lin45Dgr = [0.392439, 0.0140248, 0., -0.386728];
MMCP1Lin90Dgr = [0.392439, 0., 0.0140248, -0.386728];

%Here is the matrix for the inverse multiplication
CP1Matrix = [MMCP1Cir0Dgr;MMCP1Lin0Dgr;MMCP1Lin45Dgr;MMCP1Lin90Dgr];

%now multiply the sum of the images by the inverse of the polarization
%matrix
S = linsolve(CP1Matrix,TotalIntensityMatrix);

%normalizing the stokes vector
GeneratorPolarization = S/S(1,1)