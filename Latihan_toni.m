
tic;
[data,R]=geotiffread('E:\MOD\Penelitian\Latihan Toni\Pembobotan\Hasil_Sawah.tif');
[x,y,z]=size(data);

%block size
ukuran_block=[25 25];
data=single(data);

%start parallel job
pool=parpool; %memanggil pekerja

%normalisasi data sehingga mendapat NaN
fun_normalisasi=@(block_struct)normalisasi_data_block(block_struct.data);

Dmask=blockproc(data,ukuran_block,fun_normalisasi,'useparallel',true);

Dmask=reshape(single(Dmask),[x*y z]);

%memisahkan merubah bentuk matriks pada data utama
data=reshape(data,[x*y z]);

%membuang nilai 0 dan -3000 menjadi NaN
data=data(~isnan(Dmask(:,1)),:);

%membuat peta mask non data dengan format binary(1/0)
Dmask=~isnan(Dmask(:,1));
Dmask=reshape(Dmask,[x*y 1]);

%transformasi wavelet
level=1;
waveletname='coif1';

%decomposition signal
dec=mdwtdec('r',data,level,waveletname);

%get aproximation level 1
datawvlet=mdwtrec(dec,'a',1);

datawvlet=single(datawvlet);

for k=25
    stream=RandStream('mlfg6331_64'); %Random number stream
    option=statset('UseParallel',1,'UseSubstream',1,...
        'Streams',stream);
    [hasil_id{k},hasil_center{k}]=kmeans(datawvlet,k,'distance','sqEuclidean','Options',option,'Display','final','Replicates',3,'MaxIter',10000);
    %[hasil_id{k},hasil_center{k}]=kmeans(datawvlet,k,'distance','sqEuclidean','Options',option,'Display','final','Replicates',3,'MaxIter',100);
    img=peta_utama(hasil_id{k},Dmask);
    img=reshape(img,[x y 1]);
    %a=strcat(num2str(k),'_nganjuk.tif');
    geotiffwrite(strcat(num2str(k),'Hasil_kmeans_2015.tif'),img,R);
end
toc;


  
    

