% Define the parameters of your system (as you already did)
Kp = 2.0;       % Steady-state gain
tau = 0.5;      % Time constant
td = 0.1;       % Dead time


numerator = [Kp];
denominator = [tau, 1]; 

% Create the transfer function with the dead time
[numerator_delayed, denominator_delayed] = pade(td, 1); 
transfer_function = tf(numerator_delayed, denominator_delayed) * tf(numerator, denominator);

% Manual Kappa-Tau tuning
kappa = 0.6;     % Adjust based on the process characteristics
tau_i_tuned = tau / 2;  % Adjust based on the process characteristics

% Calculate PID gains
Kp_pid = Kp * kappa;
Ki_pid = Kp_pid / tau_i_tuned;
Kd_pid = 0;  % For Kappa-Tau method, derivative action is often not included

% Create the PID controller
controller = pid(Kp_pid, Ki_pid, Kd_pid);

% Connect the PID controller to the transfer function
sys_with_controller = feedback(controller * transfer_function, 1);

% Time vector
t = 0:0.01:10;   % Time span from 0 to 10 seconds

% Step input signal
u = ones(size(t));

% Simulate the system response
[y, ~, x] = lsim(sys_with_controller, u, t);

fprintf('Kp_tuned (steady state gain): %.2f\n', Kp_pid);
fprintf('Ki_tuned (Integral gain): %.2f\n', Ki_pid);
fprintf('kd_tuned (Derivative time): %.2f\n', Kd_pid);
% Plot the step response
figure;
plot(t, y);
xlabel('Time (seconds)');
ylabel('Output');
title('Step Response of the PID-Controlled System (Kappa-Tau Tuning)');
grid on;
