clc; clear all;
filename = '00000003_adapt2.wav';
[y,Fs] = audioread(filename);
Fs
Fs_new = 16000;
[Numer, Denom] = rat(Fs_new/Fs);
y_new = resample(y, Numer, Denom);
audiowrite('helsinkiikuisesti16kHz.wav', y_new, Fs_new);