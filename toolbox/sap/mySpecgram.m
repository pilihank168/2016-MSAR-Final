function [y,ff,tt] = specgram(x,n,sr,w,ov,mode,padding)

if (size(x,1) > size(x,2))
  x = x';
end
if (size(x,1)~=1)
    x = x(1,:);
end
% �Y�ӷ����T�x�}�A�C���ƶq�j��檺�ƶq�h��m

s = length(x);

if nargin < 2
  n = 256;
end
% �Y��J���禡���޼Ƽƶq�p��2(�Y�u��x)�A�h�]�w n=256
if nargin < 3
  sr = 1;
end
% �Y��J���禡���޼Ƽƶq�p��3(�Y�u��x�Pn)�A�h�]�w sr=1
if nargin < 4
  w = n; % window ���j�p
end
% �Y��J���禡���޼Ƽƶq�p��4(�Y�u��x�Pn�Psr)�A�h�]�w w=n
if nargin < 5
  ov = w/2; % overlap���j�p
end
% �Y��J���禡���޼Ƽƶq�p��5�A�h�]�w ov=w/2

h = w - ov;

halflen = w/2; % window ���@�b����
halff = n/2;   % window �����I
acthalflen = min(halff, halflen);

halfwin = 0.5 * ( 1 + cos( pi * (0:halflen)/halflen)); % ��cos��ƫإX�@�b��window
win = zeros(1, n);
% �Τ@�b��window�إX���㪺window
win((halff+1):(halff+acthalflen)) = halfwin(1:acthalflen);
win((halff+1):-1:(halff-acthalflen+2)) = halfwin(1:acthalflen);

switch mode
    case 0
        %[d ff tt] = spectrogram(x,win,ov,w,sr);
        % �w���t�m��X�}�C���j�p

        ncols = 1+fix((s-n)/h);
        d = zeros((1+n/2), ncols);

        c = 1;

        for b = 0:h:(s-n)
          u = win.*x((b+1):(b+n)); % ���J���T�Cn��sample���Wwindow
          t = fft(u); % ��FFT
          d(:,c) = t(1:(1+n/2))';
          c = c+1;
        end;

        if (padding)
            tt = [0:h:(s-n)]/sr;
        else
            tt = [n/2:h:(s-n/2)]/sr;
        end
        ff = [0:(n/2)]*sr/n;

    case 1
        %[d ff tt] = spectrogram(x,win,ov,60*w,sr);

        ncols = 1+fix((s-n)/h);
        % Change to be 4k by Frank 2011/5/2
        fb = 32*8/(sr/n);
        %fb = 32*4/(sr/n);
        d = zeros(fb, ncols);

        c = 1;

        for b = 0:h:(s-n)
          u = win.*x((b+1):(b+n)); % ���J���T�Cn��sample���Wwindow
          t = fpft(u,32*n,fb); % Partial FFT : It is even faster if the signal is sparse.
          d(:,c) = t';
          c = c+1;
        end;

        if (padding)
            tt = [0:h:(s-n)]/sr;
        else
            tt = [n/2:h:(s-n/2)]/sr;
        end
        ff = [0:fb-1]*sr/(32*n);

end


if nargout < 1
  imagesc(tt,ff,20*log10(abs(d)));
  axis xy
  xlabel('Time / s');
  ylabel('Frequency / Hz');
else
%if nargout < 1
%   figure;
%   subplot(311);
%   db=20*log10(abs(d));
%   imagesc(tt,ff*1000,db); axis normal;
%   colorbar;
%   axis xy
%   xlabel('Time / s');
%   ylabel('Frequency / Hz');
%   cmap=colormap;
%else
  y = d;
end
