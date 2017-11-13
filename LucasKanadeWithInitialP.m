function [dp_x,dp_y] = LucasKanadeWithInitialP(It, It1, rect, p)
% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [dp_x, dp_y] in the x- and y-directions.
threshold = 0.1;
[X,Y] = meshgrid(rect(1):rect(3),rect(2):rect(4));
It = im2double(It);
It1 = im2double(It1);
% the template
T = interp2(It,X,Y);
% the gradient of the template
[Tx, Ty] = gradient(T);
% the inverse Hessian matrix
H = [Tx(:) Ty(:)]'*[Tx(:) Ty(:)];
% initialization
delta_p = [1;1];
while norm(delta_p)>=threshold
    % warp the image
    [X,Y] = meshgrid(p(1)+(rect(1):rect(3)),p(2)+(rect(2):rect(4)));
    I = interp2(It1,X,Y);
    % compute the error image
    E = I - T;
    b = [Tx(:) Ty(:)]'*E(:);
    % H*delta_p = b
    delta_p = H\b;
    p = p - delta_p;
end
dp_x = p(1);
dp_y = p(2);