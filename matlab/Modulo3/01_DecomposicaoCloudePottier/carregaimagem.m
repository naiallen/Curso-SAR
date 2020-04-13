function image = carregaimagem(fileID, col, row, bands)

if fileID == -1, error('Cannot open file: %s', filename); end
format = 'float';
Data = fread(fileID, Inf, format);
fclose(fileID);
 
offset = size(Data,1) - (col*row*bands*2);
Data(1:offset) = [];

ImTemp = zeros(row, col, bands);
for ii = 1:bands
    ImSize = col*row*2; %Real and Imag
    clear temp_real temp_img real imag
    temp_real = Data( ((ii-1)*2)+1 : ( bands*2) : end ,1);
    temp_img =  Data( ((ii-1)*2)+2 : ( bands*2) : end, 1);

    r = reshape(temp_real, col, row)';
    im = reshape(temp_img, col, row)';

    ImTemp(:,:,ii) = r + 1i*im;
end
image = ImTemp(800:1500,1:800,:);
% image = fmedia (im, 3);
% image = ImTemp;
end

