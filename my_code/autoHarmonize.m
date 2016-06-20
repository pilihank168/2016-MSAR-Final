%Can be implemented as function later        
%function y = autoHarmonize(x, fs)
        %setting up path
        toolPath = '../toolbox/'
        addpath '../toolbox/sap/'
        addpath '../toolbox/utility/'
        addpath '../toolbox/TSM/'
        addpath '../toolbox/vocalExtraction/'
        fileDir = '../AudioFiles/';
        auFile='Hello.wav';
        
        %setting up agr
        volumn_thresh = 1;
        perform_pitchTrack = 0;
        pitch_track_type = 1; %1 for standart, 2 for pitch smoothed
        useHighPassFilter = 1;
        
        %readAudio
        [y fs] = audioread([fileDir auFile]); 
        
        %extract vocal
        tic;
            background_music = repet_ada(y, fs);
            vocal = y - background_music;
        toc;
        audiowrite('/Users/philiphsieh/Desktop/My1.wav', vocal, fs);
        
        %filter noise
        if useHighPassFilter
            fprintf('\t\t\tPerform high-pass filtering...\n');
            cutOffFreq=200;		% Cutoff frequency
            filterOrder=5;		% Order of filter
            [b, a]=butter(filterOrder, cutOffFreq/(fs/2), 'high');
            voice=filter(b, a, vocal);
        end     
        audiowrite('/Users/philiphsieh/Desktop/My2.wav', vocal, fs);
        
        %volumn threshold
        if volumn_thresh
            tmp = vocal;
            thr = max(vocal) * 0.05
            for i = 1 : length(vocal)
                if abs(vocal(i,1)) < thr(1)
                    vocal(i,1) = vocal(i,1)* 0.3;
                end
                if abs(vocal(i,2)) < thr(2)
                    vocal(i,2) = vocal(i,2) * 0.3;
                end
            end
        end
        audiowrite('/Users/philiphsieh/Desktop/My3.wav', vocal, fs);
        
        
        %sound(voice, fs);
        
        if perform_pitchTrack    
            tic;
            pitch = pitchTrackForcedSmooth(au, ptOpt, 1); 
            %size(pitch)
            toc;
        end
        
        
        
        
        
         
