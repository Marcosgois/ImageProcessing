clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Avarage of 100 images %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('Images/1.bmp');
[h, w] = size(I(:,:,1));
averageArray = zeros(h,w); 
tic
for x = 1:100
    averageArray = averageArray + double(imread(strcat('Images/',num2str(x),'.bmp')));
end
toc
avarageUint8 = uint8(averageArray/100); %Concluindo a média das imagens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     End of avarage    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ycbcr = rgb2ycbcr(avarageUint8); %Conversão RGB -> YCbCr
ycbcr(:,:,2) = mediumFilter(ycbcr(:,:,2));
ycbcr(:,:,3) = frequencyFilter(ycbcr(:,:,3));
RGB = ycbcr2rgb(ycbcr);
%figure, imshow(RGB);

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

function [imageFiltered] = mediumFilter(I)
    [h, w] = size(I);
    iFiltered = zeros(h, w);
    for i = 1:h
        for j = 1:w
            if (i == 1) || (j == 1) || (i == h) || (j == w)
                iFiltered(i, j) = I(i, j);
            else   
                aux = I(i-1:i+1, j-1:j+1);
                auxSort = sort(aux(:));
                iFiltered(i, j) = auxSort(5);
            end
        end
    end
    imageFiltered = uint8(iFiltered);
end

function [imageFLTRED] = frequencyFilter(I)
    % Image size
    [h,w] = size(I);
    
    % Padding, transform and shifting
    fpadding = uint8(zeros(2*h,2*w));
    fpadding(h/2+1:h/2+h,w/2+1:w/2+w) =  I;
    Fpadding = fftshift(fft2(fpadding));
    
    % Define ideal lowpass filter
    D0 = 100;
    H = zeros(2*h,2*w);
    for i = 1:2*h  
        for j = 1:2*w
            D = sqrt((i-h)^2 + (j-w)^2);
            if D<= D0
                H(i,j) = 1;
            end
        end
    end
    
    % Filter
    G = Fpadding.*H;
    
    
    alfa = 100*sum(sum(abs(G).^2))/sum(sum(abs(Fpadding).^2)) % Calculates the percentage of preserve power
    g = ifft2(ifftshift(G)); % Undo shifting and perfomr inverse transform
    g = g(h/2+1:h/2+h,w/2+1:w/2+w); % Extract image
    % Show filtered image
    % figure ,imshow(uint8(abs(g)));
    imageFLTRED = uint8(abs(g));
end