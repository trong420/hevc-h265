clear
A = imread('C:\Users\USER\Pictures\Saved Pictures\2.jpg');
[Height,Width,Depth] = size(A);
if mod(Height,16)~= 0
Height = floor(Height/16)*16;
end
if mod(Width,16)~= 0
Width = floor(Width/16)*16;
end
A1 = A(1:Height,1:Width,:);
clear A
A = A1;
if Depth == 3
A = rgb2ycbcr(A);
A1 = A(:,:,1);
end
clear A
A = A1;
y = varSizeDCTcoder(A,0.12,2);
function Aq = varSizeDCTcoder(A,Thresh,Qscale)
 
[Height,Width] = size(A);
S = qtdecomp(A,Thresh,[2,16]);
QuadBlks = repmat(uint8(0),size(S));
for dim = [2 4 8 16]
numBlks = length(find(S==dim));
if (numBlks > 0)
Val = repmat(uint8(1),[dim dim numBlks]);
Val(2:dim,2:dim,:) = 0;
QuadBlks = qtsetblk(QuadBlks,S,dim,Val);
end
end
QuadBlks(end,1:end) =1;
QuadBlks(1:end,end) = 1;
figure,imshow(QuadBlks,[])
Qsteps8 = [16 11 10 16 24 40 51 61;...
           12 12 14 19 26 58 60 55;...
           14 13 16 24 40 57 69 56;...
           14 17 22 29 51 87 80 62;...
           18 22 37 56 68 109 103 77;...
           24 35 55 64 81 104 113 92;...
           49 64 78 87 103 121 120 101;...
           72 92 95 98 112 100 103 99];
 
Qsteps2 = [8 34; 34 34];
Qsteps4 = [8 24 24 24; 24 24 24 24; 24 24 24 24; 24 24 24 24];
Qsteps16 = [4 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16;...
16 16 16 16 16 16 16 16 16 16 16 16 16 16 16 16];
Aq = uint8(zeros(Height,Width)); 
BlkPercent = zeros(4,1); 
m = 1;
for dim = [2 4 8 16]
[x,y] = find(S == dim);
BlkPercent(m) = length(x)*dim*dim*100/(Height*Width);
for k = 1:length(x)
t = dct2(double(A(x(k):x(k)+dim-1,y(k):y(k)+dim-1)));
switch dim
    case 2
t = round(t ./ Qsteps2) .* Qsteps2;
case 4
t = round(t ./ Qsteps4) .* Qsteps4;
case 8
t = round(t ./ (Qscale*Qsteps8)) .* (Qscale*Qsteps8);
case 16
t = round(t ./ Qsteps16) .* Qsteps16;
end
Aq(x(k):x(k)+dim-1,y(k):y(k)+dim-1) = uint8(idct2(t));
end
m = m + 1;
end
figure,imshow(Aq)
mse = std2(double(A)-double(Aq));
sprintf('2x2 = %5.2f%%\t4x4 = %5.2f%%\t8x8 = %5.2f%%\t16x16 = %5.2f%%\n',BlkPercent)
sprintf('SNR = %4.2f dB\n', 20*log10(std2(double(A))/mse))
end
 

