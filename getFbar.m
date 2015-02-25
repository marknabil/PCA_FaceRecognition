function [ f_bar ] = getFbar( X )

%% step 1 : intialize the image 

%  dirOutput = dir(fullfile('images\train_images', '*.jpg'));

%fileNames={dirOutput.name}';

%XX=char ( fileNames(1));
imgs = dir(strcat('images\train_images\','*.jpg'));
features = dir(strcat('images\train_images\', '*.txt'));
firstname= features(1).name;
%features = readfiles(featuresDir, '*.txt');
disp(firstname);
f_bar = load(['images\train_images\' firstname]);
f_pre = [13 20; 50 20; 34 34; 16 50; 48 50];

display(f_bar)

threshold = 1;
counter   = 0;
error     = 20;

while(counter < 30)
    %% Step 2: affine transformation 
     
    Ab = pinv([f_bar, [1; 1; 1; 1; 1]]) * f_pre;
    
    A = Ab(1: 2, :);
    b = Ab(3, :);
    
    A = A';
    b = b';
    % feature transform 
    Ab_temp = [A'; b'];
    f_bar = [f_bar, [1; 1; 1; 1; 1]] * Ab_temp;
    %% Step 3 : 
    f_sum = zeros(5, 2);
    
    for i = 1: (size(imgs,1))
        
        fi      = load(['images\train_images\' firstname ]);
        
        
        %affine then  feature 
        
        Ab = pinv([fi, [1; 1; 1; 1; 1]]) * f_bar;
        
        A = Ab(1: 2, :);
        b = Ab(3, :);
        
        A = A';
        b = b';
        
        
        Ab_temp = [A'; b'];
    
    fi_dash = [fi, [1; 1; 1; 1; 1]] * Ab_temp;
        f_sum   = f_sum + fi_dash;
        
    end
    %% Step 4 : 
    f_bar_t = f_sum / (size(imgs,1));
    %% Step 5 : 
    
    error = sum(sqrt(sum(((f_bar_t' - f_bar').^2))));
    
    f_bar = f_bar_t;
    
    if(error < threshold)
        break;
    end
    
    counter = counter + 1;
    
end

end

