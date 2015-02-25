%% normalization of images function 
function [Ifinal] = ImageNormalization(Io, Fbar, Fimg)

I = rgb2gray(Io);

%% affine transformation and its six parameters

  Ab = pinv([Fimg, [1; 1; 1; 1; 1]]) * Fbar;

    A = Ab(1: 2, :);
    b = Ab(3, :);

    A = A';
    b = b';
    
	%% getting the output normalized image 
    % make some kind of boarder padding to set the image to 64*64 without
    % lossing or adding features
	
Ifinal = uint8(zeros(64, 64));

 for i=1:64
      for j=1:64       
          
          xy = (pinv(A)*( [ i; j ] - b ));
          
          % extract the x and y coordinate 
          xcor = int32(xy(1,:));
          ycor = int32(xy(2,:));
          
          % Error handling conditions because from several runs we got -ve
          % values
         
          if(xcor <= 0)
              xcor = 1;
          end
           if(xcor > 240)
              xcor = 240;
           end
          
          if(ycor <= 0)
              ycor = 1;
          end
          
          if(ycor >320)
              ycor = 320;
          end
          
          Ifinal(i,j) = uint8(I(ycor, xcor));
      end
      
 end

 Ifinal = Ifinal';

end