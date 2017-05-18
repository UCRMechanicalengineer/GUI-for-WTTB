%this script will take intensitys from a vertically linearly polarized
%system and output the Muller Matrix for a polarizer

%define theta
syms theta
%Rotation matrix
Mrot = symfun([1, 0, 0, 0; 0, cos(2*theta), sin(2*theta), 0;...
    0, -sin(2*theta), cos(2*theta), 0; 0, 0, 0, 1], theta);

%define phi
syms phi
%Mueller matrix of a general retarder with its fast axis at 0 degrees (x axis)
Mretx = symfun([1, 0, 0, 0; 0, 1, 0, 0;...
    0, 0, cos(phi), sin(phi);...
    0, 0, -sin(phi), cos(phi)], phi);

syms px py
%Mueller matrix of a general linear polarizer
Mlinp = symfun(0.5*[((px^2)+(py^2)),((px^2)-(py^2)),0,0;...
                ((px^2)-(py^2)),((px^2)+(py^2)),0,0;...
                0,0,2*px*py,0;...
                0,0,0,2*px*py], [px py]);

%where the linear polarizer is attenuating the x-axis px = 0 and py = 1

MlinpPy1 = Mlinp(0,1);

%Linear horizontal stokes vector
LinHor = [1; 1; 0; 0];

%check to see if the horizontal stokes vector is completely attenuated
MlinpPy1LinHor = MlinpPy1*LinHor;

%Linear vertical stokes vector
LinVert = [1;-1;0;0];

%check to see of the vertical stokes vector is completely unattenuated
MlinpPy1LinVert = MlinpPy1*LinVert;

%Put 90 degrees into a rotator to get a quarter wave plate
QrtWvPlt = Mretx(deg2rad(90));

%For a left circular polarizer where the linear polarizer of the
%quarterwave plate is 45 degrees from the vertical access
LeftCir = QrtWvPlt*Mrot(deg2rad(-45))*Mlinp(1,0)*Mrot(deg2rad(45));

%For a right circular polarizer where the linear polarizer of the
%quarterwave plate is 45 degrees from the vertical access
RightCir = QrtWvPlt*Mrot(deg2rad(-45))*Mlinp(0,1)*Mrot(deg2rad(45));

%For a flipped left circular polarizer
FlipLeftCir = Mrot(deg2rad(-(180-45)))*Mlinp(1,0)*Mrot(deg2rad(180-45))*QrtWvPlt;

%General linear polarizer rotated 45 degrees (x to y)
MGpol45 = Mrot(deg2rad(-45))*Mlinp*Mrot(deg2rad(45));

%General circular polarizer
GCP = Mretx*MGpol45(px, py);

%General circular polarizer circular side rotated
RCPCS = symfun(Mrot(-theta)*GCP*Mrot(theta), [theta, px, py, phi]);

%A rotated circular polarizer circular side with some inputs
RCPCS(0,1,0,pi/4);

%So multiplying the first line of RCPCS with a vertical stokes vector gives
TotalIntensityVert = RCPCS*[1;-1;0;0];

%Making just a matrix not a function
TotalIntensityVertNonFun = TotalIntensityVert(theta, px, py, phi);

%Getting just the top row
TotalIntensityVertTop = symfun(TotalIntensityVertNonFun(1,1), [theta, px, py]);

%getting the array to plot 
TotalIntensityVertTopArray = TotalIntensityVertTop(deg2rad(0:180),1,0);

subplot(2,2,1);
plot(0:180,TotalIntensityVertTopArray);
str1 = {'Perfect General', 'Circular'};
title(str1);
ylabel('Intensity');
xlabel('Angle in degrees');


%For a flipped general circular polarizer
GCPF = Mrot(deg2rad(-(180-45)))*Mlinp(px,py)*Mrot(deg2rad((180-45)))*Mretx;

%For a rotated flipped general circular polarizer
RGCPF = symfun(Mrot(-theta)*GCPF*Mrot(theta), [theta, px, py, phi]);

%So the Stokes vector with the flipped polarizer is
TotalIntensityVertFlipped = RGCPF*[1;-1;0;0];

%Making just a matrix not a function
TotalIntensityVertNonFunFlipped = TotalIntensityVertFlipped(theta, px, py, phi);

%Getting just the top row
TotalIntensityVertTopFlipped = symfun(TotalIntensityVertNonFunFlipped(1,1), [theta, px, py, phi]);

