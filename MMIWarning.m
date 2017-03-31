%This funtion checks the Data to see if its Saturated

function [WarningYN] = MMIWarning(Data)

WarningYN = 0;
Datamax = max(Data);
if Datamax == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
warndlg(WarningString)
WarningYN = 1;
end