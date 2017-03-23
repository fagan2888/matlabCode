function heights=triangular(data,center,bw);
% PURPOSE:
%     Triangular kernel function
% 
% USAGE:
%     heights=triangular(data,center,bw)
% 
% INPUTS:
%     data: Data used for height calculation
%     center: The location for height calculation
%     bw:  The bandwidth
% 
% OUTPUTS:
%     heights: Scalar height for kernel density
% 
% COMMENTS:
%     For kernel density estimation
% 
% Author: Kevin Sheppard
% kksheppard@ucsd.edu
% Revision: 2    Date: 12/31/2001
u=(data-center)/bw;
heights=(1-abs(u)).*(abs(u)<1);
