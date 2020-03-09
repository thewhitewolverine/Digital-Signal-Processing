% Using GNU Octave, version 4.2.1
pkg load signal;
clc;clear;

if (exist('pictures','dir') == 0)
    mkdir 'pictures';
endif

if (exist('audio','dir') == 0)
    mkdir 'audio';
endif

if (exist('pictures/problem_6','dir') == 0)
    mkdir 'pictures/problem_6';
endif


[audio,Fs] = audioread('audio.wav');

Dw 		= 	500;
w4_1 	= 	2*(4000 - Dw/2)/Fs;
w4_2 	= 	2*(4000 + Dw/2)/Fs;
w4 		= 	2*4000/Fs;
w8_1 	= 	2*(8000 - Dw/2)/Fs;
w8_2 	= 	2*(8000 + Dw/2)/Fs;
w8 		= 	2*8000/Fs;
w12_1 	= 	2*(12000 - Dw/2)/Fs;
w12_2 	=	2*(12000 + Dw/2)/Fs;
w12 	= 	2*12000/Fs;
w16_1	=	2*(16000 - Dw/2)/Fs;
w16_2 	= 	2*(16000 + Dw/2)/Fs;
w16 	= 	2*16000/Fs;

h(1,:) = remez(200, [0, w4_1, w4_2, 1], [1,1,0,0]);
h(2,:) = remez(200, [0, w4_1, w4_2, w8_1, w8_2, 1], [0, 0, 1, 1, 0, 0]);
h(3,:) = remez(200, [0, w8_1, w8_2, w12_1, w12_2, 1], [0, 0, 1, 1, 0, 0]);
h(4,:) = remez(200, [0, w12_1, w12_2, w16_1, w16_2, 1], [0, 0, 1, 1, 0, 0]);

[B1,A1]	=	butter(6,w4);
[B2,A2] =	butter(6,[w4,w8]);
[B3,A3]	=	butter(6,[w8,w12]);
[B4,A4]	=	butter(6,[w12,w16]);


[H(1,:),W] = freqz(h(1,:));
[H(2,:),W] = freqz(h(2,:));
[H(3,:),W] = freqz(h(3,:));
[H(4,:),W] = freqz(h(4,:));

[HB(1,:),WB] = freqz(B1,A1);
[HB(2,:),WB] = freqz(B2,A2);
[HB(3,:),WB] = freqz(B3,A3);
[HB(4,:),WB] = freqz(B4,A4);

x_val 	= 	max(W)*[0, w4, w8, w12, w16, 1]';
x_lbl	=	strcat(num2str( round(100*x_val/pi)/100 ) , '\pi');

Mag = 20*log10(abs(H));
handle = plot(W,Mag,'linewidth',2);
xlabel('\omega (rad)');
ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
legend('Low Pass - 4K cutoff','Band Pass - 4K, 8K cutoff','Band Pass - 8K, 12K cutoff','Band Pass - 12K, 16K cutoff','Location','southwest');
grid on;
set(handle, {'color'}, {[0 0 0]; [1 0 0]; [0 1 0]; [0 0 1]});
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
print -color -deps pictures/problem_6/H1_H2_H3_H4.eps;
close;

% Plot for 6th Order Butterworth Filters
x_val 	= 	max(W)*[0, w4, w8, w12, w16, 1]';
x_lbl	=	strcat(num2str( round(100*x_val/pi)/100 ) , '\pi');

Mag = 20*log10(abs(HB));
handle = plot(WB,Mag,'linewidth',2);
xlabel('\omega (rad)');
ylabel('|HB(e^{j\omega})|^2 (in dB)');
axis tight;
legend('ButterWorth Low Pass - 4K cutoff','ButterWorth Band Pass - 4K, 8K cutoff','ButterWorth Band Pass - 8K, 12K cutoff','ButterWorth Band Pass - 12K, 16K cutoff','Location','southwest');
grid on;
set(handle, {'color'}, {[0 0 0]; [1 0 0]; [0 1 0]; [0 0 1]});
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
print -color -deps pictures/problem_6/Butterworth_H1_H2_H3_H4.eps;
close;
% convolve 2 channels of the audio file with these 4 filters

