clear all;
img = imread('mars.bmp');
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

[Y, Cb, Cr] = RGBconversionToYCBCR(R, G, B);%Conversion RGB - YCbCr
[Yx, Yy] = size(Y);
startPoint = MarkAPoint(Y, 0, 260, 415);%Mark the POINT
hist = createHistogram(Y);
hist = Pr_Rk(hist, Yx*Yy);
[hist, Y_equa] = equa_hist(hist, Y);
[J, T] = histeq(Y);

imgWithWayGo = walking(Y, img);
imgWithWayBack = walkingBack(Y, img);

plotSize_Line = 2;
plotSize_Row = 1;
    
figure
%{
%Print R G B
subplot(plotSize_Line,plotSize_Row,1); 
imshow(R); 
title('R')
subplot(plotSize_Line,plotSize_Row,2);
imshow(G); 
title('G')
subplot(plotSize_Line,plotSize_Row,3);
imshow(B);
title('B')
    %Print Y Cb Cr
subplot(plotSize_Line,plotSize_Row,4);
imshow(Y);
title('Y')
subplot(plotSize_Line,plotSize_Row,5);
imshow(Cb);
title('Cb')
subplot(plotSize_Line,plotSize_Row,6);
imshow(Cr);
title('Cr')
%}
%{
subplot(plotSize_Line,plotSize_Row,1);
imshow(startPoint);
title('Ponto inicial')
subplot(plotSize_Line,plotSize_Row,2);
imshow(J);
title('Equ MATLAB')
subplot(plotSize_Line,plotSize_Row,3);
imshow(Y_equa);
title('Equ MARCOS')
%}
subplot(plotSize_Line,plotSize_Row,1);
imshow(imgWithWayGo);
title('Way out')
subplot(plotSize_Line,plotSize_Row,2);
imshow(imgWithWayBack);
title('Way Back')

function imgWay = walking(map, img)
    wayX = 260;
    wayY = 415;
    targetX = 815;
    targetY = 1000;
    Igray = zeros(3,3);
    while wayX ~= 815 && wayY ~= 1000
        bestOptions = euclideanDistanceToDest(wayX,wayY, targetX, targetY);
        for i = 1:3
            Igray(i,1) = map(bestOptions(i,2),bestOptions(i,3));
            Igray(i,2) = bestOptions(i,2);
            Igray(i,3) = bestOptions(i,3);
        end
        [M,N] = min(Igray(:,1));
        img(Igray(N,2),Igray(N,3),1) = 0;
        img(Igray(N,2),Igray(N,3),2) = 0;
        img(Igray(N,2),Igray(N,3),3) = 0;
        wayX = Igray(N,2);
        wayY = Igray(N,3);
    end
    %imshow(img);
    imgWay = img;
end 

function imgWay = walkingBack(map, img)
    wayX = 815;
    wayY = 1000;
    targetX = 260;
    targetY = 415;
    Igray = zeros(3,3);
    while wayX ~= 260 && wayY ~= 415
        bestOptions = euclideanDistanceToDest(wayX,wayY, targetX, targetY);
        for i = 1:3
            Igray(i,1) = map(bestOptions(i,2),bestOptions(i,3));
            Igray(i,2) = bestOptions(i,2);
            Igray(i,3) = bestOptions(i,3);
        end
        [M,N] = min(Igray(:,1));
        img(Igray(N,2),Igray(N,3),1) = 255;
        img(Igray(N,2),Igray(N,3),2) = 255;
        img(Igray(N,2),Igray(N,3),3) = 255;
        wayX = Igray(N,2);
        wayY = Igray(N,3);
    end
    %imshow(img);
    imgWay = img;
end 

function smallest = euclideanDistanceToDest(x, y, targetx, targety)
    ED = zeros(9,3);
    smallest = zeros(3,3);
    
    ED(1,1) = sqrt(((x  )- targetx)^2 + ((y-1)- targety)^2);
    ED(1,2) = x;
    ED(1,3) = y-1;
    ED(2) = sqrt(((x-1)- targetx)^2 + ((y-1)- targety)^2);
    ED(2,2) = x-1;
    ED(2,3) = y-1;
    ED(3) = sqrt(((x+1)- targetx)^2 + ((y-1)- targety)^2);
    ED(3,2) = x+1;
    ED(3,3) = y-1;
    ED(4) = sqrt(((x  )- targetx)^2 + ((y  )- targety)^2);
    ED(4,2) = x;
    ED(4,3) = y;
    ED(5) = sqrt(((x-1)- targetx)^2 + ((y  )- targety)^2);
    ED(5,2) = x-1;
    ED(5,3) = y;
    ED(6) = sqrt(((x+1)- targetx)^2 + ((y  )- targety)^2);
    ED(6,2) = x+1;
    ED(6,3) = y;
    ED(7) = sqrt(((x  )- targetx)^2 + ((y+1)- targety)^2);
    ED(7,2) = x;
    ED(7,3) = y+1;
    ED(8) = sqrt(((x-1)- targetx)^2 + ((y+1)- targety)^2);
    ED(8,2) = x-1;
    ED(8,3) = y+1;
    ED(9) = sqrt(((x+1)- targetx)^2 + ((y+1)- targety)^2);
    ED(9,2) = x+1;
    ED(9,3) = y+1;
    
    [M, N] = min(ED(:,1));
    smallest(1,1) = M;
    smallest(1,2) = ED(N,2);
    smallest(1,3) = ED(N,3);
    ED(N,1) = 9999;
    [M, N] = min(ED(:,1));
    smallest(2,1) = M;
    smallest(2,2) = ED(N,2);
    smallest(2,3) = ED(N,3);
     ED(N,1) = 9999;
    [M, N] = min(ED(:,1));
    smallest(3,1) = M;
    smallest(3,2) = ED(N,2);
    smallest(3,3) = ED(N,3);
     ED(N,1) = 9999;
    
