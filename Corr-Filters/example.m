% Example code for visualizing spatial correlation filters 
rgb = imread('lena.jpg'); 
img = im2double(rgb2gray(rgb)); 

% 2D projected points on the book
pts = [248, 292, 248, 292;
       252, 252, 280, 280]; 
 
% Height and width of the template
dsize = [pts(2,4)-pts(2,1)+1,pts(1,2)-pts(1,1)+1]; 

% Set the template points (in order that points appear in image)
tmplt_pts = [0, dsize(2)-1, 0, dsize(2)-1; 
             0, 0, dsize(1)-1, dsize(1)-1]; 

% Step 1. Get the positive example
t = Translation; % Define a Translation object
gnd_p = t.fit(tmplt_pts, pts); % Get the ground-truth warp
x = t.imwarp(img, gnd_p, dsize); % Define the template
figure(1); clf; subplot(1,3,1); colormap('gray'); 
imagesc(img); axis off; axis image; % Display the image
h1 = t.draw(gnd_p, dsize,'r-','LineWidth',2); % Draw the ground-truth
title('Image'); 

% Step 2. 
subplot(1,3,2); colormap('gray'); 
h2 = imagesc(x); axis off; axis image; % Display the image
title('Cropped Image'); 

% Step 3. Loop through and gather data
dx = -floor(dsize(2)/2):floor(dsize(2)/2);
dy = -floor(dsize(1)/2):floor(dsize(1)/2);
[dp1,dp2] = meshgrid(dx, dy);
N = length(dp1(:)); % Get the number of warps to obtain
dP = [dp1(:),dp2(:)]'; % Set the 
subplot(1,3,3); all_patches = zeros(N*dsize(1),dsize(2)); 
% Display all the images we are collecting
h3 = imagesc(all_patches); axis off; axis square; 
title('Concatenation of Sub-Images (X)'); 

% Allocate space for the sub-images and labels
X = zeros(N,N); % vectorized sub-images
y = zeros(N,1); 

sigma = 5; % Variance of the desired Gaussian output response
for n = 1:N
    dpn = dP(:,n); 
    xn = t.imwarp(img, gnd_p + dpn, dsize); % Define the template
    X(:,n) = xn(:); % Store the sub-patch
    y(n) = exp(-dpn'*dpn/sigma); % Store the labels
    t.redraw(gnd_p + dpn, dsize, h1); % Draw the ground-truth
    all_patches((n-1)*dsize(1)+1:n*dsize(1),:) = xn; % Set the image
    set(h2,'CData',xn); % Set the data showing all the patches
    set(h3,'CData',all_patches); % Set the data showing all the patches
    drawnow; 
end

% Display the desired output response
figure(2); clf; 
mesh(dx,dy,reshape(y,dsize)); title('Desired output response'); 
% Place your solution code to the filter 
lambda = 1;
I = eye(N);
g = inv(lambda*I+X*X')*X*y;
g = reshape(g, dsize);
lambda0 = 0;
g0 = inv(lambda0*I+X*X')*X*y;
g0 = reshape(g0, dsize);
imagesc(g);
im_with_filter = imfilter(rgb2gray(rgb),g);
imagesc(im_with_filter);
im_with_conv = conv2(rgb2gray(rgb),g,'same');
imagesc(im_with_conv);
h = flipud(fliplr(g));
im_with_rotconv = conv2(rgb2gray(rgb),h,'same');
imagesc(im_with_rotconv);




