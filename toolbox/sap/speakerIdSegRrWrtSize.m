function [segmentRr, speakerSet]=speakerIdSegRrWrtSize(speakerSet, gmm, maxSegmentSize, plotOpt)
% speakerIdSegRrWrtSize: Segment recognition rate w.r.t. segment size for speaker identification
%	Usage: [segmentRr, speakerSet]=speakerIdSegRrWrtSize(speakerSet, gmm, maxSegmentSize, plotOpt)
%			speakerSet: Data structure for speaker data
%			gmm: GMM parameters
%			maxSegmentSize: maximum segment size
%			plotOpt: 1 for plotting
%			segmentRr: a vector of segment recognition rates
%			speakerSet: the output data structure for speaker data
%				speakerSet(i).sentence(j).segment(k).correct: "correct" vector of all segments of length k within sentence j of speaker i

%	Roger Jang, 20070517

if nargin<3, maxSegmentSize=100; end
if nargin<4, plotOpt=0; end

[overallRecogRate, confusionMatrix, speakerSet]=speakerIdentify(speakerSet, gmm);		% To get logProb within speakerSet(i).sentence(j)

maxSegmentSize=100;
speakerNum=length(speakerSet);
h=waitbar(0, 'Please wait...');
for i=1:speakerNum
%	fprintf('i=%d/%d\n', i, speakerNum);
	for j=1:length(speakerSet(i).sentence)
%		fprintf('\tj=%d/%d\n', j, length(speakerSet(i).sentence));
		logProb=speakerSet(i).sentence(j).logProb;
		frameNum=size(logProb, 2);
		speakerSet(i).sentence(j).segment=[];
		for k=1:maxSegmentSize
			segmentNum=frameNum-k+1;
			segmentLogProb=zeros(speakerNum, segmentNum);
			for p=1:speakerNum
				segmentLogProb(p, :)=sum(buffer2(logProb(p,:), k, k-1), 1);
			end
			predicted=zeros(1, segmentNum);
			for q=1:segmentNum
				[maxProb, predicted(q)]=max(segmentLogProb(:,q));
			end
			speakerSet(i).sentence(j).segment(k).predicted=predicted;
			speakerSet(i).sentence(j).segment(k).correct=(predicted==i);
		end
	end
	waitbar(i/speakerNum, h);
end
close(h);

segmentRr=zeros(maxSegmentSize, 1);
for k=1:maxSegmentSize
	correct=[];
	for i=1:speakerNum
		for j=1:length(speakerSet(i).sentence)
			correct=[correct, speakerSet(i).sentence(j).segment(k).correct];
		end
	end
	segmentRr(k)=sum(correct)/length(correct);
end

if plotOpt
	plot(segmentRr*100, '.-');
	xlabel('Segment length');
	ylabel('Recognition rate (%)');
end