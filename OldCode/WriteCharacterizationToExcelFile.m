%this script writes characterization workspaces to an excel file

a = [sum(Lin0Dgr),sum(Lin20Dgr),sum(Lin40Dgr),sum(Lin60Dgr),sum(Lin80Dgr),sum(Lin100Dgr),sum(Lin120Dgr),sum(Lin140Dgr),sum(Lin160Dgr),sum(Lin180Dgr);...
    sum(Cir0Dgr),sum(Cir20Dgr),sum(Cir40Dgr),sum(Cir60Dgr),sum(Cir80Dgr),sum(Cir100Dgr),sum(Cir120Dgr),sum(Cir140Dgr),sum(Cir160Dgr),sum(Cir180Dgr);...
    sum(NoPolarizer),sum(Black),sum(ExposureTime),0,0,0,0,0,0,0];

%promt user to input filename
filename = input('Please input the excel filename you would like to save to writing filename.xlsx');

%write to excel spreadsheet
xlswrite(filename,a)

