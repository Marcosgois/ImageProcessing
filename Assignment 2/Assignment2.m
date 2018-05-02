% Filtro de midia
clear all
close all
clc

%I = imread('Fig0335(a)(ckt_board_saltpep_prob_pt05).tif');
I = imread('Images/1.bmp');
[h, w] = size(I(:,:,1));
averageArray = zeros(h,w);

for x = 1:100
    I = imread(strcat('Images/',num2str(x),'.bmp'));
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    [Y, Cb, Cr] = RGBconversionToYCBCR(R, G, B);
    imshow(R);
    averageArray = averageArray + double(Y);
    %imshow(averageArray);
    disp(x);
end

avarageUint8 = uint8(averageArray/100);
%imshow(avarageUint8);

function [Y, Cb, Cr] = RGBconversionToYCBCR(R, G, B)
    [Rx, Ry] = size(R);
    for j = 1:Ry
        for i = 1:Rx
            Y(i, j) =   0.299*R(i, j) + 0.587*G(i, j) + 0.114*B(i, j);
            Cb(i, j) = -0.168736*R(i, j) - 0.331264*G(i, j) + 0.5*B(i, j);
            Cr(i, j) =  0.5*R(i, j) - 0.418688*G(i, j) - 0.081312*B(i, j);
        end
    end
end

%{
for i = 2:h-1
    for j = 2:w-1
        disp(i);
        disp(j);
        %Bloco = I(i-1:i+1, j-1:j+1);
        %V = sort(Bloco(:));
        If(i,j) = mean(averageArray);
    end
end

figure; imshow(If);
%}