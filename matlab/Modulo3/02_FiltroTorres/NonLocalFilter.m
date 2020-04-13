function [ output_image ] = NonLocalFilter( input_img, outter_window, inner_window, pvalor_n)
output_image = input_img;

[ymax, xmax, n_bands] = size(input_img); %Tamanho da Imagem

%Context
out_step = (outter_window-1)/2;
in_step = (inner_window-1)/2;
fix_step = 1;
m = 9;
n = 9;
L = 1;
q = 3;
c1 = ( (8*m*n)/(m+n) );

for jj = 1+out_step:ymax-out_step
    for ii = 1+out_step:xmax-out_step     
        
        %% Inner window
        data = mean(mean(input_img(ii-fix_step:ii+fix_step, jj-fix_step:jj+fix_step,:)));
        cov_ut = reshape(data(:),3,3)';
        
        weight_pixel = ones(5, 5, n_bands);
        weight = ones(5, 5);
        for in_jj = -in_step:in_step
            for in_ii = -in_step:in_step
                r = ii+in_ii;
                c = jj+in_jj;
                
                data = mean(mean(input_img(r-fix_step:r+fix_step, c-fix_step:c+fix_step,:)));
                cov = reshape(data(:),3,3)';

                aux1 = (1 - det(inv( inv(cov_ut) + inv(cov) ))/(sqrt(det(cov_ut)*det(cov)))^((3+3)/2) );
                v = real(c1*aux1);
                %trace((inv(cov_ut)*cov)+(inv(cov)*cov_ut))*0.5 - q;
%                 v = real(c1*L*aux1);

                %% Computa p valor              
                p_value = chi_square_p_value(3, v );

                if (in_jj == 0) && (in_ii == 0)
                    weight(in_jj+3, in_ii+3) = 1;
                else
                    if (p_value >= pvalor_n)
                        weight(in_jj+3, in_ii+3) = 1;
                    elseif (p_value > pvalor_n*0.5) && (p_value < pvalor_n)
                        weight(in_jj+3, in_ii+3) = (2/pvalor_n)*p_value - 1;
                    else
                        weight(in_jj+3, in_ii+3) = 0;
                    end
                end
                
                weight_pixel(in_jj+3, in_ii+3, :) = input_img(r, c, :)*weight(in_jj+3, in_ii+3);
                
            end
        end
        if (jj == 139 && ii == 42 )
            test = 0;
        end
        
        den = sum(sum(weight));
        output_image(ii, jj, :) = sum(sum(weight_pixel(:,:, :)))/den;
         
    end
end

end

