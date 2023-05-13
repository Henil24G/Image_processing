clear variables;
close all;

%% Question 1
% Read the image from file and convert it to a double intensity image
chess_img = imread('car_dis.png');
chess_img_db = im2double(chess_img);

% Display the original image
figure(1);
imshow(chess_img_db);
title('Original Image');

% Calculate the Fourier transform
car_FD = fft2(chess_img_db);

% Display the Fourier transform
figure(2);
imshow(car_FD);
title('Fourier Transform');

% Shift the Fourier transform
chess_img_shift = fftshift(car_FD);

% Display the log-amplitude spectrum
figure(3);
imshow(log(abs(chess_img_shift) + 1), []);
title('Log-Magnitude Spectrum');
xlabel('u');
ylabel('v');
print('-r150', '-dpng', 'Imlogmag.png');

%% Question 2
% Find the indices where the intensity at (1, 1) matches the shifted image
[row, col] = find(chess_img(1, 1) == chess_img_shift);

% Calculate the wavelength
Delta = 1;
Lambda = 9 * Delta;
Rho = 1 / Lambda;

%% Question 3 - Filter the image with a rectangular PSF
PSF = fspecial('average', [1, 9]);
imfil = imfilter(chess_img, PSF);

% Display the filtered image
figure(4);
imshow(imfil);
title('Filtered Image');

IMfil = fft2(imfil);

% Display the Fourier transform of the filtered image
figure(5);
imshow(IMfil);
title('Filtered Fourier Transform');

% Display the log-amplitude spectrum
figure(6);
imshow(fftshift(log(abs(IMfil) + 1)), []);
title('Log-Amplitude Spectrum');
xlabel('u');
ylabel('v');
imwrite(imfil, 'IMfil.jpg');
print('-r150', '-dpng', 'LogAmp.png');

%% Question 4
OTF = psf2otf(PSF, [256, 256]);

% Display the OTF
figure(7);
imshow(OTF);
title('Optical Transfer Function');

% Display the log-magnitude spectrum of the OTF
figure(8);
imshow(fftshift(log(abs(OTF) + 1)), []);
title('Log-Magnitude Spectrum');
print('-r150', '-dpng', 'LMNew.png');

% Calculate the imaginary part of the OTF
max_imag_OTF = max(abs(imag(OTF(:))));

%% Question 5
s = 17; % Matrix size
[M, N] = size(chess_img);
H = ones(size(chess_img));
row = 129;
col = 129;
