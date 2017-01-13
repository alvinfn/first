function O = normalisasi_data_block(I)
I=single(I);
[x y z] = size(I);
I = reshape(I,[x*y z]);

%fft analysis
    for i = 1:x*y;
        Isig = single(I(i,:)');
        dmax = max(Isig);
        dmin = min(Isig);
        O(i,:) = ((2/(dmax-dmin))*(Isig-ones(size(Isig))*(dmin))-(ones(size(Isig))))';
    end
 O = reshape(O,[x y z]);
end

