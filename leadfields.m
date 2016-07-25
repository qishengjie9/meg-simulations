%George Roberts 22/07/2016
%Inverse problem in MEG

clear;

load('data/Br_3.mat');  %load Br, rx, ry, rz
sqch = 16;
Nch = sqch^2;
[xsp, ysp, zsp] = sphere(sqch-1);
h = slice(rx, ry, rz, Br, xsp, ysp, zsp);

for n = 1:sqch
hold on;
plot3(xsp(n,:), ysp(n,:), zsp(n,:),'rx');

end

L = get(h,'CData');
sizl = size(L);
shading interp;
% caxis([-5.6e-16, 5.6e-16]);
caxis([-8 8]);
set(h,'EdgeAlpha',0);
set(h,'FaceAlpha',0.6);

L = reshape(L,1,sizl(1)*sizl(2));
t = linspace(0, 0.5, 150);
f = 18;
q = 1e-9 * sin(2*pi*f*t);


Bt = L'*q;

% GRIDS
% Get back R and unit vectors from passed grid
R = sqrt(rx.^2 + ry.^2 + rz.^2);  %calculate |r| at each point

%getting normal vectors
erx = rx./R;
ery = ry./R;
erz = rz./R;

%Get theta and phi for each point in grid
theta = acos(rz./R);
phi = atan2(ry,rx);

%Get theta unit vector at every point
thx = cos(theta).*cos(phi);
thy = cos(theta).*sin(phi);
thz = -sin(theta);

%Get phi unit vector at every point
phx = -sin(phi);
phy = cos(phi);
phz = zeros(size(rx));

p = 20;
thx1 = thx(p,p,p);
thy1 = thy(p,p,p);
thz1 = thz(p,p,p);
phx1 = phx(p,p,p);
phy1 = phy(p,p,p);
phz1 = phz(p,p,p);

theta_t = linspace(0, 2*pi, 45);
v_tan_x = cos(theta_t).*thx1 + sin(theta_t).*phx1;
v_tan_y = cos(theta_t).*thy1 + sin(theta_t).*phy1;
v_tan_z = cos(theta_t).*thz1 + sin(theta_t).*phz1;

rvect = [rx(p,p,p), ry(p,p,p), rz(p,p,p)];
rmult = repmat(rvect, [45 1]);

hold on;
quiver3( rmult(:,1)', rmult(:,2)', rmult(:,3)', v_tan_x, v_tan_y, v_tan_z);

% x = randn(1,N);
% y = randn(1,N);
% 
% cov1 = cov(x,y)
% 
% xdm = x - mean(x);
% ydm = y - mean(y);
% 
% sxy = xdm*ydm'/N;
% 
% cov2 = mean(sxy)
% 
% diff = cov1(1,2) - cov2