%getting the array to plot 
TotalIntensityVertTopArrayFlipped = TotalIntensityVertTopFlipped(deg2rad(0:180),1,0,deg2rad(90));

subplot(2,2,2);
plot(0:180,TotalIntensityVertTopArrayFlipped);
str2 = {'Perfect General Circular', 'Polarizer Flipped'};
title(str2);
ylabel('Intensity');
xlabel('Angle in degrees');


%Define the degrees
Degrees = 0:20:180;

%Define the circular intensitys
CircularIntensitys = [Cir0Dgr,Cir20Dgr,Cir40Dgr,Cir60Dgr,Cir80Dgr,Cir100Dgr,Cir120Dgr,Cir140Dgr,...
    Cir160Dgr,Cir180Dgr];

%Define the linear intensitys
LinearIntensitys = [Lin0Dgr,Lin20Dgr,Lin40Dgr,Lin60Dgr,Lin80Dgr,Lin100Dgr,Lin120Dgr,Lin140Dgr,...
    Lin160Dgr,Lin180Dgr,];


%plot the circular intensitys
subplot(2,2,3);
plot(Degrees, (CircularIntensitys-Black)/NoPolarizer,':w','Marker','d','MarkerFaceColor','g');
str3 = {'Circular', 'Intensitys'};
title(str3);
xlabel('Degrees');
ylabel('Intensity');
hold on

%plot the linear intensitys
subplot(2,2,4);
plot(Degrees, (LinearIntensitys-Black)/NoPolarizer,':dw','Marker','d','MarkerFaceColor','g');
str4 = {'Linear', 'Intensitys'};
title(str4);
xlabel('Degrees');
ylabel('Intensity');
hold on

%define the phase shift
alpha = -11;

%Create anonymous function to find px and py
modelfunpxpy =  @(p,x)sin(2*x)*(p(1)^2/2 - p(2)^2/2) + p(1)^2/2 + p(2)^2/2;

%Fit the functions to the Data
x = deg2rad(Degrees+alpha);
y = (CircularIntensitys-Black)/NoPolarizer;


beta0 = [.9, .1];
TIVT = fitnlm(x,y, modelfunpxpy, beta0);

%output values
p1 =TIVT.Coefficients{1,1};
p2 =TIVT.Coefficients{2,1};

%Create anonymous function to find phi
modelfunphi = @(phi,x)p1^2/2 + p2^2/2 - sin(2*x)*cos(phi(1))*(p1^2/2 - p2^2/2);

%Fit the functions to the Data
x = deg2rad(Degrees+alpha);
y = (LinearIntensitys-Black)/NoPolarizer;

beta0 = [deg2rad(90)];
TIVT2 = fitnlm(x,y, modelfunphi, beta0);
phi1 = TIVT2.Coefficients{1,1};
px1 = p1
py1 = p2
phi1 = rad2deg(phi1)


%Plot the points for circular intensity
Degrees2 = 0:1:179;
x = deg2rad(Degrees2+alpha);
subplot(2,2,3);
plot(Degrees2,TotalIntensityVertTop(x,p1,p2))

%Plot the points for linear intensity
subplot(2,2,4);
plot(Degrees2,TotalIntensityVertTopFlipped(x,p1,p2,deg2rad(phi1)))

%Muller matrix for the Circular side
%MMCS = symfun(GCP, [px,py,phi]);
%MMCS = MMCS(p1,p2,phi1);
%MMCS = double(MMCS)
%Muller matrix for the Linear side
%MMLS = symfun(GCPF, [px,py,phi]);
%MMLS = MMLS(p1,p2,phi1);
%MMLS = double(MMLS)

%Muller matrix for the Circular side
MMCS = RCPCS(deg2rad((0+alpha:359+alpha)), p1, p2, deg2rad(phi1));

%Get the information out of the cell and into an array size (4,4,360)
MMCSAllDegCS = zeros(4,4,360);

for ii=1:4
    for jj=1:4
        for qq=1:360
            MMCSAllDegCS(ii,jj,qq) = MMCS{ii,jj}(qq);
        end
    end
end

%Muller matrix for the Linear side
MMCS = RGCPF(deg2rad((0+alpha:359+alpha)), p1, p2, deg2rad(phi1));

%Get the information out of the cell and into an array size (4,4,360)
MMCSAllDegLS = zeros(4,4,360);

for ii=1:4
    for jj=1:4
        for qq=1:360
            MMCSAllDegLS(ii,jj,qq) = MMCS{ii,jj}(qq);
        end
    end
end













