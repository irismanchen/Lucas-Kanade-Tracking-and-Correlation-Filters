function [dp_x,dp_y] = LucasKanadeBasis(It, It1, rect, bases)

% input - image at time t, image at t+1, rectangle (top left, bot right
% coordinates), bases 
% output - movement vector, [dp_x,dp_y] in the x- and y-directions.

% A*p - b - BB^T * A*p + BB^T * b
% A*p - BB^T * A*p － b ＋ BB^T * b
% (A - BB^T * A) *p － b ＋ BB^T * b

    threshold = 0.1;
    It = im2double(It);
    It1 = im2double(It1);
    [It1x, It1y] = gradient(It1);
    p = [0;0];
    delta_p = [1;1];
    bases_num = size(bases,3);
    temp_x = rect(1);
    temp_y = rect(2);
    rect_w = round(rect(3)-rect(1));
    rect_h = round(rect(4)-rect(2));
    B = reshape(bases, (rect_w+1)*(rect_h+1), bases_num);
    BBT = B*B';
    T = It(rect(2):rect(4),rect(1):rect(3));
    [X,Y] = meshgrid(1:size(It,2),1:size(It,1));
    while norm(delta_p)>=threshold
        [X_interp,Y_interp] = meshgrid(temp_x:temp_x+rect_w,temp_y:temp_y+rect_h);
        grad_x = interp2(X, Y, It1x, X_interp, Y_interp);
        grad_y = interp2(X, Y, It1y, X_interp, Y_interp);
        next_rect = interp2(X, Y, It1, X_interp, Y_interp);
        b = T - next_rect;
        b = b(:) - BBT*b(:);
        A = [grad_x(:) grad_y(:)];
        A = A - BBT*A;
        delta_p = A\b;
        p = p + delta_p;
        temp_x = temp_x+delta_p(1);
        temp_y = temp_y+delta_p(2);
    end
    dp_x = p(1);
    dp_y = p(2);
end