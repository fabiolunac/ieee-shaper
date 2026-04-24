clc; clear; close all;

s = tf('s');

%% Parameters

Rf = 10e3;
Cf = 51e-12;
Cd = 1e-12;

tauD = 5e-9;
tauR = 1e-9;
I0 = 1;

%% CSP
% Current initial
Is = I0*tauD/(tauD*s + 1) + I0*tauR/(tauR*s + 1);

% CSP stage
H = -(Rf*Cd*s) / (Rf*Cf*s + 1);

Hcsp = H*Is;
[num, den] = tfdata(Hcsp, 'v');

%% Partial Fractions
[r, p, k] = residue(num, den);

Hs = cell(1,3);

for i = 1:length(r)
    Hs{1,i} = tf([r(i)], [1, -p(i)]); % Create first-order transfer functions
end


%% Plot
% Plot resposta ao impulso PSC
t = 0:1e-9:40e-6; 
[ycsp, t] = impulse(Hcsp, t);

figure;
plot(t*1e6, ycsp);
title('Impulse Response - Hcsp')
xlabel('Time (\mus)')
ylabel('Amplitude')
grid on