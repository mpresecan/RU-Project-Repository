function PrepareTrainData()
    %PREPARETRAINDATA Summary of this function goes here
    %   Detailed explanation goes here

    %how much of negative faces would be trained compared to positive faces
    negativePositiveRation = 1; %maybe 2 is OK
    widthHeightRectangle = 70;
    workingDirs = {'tomislav', 'bruno'};

    imagesD = {};
    imagesC = {};

    %for all directories get the names of the images in imagesD and imagesC
    %with its full path
    for workingDir = workingDirs
        fullDirFile = fullfile(workingDir, 'images','RGB_*.png');
        imageNamesColor = dir(fullDirFile{1});
        fullDirFile = fullfile(workingDir, 'images','Depth_RGB*.png');
        imageNamesDepth = dir(fullDirFile{1});
        
        imageNamesColor = {imageNamesColor.name}';
        imageNamesDepth = {imageNamesDepth.name}';

        imagesCNames = {};
        imagesDNames = {};
        for i = 1:length(imageNamesColor)
           fullPathColorImage = strcat(strcat(workingDir, '\\images\\'), imageNamesColor{i});
           imagesCNames = cat(1,imagesCNames, fullPathColorImage);
           
           fullPathDepthImage = strcat(strcat(workingDir, '\\images\\'), imageNamesDepth{i});
           imagesDNames = cat(1,imagesDNames, fullPathDepthImage);
        end
        
        imagesC = cat(1, imagesC, imagesCNames);
        imagesD = cat(1, imagesD, imagesDNames);
    end
    
    FDetect = vision.CascadeObjectDetector;
    
    negativeCounter = 0;
    for i = 1:length(imagesC)
       frameC = imread(imagesC{i});
       frameD = imread(imagesD{i});
       imInfo = imfinfo(imagesD{i});
       BB = step(FDetect,frameC);
       if isempty(BB) ~= 1
           %fill positives
           imCrop = imcrop(frameD, [round(BB(1,1) - 0.2*BB(1,3)) round(BB(1,2) - 0.2*BB(1,4)) BB(1,3) BB(1,4)]); %%PAZI NA OVAJ 0.2 ispravak
           frameDCroped = imresize(imCrop, [widthHeightRectangle widthHeightRectangle]);
           imwrite(frameDCroped, strcat(strcat(strcat('trainingImages', '\\positive\\'), num2str(i,'%04u')),'.png'));
           
           %fill negatives
           for j = 1:negativePositiveRation
               condition = 1;
               while condition
                  %generate frame that doesnt consists face
                  x = randsample(imInfo.Width - widthHeightRectangle,1);
                  y = randsample(imInfo.Height - widthHeightRectangle,1);
                  if (~((x > BB(1,1)) && (x < BB(1,1) + BB(1,3))) || ((y > BB(1,2)) && (y < BB(1,2) + BB(1,4))))
                      condition = 0;
                  end
               end
               negativeCounter = negativeCounter + 1;
               imCrop = imcrop(frameD, [x, y + widthHeightRectangle, widthHeightRectangle, widthHeightRectangle]);
               frameDCroped = imresize(imCrop, [widthHeightRectangle widthHeightRectangle]);
               imwrite(frameDCroped, strcat(strcat(strcat('trainingImages', '\\negative\\'), num2str(negativeCounter,'%06u')),'.png'));
               
           end    
       end
    end
    disp('Finished. Data is prepared for training, but first check manualy for false positive data in \\trainingImages\\positives directories');
end

