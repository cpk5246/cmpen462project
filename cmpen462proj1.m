data = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
x = zeros(1, 19);
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
loops = idivide(int64(length(TestData)),int64(length(pnMSRG)));
for i=0:loops-1
   sIndex = i*pnLength+1; 
   eIndex = sIndex+pnLength-1;
   encryptedData(sIndex:eIndex) = xor(pnMSRG, TestData(sIndex:eIndex)); 
end

rembits = int64(length(TestData))-(sIndex+pnLength-1);
if rembits ~= 0
  sIndex = sIndex+pnLength;
  eIndex = sIndex + rembits-1;
  encryptedData(sIndex:eIndex) = xor(pnMSRG(1:rembits), TestData(sIndex:eIndex));
end