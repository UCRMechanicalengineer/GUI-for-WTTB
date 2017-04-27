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





