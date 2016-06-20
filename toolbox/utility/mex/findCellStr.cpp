#include <mex.h>
#include <wchar.h>
#include <vector>

using namespace std;

#define CELLSTR	prhs[0]
#define STR	prhs[1]
#define METHOD	prhs[2]

#define INDEX	plhs[0]

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] ) {
	bool bBinarySearch=false;
	char message[200];
	
	// check for proper number of arguments
	if(nrhs != 2 && nrhs != 3){
		sprintf(message, "Wrong usage!\nUsage 1: index = %s(cellStr, str)\nUsage 2: index = %s(cellStr, str, method)\n", mexFunctionName(), mexFunctionName());
		strcat(message, "\tmethod = 0 for linear search (default)\n");
		strcat(message, "\tmethod = 1 for binary search (in which the cellStr should be SORTED first)");
		mexErrMsgTxt(message);
	} else if(nlhs > 1)
		mexErrMsgTxt("There should be only one output.");
		
	// input must be a cell
	if(mxIsCell(CELLSTR) != 1)
		mexErrMsgTxt("The first input must be a cell string.");

	// input must be a string
	if (mxIsChar(STR) != 1)
		mexErrMsgTxt("The second input must be a string.");

	// determine searching strategy
	if((nrhs==3) && ((mxGetPr(METHOD))[0]==1))
		bBinarySearch = true;

	// search for the target string
	int intIter;
	int intInputCellSize = mxGetNumberOfElements(CELLSTR);
	int intTargetLen = mxGetNumberOfElements(STR);
	int intSourceLen;
	wchar_t *pwchrTarget = reinterpret_cast<wchar_t *>(mxGetPr(STR));
	wchar_t *pwchrSource;
	mxArray *pmxCell;
	vector<int> vecintHitList;

	if(!bBinarySearch) {	// Sequential search
		for(intIter=0; intIter<intInputCellSize; intIter++) {
			pmxCell = mxGetCell(CELLSTR, intIter);
			intSourceLen = mxGetNumberOfElements(pmxCell);
			pwchrSource = reinterpret_cast<wchar_t *>(mxGetPr(pmxCell));

			if(intSourceLen == intTargetLen && wcsncmp(pwchrSource, pwchrTarget, intTargetLen) == 0)
				vecintHitList.push_back(intIter+1);
		}
	} else {	// Binary search
		int intLowerBound = 0;
		int intUpperBound = intInputCellSize - 1;
		int intSearchPos, intCompareLen, intCompareResult;
		bool bMoreToSearch;
		
		while(intLowerBound<=intUpperBound) {
			intSearchPos = (intLowerBound + intUpperBound) / 2;

			pmxCell = mxGetCell(CELLSTR, intSearchPos);
			intSourceLen = mxGetNumberOfElements(pmxCell);
			pwchrSource = reinterpret_cast<wchar_t *>(mxGetPr(pmxCell));
			
			intCompareLen = (intTargetLen <= intSourceLen) ? intTargetLen : intSourceLen;
			intCompareResult = wcsncmp(pwchrSource, pwchrTarget, intCompareLen);
		
			if(intSourceLen == intTargetLen && intCompareResult == 0) {
				vecintHitList.push_back(intSearchPos+1);
				
				// search left side neighborhood
				bMoreToSearch = true;
				intIter = intSearchPos;
				while(bMoreToSearch) {
					if(--intIter < 0)
						break;
						
					pmxCell = mxGetCell(CELLSTR, intIter);
					intSourceLen = mxGetNumberOfElements(pmxCell);
					pwchrSource = reinterpret_cast<wchar_t *>(mxGetPr(pmxCell));
			
					if(intSourceLen == intTargetLen && wcsncmp(pwchrSource, pwchrTarget, intTargetLen) == 0)
						vecintHitList.push_back(intIter+1);
					else
						bMoreToSearch = false;
				}
				
				// search right side neighborhood
				bMoreToSearch = true;
				intIter = intSearchPos;
				while(bMoreToSearch) {
					if(++intIter > intInputCellSize - 1)
						break;
						
					pmxCell = mxGetCell(CELLSTR, intIter);
					intSourceLen = mxGetNumberOfElements(pmxCell);
					pwchrSource = reinterpret_cast<wchar_t *>(mxGetPr(pmxCell));
			
					if(intSourceLen == intTargetLen && wcsncmp(pwchrSource, pwchrTarget, intTargetLen) == 0)
						vecintHitList.push_back(intIter+1);
					else
						bMoreToSearch = false;
				}
				break;
			} else if(intCompareResult < 0)
				intLowerBound = intSearchPos + 1;
			else if(intCompareResult > 0)
				intUpperBound = intSearchPos - 1;
			else {
				if(intSourceLen < intTargetLen)
					intLowerBound = intSearchPos + 1;
				else
					intUpperBound = intSearchPos - 1;
			}
		}
	}
	
	// generate output array
	int intNumberOfHits = vecintHitList.size();
	INDEX = mxCreateDoubleMatrix(1, intNumberOfHits, mxREAL);
	double *pdblOut = mxGetPr(INDEX);
	int intBinarySearchTurnPoint = intNumberOfHits - 1;
	
	if(!bBinarySearch)
		for(intIter = 0; intIter < intNumberOfHits; intIter++)
			pdblOut[intIter] = vecintHitList[intIter];
	else {
		// since we search the left side and right side neighborhood, we have to sort the output result
		for(intIter = 0; intIter < intNumberOfHits - 1; intIter++)
			if(vecintHitList[intIter+1] > vecintHitList[intIter]) {
				intBinarySearchTurnPoint = intIter;
				break;
			}
	
		for(intIter = intBinarySearchTurnPoint; intIter >= 0; intIter--)
			pdblOut[intBinarySearchTurnPoint - intIter] = vecintHitList[intIter];
		
		for(intIter = intBinarySearchTurnPoint + 1; intIter < intNumberOfHits; intIter++)
			pdblOut[intIter] = vecintHitList[intIter];

	}
}
