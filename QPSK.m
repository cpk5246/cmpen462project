function ret = QPSK(seq) 
    % assume prior parts dealt with odd number of input sequence length 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    modulated = zeros(1, length(seq) / 2); 
    for i = 1:length(seq) / 2 
        iReal = i * 2 - 1; 
        iImg = i * 2; 
        modulated(i) = ((-1) ^ seq(iReal)) / sqrt(2) + (((-1) ^ seq(iImg)) / sqrt(2)) * 1j; 
    end 

    ret = modulated; 
end 


