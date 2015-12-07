
function CaptureAndSaveRGBOnly(picNum)

vidobj = imaq.VideoDevice('kinect', 1);

vidobj.ReturnedColorSpace = 'RGB';
disp('Recording started.');
frames = cell(picNum);
tic;
for i=1:picNum
    frames{i}=step(vidobj);
end
elapsedTime = toc;
disp('Recording stopped.');
release(vidobj);
clear vidobj;

% Check to see if folder 'images' exists.
folderExists  = (exist(fullfile(cd, 'images'), 'dir') == 7);
if folderExists
    disp('Saving to images folder.');
else
    disp('Creating images folder and saving to it.');
    mkdir('images')
end

% Process and save images.
for i=1:picNum
    disp('Processing :');
    disp(i);
    
    imwrite(frames{i}, strcat(strcat('images/RGB_', num2str(i,'%04u')),'.png'));
end

PNG2AVI_FrameRate = picNum / elapsedTime;
disp(strcat('Saving color to video file.'));
disp(strcat('frameRate-', num2str(PNG2AVI_FrameRate)));
PNG2AVI(PNG2AVI_FrameRate);
disp('Done!');