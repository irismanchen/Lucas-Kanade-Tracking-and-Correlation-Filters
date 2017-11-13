% your code here
function testCarSequence()
    load('../data/carseq.mat');
    seq_num = size(frames,3);
    rect = [60, 117, 146, 152];
    save_frame = [1 100 200 300 400];
    save_rect = zeros(seq_num,4);
    for i=1:seq_num
        current_seq = frames(:,:,i);
        if i~=1
            [dp_x,dp_y] = LucasKanade(frames(:,:,i-1),current_seq,rect);
            rect = rect+[dp_x,dp_y,dp_x,dp_y];
        end
        save_rect(i,:) = rect;
        imshow(current_seq);
        hold on;
        rectangle('Position',[rect(1) rect(2) rect(3)-rect(1) rect(4)-rect(2)],'EdgeColor','y');
        hold off;
        if ~isempty(find(save_frame==i))
            print(['./q1_3_',num2str(i),'.jpg'], '-djpeg');
        end
        pause(0.01);
    end
    save('./carseqrects.mat','save_rect');
end