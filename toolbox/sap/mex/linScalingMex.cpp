// Linear scaling
// This version takes a single query pitch and scaled it for comparison, which is less efficient for comparison with multiple songs.
// How to compile:
// mex -I/users/jang/c/lib/audio -I/users/jang/c/lib/utility -I/users/jang/c/lib/wave linScalingMex.cpp d:/users/jang/c/lib/wave/waveRead4pda.cpp d:/users/jang/c/lib/audio/audio.cpp d:/users/jang/c/lib/utility/utility.cpp -output linScalingMex.dll

#include <string.h>
#include <math.h>
#include "mex.h"
#include "audio.hpp"

/* Input Arguments */
#define PITCH			prhs[0]		// �ϥΪ̪���J����
#define STDPITCH		prhs[1]		// �зǵ��ת�����
#define LOWERRATIO		prhs[2]		// �̤p���ת����v�A�Ҧp�쥻��J���ת� 0.4 ��
#define UPPERRATIO		prhs[3]		// �̤j���ת����v�A�Ҧp�쥻��J���ת� 1.6 ��
#define RESOLUTION		prhs[4]		// �����X����
#define DISTANCETYPE		prhs[5]		// 1: L1 norm (shift to median), 2: L2 norm (shift to mean)
#define DISTBOUND		prhs[6]		// Distance bound (for partial computation)
/* Output Arguments */
#define	MINDIST			plhs[0]
#define	NEWPITCH		plhs[1]
#define	ALLDIST			plhs[2]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	/* Default values */
	int resolution = 88;
	double lowerRatio = 0.4;
	double upperRatio = 1.5;
	int distanceType = 1;	// L1 norm
	double distBound=INF;
	
	// Error checking
	if ((nrhs<2)||(nrhs>7)||(nlhs>3)) {
		char message[200];
		strcpy(message, mexFunctionName());
		strcat(message, " requires 2~6 input arguments and 0~3 output arguments.\n");
		strcat(message, "Usage: [minDist, newPitch, allDistance] = ");
		strcat(message, mexFunctionName());
		strcat(message, "(pitch, stdPitch, lowerRatio, upperRatio, resolution, distType, distBound)");
		mexErrMsgTxt(message);
	}
	if (nrhs>=3) lowerRatio = mxGetScalar(LOWERRATIO);
	if (nrhs>=4) upperRatio = mxGetScalar(UPPERRATIO);
	if (nrhs>=5) resolution = (int)mxGetScalar(RESOLUTION);
	if (nrhs>=6) distanceType = (int)mxGetScalar(DISTANCETYPE);
	if (nrhs>=7) distBound=mxGetScalar(DISTBOUND);
	
	double *pitch = mxGetPr(PITCH);
	int pitchLen = mxGetN(PITCH)*mxGetM(PITCH);
	double *stdPitch = mxGetPr(STDPITCH);
	int stdPitchLen = mxGetN(STDPITCH)*mxGetM(STDPITCH);

	double *distVec = new double [resolution];
	double *muVec = new double [resolution];
	double *newPitch = new double[(int)(pitchLen*upperRatio)];		// Resampled pitch with the max. length
	double *tempPitch = new double[(int)(pitchLen*upperRatio)];
	int minIndex;
//printf("Before calling linearScaling...\n");
	double distanceMin=linearScaling(pitch, pitchLen, stdPitch, stdPitchLen, lowerRatio, upperRatio, resolution, distanceType, distVec, muVec, newPitch, tempPitch, minIndex, distBound);
//printf("After calling linearScaling...\n");
//	printf("minIndex=%d\n", minIndex);
//	printf("bestRatio=%f\n", lowerRatio+minIndex*(upperRatio-lowerRatio)/(resolution-1));

	//�}�l�ǳƭn��X�����
	MINDIST = mxCreateDoubleMatrix(1,1, mxREAL);
	mxGetPr(MINDIST)[0] = distanceMin;			//�̤p�Z��

	if (nlhs>1){	// �Y�ݭn�����Υ����᪺ pitch
		int newPitchLen  = (int)(pitchLen*(lowerRatio+minIndex*(upperRatio-lowerRatio)/(resolution-1)));
		NEWPITCH = mxCreateDoubleMatrix(1, newPitchLen, mxREAL);
		double *newPitch=mxGetPr(NEWPITCH);
		vecResample(pitch, pitchLen, newPitch, newPitchLen);	// ���t
		double muBest = muVec[minIndex];
		vecMinus(newPitch, muBest, newPitchLen, newPitch);	// ����
	}

	if (nlhs>2){	// �Y�ݭn all distance
		ALLDIST = mxCreateDoubleMatrix(1, resolution, mxREAL);
		for (int i=0; i<resolution; i++)
			mxGetPr(ALLDIST)[i]=distVec[i];
	}
	delete [] distVec;
	delete [] muVec;
	delete [] newPitch;
	delete [] tempPitch;
}
