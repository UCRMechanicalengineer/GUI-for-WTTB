%This Function Subtracts the Black Background from the other pictures
function [CP1Cir0DgrMinusBl,CP1Lin0DgrMinusBl,CP1Lin45DgrMinusBl,CP1Lin90DgrMinusBl] = MinusBlack(CP1Cir0Dgr,CP1Lin0Dgr,CP1Lin45Dgr,CP1Lin90Dgr,Black)

CP1Cir0DgrMinusBl = (CP1Cir0Dgr-Black);
CP1Lin0DgrMinusBl = (CP1Lin0Dgr-Black);
CP1Lin45DgrMinusBl = (CP1Lin45Dgr-Black);
CP1Lin90DgrMinusBl = (CP1Lin90Dgr-Black);