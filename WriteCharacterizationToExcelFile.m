%this script writes characterization workspaces to an excel file

a = [Lin0Dgr,Lin20Dgr,Lin40Dgr,Lin60Dgr,Lin80Dgr,Lin100Dgr,Lin120Dgr,Lin140Dgr,Lin160Dgr,Lin180Dgr;...
    Cir0Dgr,Cir20Dgr,Cir40Dgr,Cir60Dgr,Cir80Dgr,Cir100Dgr,Cir120Dgr,Cir140Dgr,Cir160Dgr,Cir180Dgr;...
    NoPolarizer,Black,ExposureTime,0,0,0,0,0,0,0];

%promt user to input filename
filename = input('Please input the excel filename you would like to save to writing filename.xlsx');

%write to excel spreadsheet
xlswrite(filename,a)

