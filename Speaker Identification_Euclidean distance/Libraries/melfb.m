function m = melfb(p, n, fs)
%p=20;
% MELFB         Determine matrix for a mel-spaced filterbank
%
% Inputs:       p=20;   number of filters in filterbank
%               n=256;   length of fft
%               fs=12500;  sample rate in Hz
%
% Outputs:      x   a (sparse) matrix containing the filterbank amplitudes
%                   size(x) = [p, 1+floor(n/2)]
%
% Usage:        For example, to compute the mel-scale spectrum of a
%               colum-vector signal s, with length n and sample rate fs:
%
%               f = fft(s);
%               m = melfb(p, n, fs);
%               n2 = 1 + floor(n/2);
%               z = m * abs(f(1:n2)).^2;
%
%               z would contain p samples of the desired mel-scale spectrum
%
%               To plot filterbanks e.g.:
% 
%                 plot(linspace(0, (12500/2), 129), melfb(20, 256, 12500)),
%                title('Mel-spaced filterbank'), xlabel('Frequency (Hz)');
%%%%%%%%%%%%%%%%%%

% Mel freq wrap formula mel(f)=2595*log10(1+f/700)
f0 = 700 / fs;
fn2 = floor(n/2);

lr = log(1 + 0.5/f0) / (p+1);

% convert to fft bin numbers with 0 for DC term
bl = n * (f0 * (exp([0 1 p p+1] * lr) - 1));

b1 = floor(bl(1)) + 1;  %Aproximating Values of b1(1)
b2 = ceil(bl(2));       %Aproximating Values of b1(2)
b3 = floor(bl(3));      %Aproximating Values of b1(3)
b4 = min(fn2, ceil(bl(4))) - 1;%Aproximating Values of b1(4)

pf = log(1 + (b1:b4)/n/f0) / lr; % Log Filter
fp = floor(pf);     % Aproximated Log Filter
pm = pf - fp;       %Filter Banks

r = [fp(b2:b4) 1+fp(1:b3)];    %Log Filter
c = [b2:b4 1:b3] + 1;          %Triangular Filter - linear frequency spacing
v = 2 * [1-pm(b2:b4) pm(1:b3)]; % Filter Banks

m = sparse(r, c, v, p, 1+fn2);
%%ZZZ=full(m); plot row wise and see the filter banks

%--------------------------------------------------------------------------