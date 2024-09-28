
td = 0.1;
numerator = 1;
denominator = conv([1 1 1], conv([1 2], [1 2]));  % Convolution of the polynomial factors

[numerator_delayed, denominator_delayed] = pade(td, 1); 
transfer_function = tf(numerator_delayed, denominator_delayed) * tf(numerator, denominator);
% Convert the transfer function to a symbolic expression
disp('Transfer Function:');
sys = tf(numerator, denominator);
disp(sys);


% Create the Nyquist plot
h = nyquistplot(sys);
nyquist(sys, 'r');

xlabel('Real');
ylabel('Imaginary');
title('Nyquist Plot');


