clear all;
close all;
clc;
[x,fs]=wavread('sound.wav'); %fs=22050Hz
N = 2^12;
fc = 3900;
Ts = 1/fs;  
n  = 0:length(x)-1; 
tn = n*Ts  ;            
x=x(1:end/2);
plot(tn,x);
title('Input signal');xlabel('Time (s)');ylabel('Amplitude');
%spectrum 
X = abs(fft(x,N));
f = [0:N-1]*(fs/N);
X = X(1:end/2);
f = f(1:end/2);
tn = (0:length(x)-1)/fs;
figure('Color',[1 1 1]);
h = plot(f,X); box off;
xlabel('Frequency (Hz)');ylabel('Linear Spectrum');
% Bandpass Pre Filtering will filter out the DC component and filter unwanted siganls out.
B = fir1(200,[0.4 0.6],'bandpass');
xb = filter(B,1,x)';
figure('Color',[1 1 1]);
plot(tn,xb);
title('Filtered Signal');xlabel('Time (s)');ylabel('Amplitude');

X = abs(fft(xb,N));
f = [0:N-1]*(fs/N);
X = X(1:end/2);
f = f(1:end/2);

tn = (0:length(xb)-1)/fs;
figure('Color',[1 1 1]);
h = plot(f,X); box off;
xlabel('Frequency (Hz)');ylabel('Magnitude');title('Filtered Signal Spectrum');

%carrier signal
c  = cos(2*pi*fc*tn);  
A = abs(min(xb))+1;
AM = (A + xb).*c';
%AM spectrum
X = abs(fft(AM,N));
f = [0:N-1]*(fs/N);
X = X(1:end/2);
f = f(1:end/2);
tn = (0:length(AM)-1)/fs;
figure('Color',[1 1 1]);

h = plot(f,X); 
xlabel('Frequency (Hz)');ylabel('Magnitude');
%demodulation
AM2 = AM.*AM;
B = fir1(200,0.5,'low');
xl = filter(B,1,AM2);

figure('Color',[1 1 1]);
subplot(2,1,1);
plot(tn,AM2); box off;
title('AM(t)^2');xlabel('Time (s)');ylabel('Amplitude');
subplot(2,1,2);
plot(tn,xl); box off;
title('lowpass(AM(t)^2)');xlabel('Time (s)');ylabel('Amplitude');

figure('Color',[1 1 1]);
h = plot(tn,xl);box off; hold on;
set(h,'Color', [1 0.5 0.5]);
h = plot(tn,x);
title({'Blue = Orignal Signal'; 'Red = Demodulated Signal';'Square law Demodulator'});xlabel('Time (s)');ylabel('Amplitude');

X1 = abs(fft(xl,N));
f = [0:N-1]*(fs/N);
X1 = X1(1:end/2);
f = f(1:end/2);

X2 = abs(fft(x,N));
X2 = X2(1:end/2);

tn = (0:length(AM)-1)/fs;
figure('Color',[1 1 1]);
h = plot(f,X1); box off; hold on;
set(h,'Color', [1 0.5 0.5]);
h = plot(f,X2);
xlabel('Frequency (Hz)');ylabel('Magnitude');title({'Blue = orignal signal'; 'Red = demodulated signal';'Square law Demodulator'});
xlim([0 12]);