%%data tiga tahunan
%%Kmeans all data in dir
list = dir(['*.tif']);
i = size(list,1);

%% start parallel matlab --> matlabpool;
%start parallel job
%pool=matlabpool('local') %memanggil pekerja matlab 2011 matlabpool, 2012 or leater parpool

for n = 1:1
    [data, r]=  geotiffread(list(n).name);
[x y z] = size(data);
mask = data;
%pola = data{n};
ukuran_block=[25 25];

%normalisasi data sehingga mendapat NaN
fun_normalisasi=@(block_struct)normalisasi_data_block(block_struct.data);
datanorm=blockproc(mask,ukuran_block,fun_normalisasi,'useparallel',true);
datanorm=reshape(single(datanorm),[x*y z]);
end

for n = 1:i
[data, r]=  geotiffread(list(n).name);
[x y z] = size(data);
%mask = data{1};

%reshape data to each point

data = single(reshape(data, [x*y z]));

%select land data
data = data(~isnan(datanorm(:,1)),:);
%datanorm=~isnan(datanorm(:,1));
%datanorm=reshape(datanorm,[x y 1]);

%data to txt
[a b] = size(data);
polatxt(1:a*i,1) = 1; polatxt = single(polatxt);
polatxt(1+a*(n-1):a*n,2:b+1) = data;

end


%% write data to txt
fName = ['sawah_allyears.txt'];         %# A file name
fid = fopen(fName,'w');            %# Open the file
dlmwrite(fName,polatxt,'-append',...  %# Print the matrix
         'delimiter','\t',...
         'newline','pc');
    
fclose(fid);