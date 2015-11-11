
workingDir = '.';

imageNamesColor = dir(fullfile(workingDir,'images','RGB_*.png'));
imageNamesColor = {imageNamesColor.name}';
imageNamesDepth = dir(fullfile(workingDir,'images','Depth_RGB_*.jpg'));
imageNamesDepth = {imageNamesDepth.name}';

outputVideoColor = VideoWriter(fullfile(workingDir,'color_out.avi'), 'Uncompressed AVI');
outputVideoColor.FrameRate = 20;
outputVideoDepth = VideoWriter(fullfile(workingDir,'depth_out.avi'), 'Uncompressed AVI');
outputVideoDepth.FrameRate = 7;

open(outputVideoColor)
for ii = 1:length(imageNamesColor)
   img = imread(fullfile(workingDir,'images',imageNamesColor{ii}));
   writeVideo(outputVideoColor, img)
end
close(outputVideoColor)

open(outputVideoDepth)
for ii = 1:length(imageNamesDepth)
   img = imread(fullfile(workingDir,'images',imageNamesDepth{ii}));
   writeVideo(outputVideoDepth, img)
end
close(outputVideoDepth)

disp('Done!');