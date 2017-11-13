% your code here
function testAerialSequence()
    load('../data/aerialseq.mat');
    save_frame = [30 60 90 120];
    numOfFrames = size(frames, 3);
    for i = 2:numOfFrames
        curFrame = frames(:,:,i);
        mask = SubtractDominantMotion(frames(:,:,i-1),curFrame);
        C = imfuse(frames(:,:,i-1), mask);
        imshow(C);
        if ~isempty(find(save_frame==i))
            %print(['../results/q3_3_',num2str(i),'.jpg'], '-djpeg');
            print(['./q4_1_',num2str(i),'.jpg'], '-djpeg');
        end
        pause(0.01);
    end
end