function [XData, yValue] = TrainData()
%TRAINDATA Summary of this function goes here
%   Detailed explanation goes here

fullDirFile = fullfile('trainingImages', 'positive','*.png');
imageNamesPositive = dir(fullDirFile);
fullDirFile = fullfile('trainingImages', 'negative','*.png');
imageNamesNegative = dir(fullDirFile);

imageNamesPositive = {imageNamesPositive.name}';
imageNamesNegative = {imageNamesNegative.name}';

%X = cell((length(imageNamesPositive) + length(imageNamesNegative)), 9800);
%y = cell((length(imageNamesPositive) + length(imageNamesNegative)),1);

X = [];
y = [];

%convert positive images to features
for i = 1:length(imageNamesPositive)
    fullPathImage = strcat(strcat('trainingImages\\positive\\'), imageNamesPositive{i});
    frame = imread(fullPathImage);
    red = double(frame(:,:,1));
    green = double(frame(:,:,2));
    sum = red*255 + green;
    features = reshape(sum, 1, []); %plavi kanal je sve u 0 tako da ga ne citamo
    X = [X; features];
    y = [y; 1];
end  

%convert negative images to features
for i = 1:length(imageNamesNegative)
    fullPathImage = strcat(strcat('trainingImages\\negative\\'), imageNamesNegative{i});
    frame = imread(fullPathImage);
    red = double(frame(:,:,1));
    green = double(frame(:,:,2));
    sum = red*255 + green;
    features = reshape(sum, 1, []); %plavi kanal je sve u 0 tako da ga ne citamo
    X = [X; features];
    y = [y; 0];
end
XData = X;
yValue = y;

end

