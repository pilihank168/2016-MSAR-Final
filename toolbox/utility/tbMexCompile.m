function tbMexCompile(mode)
% tbMexCompile: Compile all mex files within a toolbox
%
%	Usage:
%		tbMexCompile(mode)
%			mode='demo' (default) makes the mex files expires at a certain date.
%			mode='normal' makes the mex files to check the license each time the mex files are invoked.
%
%	You should invoke this script with mex dir of each toolbox.

%	Roger Jang, 20090210

if nargin<1, mode='demo'; end

definedMode='';
if strcmp(mode, 'demo')
	definedMode='-DDEMO';
end

clear mex;

fprintf('This script generate mex files compatible with MATLAB 7.x...\n');
[parentDir, dirName, junk]=fileparts(pwd);
[junk, toolboxDir, junk]=fileparts(parentDir);

switch toolboxDir
	case 'utility'
		skipFileNames={};
	case 'machineLearning'
		skipFileNames={'gmmTrainMex', 'gmmEvalIntMex'};
	case 'sap'
		skipFileNames={};
	case 'melodyRecognition'
		skipFileNames={};
	otherwise
		error(sprintf('Unknown toolbox "%s"! (You need to run this command from the mex folder of a toolbox.)', toolboxDir));
end

cppFiles=dir('*.cpp');
for i=1:length(cppFiles)
	mainName=cppFiles(i).name(1:end-4);
	% === Set up cmd for compilation
	% /users/jang ===> ../../../..
	switch toolboxDir
		case 'utility'
			cmd=sprintf('mex -I../../../../c/lib -I../../../../c/lib/utility %s.cpp ../../../../c/lib/utility/utility.cpp', mainName);
		case 'machineLearning'
		%	cmd=sprintf('mex -I/users/jang/c/lib -I/users/jang/c/lib/utility -I/users/jang/c/lib/dcpr -I/users/jang/c/lib/mfccInt %s.cpp /users/jang/c/lib/dcpr/dcpr.cpp /users/jang/c/lib/utility/utility.cpp -output %s', mainName, mainName);
			cmd=sprintf('mex -I/users/jang/c/lib -I/users/jang/c/lib/utility -I/users/jang/c/lib/dcpr -I/users/jang/c/lib/mfccInt %s.cpp /users/jang/c/lib/dcpr/dcpr.cpp /users/jang/c/lib/utility/utility.cpp', mainName);
			cmd=sprintf('mex %s -I/users/jang/c/lib -I/users/jang/c/lib/utility -I/users/jang/c/lib/dcpr -I/users/jang/c/lib/mfccInt -I/users/jang/c/lib/matlab %s.cpp /users/jang/c/lib/dcpr/dcpr.cpp /users/jang/c/lib/utility/utility.cpp /users/jang/c/lib/matlab/license.cpp', definedMode, mainName);
		case 'sap'
			cmd=sprintf('mex -I/users/jang/c/lib -I/users/jang/c/lib/audio -I/users/jang/c/lib/utility %s.cpp /users/jang/c/lib/audio/audio.cpp /users/jang/c/lib/utility/utility.cpp', mainName);
			if find(strcmp(mainName, {'uniCombMex', 'lpCombMex', 'tapDelayLineMex'}))
				cmd=sprintf('mex -I/users/jang/c/lib/audio %s.cpp /users/jang/c/lib/audio/audioEffect.cpp', mainName);
			end
			if strcmp(mainName, 'wavReadMex')
				cmd=sprintf('mex -I/users/jang/c/lib -I/users/jang/c/lib/wave -I/users/jang/c/lib/utility %s.cpp /users/jang/c/lib/wave/CWavePCM.cpp /users/jang/c/lib/wave/waveRead4pda.cpp /users/jang/c/lib/utility/utility.cpp', mainName);
			end
			if strcmp(mainName, 'wave2mfccMex')
				cmd=sprintf('mex -I/users/jang/c/lib -I/users/jang/c/lib/wave -I/users/jang/c/lib/audio -I/users/jang/c/lib/mfcc -I/users/jang/c/lib/utility %s.cpp /users/jang/c/lib/audio/audio.cpp /users/jang/c/lib/wave/waveRead4pda.cpp /users/jang/c/lib/utility/utility.cpp /users/jang/c/lib/mfcc/CMEL.cpp /users/jang/c/lib/mfcc/CFEABUF.cpp /users/jang/c/lib/mfcc/CSigP.cpp', mainName);
			end
			if strcmp(mainName, 'wave2mfccMexByGavins')
				cmd=sprintf('mex -I/users/jang/c/lib -I/users/jang/c/lib/audio -I/users/jang/c/lib/mfcc -I/users/jang/c/lib/utility %s.cpp /users/jang/c/lib/audio/audio.cpp /users/jang/c/lib/mfcc/mfccByGavins.cpp /users/jang/c/lib/utility/utility.cpp', mainName);
			end
		case 'melodyRecognition'
			cmd=sprintf('mex -I/users/jang/c/lib/audio -I/users/jang/c/lib/utility -I/users/jang/c/lib/wave %s.cpp /users/jang/c/lib/wave/waveRead4pda.cpp /users/jang/c/lib/audio/audio.cpp /users/jang/c/lib/utility/utility.cpp', mainName);
		otherwise
			error(sprintf('Unknown toolbox %s!', toolboxDir));
	end
	if any(strcmp(mexext, {'mexglx', 'mexa64', 'mexmaci', 'mexmaci64'}))
		cmd=strrep(cmd, '/users/jang', '../../../..');
	end
	fprintf('%.2d/%d: %s\n', i, length(cppFiles), cmd);
	% === Skip unfinished code
	if any(strcmp(mainName, skipFileNames))
		fprintf('\tSkip unfinished %s.cpp!!!\n', mainName);
		continue;
	end
	% === Do the compilation
	try
		eval(cmd);
	catch
		fprintf('	Warning: Cannot compile via "%s"!\n', cmd);
	end
end

% ====== Special case handling
switch toolboxDir
	case 'utility'
	case 'machineLearning'
		%cmd2='mex gmmEvalIntMex.cpp -I/users/jang/c/lib -I/users/jang/c/lib/utility -I/users/jang/c/lib/dcpr -I/users/jang/c/lib/mfccInt -I/users/jang/c/lib/tableLookUp /users/jang/c/lib/dcpr/dcpr.cpp /users/jang/c/lib/dcpr/dcprInt.cpp /users/jang/c/lib/utility/utility.cpp';
		%fprintf('cmd2=%s\n', cmd2);
		%eval(cmd2);
	%	mFiles={'dtw1m.m', 'dtw2m.m', 'dtw3m.m', 'distPairwiseM.m', 'distSqrPairwiseM.m', 'dpOverMapM.m'};
	%	for i=1:length(mFiles)
	%		dosCmd=sprintf('xcopy /y /q %s ..\\private', mFiles{i});
	%		dos(dosCmd);
	%	end
	case 'sap'
	case 'melodyRecognition'
	otherwise
		error(sprintf('Unknown toolbox %s!', toolboxDir));
end

% ====== Copy all mex files to the private folder
fprintf('Copying *.mex* to the toolbox''s private directory...\n');
switch mexext
	case {'mexw32', 'mexw64'}
		dos('xcopy /y /q *.mex* ..\private');
	case {'mexglx', 'mexa64', 'mexmaci', 'mexmaci64'}
		unix('cp -f *.mex* ../private');
end
