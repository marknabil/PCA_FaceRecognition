function [related_image_1, related_image_2, related_image_3, related_image_name_1, related_image_name_2, related_image_name_3, error_1, error_2, error_3] = recognize_face(handles, original_image_name, f_bar)

%%intialization of the D-matrix and the normalized images

matrixD = [];
Inormalized = dir(strcat('images\normalized_images\','*.jpg'));

%% computer eigen faces from a training set - build the D-matrix

for index = 1: (size(Inormalized,1))
    
    normalized_image = imread(['images\normalized_images\' Inormalized(index).name()]);
    
    matrixD = [matrixD; reshape(normalized_image', 1, 4096)];
    
end

matrixD = double(matrixD);

%% compute the mean of the columns of d_matrix
matrixDmean = mean(matrixD);

[p d] = size(matrixD);

matrixDnorm = matrixD;
matrixDnormT=matrixDnorm';

%% subtract the mean from each row vector in d_matrix, call the new matrix d_matrix_norm
for index = 1: p
    
    matrixDnorm(index, :) = matrixD(index, :) - matrixDmean;
    
end
%% compute Sigma
sigmaDash = (1 / (p - 1)) * (matrixDnorm * matrixDnorm');

% choose proper k number <100 for face recognition 
k = 50;
%k=20;

% find its eigenvectors
[ vector values ] = eigs(sigmaDash, k);

% phi' is equal to eigenvectors of E'
phiDash = vector;

% We can obtain phi, 
% d_matrix_norm' * phi'  
phi   = matrixDnorm' * phiDash;
phiI = matrixD * phi;
phiI = phiI';

%% Sterp : recognizing a face 

Ioriginal   = imread(['images\test_images\' original_image_name '.jpg']);
f_image          = load(['images\test_images\' original_image_name '.txt']);
normalized_image = ImageNormalization(Ioriginal, f_bar, f_image);
Xj               = double(reshape(normalized_image', 1, 4096));

%% Euclidean distance between phiJ & phiI
phiJ    = Xj * phi;
phiJ    = phiJ';
distance = [];

for i = 1: (size(Inormalized,1))
    
    distance(i, 1) = i;
    distance(i, 2) = sqrt(sum((phiJ - phiI(: , i)).^2));
    
end

distance = sortrows(distance, 2);

related_image_1      = ['images\train_images\' handles.jpg_train_image_array(distance(1, 1)).name];
related_image_2      = ['images\train_images\' handles.jpg_train_image_array(distance(2, 1)).name];
related_image_3      = ['images\train_images\' handles.jpg_train_image_array(distance(3, 1)).name];
related_image_name_1 = handles.jpg_train_image_array(distance(1, 1)).name(1: end - 6);
related_image_name_2 = handles.jpg_train_image_array(distance(2, 1)).name(1: end - 6);
related_image_name_3 = handles.jpg_train_image_array(distance(3, 1)).name(1: end - 6);

% compare the names of the related images and the choosen one 
if(~strcmp(original_image_name(1: end - 2), related_image_name_3))
    error_3 = 1;
else
    error_3 = 0;
end


if(~strcmp(original_image_name(1: end - 2), related_image_name_2))
    error_2 = 1;
else
    error_2 = 0;
    error_3 = 0;
end


if(~strcmp(original_image_name(1: end - 2), related_image_name_1))
    error_1 = 1;
else
    error_1 = 0;
    error_2 = 0;
    error_3 = 0;
end

return;

end

