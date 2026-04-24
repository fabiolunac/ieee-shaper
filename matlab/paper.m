clc
clear
close all

%% Parameters
fs = 40e6;
Ts = 1/fs;

%% Coefficients

% CSP coeffs
n_csp1 = -7.4e-3;
d_csp1 = [1 2e8];

n_csp2 = 8.8e-2;
d_csp2 = [1 2e7];

n_csp3 = -1.4e-2;
d_csp3 = [1 1e9];

csp1 = tf(n_csp1,d_csp1);
csp2 = tf(n_csp2,d_csp2);
csp3 = tf(n_csp3,d_csp3);

Hcsp = csp1+csp2+csp3;

% PSC coeffs
n_shp1 = [3e7];
d_shp1 = [1 2.4e7];

n_shp2 = [-2e7];
d_shp2 = [1 7.1e8];

n_shp3 = [-6.7e7];
d_shp3 = [1 2e8];

n_shp4 = [5.6e7];
d_shp4 = [1 4.7e8];

n_shp5 = [-2e3];
d_shp5 = [1 2e3];

shp1 = tf(n_shp1,d_shp1);
shp2 = tf(n_shp2,d_shp2);
shp3 = tf(n_shp3,d_shp3);
shp4 = tf(n_shp4,d_shp4);
shp5 = tf(n_shp5,d_shp5);

Hpsc = shp1 + shp2 + shp3 + shp4 + shp5;

% Final shaper
Hs = Hpsc * Hcsp;

t = 0:1e-10:500e-9; 
[ys, ~] = impulse(Hs, t);

figure;
impulseplot(Hs);
title('Final Impulse Shaper')
grid on;

%% Digitalization

[num, den] = tfdata(Hs, 'v');

[num_d, den_d] = impinvar(num, den, fs);
Hz = tf(num_d, den_d, Ts);

[yz, tz] = impz(num_d, den_d);
td_ns = tz*Ts*1e9;

% Normalizing values
ys_norm = ys/max(ys);
yz_norm = yz*Ts/max(yz*Ts);

% Plot
figure;
plot(t*1e9, ys_norm, 'k-', 'LineWidth', 2);
hold on;

stem_color = [0.75 0.10 0.10];
h_disc = stem(td_ns, yz_norm, ...
    'Color',         stem_color, ...
    'LineWidth',     1.5, ...
    'MarkerSize',    6, ...
    'MarkerFaceColor', stem_color, ...
    'BaseValue',     0);

xlabel('Time (ns)');
ylabel('Amplitude (normalised)');
xlim([0 350]);
ylim([0 1]);
legend('$H(s)$ – continuous', '$H(z)$ – discrete', ...
    'Interpreter', 'latex');
grid on;

set(gca, 'FontName', 'Times New Roman', 'FontSize', 16, ...
         'TickDir', 'in', 'Box', 'on', ...
         'XMinorTick', 'on', 'YMinorTick', 'on');


%% Pade aproximation

[ys_max, idx_max] = max(ys);
ts_max = t(idx_max); % tempo em que ocorre o pico

% Colocar o pico em 75ns
t_alvo = 75e-9;
tau = t_alvo - ts_max;

% TF de padé
[num_pade, den_pade] = pade(tau, 2);
H_pade = tf(num_pade, den_pade);

% TF deslocada
H_shifted = Hs*H_pade;
[y_shifted, ~] = impulse(H_shifted, t);
[num_sh, den_sh] = tfdata(H_shifted, 'v');

% Digitaliza
[num_dig, den_dig] = impinvar(num_sh, den_sh, fs);

% Normalização
num_dig = num_dig * (fs/ys_max);
[y_dig, t_dig] = impz(num_dig, den_dig);
t_dig_ns = t_dig*Ts*1e9;

offset_ns = t_alvo*1e9 - 50;

% Normalização da amplitude
y_shifted_norm = y_shifted/max(y_shifted);
y_dig_norm = y_dig/max(y_dig);

% Plot
figure;
plot(t*1e9 - offset_ns, y_shifted_norm, 'k-', 'LineWidth', 2);
hold on;

stem_color = [0.75 0.10 0.10];
stem(t_dig_ns - offset_ns, y_dig_norm, ...
    'Color',           stem_color, ...
    'LineWidth',       1.5, ...
    'MarkerSize',      6, ...
    'MarkerFaceColor', stem_color, ...
    'BaseValue',       0);

xlabel('Time (ns)');
ylabel('Amplitude (normalised)');
xlim([0 350]);
legend('$H(s)$ – continuous', '$H(z)$ – discrete', ...
    'Interpreter', 'latex');
grid on;

set(gca, 'FontName', 'Times New Roman', 'FontSize', 16, ...
         'TickDir', 'in', 'Box', 'on', ...
         'XMinorTick', 'on', 'YMinorTick', 'on');

%% Partial Fractions
[r, p, k] = residuez(num_dig, den_dig);

pairs = [4,5];
Hz = cell(9,1);

% Agrupando termos independentes
for i=1:3
    Hz{i,1} = tf(real(r(i)),  [1, -real(p(i))], Ts);
end

for i=6:10
    Hz{i-1,1} = tf(real(r(i)),  [1, -real(p(i))], Ts);
end

% Agrupando complexos (4 e 5)
ri = r(4);
pi = p(4);

b0 = 2*real(ri);
b1 = -2*(real(ri)*real(pi) + imag(ri)*imag(pi));

a1 = -2*real(pi);
a2 = abs(pi)^2;

Hz{4,1} = tf([b0, b1], [1, a1, a2], Ts);


save('Hz.mat', "Hz");






