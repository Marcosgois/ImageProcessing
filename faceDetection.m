

I = imread('HumanFaceOriginal.jpg');

ISkin = I;
IHair = I;
R = double(I(:,:,1));
G = double(I(:,:,2));
B = double(I(:,:,3));

In = normalizeImg(I);
Rn = In(:,:,1);
Gn = In(:,:,2);
Bn = In(:,:,3);

[h,w] = size(In(:,:,1));
IBinSkin = zeros(h, w);
IBinHair = zeros(h, w);
for i = 1:h
    for j = 1:w
        %Conversion to HSI
        delta = acos((0.5*((R(i,j)-G(i,j))+(R(i,j)-B(i,j)))) / sqrt(((R(i,j)-G(i,j))^2) + ((R(i,j)-B(i,j))*(G(i,j)-B(i,j)))));
        
        if B(i,j) <= G(i,j)
            H = 0;
        else
            H = (2*pi) - delta;
        end
        
        
        %Normalização
        Int = (R(i,j) + G(i,j) + B(i,j)) / 3;
        %Limiares do gráfico 1
        Fone = (-1.376*(Rn(i,j)^2)) + (1.0743*Rn(i,j)) + 0.2;
        Ftwo = (-0.766*(Rn(i,j)^2)) + (0.5601*Rn(i,j)) + 0.18;
        %Determinando cor branca
        white = ((Rn(i,j) - 0.33)^2) + ((Gn(i,j) - 0.33)^2);
        %Condição para determinação da cor de pele
        if (Gn(i,j) < Fone) && (Gn(i,j) > Ftwo) && (white > 0.001) && (H > 4.15879 || H <= 0.34906585)
           ISkin(i,j,:) = ISkin(i,j,:)*1;
           IBinSkin(i,j) = true;
        else
           ISkin(i,j,:) = ISkin(i,j,:)*255;
           IBinSkin(i,j) = false;
        end
        %Condição para determinação da cor de cabelo
        if  H == 0
            H = (2*pi) - delta;
        end
        if (Int < 80 && ( B(i,j)-G(i,j) < 15 || B(i,j)-R(i,j) < 15)) || (H > 0.34906585 && H <= 0.6981317)
           IHair(i,j,:) = IHair(i,j,:)*1;
           IBinHair(i,j) = true;
        else
           IHair(i,j,:) = IHair(i,j,:)*255;
           IBinHair(i,j) = false;
        end
    end
end
figure, imshowpair(IBinSkin, ISkin, 'montage');
figure, imshowpair(IBinHair, IHair, 'montage');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% QUANTIZATION %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[h, w, x] = size(I);
quantFilter = zeros(5,5);
ISkinQuant = zeros(h, w);
IHairQuant = zeros(h, w);
for i = 5:5:h-5
    for j = 5:5:w-5
        quantFilter = IBinSkin(i:i+4,j:j+4);
        if sum(sum(quantFilter)) >= 12
            ISkinQuant(i:i+4,j:j+4) = true;
        else
            ISkinQuant(i:i+4,j:j+4) = false;
        end
        quantFilter = IBinHair(i:i+4,j:j+4);
        if sum(sum(quantFilter)) >= 12
            IHairQuant(i:i+4,j:j+4) = true;
        else
            IHairQuant(i:i+4,j:j+4) = false;
        end
    end
end
figure, imshowpair(ISkinQuant, IHairQuant, 'montage');
[BWface, Lface] = bwboundaries(ISkinQuant);
[BWhair, Lhair] = bwboundaries(IHairQuant);
Lface = label2rgb(Lface, @jet, [.5 .5 .5]);
Lhair = label2rgb(Lhair, @jet, [.5 .5 .5]);
figure, imshow(I);
hold on
aux = 0;
for k = 1:length(BWface)
    [auxX, auxY] = size(BWface{k, 1});
    if aux < auxX
        aux = auxX;
        face = k;
    end
end 
aux = 0;
auxX = 0;
for ky = 1:length(BWhair)
    [auxX, auxY] = size(BWhair{ky, 1});
    if aux < auxX
        aux = auxX;
        hair = ky;
    end
end
if length(BWface) > 0 && length(BWhair) > 0
   boundaryFace = BWface{face};
   maxBoundFace = max(boundaryFace);
   minBoundFace = min(boundaryFace);
   boundaryHair = BWhair{hair};
   maxBoundHair = max(boundaryHair);
   minBoundHair = min(boundaryHair);
   interx = intersect(boundaryFace(:,1), boundaryHair(:,1));
   intery = intersect(boundaryFace(:,2), boundaryHair(:,2));
end
   if  ~(isempty(interx) && isempty(intery))
       rectangle('Position',[minBoundFace(2),minBoundFace(1),maxBoundFace(2)-minBoundFace(2), maxBoundFace(1)-minBoundFace(1)],'Edgecolor', 'g');
       rectangle('Position',[minBoundHair(2),minBoundHair(1),maxBoundHair(2)-minBoundHair(2), maxBoundHair(1)-minBoundHair(1)],'Edgecolor', 'g');
   else
       I = insertText(I,[0,0],'No face detected');
       imshow(I);
   end
       %plot(boundaryFace(:,2), boundaryFace(:,1), 'w', 'LineWidth', 2);
       %plot(boundaryHair(:,2), boundaryHair(:,1), 'w', 'LineWidth', 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% NORMALIZATION %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [INorm] = normalizeImg(I)
    [h, w, x] = size(I);
    INorm = zeros(h, w, x);
    R = double(I(:,:,1));
    G = double(I(:,:,2));
    B = double(I(:,:,3));
    
    for i = 1:h
        for j = 1:w
            total = R(i, j) + G(i, j) + B(i, j);
            INorm(i, j, 1) = (R(i, j) / total); %* 255;
            INorm(i, j, 2) = (G(i, j) / total); %* 255;
            INorm(i, j, 3) = (B(i, j) / total); %* 255;
        end
    end
end
