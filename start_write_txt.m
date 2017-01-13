%%Kmeans all data in dir
list = dir(['*.tif']);
i = size(list,1);

%% start parallel matlab --> matlabpool;
%start parallel job
%pool=matlabpool('local') %memanggil pekerja matlab 2011 matlabpool, 2012 or leater parpool

for n = 1:1
    [data{n}, r]=  geotiffread(list(n).name);
end
[x y z] = size(data{n});
pola = data{n};
ukuran_block=[25 25];

%normalisasi data sehingga mendapat NaN
fun_normalisasi=@(block_struct)normalisasi_data_block(block_struct.data);
datanorm=blockproc(pola,ukuran_block,fun_normalisasi,'useparallel',true);

%reshape data to each point
datanorm=reshape(single(datanorm),[x*y z]);
pola = single(reshape(pola, [x*y z]));

%select land data
pola = pola(~isnan(datanorm(:,1)),:);
datanorm=~isnan(datanorm(:,1));
datanorm=reshape(datanorm,[x y 1]);

%data to txt
[a b] = size(pola);
polatxt(1:a,1) = 1:a;
polatxt(:,2:b+1) = pola;
%% write data to txt
fName = 'data_2001.txt';         %# A file name
fid = fopen(fName,'w');            %# Open the file
dlmwrite(fName,polatxt,'-append',...  %# Print the matrix
         'delimiter','\t',...
         'newline','pc');
    
fclose(fid);

clear polatxt;

%setting kmeans parameter
stream=RandStream('mlfg6331_64'); %Random number stream
%option=statset('UseParallel',1,'UseSubstream',1,...
%        'Streams',stream);
option=statset('UseParallel','always','UseSubstream','always','Streams',stream);

for k = 8:128
    k
    [id{k}, c{k}, sumd{k}, D{k}] = kmeans(pola,k, ...
                                'distance','sqEuclidean','Options',option, ...
                            'Display','iter','Replicates',3,'MaxIter',10000);
    totalsumd(k) = sum(sumd{k});
end

plot(totalsumd);
M = diff(totalsumd);
