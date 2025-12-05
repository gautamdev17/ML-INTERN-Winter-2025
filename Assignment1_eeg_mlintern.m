%{
Part 1: Generate a Simple Sine Wave
Create a sine wave signal:

Duration: 5 seconds

Sampling Rate: 5 Hz

Frequency: 5 Hz

Plot the signal in the time domain.

Perform frequency analysis using the Fourier Transform (e.g., np.fft.fft in Python or fft in MATLAB).

Plot the magnitude spectrum and interpret the dominant frequency.
%}

fs = 5; ts=1/fs; T = 5; t = 0:ts:T; % ts is sampling time and t is a vector with all sample times, T is duration of signal
f = 5; %freq of signal
signal1 = sin(2*pi*f*t); %creating the sin wave

%plotting the signal
figure; stem(t,signal1); title("5hz sin wave sampled at 5hz"); xlabel("time(s)"); ylabel("amplitude"); ylim([-1.5 1.5]); xlim([0 T]);

% fft for fs=5
N1 = length(signal1); % to get number of samples
f_axis1 = (0:N1-1)*(fs/N1); % apply formula fk = (k/N)*fs, to get the frequency axis. i gotta plot X[k] vs fk not X[k] vs k
% fft bin indezx is converted to frequency in hz
figure; stem(f_axis1, abs(fft(signal1))); % take mag of signal, root realpart^2 + impart^2
title("fourier transform of 5 hz sin sampled at 5hz");
ylim([0 1]); xlim([0 fs/2]); % fft starts to mirror after fs/2



%{
Part 2: Generate Higher Frequency Sine Waves
Repeat the above steps for the following:

Frequency: 10 Hz

Frequency: 20 Hz

Note: You may increase the sampling rate (e.g., to 100 Hz) for these signals to meet the Nyquist criterion and avoid aliasing.
%}

fs = 100; ts = 1/fs; T = 5; t = 0:ts:T;
f = 10;
signal2 = sin(2*pi*f*t);
N = length(signal2);
f_axis = (0:N-1)*(fs/N);   %to convert k axis to f axis
figure; stem(t,signal2); title("10hz sin wave sampled at 100hz"); xlabel("time(s)"); ylabel("amplitude"); ylim([-1.5 1.5]); xlim([0 T]);
figure; stem(f_axis, abs(fft(signal2))); title("fourier transform of 10 hz sin sampled at 100hz"); ylim([0 300]); xlim([0 fs/2]);

f = 20;
signal3 = sin(2*pi*f*t);
N = length(signal3);
f_axis = (0:N-1)*(fs/N);

figure; stem(t,signal3); title("20hz sin wave sampled at 100hz"); xlabel("time(s)"); ylabel("amplitude"); ylim([-1.5 1.5]); xlim([0 T]);
figure; stem(f_axis, abs(fft(signal3))); title("fourier transform of 20 hz sin sampled at 100hz"); ylim([0 300]); xlim([0 fs/2]);



%{
Part 3: Combine Signals
Combine the three sine waves (5 Hz, 10 Hz, 20 Hz) into a single composite signal.

Plot the time-domain representation of the combined signal.

Perform Fourier Transform and plot the frequency spectrum.

Identify the presence of all three frequency components in the frequency domain.
%}
%takin all 3singals
signal5  = sin(2*pi*5*t);  
signal10 = sin(2*pi*10*t);   
signal20 = sin(2*pi*20*t);   

signal4 = signal5 + signal10 + signal20; %combination
%same process
N = length(signal4);
f_axis = (0:N-1)*(fs/N); 
figure; stem(t,signal4); 
title("composite signal sampled at 100hz"); 
xlabel("time(s)"); ylabel("amplitude"); 
ylim([-3.5 3.5]); xlim([0 T]);%since sum of 3 waves amplutide upto 3, i took 3.5 for tolerance
figure; stem(f_axis, abs(fft(signal4))); 
title("fourier transform of composite signal sampled at 100hz"); 
ylim([0 300]); xlim([0 fs/2]);



%{
Part 4: Add Noise
Add random noise (e.g., Gaussian noise using np.random.normal) to the combined signal.

Plot the noisy signal in the time domain.

Perform Fourier Transform and plot the frequency spectrum.

Discuss how noise affects the frequency representation.
%}


noise= 0.5; % noise level, larger more noise, smaller less npoise. it will be the std deviation  of the gaussian noise added
% ex: noise_std = 0.5 ,the noise values will mostly lie in [-1.5, +1.5] (3*sigma range)


%doubt: why dont just add random element to signal? -- > in real physical
%systems,it seems ,noise is gaussian, not uniform, not random integers,
%refer central limit theorem


signal_with_noise = signal4 + noise*randn(size(signal4));
figure; stem(t,signal_with_noise); title("noisy composite signal"); xlabel("time(s)"); ylabel("amplitude"); xlim([0 T]);
N = length(signal_with_noise);
f_axis = (0:N-1)*(fs/N);
figure; stem(f_axis, abs(fft(signal_with_noise))); 
title("fourier transform of noisy composite signal"); 
xlabel("frequency(hz)"); ylabel("magnitude"); % couldnt determine y cuz of noise, so no limits set
xlim([0 fs/2]);


%doubt: but we dont know the amplitude of the incoming signal right our
%noise might be very weak or strong to it? answer: we use SNR (Signal-To-Noise Ratio).



%{
Part 5: Filtering
Apply a bandpass filter (e.g., 0.5–30 Hz) to the noisy signal and analyze the result.

Compare the spectrum of the raw noisy signal and the filtered signal.
%}

filtered = bandpass(signal_with_noise, [0.5 30], fs); %using matlab inbuilt bandpass filter

figure; plot(t,filtered); 
title("filtered composite signal (0.5–30hz)"); 
xlabel("time(s)"); ylabel("amplitude"); xlim([0 T]);

% using butterworth and filtfilt instead of bandpass:
% bandpass() caused phase distortion and ringing.
% butter() gives a smooth (flat) passband, and filtfilt() removes phase shift
% by filtering forward and backward , cleaner time + frequency output.
[b,a] = butter(4, [0.5 30]/(fs/2));
filtered2 = filtfilt(b,a, signal_with_noise);

N2 = length(filtered2);
f_axis2 = (0:N2-1)*(fs/N2);
figure; stem(f_axis2, abs(fft(filtered2)));
title("filtered composite signal fourier transform (0.5-30hz)");
ylabel("magnitude");
xlabel("freq(hz)");
ylim([0 300]);
xlim([0 fs/2]);