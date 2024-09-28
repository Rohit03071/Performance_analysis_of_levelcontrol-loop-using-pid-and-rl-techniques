% Define the transfer function of the original system
numerator = 1;
denominator = [1 6 25 25];
original_system = tf(numerator, denominator);

% Calculate the dominant poles
poles = pole(original_system);
dominant_poles = [];
for i = 1:length(poles)
    if real(poles(i)) < 0
        dominant_poles = [dominant_poles poles(i)];
    end
end

% Calculate the dominant time constant (reciprocal of magnitude of dominant pole)
dominant_time_constant = 1 / abs(min(dominant_poles));

% Calculate the static gain (steady-state gain)
steady_state_gain = dcgain(original_system);

% Calculate the time delay using the step response
[y, t] = step(original_system);
[~, index] = max(y);
time_delay = t(index);

% Display the calculated parameters
disp(['Dominant Poles: ', num2str(dominant_poles)]);
disp(['Dominant Time Constant (\tau): ', num2str(dominant_time_constant)]);
disp(['Static Gain (Kp): ', num2str(steady_state_gain)]);
disp(['Time Delay (L): ', num2str(time_delay)]);

% Create the FOPDT transfer function
fopdt_system = tf([steady_state_gain], [dominant_time_constant 1], 'InputDelay', time_delay);

% Display the FOPDT system
disp('FOPDT System:');
disp(fopdt_system);

% Plot the step response of the FOPDT system
figure;
step(fopdt_system);
grid on;
title('Step Response of FOPDT System');

figure('Position', [100, 100, 800, 600]); % Adjust the position and size as needed

% Plot the Nyquist plot for both systems on the same graph
nyquist(original_system, fopdt_system);
grid on;
title('Nyquist Plot of Original and FOPDT Systems');
legend('Original System', 'FOPDT System');
