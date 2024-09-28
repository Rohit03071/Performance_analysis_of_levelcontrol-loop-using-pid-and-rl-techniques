Kp = 0.0057;       % Steady-state gain
tau = 16.7028;      % Time constant
td = 9.4132;       % Dead time

numerator = [Kp];
denominator = [tau, 1]; 
% Create the transfer function with the dead time
[numerator_delayed, denominator_delayed] = pade(td, 1); 
transfer_function = tf(numerator_delayed, denominator_delayed) * tf(numerator, denominator);

% Manual Ziegler-Nichols tuning
Kp_tuned = 0.6 * Kp;
Ki_tuned = 1.2 / (Kp * tau);
Kd_tuned = 0.075 * Kp * tau;

% Create the PID controller
controller = pid(Kp_tuned, Ki_tuned, Kd_tuned);

% Connect the PID controller to the transfer function
sys_with_controller = feedback(controller * transfer_function, 1);

% Compute the step response
t = 0:0.01:10;   % Time span from 0 to 10 seconds
[y, t] = step(sys_with_controller, t);

% Plot the step response
figure;
plot(t, y);
xlabel('Time (seconds)');
ylabel('Output');
title('Step Response of the PID-Controlled System');
grid on;

% Calculate settling time and peak overshoot using stepinfo
step_info = stepinfo(y, t);
settling_time = step_info.SettlingTime;
peak_overshoot = step_info.Overshoot;
rise_time = step_info.RiseTime;

% Display the results in the command window
disp(['Settling Time: ' num2str(settling_time) ' seconds']);
disp(['Peak Overshoot: ' num2str(peak_overshoot) ' percent']);
disp(['Rise Time: ' num2str(rise_time) 'seconds']);

