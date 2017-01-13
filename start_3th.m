%%data tiga tahunan
%%Kmeans all data in dir
list = dir(['*.tif']);
i = size(list,1);

%% start parallel matlab --> matlabpool;
%start parallel job
%pool=matlabpool('local') %memanggil pekerja matlab 2011 matlabpool, 2012 or leater parpool

for n = 1:1
    [data{n}, r]=  geotiffread(list(n).name);
[x y z] = size(data{n});
mask = data{1};
%pola = data{n};
ukuran_block=[25 25];

%normalisasi data sehingga mendapat NaN
fun_normalisasi=@(block_struct)normalisasi_data_block(block_struct.data);
datanorm=blockproc(mask,ukuran_block,fun_normalisasi,'useparallel',true);
datanorm=reshape(single(datanorm),[x*y z]);
end

for n = 2:i-1
    [data{n-1}, r]=  geotiffread(list(n-1).name);
    [data{n}, r]=  geotiffread(list(n).name);
    [data{n+1}, r]=  geotiffread(list(n+1).name);
[x y z] = size(data{n});
%mask = data{1};
polaA = data{n-1};
polaB = data{n};
polaC = data{n+1};

%reshape data to each point

polaA = single(reshape(polaA, [x*y z]));
polaB = single(reshape(polaB, [x*y z]));
polaC = single(reshape(polaC, [x*y z]));

%select land data
polaA = polaA(~isnan(datanorm(:,1)),:);
polaB = polaB(~isnan(datanorm(:,1)),:);
polaC = polaC(~isnan(datanorm(:,1)),:);
%datanorm=~isnan(datanorm(:,1));
%datanorm=reshape(datanorm,[x y 1]);

%data to txt
[a b] = size(polaA);
polatxt(1:a*3,1) = 1:a*3; polatxt = single(polatxt);
polatxt(1:a,2:b+1) = polaA;
polatxt(a+1:a*2,2:b+1) = polaB;
polatxt(2*a+1:a*3,2:b+1) = polaC;

%% write data to txt
fName = [list(n-1).name,'_',list(n).name,'_',list(n+1).name,'.txt'];         %# A file name
fid = fopen(fName,'w');            %# Open the file
dlmwrite(fName,polatxt,'-append',...  %# Print the matrix
         'delimiter','\t',...
         'newline','pc');
    
fclose(fid);
end