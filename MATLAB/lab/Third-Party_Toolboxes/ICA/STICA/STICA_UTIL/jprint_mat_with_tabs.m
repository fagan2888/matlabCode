function jprint_mat_with_tabs(m,fname,col_names,row_names);[nr nc]=size(m);fp=jfopen(fname,'w');if nargin>2fprintf(fp,'\t\t\t');for i=1:nc	name = col_names(i,:);	name=deblank(name);	fprintf(fp,'%s\t',name);end;fprintf(fp,'\n');end;s='%.3f\t';ss=[];for i=1:nc	ss=[ss s];end;ss=[ss '\n'];m=m';[nr nc]=size(m);for i=1:nc	if nargin>3		fprintf(fp,'%s ',row_names(i,:));	end;	val=m(:,i);	if val>=0		fprintf(fp,'%s',' ');	end;	fprintf(fp,ss,m(:,i));end;fclose(fp);