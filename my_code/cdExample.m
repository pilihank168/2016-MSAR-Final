addpath ../toolbox/;
addpath ../toolbox/ChordDetect/;
addpath ../toolbox/ChordDetect/isptoolbox/;
addpath ../toolbox/ChordDetect/svm_hmm;
toolBoxPath = '../toolbox/ChordDetect';
inputPath = 'Input/';
resultPath = 'Result';
doChordID_svm([toolBoxPath inputPath 'songPath.txt'] , [toolBoxPath inputPath 'models'] ,[toolBoxPath resultPath])
%doChordID_svm([toolBoxPath inputPath 'songPath.txt'] , [toolBoxPath '/models'] , './');