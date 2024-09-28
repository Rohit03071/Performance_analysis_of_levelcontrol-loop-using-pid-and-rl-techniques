% Define the parameters of your system (as you already did)
Kp = 2.0;       % Steady-state gain
tau = 0.5;      % Time constant
td = 0.1;       % Dead time

% Create the transfer function with the dead time
[numerator_delayed, denominator_delayed] = pade(td, 1); 
transfer_function = tf(numerator_delayed, denominator_delayed) * tf(numerator, denominator);

% Calculate the ultimate gain and ultimate period
% (You can adjust the input signal for your specific system)
u = ones(1, 100);  % Input signal (e.g., a step input)
[y, t] = lsim(transfer_function, u);
[y_max, idx] = max(y);
Tu = t(idx) * 4;  % Ultimate period is approximately 4 times the time to peak

% Manual Cohen-Coon tuning
Kp_tuned = (1.35 / Kp) * (Tu / tau);
Ki_tuned = (0.34 / Kp) / (Tu / tau);
Kd_tuned = (0.95 / Kp) * (Tu / tau);

% Create the PID controller
controller = pid(Kp_tuned, Ki_tuned, Kd_tuned);

% Connect the PID controller to the transfer function
sys_with_controller = feedback(controller * transfer_function, 1);

% Time vector
t = 0:0.01:10;   % Time span from 0 to 10 seconds

% Step input signal
u = ones(size(t));

% Simulate the system response
[y, ~, x] = lsim(sys_with_controller, u, t);

% Plot the step response
figure;
plot(t, y);
xlabel('Time (seconds)');
ylabel('Output');
title('Step Response of the PID-Controlled System (Cohen-Coon Tuning)');
grid on;
