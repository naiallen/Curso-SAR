function output_image = fmedia (input_img, box)

% Cria a imagem de saida
output_image = zeros(size(input_img));

%Contexto
step = (box-1)/2;
for jj = 1+step:size(input_img,2)-step
    for ii = 1+step:size(input_img,1)-step
        output_image(ii, jj) = mean(mean(input_img(ii-step:ii+step, jj-step:jj+step)));
    end
end

end