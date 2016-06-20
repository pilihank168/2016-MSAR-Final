
addpath '../toolbox/sap/'
addpath '../toolbox/utility/'
addpath '../toolbox/TSM/'
addpath '../toolbox/vocalExtraction/'
fileDir = '../AudioFiles/';
auFile='SomeoneLikeYou.wav';
[y fs] = audioread([fileDir auFile]);
tic;
%newy = repet(y, fs);
newy = repet_ada(y, fs); 
%newnewy = repet(newy, fs);

toc;
sound(y-newy, fs);