% Using GNU Octave, version 4.2.1
pkg load signal;
clc;clear;

if (exist('pictures','dir') == 0)
    mkdir 'pictures';
endif

if (exist('pictures/problem_5','dir') == 0)
    mkdir 'pictures/problem_5';
endif

fp_param 	= 0.65; 
fs_param 	= 0.7;
% wp and ws are numbers from 0 to 1, so we have to divide by pi
% Explanation:
% Max Allowed input Freq is Fs/s (Fs : Sampling Frequency)
% This maps to a digital frequency of pi
% so fp would map to pi*fp/(Fs/2) = 2*pi*fp/Fs (fp: pass freq)
% so fs would map to pi*fs/(Fs/2) = 2*pi*fs/Fs (fs: stop freq)
% Note: kaiserord and remezord functions map Fs/2 to 2,
% so fs would be mapped to fs/(Fs/2) = 2*fs/Fs
% This is same as wp/pi

d1 		= 1 - 10^(-1/20);
d1_db 	= 1;
d2 		= 10^(-75/20);
d2_db	= 75;

% To find Order of Filters:
[K_n, K_Wn, K_beta, K_ftype] = kaiserord([fp_param, fs_param], [1, 0], [d1, d2]);
[R_n, R_f0, R_a0, R_w] = remezord([fp_param, fs_param], [1, 0], [d1, d2]);
[E_n,E_Wn] = ellipord(fp_param,fs_param,d1_db,d2_db);

disp('Order of the Kaiser Filter:');
disp(K_n);
disp('Order of the Filter using Parks-McClellan algorithm:');
disp(R_n);
disp('Order of the Filter using elliptical prototype filter:');
disp(E_n);


% Finding the Filters Actually
K_B = fir1(K_n,K_Wn,K_ftype,kaiser(K_n+1,K_beta),'noscale');
R_B = remez(R_n, R_f0, R_a0, R_w);
[E_B,E_A] = ellip(E_n,d1_db,d2_db,E_Wn);

[HK,W] = freqz(K_B);
[HR,W] = freqz(R_B);
[HE,W] = freqz(E_B,E_A);
H(1,:) = HK;
H(2,:) = HR;
H(3,:) = HE;

x_val 	= 	max(W)*[0:1/4:1]';
x_lbl	=	strcat(num2str( round(100*x_val/pi)/100 ) , '\pi');
theta_val 	= max(angle(HK))*linspace(-1,1,7)';
theta_lbl	= strcat(num2str( round(100*theta_val/pi)/100 ) , '\pi');

subplot(2,1,1);
plot(W,20*log10( abs(HK) ),'linewidth',2);
xlabel('\omega (rad)');
ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
title('FIR filter using Kaiser Window');
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));

subplot(2,1,2);
plot(W,angle(HK),'linewidth',1);
xlabel('\omega (rad)');
ylabel('arg[H(e^{j\omega})]');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
set(gca,'YTick',theta_val);
set(gca,'YTickLabel',cellstr(theta_lbl));
print -color -deps pictures/problem_5/FIR_using_kaiser.eps;
close;

subplot(2,1,1);
plot(W,20*log10( abs(HR) ),'linewidth',2);
xlabel('\omega (rad)');
ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
title('FIR filter using Parks-McClellan Algorithm');
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));

subplot(2,1,2);
plot(W,angle(HR),'linewidth',1);
xlabel('\omega (rad)');
ylabel('arg[H(e^{j\omega})]');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
set(gca,'YTick',theta_val);
set(gca,'YTickLabel',cellstr(theta_lbl));
print -color -deps pictures/problem_5/FIR_using_remez.eps;
close;

subplot(2,1,1);
plot(W,20*log10( abs(HE) ),'linewidth',2);
xlabel('\omega (rad)');
ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
title('FIR filter using Elliptical Prototype Filter');
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));

subplot(2,1,2);
plot(W,angle(HE),'linewidth',1);
xlabel('\omega (rad)');
ylabel('arg[H(e^{j\omega})]');
axis tight;
grid on;
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
set(gca,'YTick',theta_val);
set(gca,'YTickLabel',cellstr(theta_lbl));
print -color -deps pictures/problem_5/FIR_using_ellip.eps;
close;

handle = plot(W,20*log10( abs(H) ),'linewidth',2);
xlabel('\omega (rad)');
ylabel('|H(e^{j\omega})|^2 (in dB)');
axis tight;
grid on;
title('Comparision of all three');
legend('Using Kaiser Window','Using Parks-McClellan Algorithm','Using Elliptical Prototype Filter','Location','southwest');
set(handle, {'color'}, {[0 0 0]; [1 0 0]; [0 0 1]});
set(gca,'XTick',x_val);
set(gca,'XTickLabel',cellstr(x_lbl));
print -color -deps pictures/problem_5/FIR_comparision.eps;