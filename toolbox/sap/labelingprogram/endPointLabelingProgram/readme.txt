Program for labeling endpoints
Roger Jang, 20050314, 20060304, 20140316

1. Install the following two toolboxes if you haven't done so yet:
	Utility Toolbox: http://mirlab.org/jang/matlab/toolbox/utility.rar
	SAP Toolbox:     http://mirlab.org/jang/matlab/toolbox/sap.rar

2. Modify the main program "goLabel.m" such that the variable "auDir" holds the path to the audio files to be labeled.

3. Type "goLabel" under MATLAB to start labeling endpoints.

4. The program will load each audio file. You can drag the red lines in the first plot to modify the endpoints.
   (Originally the red lines coincide with the magenta and green lines, which are the endpoints identified by the computer.)

5. You can hit ENTER or any key to save the file and move to the next file.

6. The endpoints will be recorded in the file name.
   For instance, 3a.wav will be renamed as 3a_849_31226.wav if the endpoints are 849 and 31226.

7. If you run into any problem, please get in touch with Roger Jang at "jang@mirlab.org".