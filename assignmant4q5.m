pkg load signal;
clc;clear;

[audio,Fs] =
w8_h 	= 	2*(8000 + rip/2)/Fs;
w8 		= 	2*8000/Fs; audioread('audio_cut.wav');

rip 		= 	200;
w4_l 	= 	2*(4000 - rip/2)/Fs;
w4_h 	= 	2*(4000 + rip/2)/Fs;
w4 		= 	2*4000/Fs;
w8_l 	= 	2*(8000 - rip/2)/Fs;
w12_l 	= 	2*(12000 - rip/2)/Fs;
w12_h 	=	2*(12000 + rip/2)/Fs;
w12 	= 	2*12000/Fs;
w16_l	=	2*(16000 - rip/2)/Fs;
w16_h 	= 	2*(16000 + rip/2)/Fs;
w16 	= 	2*16000/Fs;

[b1,a1]	=	butter(6,w4);
[b2,a2] =	butter(6,[w4,w8]);
[b3,a3]	=	butter(6,[w8,w12]);
[b4,a4]	=	butter(6,[w12,w16]);

rfil(1,:) = remez(200, [0, w4_l, w4_h, 1], [1,1,0,0]);
rfil(2,:) = remez(200, [0, w4_l, w4_h, w8_l, w8_h, 1], [0, 0, 1, 1, 0, 0]);
rfil(3,:) = remez(200, [0, w8_l, w8_h, w12_l, w12_h, 1], [0, 0, 1, 1, 0, 0]);
rfil(4,:) = remez(200, [0, w12_l, w12_h, w16_l, w16_h, 1], [0, 0, 1, 1, 0, 0]);


y1(:,1) = conv(rfil(1,:)',audio(:,1));
y1(:,2) = conv(rfil(1,:)',audio(:,2));


y2(:,1) = conv(rfil(2,:)',audio(:,1));
y2(:,2) = conv(rfil(2,:)',audio(:,2));

y3(:,1) = conv(rfil(3,:)',audio(:,1));
y3(:,2) = conv(rfil(3,:)',audio(:,2));

y4(:,1) = conv(rfil(4,:)',audio(:,1));
y4(:,2) = conv(rfil(4,:)',audio(:,2));

ybut1(:,1) = filter(b1,a1,audio(:,1));
ybut1(:,2) = filter(b1,a1,audio(:,2));

ybut2(:,1) = filter(b2,a2,audio(:,1));
ybut2(:,2) = filter(b2,a2,audio(:,2));

ybut3(:,1) = filter(b3,a3,audio(:,1));
ybut3(:,2) = filter(b3,a3,audio(:,2));

ybut4(:,1) = filter(b4,a4,audio(:,1));
ybut4(:,2) = filter(b4,a4,audio(:,2));
