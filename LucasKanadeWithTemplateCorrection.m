function [dp_x,dp_y] = LucasKanadeWithTemplateCorrection(It, It1, I0, rect, rect0)
    epsilon = 2;
    % using the template from the last frame
    [delta_laxt_x, delta_last_y] = LucasKanade(It, It1, rect);
    rect_last = rect+[delta_laxt_x, delta_last_y, delta_laxt_x, delta_last_y];
    % using template from the first frame
    p = (rect_last(1:2)-rect0(1:2))';
    [delta_first_x, delta_first_y] = LucasKanadeWithInitialP(I0, It1, rect0, p);
    delta_first_x = delta_first_x+rect0(1)-rect(1);
    delta_first_y = delta_first_y+rect0(2)-rect(2);
    drift = [delta_first_x, delta_first_y]-[delta_laxt_x, delta_last_y];
    if norm(drift)<=epsilon
        dp_x = delta_first_x;
        dp_y = delta_first_y;   
    else
        dp_x = delta_laxt_x;
        dp_y = delta_laxt_y;
    end
end