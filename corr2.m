clear
clc
% Get the directory where the frames are stored
asc_dir = uigetdir('','Select the directory where the ASC files are stored');
% Get a list of all ASC files in the directory
frames = dir(fullfile(asc_dir, '*.jpg'));
Filenames = {frames.name};
filenames = sort_nat(Filenames);
T=imcrop(imread(frames(1).name));
imshow(T)
imwrite(T,'template.jpg')
close all
parfor i = 1:length(frames)
        fname=filenames{i};
        R=imread(fname);
        c=normxcorr2(T,R);
        [ypeak,xpeak]=find(c==max(c(:)));
        yoffSet(i) = ypeak-size(T,1);
        xoffSet(i) = xpeak-size(T,2);
end
writerObj = VideoWriter('frames.avi');
writerObj.FrameRate = 60;
open(writerObj);
for i = 1:length(frames)
        fname=filenames{i};
        R=imread(fname);
        imshow(R);
        rectangle('Position',[xoffSet(i)+1, yoffSet(i)+1, size(T,2), size(T,1)], ...
            'EdgeColor','r','LineWidth',2);
        %imrect(gca, [xoffSet(i)+1, yoffSet(i)+1, size(T,2), size(T,1)]);
        v=getframe(gca);
        writeVideo(writerObj, imresize(v.cdata,[1920 1088]));
end
close(writerObj);