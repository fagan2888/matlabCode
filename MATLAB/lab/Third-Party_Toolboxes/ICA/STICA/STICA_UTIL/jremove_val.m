function [x, ind_val, ind_notval]=jremove_val(x,val);% Remove all cells with value==val.% Return shortened array.if isempty(x)	x=[]; else	ind_val=find(x==val);	y=(x~=val);	ind_notval=find(y);	x=x(ind_notval);end;