
function r = mfcc(s, fs)
% MFCC
%
% Inputs: s  contains the signal to analize
%         fs is the sampling rate of the signal
%
% Output: r contains the transformed signal

% MFCC Flow
%---Frame Blocks-->Windowing--->FFT-->Mel Freq wrap--->Cepstrum.
% s=wavread('s1.wav');

m = 100;
n = 256;
l = length(s);
%---Frame Blocking
nbFrame = floor((l - n) / m) + 1;

for i = 1:n              % 1 to 256 %
    for j = 1:nbFrame    % i to 100 %
        M(i, j) = s(((j - 1) * m) + i);   % Arranging samples row wise 1,101,201,301
    end
end
%-->Windowing
h = hamming(n);  % creats a hamming window coefficient of size 'n*1'

M2 = diag(h) * M; % Window multiplied along diagonal.
                  %check for window muliplied coloumwise in M2
%--->FFT ---Mel freq wrap done in Freq domain.
for i = 1:nbFrame 
    frame(:,i) = fft(M2(:, i));  % FFT for sequence Coloum wise 
end
% fs=22050;
t = n / 2;
tmax = l / fs;
% ----->Mel Freq wrap
m = melfb(13, n, fs);  %passing filter balnks , n,sampling frequency
% figure,plot(m);
n2 = 1 + floor(n / 2);
z = m * abs(frame(1:n2, :)).^2;
% --->Cepstrum.
r = dct(log(z));%back to time domain by discrete cosine transform.

%--------------------------------------------------------------------------
