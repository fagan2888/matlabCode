function jfig(i,nrows,ncols,x_left,y_bot);

figure(i);

% Set Window
fig     = gcf;

if nargin==1
	% NOTE THAT A K=300 GIVES A PIXMAP OF 299*299.
	% SET STANDARD SIZE.
	k=300; % Set to K*100 for make_movie not K*100+1.
	nrows=k; ncols=k;
end;

if nargin<4
	pos=get(fig,'position');
	x_left=pos(1);
	y_bot =pos(2);
	ncols1=pos(3);
	nrows1=pos(4);

	% SET STANDARD POSITION.
	%a=get(fig,'position') ;
	%x_left=970; y_bot=650;
end;

set(fig,'position',[x_left y_bot ncols nrows]);

% Set bounds of drawing area in figure
% arect = [0 0 1 1]; set(gca,'Position',arect);

