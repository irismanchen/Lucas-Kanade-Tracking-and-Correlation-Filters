function M = InverseCompositionAffine(It, It1)

% input - image at time t, image at t+1
% output - M affine transformation matrix
    threshold = 0.1;
    It = im2double(It);
    It1 = im2double(It1);
    % the gradient of the It
    [dX, dY] = gradient(It);
    dX = dX(:);
    dY = dY(:);
    [X,Y] = meshgrid(1:size(It,2),1:size(It,1));
    X = X(:);
    Y = Y(:);
    % should be N(point number)*6
    SD = [X.*dX X.*dY Y.*dX Y.*dY dX dY];
    % initialization
    p = zeros(6,1);
    delta_p = ones(size(p));
    times = 0;
    while (norm(delta_p)>=threshold && times<=100)
        times=times+1;
        % affine transformation matrix
        M = [1+p(1) p(3) p(5);p(2) 1+p(4) p(6);0 0 1];
        imagePoints = [X(:)'; Y(:)'; ones(1,numel(It))];
        warped_imagePoints = M*imagePoints;
        selectedPixel = (warped_imagePoints(1,:)>=1)&(warped_imagePoints(1,:)<size(It1,2))&(warped_imagePoints(2,:)>=1)&(warped_imagePoints(2,:)<size(It1,1));
        tmpSD = SD(selectedPixel,:);
        H = tmpSD'*tmpSD;
        % compute the error image I(W(x;p))-T(x)
        warped_Image = interp2(It1,warped_imagePoints(1,:),warped_imagePoints(2,:),'nearset');
        E = It(:)'-warped_Image;
        E = E(selectedPixel);
        b = tmpSD'*E(:);        
        % H*delta_p = b
        delta_p = H\b;
        p = p + delta_p;
    end
end
