function output_image = flee(input_img, box)

% Cria a imagem de saida
output_image = zeros(size(input_img));

%Contexto
step = (box-1)/2;

var_im = (std(input_img(:)))^2;
for jj = 1+step:size(input_img,2)-step
    for ii = 1+step:size(input_img,1)-step
        kernel = input_img(ii-step:ii+step, jj-step:jj+step);
        
        % Calcula a media
        k = mean(kernel(:));
        
        % Centro do kernel
        c = input_img(ii, jj);  
        
        %Calcula o peso
        var_kernel = (std(kernel(:)))^2;
        w = var_im / (var_kernel+var_im);
        
        output_image(ii, jj) = k + w*(c-k);
    end
end

end