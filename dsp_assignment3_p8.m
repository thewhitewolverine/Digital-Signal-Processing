% Using GNU Octave, version 4.2.1

clc;clear;close all;

if (exist('pictures','dir') == 0)
    mkdir 'pictures';
end

[audio,Fs] = audioread('rhino.wav');
plot(audio,'b','linewidth',2);grid on;
axis('tight');
xlabel('smaples');
ylabel('Amplitude');
title('rhino.wav audio signal plot');
print -color -djpeg pictures/rhino_audio.jpeg

disp('Sampling Frequency is: ');
disp(Fs);

% rhino.wav Sound
%soundsc(audio,Fs);

% This audio is a 90462x2 sized matrix; Reppresenting two channels.
ch1 = audio(:,1);
[H,W] = freqz(ch1);
f = W*Fs/(2*pi);

audio = audio + 0.01*randn(90462,2);
% rhino.wav Sound when Gaussian Noise is added
%soundsc(audio,Fs);

ch1_n = audio(:,1);
[H2,W] = freqz(ch1_n);

figure();
plot(f,20*log10(H),'-b;rhino.wav (ch1);','linewidth',2,f,20*log10(H2),'-r;rhino.wav (ch1) + noise;','linewidth',2);
grid on;
axis('tight');
print -color -deps pictures/freq_rhino_audio.eps

[B,A] = butter(6,1000*2/44100);
figure();
freqz(B,A);
title('6th Order Lowpass Butterworth Filter with cutoff 1kHz');
print -color -deps pictures/butter6_lpf.eps

% Filtering each channel of Noise curropted signals
audio2(:,1) = filter(B,A,audio(:,1));
audio2(:,2) = filter(B,A,audio(:,2));

% Filtered Sound Output
%soundsc(audio2,Fs);