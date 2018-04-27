% Filtro de midia
clear all
close all
clc

%I = imread('Fig0335(a)(ckt_board_saltpep_prob_pt05).tif');
RGB = imread('Images/1.bmp');
[h, w, z] = size(RGB);
ycbcr = zeros(h, w, z);

for i = 1:100
    RGB = imread(strcat('Images/',num2str(i),'.bmp'));
    ycbcr = ycbcr + double(rgb2ycbcr(RGB));
end
imshow(ycbcr2rgb(uint8(ycbcr/100)));