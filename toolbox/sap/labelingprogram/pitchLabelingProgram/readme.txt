This is the pitch labeling program. Please follow the steps to label the pitch.

1. Modify "go.m" to assign the directory of your recordings to the variable "waveDir". 
2. Execute "go" within MATLAB to generate a figure containing the waveform of the first file for pitch labeling.
3. Please maximize the waveform window for easy viewing.
4. You can click on the wrongly identified pitch to show a new figure of ACF and AMDF.
5. You can click on the right pitch point of ACF to correct the pitch in the waveform figure.
6. If there is no pitch at all, you can click outside the axis to make the pitch equal to 0 in the waveform figure.
7. If the volume is small, the pitch will be unstable. Moreover, there is no pitch for unvoiced sounds.
8. If it's hard to identify the pitch point, please make sure your pitch point should generate a continuous curve in the original figure.
9. Computer detected pitch is pitch1, human labeled pitch is pitch2. Before your labeling, pitch2 is equal to pitch1.
10. You can click "Play wave" to play the original recording.
11. You can click "Play pitch" to play the pitch detected by computer.
12. You can click "Play pitch2" to play the pitch labeled by human. The human-labeled pitch contour should be smooth.
13. When you finish labeling a file, press "enter" to save human-labeled pitch and move to the next file.

If you want to label a single file, try "pitchLabel.m".

Pitch labeling requires practice and experiences. If the pitch is not labeled correctly, it will cause problems in performance evaluation for pitch tracking and melody recognition. So make sure you understand what you are doing for every single detail. If you have any questions, please contact with TA as soon as you can.

The following is Chinese translation:

�����H�u�Хܭ������{���A�Ϊk�p�U�C

1. �ק� go.m�A�N waveDir ����A���e�������ɮשҦb���ؿ��C 
2. ���� go�A�Y�i���ͤ@�ӵ����A��Ĥ@�� wave �ɮ׶i��Х� pitch ���u�@�C
3. �бN���������̤j�A�H�K�[��B�I��C
4. �A�i�H���I��j�Ͽ��~�������I�A���ɷ|���ͤp�ϡA��� AMDF �M ACF�C
5. �Y�b�p�Ϫ� ACF �I��̤j�Ȫ���m�]������򥻶g���^�A�j�Ϫ������I�|��ۭץ��C
6. �Y�������s�b�A�Ъ����b�p�Ϫ��϶b�~���I�@�U�A�j�Ϫ������ȴN�|�Q�]�w���s�C
7. ���q�Ӥp�ɡA�q�`�����N�|��í�w�A�άO�ڥ����s�b�C�J��𭵮ɡA�����]�O���s�b�C
8. �Y���e���ݥX�����I�A�аѦҥ��k���ءA�ⴤ�@�ӭ�h�G�������u�����O�s�򥭷ƪ����u�C
9. pitch1 �O�q�����Ѫ����G�Apitch2 �O�H�u�Хܪ����G�A�|���i��H�u�Хܫe�Apitch2 = pitch1�C
10. �A�i�H�I�� Play wave �H�����l�����ɮסC
11. �A�i�H�I�� Play pitch �H����q���۰ʧ�쪺�������u�C
12. �A�i�H�I�� Play pitch2 �H����ץ��᪺�������u�A�����Ӧ��ɭ��C
13. �C���Хܧ��@���q���A���U Enter�A�Y�۰��x�s�̫�H�u�Хܪ� pitch �ɮסA�åi����U�@���C

�Y�n���ճ�@�q���������ХܡA�i�H�������� pitchLabel.m�C

�Хܭ����ݭn�@�Ǹg��M�m�ߡA�Y�Хܤ����T�A�|�y������\�h���դήե������D�A�ҥH�·ЦU��P�ǰȥ��n�p�߶i��C
�]���Y������ðݡA�кɧ֪����M�U�ЩάO�Ѯv�pô�C