%this script outputs the theoretical values of intensity into the workspace
%to verify the code is working

% CP1Cir0DgrMinusBlSumRow = sin(deg2rad(2*0))*(px1^2/2 - py1^2/2) + px1^2/2 + py1^2/2;
% CP1Lin0DgrMinusBlSumRow = px1^2/2 + py1^2/2 - sin(deg2rad(2*0))*cos(deg2rad(phi1))*(px1^2/2 - py1^2/2);
% CP1Lin45DgrMinusBlSumRow = px1^2/2 + py1^2/2 - sin(deg2rad(2*45))*cos(deg2rad(phi1))*(px1^2/2 - py1^2/2);
% CP1Lin90DgrMinusBlSumRow = px1^2/2 + py1^2/2 - sin(deg2rad(2*90))*cos(deg2rad(phi1))*(px1^2/2 - py1^2/2);

CP1Cir0DgrMinusBlSumRow = .3846;
CP1Lin0DgrMinusBlSumRow = .3825;
CP1Lin45DgrMinusBlSumRow = .3476;
CP1Lin90DgrMinusBlSumRow = .3646;