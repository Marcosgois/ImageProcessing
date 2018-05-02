clear all
close all
clc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Avarage of 100 images %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('Images/1.bmp');
[h, w] = size(I(:,:,1));
averageArray = zeros(h,w); 
for x = 1:100
    I = imread(strcat('Images/',num2str(x),'.bmp'));
    averageArray = averageArray + double(I);
    disp(x);
end
avarageUint8 = uint8(averageArray/100); %Concluindo a m�dia das imagens
imshow(avarageUint8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     End of avarage    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ycbcr = rgb2ycbcr(avarageUint8); %Convers�o RGB -> YCbCr

%{
%%%%% Mostrando componentes da imagem %%%%%%
figure , imshow(ycbcr(:,:,1)); %Componente Y
figure , imshow(ycbcr(:,:,2)); %Componente Cb
figure , imshow(ycbcr(:,:,3)); %Componente Cr
%}
ycbcr(:,:,2) = mediuanFilter(ycbcr(:,:,2));
figure, imshow(ycbcr(:,:,2));
ycbcr(:,:,3) = imgaussfilt(ycbcr(:,:,3), 2);%Solu��o encontrada por enquanto!
RGB = ycbcr2rgb(ycbcr);
figure, imshow(RGB);

%{
%%%%%%%%%%%%%%%%
%Ploting Images%
%%%%%%%%%%%%%%%%
subplot(2,2,1);
imshow(avarageUint8);
title('Image Original')
subplot(2,2,2);
imshow(ycbcr(:,:,1));
title('Component Y')
subplot(2,2,3);
imshow(ycbcr(:,:,2));
title('Component Cb')
subplot(2,2,4);
imshow(ycbcr(:,:,3));
title('Component Cr')
%%%%%%%%%%%%%%%%
%% End Ploting%%
%%%%%%%%%%%%%%%%
%}
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

function [imageFiltered] = mediuanFilter(Img)
    [h, w] = size(Img);
    iFiltered = zeros(h, w);
    for i = 2:h-1
        for j = 2:w-1
            aux = Img(i-1:i+1, j-1:j+1);
            auxSort = sort(aux(:));
            iFiltered(i, j) = auxSort(5);
        end
        disp(i);
    end
    imageFiltered = uint8(iFiltered);
end

function [imageNormalized] = normalizeImage(Img)
    [h, w] = size(Img);
    
end