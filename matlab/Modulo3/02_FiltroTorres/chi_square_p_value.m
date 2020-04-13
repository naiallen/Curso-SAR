function p_value = chi_square_p_value( d_f, chi_ob )
acc = 0;
step = 0.1;
for ii = 0:step:100
    p = (1/(2^(d_f/2)*gamma(d_f/2)))*ii^(d_f/2 - 1)*exp(-ii/2);
    if (ii >= chi_ob)
        acc = acc +  p*step; 
    end    
end
p_value = acc;
end

