% Filtro de midia
clear all
close all
clc

%I = imread('Fig0335(a)(ckt_board_saltpep_prob_pt05).tif');
I = imread('Images/1.bmp');
[h, w, x] = size(I);
Iav = zeros(h, w, x);
averageArrayY = zeros(h,w);
averageArrayCb = zeros(h,w);
averageArrayCr = zeros(h,w);
H = [0.111, 0.111, 0.111;
     0.111, 0.111, 0.111;
     0.111, 0.111, 0.111];
for x = 1:100
    I = imread(strcat('Images/',num2str(x),'.bmp'));
    Iav = Iav + double(I);
    [Y, Cb, Cr] = RGBconversionToYCBCR(I);
    averageArrayY = averageArrayY + double(Y);
    averageArrayCb = averageArrayCb + double(Cb);
    averageArrayCr = averageArrayCr + double(histeq(Cr));
    disp(x);
end
averageUint8Y = uint8(averageArrayY/100);
averageUint8Cb = uint8(averageArrayCb/100);
avarageUint8Cr = uint8(averageArrayCr/100);
figure
imshow(cat(3,averageUint8Y,averageUint8Cb,avarageUint8Cr));
Iav = Iav / 100;
figure
imshow(uint8(Iav));
imhist(Iav);

function [Y, Cb, Cr] = RGBconversionToYCBCR(I)
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    [Rx, Ry] = size(R);
    for j = 1:Ry
        for i = 1:Rx
            Y(i, j) =   0.299*R(i, j) + 0.587*G(i, j) + 0.114*B(i, j);
            Cb(i, j) = -0.168736*R(i, j) - 0.331264*G(i, j) + 0.5*B(i, j);
            Cr(i, j) =  0.5*R(i, j) - 0.418688*G(i, j) - 0.081312*B(i, j);
        end
    end
end

function [Y, Cb, Cr] = RGBconversionToYCBCR(I)
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    [Rx, Ry] = size(R);
    for j = 1:Ry
        for i = 1:Rx
            Y(i, j) =   0.299*R(i, j) + 0.587*G(i, j) + 0.114*B(i, j);
            Cb(i, j) = -0.168736*R(i, j) - 0.331264*G(i, j) + 0.5*B(i, j);
            Cr(i, j) =  0.5*R(i, j) - 0.418688*G(i, j) - 0.081312*B(i, j);
        end
    end
end

function [Filtered] = saltANDPeperFilter(IMG)
    [h, w] = size(IMG);
    for i = 2:h-1
        for j = 2:w-1
            Bloco = I(i-1:i+1, j-1:j+1);
            V = sort(Bloco(:));
            If(i,j) = V(5);
        end
    end
end