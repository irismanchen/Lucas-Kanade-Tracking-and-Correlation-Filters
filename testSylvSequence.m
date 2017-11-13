% your code here
function testSylvSequence()
    load('../data/sylvbases.mat');
    load('../data/sylvseq.mat');
    basesNum = size(bases,3);
    rect = [102, 62, 156, 108];
    save_frame = [1 200 300 350 400];
    framesNum = size(frames,3);
    save_rect = zeros(framesNum,4);
    rect_lk = rect;
    rect_lkwb = rect;
    for i = 1:framesNum
        current_frame = frames(:,:,i);
        if i~=1
            [dp_x,dp_y] = LucasKanade(frames(:,:,i-1),current_frame,rect_lk);
            rect_lk = rect_lk+[dp_x,dp_y,dp_x,dp_y];
            [u,v] = LucasKanadeBasis(frames(:,:,i-1),current_frame,rect_lkwb, bases);
            rect_lkwb = rect_lkwb+[u,v,u,v];
        end
        imshow(current_frame);
        hold on;
        rectangle('Position',[rect_lkwb(1) rect_lkwb(2) rect_lkwb(3)-rect_lkwb(1) rect_lkwb(4)-rect_lkwb(2)],'EdgeColor','y');
        rectangle('Position',[rect_lk(1) rect_lk(2) rect_lk(3)-rect_lk(1) rect_lk(4)-rect_lk(2)],'EdgeColor','g');
        hold off;
        save_rect(i,:) = rect_lkwb;
        if ~isempty(find(save_frame==i))
            print(['./q2_3_',num2str(i),'.jpg'], '-djpeg');
        end
        pause(0.01)
    end
    save('./sylvseqrects.mat','save_rect');
end