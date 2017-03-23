function im1 = make_disc_noise_image(nr, nc, X,Y,radius)% Make disc in image of size nrxnc with radius=radius% centred at point X Y. Note that Xy=[-1,1].% square is -1-->1, so position circle with X==-1 to +1.% e.g. a = make_disc_noise_image(32,32,0.5,0.5,0.2);if(nr ~= nc)	return;endn = nr;[x, y] = meshgrid(linspace(-1, 1, n));im1 = ((x-X).^2+(y+Y).^2) < radius; temp=randn(size(im1));im1=im1.*temp;% im1 =  sin(x.^3 + y.^3);im1 = im1(:);  im1 = im1-mean(im1);  im1 = im1/std(im1);im1=reshape(im1,nr,nc);%jfig(9); imagesc(im1);