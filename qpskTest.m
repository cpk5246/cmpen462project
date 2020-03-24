function ret = qpskTest() 
    %Testing part
    load('Proj1TestEncryptedData.mat', 'TestEncryptedData'); 
    load('Proj1ModSymb.mat', 'ModSymb'); 
    load('Proj1TransSymbStream.mat', 'TransSymbStream'); 
    seq = TestEncryptedData(1:10); 
    
    %seq = ModSymb(1:32); 
    
    tic 
    mod = QPSK(seq); 
    toc 
    for i = 1:length(mod)
        if mod(i) ~= ModSymb(i)
            i
        end
    end
    
    %y = ifft(seq); 
    %ret = mod; 
    
end