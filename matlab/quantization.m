clc; clear; close all;

% File to do the coefficientes quantization
G = 2^15;

Hz = load('Hz.mat', 'Hz').Hz;

Hz_quant = cell(length(Hz), 1);

for i=1:length(Hz)
    Zn = Hz{i,1}.Numerator{1};
    Zd = Hz{i,1}.Denominator{1};

    Zn_q = round(Zn*G);
    Zd_q = round(Zd*G);

    Hz_quant{i,1}.Numerator = Zn_q;
    Hz_quant{i,1}.Denominator = Zd_q;

    % fprintf('i=%d  Zn = [%s],  Zd = [%s]\n', i, num2str(Zn_q), num2str(Zd_q));
end

save('Hz_quant.mat', "Hz_quant");
