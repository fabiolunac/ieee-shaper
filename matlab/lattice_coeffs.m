clc; clear; close all;

G = 2^15;

% Loading coeffs
Hz = load("Hz.mat", "Hz").Hz;

for i=1:length(Hz)
    b = Hz{i,1}.Numerator{1};
    a = Hz{i,1}.Denominator{1};

    [k{i}, v{i}] = tf2latc(b, a);

    k_quant{i} = round(k{i}*G);
    v_quant{i} = round(v{i}*G);
end



