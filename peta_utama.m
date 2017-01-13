function I = peta_utama(sawah,mask)
b=1;
I=zeros(size(mask,1),size(sawah,2));
    for a=1:size(mask,1)
        if(mask(a,1)==0)
            I(a,:)=0;
        else
            I(a,:)=sawah(b,:);
            b=b+1;
        end
    end
end