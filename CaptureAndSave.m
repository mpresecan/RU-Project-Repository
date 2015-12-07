
function CaptureAndSave(picNum, videoName)

workingDir = videoName;
vidobj = imaq.VideoDevice('kinect', 1);
vidobj2 = imaq.VideoDevice('kinect', 2);

vidobj2.ReturnedDataType= 'uint16';
vidobj.ReturnedColorSpace = 'RGB';
vidobj2.ReturnedColorSpace = 'Grayscale';
disp('Recording started.');
frames = cell(picNum);
frames2 = cell(picNum);
tic;
for i=1:picNum
    frames{i}=step(vidobj);
    frames2{i}=step(vidobj2);
end
elapsedTime = toc;
disp('Recording stopped.');
release(vidobj);
clear vidobj;
release(vidobj2);
clear vidobj2;

% Check to see if folder 'images' exists.
folderExists  = (exist(fullfile(workingDir, 'images'), 'dir') == 7);
if folderExists
    disp('Saving to images folder.');
else
    disp('Creating images folder and saving to it.');
    mkdir(strcat(workingDir, '\\images'));
end
% Clear the folder
imageNamesColor = dir(fullfile(workingDir, 'images','*.png'));
imageNamesColor = {imageNamesColor.name}';
for ii = 1:length(imageNamesColor)
   delete(fullfile(workingDir, 'images', imageNamesColor{ii}));
end

% Process and save images.
for i=1:picNum
    disp('Processing :');
    disp(i);
    
    imwrite(frames{i}, strcat(strcat(strcat(workingDir, '\\images\\RGB_'), num2str(i,'%04u')),'.png'));
    imwrite(frames2{i}, strcat(strcat(strcat(workingDir, '\\images\\Depth_'), num2str(i)),'.png'));
    
    % read in tiff image and convert it to integers from [0, 65536]
    my_image = floor(im2double(frames2{i})*256*256);
    % allocate space for thresholded image
    image_thresholded = zeros(size(frames{i}));
    % loop over all rows and columns
    for ii=1:size(my_image,1)
        for jj=1:size(my_image,2)
           % get pixel value
            pixel = my_image(ii,jj,1);
            lowerBits = mod(pixel, 256);
            upperBits = (pixel - lowerBits) / 256;
            new_pixel(1) = upperBits / 256.0;
            new_pixel(2) = lowerBits / 256.0;
            new_pixel(3) = 0.0;
            
            image_thresholded(ii,jj,1:3) = new_pixel;
        end
    end
  
    imwrite(image_thresholded, strcat(strcat(strcat(workingDir, '\\images\\Depth_RGB_'), num2str(i,'%04u')),'.png'));
    
end
PNG2AVI_FrameRate = picNum / elapsedTime;
disp(strcat('Saving color and depth to video file.'));
disp(strcat('frameRate-', num2str(PNG2AVI_FrameRate)));
PNG2AVI(PNG2AVI_FrameRate, videoName);
disp('Done!');