y1(:,1) = conv(h(1,:)',audio(:,1));
y1(:,2) = conv(h(1,:)',audio(:,2));
wavwrite(y1,Fs,'audio/output_remez1.wav');

y2(:,1) = conv(h(2,:)',audio(:,1));
y2(:,2) = conv(h(2,:)',audio(:,2));
wavwrite(y2, Fs,'audio/output_remez2.wav');

y3(:,1) = conv(h(3,:)',audio(:,1));
y3(:,2) = conv(h(3,:)',audio(:,2));
wavwrite(y3, Fs,'audio/output_remez3.wav');

y4(:,1) = conv(h(4,:)',audio(:,1));
y4(:,2) = conv(h(4,:)',audio(:,2));
wavwrite(y4, Fs,'audio/output_remez4.wav');

y_butter1(:,1) = filter(B1,A1,audio(:,1));
y_butter1(:,2) = filter(B1,A1,audio(:,2));
wavwrite(y_butter1, Fs,'audio/output_butter1.wav');

y_butter2(:,1) = filter(B2,A2,audio(:,1));
y_butter2(:,2) = filter(B2,A2,audio(:,2));
wavwrite(y_butter2, Fs,'audio/output_butter2.wav');

y_butter3(:,1) = filter(B3,A3,audio(:,1));
y_butter3(:,2) = filter(B3,A3,audio(:,2));
wavwrite(y_butter3, Fs,'audio/output_butter3.wav');

y_butter4(:,1) = filter(B4,A4,audio(:,1));
y_butter4(:,2) = filter(B4,A4,audio(:,2));
wavwrite(y_butter4, Fs,'audio/output_butter4.wav');

[AUDIO1,W] 	= freqz(audio(:,1));
[AUDIO2,W] 	= freqz(audio(:,2));
[Y1,W]		= freqz(y1(:,1));
[Y2,W]		= freqz(y2(:,1));
[Y3,W]		= freqz(y3(:,1));
[Y4,W]		= freqz(y4(:,1));
[Y_Butter1,W]	= freqz(y_butter1(:,1));
[Y_Butter2,W]	= freqz(y_butter2(:,1));
[Y_Butter3,W]	= freqz(y_butter3(:,1));
[Y_Butter4,W]	= freqz(y_butter4(:,1));

x_val 	= 	max(W)*(linspace(0,1,5))';
x_lbl	=	strcat(num2str( round(100*x_val/pi)/100 ) , '\pi');

% Input DTFT
subplot(2,1,1);
plot(W,20*log10( abs(AUDIO1) ));title('Channel 1');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
subplot(2,1,2);
plot(W,20*log10( abs(AUDIO2) ));title('Channel 2');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
print -color -deps pictures/problem_6/DTFT_of_input.eps;
close;

% DTFT of Remez Output
subplot(2,2,1);
plot(W,20*log10( abs(Y1) ));title('O/P of 4K LPF');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
subplot(2,2,2);
plot(W,20*log10( abs(Y2) ));title('O/P of 4K-8K BPF');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
subplot(2,2,3);
plot(W,20*log10( abs(Y3) ));title('O/P of 8K-12K BPF');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
subplot(2,2,4);
plot(W,20*log10( abs(Y4) ));title('O/P of 12K-16K BPF');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
print -color -deps pictures/problem_6/DTFT_of_remez_outputs.eps;
close;

% DTFT of Butterworth Output
subplot(2,2,1);
plot(W,20*log10( abs(Y_Butter1) ));title('O/P of 4K LPF(Butterworth)');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
subplot(2,2,2);
plot(W,20*log10( abs(Y_Butter2) ));title('O/P of 4K-8K BPF(Butterworth)');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
subplot(2,2,3);
plot(W,20*log10( abs(Y_Butter3) ));title('O/P of 8K-12K BPF(Butterworth)');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
subplot(2,2,4);
plot(W,20*log10( abs(Y_Butter4) ));title('O/P of 12K-16K BPF(Butterworth)');xlabel('\omega (rad)');ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
print -color -deps pictures/problem_6/DTFT_of_butterworth_outputs.eps;