data = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
x = zeros(1, 19);
input = TestData;
pnMSRG = zeros(1, 524287);
%MSRG for PNSeq
pnMSRG(1) = data(19);
for i=1:524286
    x(1) = data(19);
    x(2) = xor(data(1), data(19));
    x(3) = xor(data(19), data(2));
    x(4) = data(3);
    x(5) = data(4);
    x(6) = xor(data(19), data(5));
    x(7) = data(6);
    x(8) = data(7);
    x(9) = data(8);
    x(10) = data(9);
    x(11) = data(10);
    x(12) = data(11);
    x(13) = data(12);
    x(14) = data(13);
    x(15) = data(14);
    x(16) = data(15);
    x(17) = data(16);
    x(18) = data(17);
    x(19) = data(18);
    pnMSRG(i+1) = x(19);
    data = x;
end

%Encrypts the data using the PNSeq
encryptedData = zeros(1, 20480000);
pnLength = length(pnMSRG);
loops = idivide(int64(length(input)),int64(length(pnMSRG)));
for i=0:loops-1
   sIndex = i*pnLength+1; 
   eIndex = sIndex+pnLength-1;
   encryptedData(sIndex:eIndex) = xor(pnMSRG, input(sIndex:eIndex)); 
end

rembits = int64(length(input))-(sIndex+pnLength-1);
if rembits ~= 0
  sIndex = sIndex+pnLength;
  eIndex = sIndex + rembits-1;
  encryptedData(sIndex:eIndex) = xor(pnMSRG(1:rembits), input(sIndex:eIndex));
end

% assume prior parts dealt with odd number of input sequence length     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
modulated = zeros(1, length(encryptedData) / 2); 
for i = 1:length(encryptedData) / 2 
    iReal = i * 2 - 1; 
    iImg = i * 2; 
    modulated(i) = ((-1) ^ seq(iReal)) / sqrt(2) + (((-1) ^ seq(iImg)) / sqrt(2)) * 1j; 
end 
ret = modulated; 


 %This code accomplishes the s/p , p/s , IFFT and cyclic prefix(CP) insertion 

clc
input = ret;                        %ModSymb is found in canvas files
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