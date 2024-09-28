Kp = 0.0057;       % Steady-state gain
tau = 16.7028;      % Time constant
td = 9.4132;       % Dead time

% Create the transfer function with the dead time
[numerator_delayed, denominator_delayed] = pade(td, 1); 
transfer_function = tf(numerator_delayed, denominator_delayed) * tf(numerator, denominator);

% Calculate the ultimate gain and ultimate period
u = ones(size(t));  % Input signal (e.g., a step input)

% Time vector
t = 0:0.01:10;   % Time span from 0 to 10 seconds

[y, ~, x] = lsim(transfer_function, u', t');  % Transpose u and t for proper dimensions

% Calculate the ultimate period (Tu) and ultimate gain (Ku)
[y_max, idx] = max(y);
Tu = t(idx) * 4;

% Manual Cohen-Coon tuning
Kp_tuned = (1.35 / Kp) * (Tu / tau);
Ki_tuned = (0.34 / Kp) / (Tu / tau);
Kd_tuned = (0.95 / Kp) * (Tu / tau);

% Create the PID controller
controller = pid(Kp_tuned, Ki_tuned, Kd_tuned);

% Connect the PID controller to the transfer function
sys_with_controller = feedback(controller * transfer_function, 1);

% Simulate the system response with the correct input format
[y, ~, x] = lsim(sys_with_controller, u', t');  % Transpose u and t for proper dimensions

% Plot the step response
figure;
plot(t, y);
xlabel('Time (second');
ylabel('Output');
title('Step Response of the PID-Controlled System (Cohen-Coon Tuning)');

grid on;


