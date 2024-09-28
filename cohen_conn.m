% Define the parameters of your system (as you already did)
Kp = 0.0057;       % Steady-state gain
tau = 16.7028;      % Time constant
td = 9.4132;       % Dead time

numerator = [Kp];                  % For a first-order system
denominator = [tau, 1];            % For a first-order system
% Create the transfer function with the dead time
[numerator_delayed, denominator_delayed] = pade(td, 1); 
transfer_function = tf(numerator_delayed, denominator_delayed) * tf(numerator, denominator);

Kp_pid = 1.35/Kp * ((tau/(td) + 0.185));
Ti_tuned = (td * 2.5)* ((tau+ 0.185 * td)/(tau + 0.611 * td));
Td_tuned = td * 0.37 * (tau / (tau + 0.185 * td));


% Calculate PID gains
Kp_tuned = Kp_pid;
Ki_pid = Kp_pid / Ti_tuned;
Kd_pid = Kp_pid * Td_tuned;

fprintf('Kp_tuned (steady state gain): %.2f\n', Kp_tuned);
fprintf('Ki_tuned (Integral gain): %.2f\n', Ki_pid);
fprintf('kd_tuned (Derivative time): %.2f\n', Kd_pid);

% Create the PID controller
controller = pid(Kp_pid, Ki_pid, Kd_pid);

% Connect the PID controller to the transfer function
sys_with_controller = feedback(controller * transfer_function, 1);

% Time vector
t = 0:0.01:100;   % Time span from 0 to 10 seconds

% Step input signal
u = ones(size(t));

% Simulate the system response
[y, t, x] = lsim(sys_with_controller, u, t);

% Find the rise time (time to reach 90% of the final value)
final_value = y(end);  % Final value of the response
threshold = 0.9 * final_value;  % 90% threshold
rise_time_index = find(y >= threshold, 1);
rise_time = t(rise_time_index);

% Find the peak overshoot
peak_overshoot_percentage = (max(y) - final_value) / final_value * 100;  % Percentage overshoot

step_info = stepinfo(sys_with_controller);
settling_time = step_info.SettlingTime;
peak_overshoot = step_info.Peak;
% Display the results
fprintf('Rise Time: %.2f seconds\n', rise_time);
fprintf('Settling Time: %.2f seconds\n', settling_time);
fprintf('Peak Overshoot: %.2f%\n', peak_overshoot);
fprintf('Peak Overshoot: %.2f%%\n', peak_overshoot_percentage);

% Plot the step responsea
figure;
plot(t, y);
xlabel('Time (seconds)');
ylabel('Output');
title('Step Response of the PID-Controlled System (Cohen-Coon Tuning)');
grid on;