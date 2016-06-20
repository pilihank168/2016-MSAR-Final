function semitone=str2semitone(str)

octave2={'C2', '#C2', 'D2', '#D2', 'E2', 'F2', '#F2', 'G2', '#G2', 'A2', '#A2', 'B2'};
octave3={'C3', '#C3', 'D3', '#D3', 'E3', 'F3', '#F3', 'G3', '#G3', 'A3', '#A3', 'B3'};
octave4={'C4', '#C4', 'D4', '#D4', 'E4', 'F4', '#F4', 'G4', '#G4', 'A4', '#A4', 'B4'};
octave5={'C5', '#C5', 'D5', '#D5', 'E5', 'F5', '#F5', 'G5', '#G5', 'A5', '#A5', 'B5'};
octave6={'C6', '#C6', 'D6', '#D6', 'E6', 'F6', '#F6', 'G6', '#G6', 'A6', '#A6', 'B6'};
allStr=[octave2, octave3, octave4, octave5, octave6];
index=find(strcmp(lower(allStr), lower(str)));
if isempty(index)
	sprintf('Warning: Cannot find the given str %s in the table!', str);
	semitone=nan;
	return
end
semitone=index+35;