function pnshow(im, gamma)

% function pnshow(im, [gamma = 1])
%
% shows image (gamma corrected) with red -ve green +ve colormap
%
% im    = image to display
% gamma = gamma brightness correction, default 1

if nargin == 2 & gamma ~= 1
	im = -((-(im < 0).*im).^(1/gamma))+((im > 0).*im).^(1/gamma);
end

imax = max(max(im));
imin = min(min(im));
imax = max(abs(imax), abs(imin));
imin = -imax;
im = 1+(im-imin)/(imax-imin)*64;

% make color map with white as zero
o  = ones(32, 1);
up = linspace(0, 1, 32)';
dn = linspace(1, 0, 32)';
rp = dn;  gp = o;  bp = dn; % +ve white -> green
rn = o;   gn = up; bn = up; % -ve white -> red
pnmap = [[rn gn bn]; [rp gp bp]];

% make color map with black as zero
% z  = zeros(32, 1);
% up = linspace(0, 1, 32)';
% dn = linspace(1, 0, 32)';
% rp = z;   gp = up;  bp = z; % +ve black -> green
% rn = dn;  gn = z;   bn = z; % -ve black -> red
% pnmap = [[rn gn bn]; [rp gp bp]];

z = zeros(32, 1);
r = [(32:-1:1)' z z];
g = [z (1:32)' z];
map = [r;[0 0 0]; g]/32;
image(im) 
colormap(pnmap)
%axis off
%axis equal
%axis ij
