% Filtro de média
clear all
close all
clc

%I = imread('Fig0335(a)(ckt_board_saltpep_prob_pt05).tif');
I = imread('1.bmp');
imshow(I)
averageArray = zeros(1,100);
If = I;
[h, w] = size(I);

for i = 2:h-1
    for j = 2:w-1
        disp(i);
        disp(j);
        for x = 1:100
            I = imread(strcat(num2str(x),'.bmp'));
            averageArray(x) = I(i,j);
        end
        %Bloco = I(i-1:i+1, j-1:j+1);
        %V = sort(Bloco(:));
        If(i,j) = mean(averageArray);
    end
end

figure; imshow(If);
