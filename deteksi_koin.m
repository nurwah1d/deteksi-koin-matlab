clc; clear;

%Image yang akan di proses
img = imread('dataset/koin_15.jpg');
%figure, imshow(img);

% mengkonversi citra rgb menjadi grayscale
img_gray = rgb2gray(img);
figure, imshow(img_gray);

% mengkonversi citra grayscale menjadi biner
bw = imbinarize(img_gray,graythresh(img_gray));
% melakukan komplemen citra agar objek bernilai satu dan background bernilai nol
bw = imcomplement(bw);
figure, imshow(bw);

% operasi morfologi untuk menyempurnakan hasil segmentasi
% area opening untuk menghilangkan noise
bw = bwareaopen(bw,100);
% filling holes untuk mengisi objek yang berlubang
bw = imfill(bw,'holes');
% closing untuk membuat bentuk objek lebih smooth
str = strel('disk',5);
bw = imclose(bw,str);
% menghilangkan objek yang menempel pada border (tepian citra)
bw = imclearborder(bw);
figure, imshow(bw);

% pelabelan terhadap masing2 objek
[B,L] = bwlabel(bw);
% menghitung luas dan centroid objek
stats = regionprops(B,'All');
centroid = stats.Centroid;
luas = stats.Area;
disp(luas);
% mengkonversi citra rgb menjadi YCbCr
YCbCr = rgb2ycbcr(img);
% mengekstrak komponen Cb (Chrominance-blue)
Cb = YCbCr(:,:,2);

%Menampilkan citra asli untuk dilabeli
figure, imshow(img);
hold on
boundaries = bwboundaries(bw,'noholes');
boundary = boundaries{1};

if luas<32000 nilai = 100;
elseif luas<38000 nilai = 100;
elseif luas<42000 nilai = 1000;
elseif luas<47000 nilai = 200;
elseif luas<53000 nilai = 500;
elseif luas<62000 nilai = 500;
end

% menampilkan boundary pada objek
plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 4);
text(centroid(1)-50,centroid(2),num2str(nilai),'Color','y','FontSize',20,'FontWeight','bold');