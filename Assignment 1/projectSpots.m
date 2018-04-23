clear all;
img = imread('spots.tif');
[imgBoudaries] = createBoundaries(img);
figure
imshow(cat(3,zeros(512,512),imgBoudaries,zeros(512,512)));
imgDataBalls = zeros(512,512);
[imgWBoards] = addingBoards(img);
[imgManchas] = rotulacaoDeManchas(imgWBoards);
[X,Y] = size(img);



function [imgBoudaries] = createBoundaries(imgAnalog)
[X,Y] = size(imgAnalog);
imgBoudaries  = zeros(X,Y);

for i = 2:X-1
    for j = 2:Y-1
        contador = 0;
        if imgAnalog(i,j) == 0
            if imgAnalog(i+1,j-1) == 255
                contador = contador + 1;
            end
            if imgAnalog(i+1,j) == 255
                contador = contador + 1;
            end
            if imgAnalog(i+1,j+1) == 255
                contador = contador + 1;
            end
            if imgAnalog(i,j-1) == 255
                contador = contador + 1;
            end
            if imgAnalog(i,j) == 255
                contador = contador + 1;
            end
            if imgAnalog(i,j+1) == 255
                contador = contador + 1;
            end
            if imgAnalog(i-1,j-1) == 255
                contador = contador + 1;
            end
            if imgAnalog(i-1,j) == 255
                contador = contador + 1;
            end
            if imgAnalog(i-1,j+1) == 255
                contador = contador + 1;
            end
        end
        if contador > 1
            imgBoudaries(i,j) = 1;
        end
    end
end
end
%{
function [balls] = countBoundaries(img)
    [X,Y] = size(img);
    imgNext = img;
    contador = 0;
    for i = 3:X-2
        for j = 3:Y-2
            if imgNext(i,j) == 1
                auxi = i;
                auxj = j;
                while(1)
                    imgNext(auxi,auxj) = 0;
                    if imgNext(auxi+1,auxj-1) == 1
                       auxi = auxi+1;
                       auxj = auxj-1;
                    elseif imgNext(auxi+1,auxj) == 1
                        auxi = auxi+1;
                        auxj = auxj;
                    
                    elseif imgNext(auxi+1,auxj+1) == 1
                        auxi = auxi+1;
                        auxj = auxj+1;
                    
                    elseif imgNext(auxi,auxj-1) == 1
                        auxi = auxi;
                        auxj = auxj-1;
                    
                    elseif imgNext(auxi,auxj+1) == 1
                        auxi = auxi;
                        auxj = auxj+1;
                    
                    elseif imgNext(auxi-1,auxj-1) == 1
                        auxi = auxi-1;
                        auxj = auxj-1;
                    
                    elseif imgNext(auxi-1,auxj) == 1
                        auxi = auxi-1;
                        auxj = auxj;
                    
                    elseif imgNext(auxi-1,auxj+1) == 1
                        auxi = auxi-1;
                        auxj = auxj+1;
                    else
                        volta = 1;
                        break;
                    end
                end
                contador = contador + 1;
            end
        end
    end
    balls = contador;
end
%}
function [imgManchas] = rotulacaoDeManchas(img)
    imgDataBalls = ones(512,512);
    [X,Y] = size(img);
    rotulo = 0;
    for i = 3:X
        for j = 3:Y
            if img(i,j) == 0
                if img(i-1,j) == 1
                    if img(i,j-1) == 1
                        rotulo = rotulo + 1;
                        imgDataBalls(i-2,j-2) = rotulo;
                    else
                        imgDataBalls(i-2,j-2) = rotulo;
                    end
                else
                    if img(i,j-1) == 1
                        imgDataBalls(i-2,j-2) = rotulo;
                    else
                        if imgDataBalls((i-2)-1,j-2) ~= imgDataBalls((i-2),(j-2)-1)
                            minimo = min(imgDataBalls((i-2)-1,j-2),imgDataBalls((i-2),(j-2)-1));
                            imgDataBalls((i-2)-1,j-2) = minimo;
                            imgDataBalls((i-2),(j-2)-1) = minimo;
                            imgDataBalls(i-2,j-2) = minimo;
                        else
                            imgDataBalls(i-2,j-2) = imgDataBalls((i-2),(j-2)-1);
                        end
                    end
                end
            end
            rotulo = rotulo + 1;
        end
    end
    imgManchas = imgDataBalls;
end
function [newImg] = addingBoards(img)
imgWBoards = ones(514,514);
for i = 3:514
    for j = 3:514
        if img(i-2,j-2) == 255
            imgWBoards(i,j) = 1;
        else
            imgWBoards(i,j) = 0;
        end
    end
end
newImg = imgWBoards;
figure
imshow(newImg);
end