end


%Tratamento de imagem

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

function startPoint = MarkAPoint(startPoint, value, x,y)
        valueOfNeighbors = 3;
        startPoint(x,y) = value;
        %4-neighbors
        for i = 1:valueOfNeighbors
            startPoint(x+i, y) = value;
            startPoint(x-i, y) = value;
            startPoint(x, y+i) = value;
            startPoint(x, y-i) = value;
            %diagonal-neighbors
            startPoint(x+i, y+i) = value;
            startPoint(x+i, y-i) = value;
            startPoint(x-i, y+i) = value;
            startPoint(x-i, y-i) = value;     
        end
end
%{
HISTOGRAM -> 
                0 - 1   1 
                2 - 3   2
                4 - 7   3
                8 - 15  4 
                16  31  5
                32  63  6
                64  127 7
                128 255 8
%}
function histogram = createHistogram(Y)
    [Yx, Yy] = size(Y);
    list = createList();
    for j = 1:Yy
        for i = 1:Yx
            list(Y(i,j)+1,2) = list(Y(i,j)+1,2) + 1;
        end
    end
    histogram = list;
end

function [list, Y_eq] = histogramDigital(Y)
    Y_eq = zeros(840,1035);
    [Yx, Yy] = size(Y);
    list = zeros(8,4); 
    for i = 1:8
        list(i,1) = i-1;
        list(i,2) = 0;
    end
    
    for j = 1:Yy
        for i = 1:Yx
            flag = Y(i,j);
            if flag == 0 || flag == 1
                    list(1,2) = list(1,2) + 1;
            elseif flag == 2 || flag == 3
                    list(2,2) = list(2,2) + 1;
                elseif flag > 3 && flag < 8
                    list(3,2) = list(3,2) + 1;
                elseif flag > 7 && flag < 16
                    list(4,2) = list(4,2) + 1;
                elseif flag > 15 && flag < 32
                    list(5,2) = list(5,2) + 1;
                elseif flag > 31 && flag < 64
                    list(6,2) = list(6,2) + 1;
                elseif flag > 63 && flag < 128
                    list(7,2) = list(7,2) + 1;
                elseif flag > 127 && flag < 256
                    list(8,2) = list(8,2) + 1;
            end
        end
    end
    for i = 1:8
        list(i,3) = list(i,2)/(Yx*Yy);
    end
    for i = 2:8
            list(i,4) = list(i,3)+list(i-1,4);
    end
    for j = 1:Yy
        for i = 1:Yx
            flag = Y(i,j);
            if flag == 0 || flag == 1
                Y_eq(i,j) = flag*list(1,4);
            elseif flag == 2 || flag == 3
                Y_eq(i,j) = flag*list(2,4);
            elseif flag > 3 && flag < 8
                Y_eq(i,j) = flag*list(3,4);
            elseif flag > 7 && flag < 16
                Y_eq(i,j) = flag*list(4,4);
            elseif flag > 15 && flag < 32
                Y_eq(i,j) = flag*list(5,4);
            elseif flag > 31 && flag < 64
                Y_eq(i,j) = flag*list(6,4);
            elseif flag > 63 && flag < 128
                Y_eq(i,j) = flag*list(7,4);
            elseif flag > 127 && flag < 256
                Y_eq(i,j) = flag*list(8,4);
            end
        end
    end
end

function list = createList()
    list = zeros(256,4);
    for i = 1:256
        list(i,1) = i-1;
        list(i,2) = 0;
    end
end

function hist_P = Pr_Rk(nk, MN)
    hist_P = nk;
    for i = 1:256
        hist_P(i,3) = hist_P(i,2)/MN;
    end
    
end

function [hist, Y_equa] = equa_hist(hist , Y)
    Y_equa = zeros(840,1035);
    hist_equa = hist;
    
    for i = 2:256
            hist_equa(i,4) = hist_equa(i,3)+hist_equa(i-1,4);
    end
    
    hist = hist_equa;
    [Yx, Yy] = size(Y);
    for j = 1:Yy
        for i = 1:Yx
            Y_equa(i,j) = round(hist_equa(Y(i,j),4) * 255);
        end
    end    
end

