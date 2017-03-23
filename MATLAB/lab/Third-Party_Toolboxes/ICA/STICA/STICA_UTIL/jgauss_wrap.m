function op=jgauss_wrap(ip,sd);% Smoothes values in ip array using wrap-around.% Make Gaussian mask for smoothing.num_sds = 2;mask_len = ceil(2*num_sds*sd) + 1;if mask_len==2 	fprintf('jgauss_wrap: sd too small\n');end;N = length(ip);if mask_len>Nmask_lenN	fprintf('ERROR jgauss_wrap, mask_len>ip_len');end;x = linspace(-num_sds,num_sds,mask_len); z = (x.*x) / (2*sd*sd);mask = exp(-z);mask = mask/sum(mask);% plot(mask); pause;op = zeros(1,N);for i=1:N	% shift ip along by one element.	x = jshift_wrap(ip,i);	res = dot(x(1:mask_len),mask);	op(i)=res;end;% Clean up.n=mask_len/2;n=-n;n = floor(n)+1;op=jshift_wrap(op,n);op=jreverse(op);%old off; plot(ip,'b');hold on;pause; plot(op,'g');