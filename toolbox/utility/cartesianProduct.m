function out=cartesianProduct(in1, in2, in3, in4)

if nargin<1, selfdemo; return; end

out={};
if nargin==2
	for i=1:length(in1)
		for j=1:length(in2)
			out{end+1}=[in1{i}, in2{j}];
		end
	end
end

if nargin==3
	for i=1:length(in1)
		for j=1:length(in2)
			for k=1:length(in3)
				out{end+1}=[in1{i}, in2{j}, in3{k}];
			end
		end
	end
end

if nargin==4
	for i=1:length(in1)
		for j=1:length(in2)
			for k=1:length(in3)
				for l=1:length(in4)
					out{end+1}=[in1{i}, in2{j}, in3{k}, in4{l}];
				end
			end
		end
	end
end

% ====== Self demo
function selfdemo
in1={'I ', 'We ', 'You '};
in2={'are ', 'am '};
in3={'here.', 'there.'};
fprintf('in1=%s\n', cell2str(in1));
fprintf('in2=%s\n', cell2str(in2));
fprintf('in3=%s\n', cell2str(in3));
out=cartesianProduct(in1, in2, in3);
fprintf('out=cartesianProduct(in1, in2, in3)\n');
fprintf('The content of out:\n');
disp(out);