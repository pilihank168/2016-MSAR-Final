%function photoTimeCheck(photoDir)

photoDir='.';

photoSet=recursiveFileList(photoDir, 'jpg');
targetPhotoSet=recursiveFileList('d:/users/jang2/image/diary', 'jpg');
targetPhotoSize=[targetPhotoSet.bytes];

for i=1:length(photoSet)
	index=find(targetPhotoSize==photoSet(i).bytes);
	photoSet(i).sameSizeIndex=index;
	photoSet(i).sameSizePhotoCount=length(index);
end