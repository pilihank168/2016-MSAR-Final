function pitch = freq2pitch(freq)
% freq2pitch: Frequency (in Hertz) to pitch (in semitones) conversion. [���W�v�]�HHertz�����^�ܭ����]�HSemitone�����^���ഫ]
%	Usage: pitch = freq2pitch(freq)
%		freq: frequency vector
%		pitch: pitch vector
%		(Elements of zero are considered as silence and thus not converted.)	

%	Roger Jang, 20040524

pitch=freq;
index=find(freq~=0);
pitch(index) = 69+12*log2(freq(index)/440);
