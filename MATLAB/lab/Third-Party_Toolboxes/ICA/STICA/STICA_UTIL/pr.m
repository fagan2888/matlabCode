function c=pr(str)%if nargin>0%	fprintf('pr: %s\n',str);%end;%press_return;drawnow;if nargin>0	fprintf('%s\n',str);end;fprintf('Press any key ... ');c=getchar;fprintf('%c\n',c);%press_return;