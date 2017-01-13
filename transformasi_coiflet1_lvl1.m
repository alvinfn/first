function imgS = transformasi_coiflet1_lvl1(X)
[x,y,z] = size(X);
X = reshape(X,[x*y z]);

level = 1;
waveletName = 'coif1';

%decomposition signal
dec = mdwtdec('r',X,level,waveletName);

%get approximation level 1
imgS = mdwtrec(dec,'a',1);

imgS = reshape(imgS,[x y z]);
end
