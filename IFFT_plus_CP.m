%This code accomplishes the s/p , p/s , IFFT and cyclic prefix(CP) insertion 

clc
input = ModSymb;                        %ModSymb is found in canvas files
cycli_prefix = 70;
reStream = reshape(input,[1024,10000]); %Reshape serial stream to 1024(sample) x 10,000(symbol) array
invStream = zeros(1024,10000);          %Preallocation for speed
%invStream = [];                        %input stream after IFFT on per column basis
sz = size(reStream);
for i=1:sz(2)
    mem = ifft(reStream(:,i));          %Ifft occurs on a per column basis, A(:,n) is the nth column of matrix A.
    invStream(:,i) = mem;               %appending IFFT output to invStream
end
invStream = invStream.';                %transpose, change to 10,000 x 1024
tx = [invStream(:,end-cycli_prefix+1:end) invStream] ; %Insert CP
% A(:,j:k) includes all subscripts in the first dimension but uses the vector j:k to index in the second dimension.
% This returns a matrix with columns [A(:,j), A(:,j+1), ..., A(:,k)] from
% matlab documentation
%Output is 10,000 x 1094 array

tx = tx.' ;                            %Change  to 1094 x 10,000
serOutStream = reshape(tx,1,[]);       %Serial output stream

%TEST
if isequal(serOutStream,TransSymbStream)
    disp('Cp insertion was a success!')
else
    disp('CP failed')
end

%Up Conversion
%Variables
f = FreqIF;
dt = 1/10240000%0.097656*10^-6;
%Split stream post cyclic prefix
Re_ser = real(serOutStream); %NB: SerOutStream = TransSymbStream
Im_ser = imag(serOutStream);
I_t = zeros(1,10940000); %Preallocating memory
Q_t = zeros(1,10940000);
for n = 1:length(serOutStream)
    I_t(n) = Re_ser(n)*cos(2*pi*f*(n)*dt);
    Q_t(n) = 1i*Im_ser(n)*sin(2*pi*f*(n)*dt);
end
inIF = I_t + Q_t; %Stream upconverted to IF

%TEST
if isequal(inIF,UpCnvrt2IF)
    disp('UpConv was a success')
else
    disp('UpConv failed')    
end

