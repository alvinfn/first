tic;
[data,R] = geotiffread('E:\MOD\Penelitian\Tiff_percobaan\rembang_2014_2015.tif');
[x,y,z]=size(data);
%block size
ukuran_block = [25 25];
data = single(data);
%Transformasi data
fun_transform = @(block_struct) transformasi_coiflet1_lvl1(block_struct.data);

data = blockproc(data,ukuran_block,fun_transform,'UseParallel',true);
geotiffwrite('Hasil_transformasi.tif',single(data),R);
