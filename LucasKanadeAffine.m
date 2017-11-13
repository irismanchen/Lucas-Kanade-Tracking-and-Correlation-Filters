function M = LucasKanadeAffine(It, It1)

% input - image at time t, image at t+1 
% output - M affine transformation matrix
    It = im2double(It);
    It1 = im2double(It1);
    % gradient of image I
    [It1x, It1y] = gradient(It1);
    p = zeros(6,1);
    delta_p = ones(size(p));
    threshold = 0.1;
    [X,Y] = meshgrid(1:size(It,2),1:size(It,1));
    imagePoints = [X(:)'; Y(:)'; ones(1,numel(It))];
    while norm(delta_p)>=threshold
        % affine transformation matrix
        M = [1+p(1),p(2),p(3);p(4),1+p(5),p(6);0,0,1];
        warped_imagePoints = M*imagePoints;
        selectedPixel = (warped_imagePoints(1,:)>=1)&(warped_imagePoints(1,:)<size(It1,2))&(warped_imagePoints(2,:)>=1)&(warped_imagePoints(2,:)<size(It1,1));
        % only keep the points that lie in the common area
        X_interp = warped_imagePoints(1,selectedPixel)';
        Y_interp = warped_imagePoints(2,selectedPixel)';
        % warp I and gradient of I
        I = interp2(X, Y, It1, X_interp, Y_interp);
        grad_x = interp2(X, Y, It1x, X_interp, Y_interp);
        grad_y = interp2(X, Y, It1y, X_interp, Y_interp);
        %I = reshape(I,size(It1));
        XX = X(selectedPixel);
        YY = Y(selectedPixel);
        % compute the error image
        Itt = It(selectedPixel);
        E = Itt(:)-I(:);
        % the steepest descent images
        SD = [grad_x(:).*XX(:), grad_x(:).*YY(:),grad_x(:), grad_y(:).*XX(:), grad_y(:).*YY(:),grad_y(:)];
        % Hessian
        H = SD'*SD;
        b = SD'*E(:);
        delta_p = H\b;
        p = p+delta_p;
    end
end