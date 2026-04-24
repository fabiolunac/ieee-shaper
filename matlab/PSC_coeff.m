clc; clear; close all;

syms s R C

%% Pulse Shaper Circuit

ZC = 1/(s*C);
ZR = R;

serie = @(Z) [1, Z; 0, 1];
shunt = @(Z) [1, 0; 1/Z, 1];

Mpsc = serie(ZC)  * ...   % C1
       shunt(ZR)  * ...   % R1
       serie(ZR)  * ...   % R2
       shunt(ZC)  * ...   % C2
       serie(ZR)  * ...   % R3
       shunt(ZC)  * ...   % C3
       serie(ZR)  * ...   % R4
       shunt(ZC)  * ...   % C4
       serie(ZR)  * ...   % R5
       shunt(ZC);         % C5

Mpsc = simplify(Mpsc);

% Mpsc = [A, B; C, D]
% V2/V1 = 1/A
A = Mpsc(1,1);
H_sym = simplify(1/A);

% Funcao genérica
disp('H(s, R, C) =')
disp(H_sym)

%% Substituindo valores
C_val = 1e-9;
R_val = 5e3;

H_num = subs(H_sym, [R, C], [R_val, C_val]);
H_num = simplify(H_num);

% Converter
[num_sym, den_sym] = numden(H_num);

num_poly = sym2poly(expand(num_sym));
den_poly = sym2poly(expand(den_sym));

% Normalizar
num_poly = num_poly / den_poly(end);
den_poly = den_poly / den_poly(end);

% Hpsc final
Hpsc = tf(num_poly, den_poly);

% Plot resposta ao impulso PSC
t = 0:1e-9:40e-6; 
[ypsc, t] = impulse(Hpsc, t);

figure;
plot(t*1e6, ypsc);
title('Impulse Response - Hpsc')
xlabel('Time (\mus)')
ylabel('Amplitude')
grid on


%% Partial Fractions
[r, p, k] = residue(num_poly, den_poly);

% 5 coeficients, 5 1st order filter
Hs = cell(1,5);

for i = 1:length(r)
    Hs{1,i} = tf([r(i)], [1, -p(i)]); % Create first-order transfer functions
end

%% Final plot comparison
figure;
hold on;
colors = lines(length(r));

for i = 1:length(r)
    % Impulse response (manual kkkk)
    h_i = real(r(i) * exp(p(i) * t));
    plot(t*1e6, h_i, 'Color', colors(i,:), 'LineWidth', 1.5, ...
         'DisplayName', sprintf('Hpsc_%d(s)', i));
end

plot(t*1e6, ypsc, 'k--', 'LineWidth', 2.5, 'DisplayName', 'H_{psc}(s)');

xlabel('Time (\mus)');
ylabel('Amplitude');
title('Impulse Response - PSC Transfer Functions');
legend('Location', 'best');
grid on;
hold off;


%% Save values
save('Hpsc.mat', "Hs");