tic;
[data,R]=geotiffread('Sawah_Jateng_17JULI.tif');
[x,y,z]=size(data);

%block size
ukuran_block=[25 25];
data=single(data);

%start parallel job
pool=parpool; %memanggil pekerja

%normalisasi data sehingga mendapat NaN
fun_normalisasi=@(block_struct)normalisasi_data_block(block_struct.data);

datanorm=blockproc(data,ukuran_block,fun_normalisasi,'useparallel',true);

datanorm=reshape(single(datanorm),[x*y z]);

%memisahkan merubah bentuk matriks pada data utama
data=reshape(data,[x*y z]);

%membuang nilai 0 dan -3000 menjadi NaN
data=data(~isnan(datanorm(:,1)),:);

%membuat peta mask non data dengan format binary(1/0)
Dmask=~isnan(datanorm(:,1));
Dmask=reshape(Dmask,[x*y 1]);

%normalisasi scaling -1 to 1
datanorm = datanorm(~isnan(datanorm(:,1)),:);

%gandain array
RCA = repmat(datanorm,1,10);
[a, b] = size(RCA);

%hann windowing
winhan = hann(b);
winhan = repmat(winhan,1,a);
YHAN = winhan'.*RCA;

%FFT Analysis
Fs = 23;
T = 1/Fs;
Per = 1/Fs;

NFFT = 2^nextpow2(b);
Y = fft(YHAN,NFFT,2)/b;
f = Fs/2*linspace(0,1,NFFT/2+1);
dataabs = 2*abs(Y(:,1:NFFT/2+1));

%k-mean clustering
for k=25
    stream=RandStream('mlfg6331_64'); %Random number stream
    option=statset('UseParallel',1,'UseSubstream',1,...
        'Streams',stream);
    [fft_id{k},fft_center{k}]=kmeans(absffthan,k,'distance','sqEuclidean','Options',option,'Display','final','Replicates',3,'MaxIter',10000);
    img=peta_utama(fft_id{k},Dmask);
    img=reshape(img,[x y 1]);
    geotiffwrite(strcat(num2str(k),'FFT_NORM_HANN.tif'),img1,R);
end