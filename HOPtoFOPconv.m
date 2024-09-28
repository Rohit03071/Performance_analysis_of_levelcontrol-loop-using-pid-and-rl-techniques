% Define the coefficients of the original higher-order transfer function
numerator = 1;  % You can adjust this as needed
denominator = [1 6 25 25];  % Example coefficients

% Define the point around which you want to perform the Taylor series expansion
s0 = -1;  % Choose a point near the dominant poles

% Perform the Taylor series expansion manually and extract coefficients
num_taylor = numerator;
den_taylor = denominator;

% Initialize variables for coefficients
Kp = num_taylor(1);
tau = 0;  % Initialize tau as zero
L = 0;    % Assuming no delay in the FOPDT model

% Extract coefficients using Taylor series expansion
for i = 1:length(denominator)
    term_coeff = num_taylor(i) / factorial(i-1);
    if i == 1
        Kp = term_coeff;
    elseif i == 2
        tau = -1 / term_coeff;
    elseif i == 3
        L = -term_coeff / (tau * tau);
    end
end

% Create the FOPDT transfer function
fopdt_system = tf([Kp], [tau 1], 'InputDelay', L);

% Display the FOPDT system
disp('FOPDT System (Taylor Series Approximation):');
disp(fopdt_system);

% Plot the step response of the FOPDT system
figure;
step(fopdt_system);
grid on;
title('Step Response of FOPDT System (Taylor Series Approximation)');
