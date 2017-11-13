% your code here
function testCarSequenceWithTemplateCorrection()
    load('../data/carseq.mat');
    load('../results/carseqrects.mat')
    seq_num = size(frames,3);
    rect_wtc = [60, 117, 146, 152];
    save_frame = [1 100 200 300 400];
    save_rect_wtc = zeros(seq_num,4);
    firstFrame = frames(:,:,1);
    rect0 = [60, 117, 146, 152];
    for i=1:seq_num
        current_seq = frames(:,:,i);
        if i~=1
            [dp_x,dp_y] = LucasKanadeWithTemplateCorrection(frames(:,:,i-1),current_seq,firstFrame,rect_wtc,rect0);
            rect_wtc = rect_wtc+[dp_x,dp_y,dp_x,dp_y];
        end
        save_rect_wtc(i,:) = rect_wtc;
        imshow(current_seq);
        hold on;
        rectangle('Position',[rect_wtc(1) rect_wtc(2) rect_wtc(3)-rect_wtc(1) rect_wtc(4)-rect_wtc(2)],'EdgeColor','y');
        rectangle('Position',[save_rect(i,1) save_rect(i,2) save_rect(i,3)-save_rect(i,1) save_rect(i,4)-save_rect(i,2)],'EdgeColor','g');
        hold off;
        if ~isempty(find(save_frame==i))
            print(['./q1_4_',num2str(i),'.jpg'], '-djpeg');
        end
        pause(0.01);
    end
    save('./carseqrects-wcrt.mat','save_rect_wtc');
end