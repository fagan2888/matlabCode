function v0=jconvolve(vv1,vv2);n1 = length(vv1);n2 = length(vv2);% Make v1 larger of vv1 and vv2.if n1>n2	v1=vv1; v2 = vv2;else	v1=vv2; 	v2=vv1;end;n1 = length(v1);n2 = length(v2);	v0 = zeros(1,n1);for i=1:n1	v1_shifted = jshift_wrap(v1,i-1); % i-1=0-->n1-1	v0(i) = dot(v2,v1_shifted(1:n2) );end;% Compensate for shift.v0 = jshift_wrap(v0,-floor(n2/2));v0=reverse(v0);