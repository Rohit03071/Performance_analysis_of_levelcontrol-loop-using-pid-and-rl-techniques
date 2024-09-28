
 
Kp = -9.65;
% Calculate the time delay (θ)
td = 6.47;

% Calculate the time constant (τ)
tau = 52.38;

numerator = Kp;                  % For a first-order system
denominator = [tau, 1];            % For a first-order system
% Create the transfer function with the dead time
[numerator_delayed, denominator_delayed] = pade(td, 1); 
transfer_function = tf(numerator_delayed, denominator_delayed) * tf(numerator, denominator);

del_value = 0.8;
b = 3.6; 
Wo = (4 * td + tau)/ (2 * b * 0.8 * td * tau);
a = ((4 * tau + td) / (2 * td * tau)) - (0.8 * Wo);

fprintf('wo value: %.2f\n', Wo);
fprintf('a value: %.2f\n', a);

kp_pid = ((a * del_value + Wo)* a * Wo * (td)^2 * tau - 2) / (2 * Kp);
ki_pid = (a^2 * Wo^2 * td^2 * tau) / (4 * Kp);
kd_pid = (1 / (4 * Kp) ) * ((a^2 + 4 * a * del_value * Wo + (Wo^2)) * ((td)^2 * tau) - 4 * (td + tau));

fprintf('proportional gain (kp): %.2f\n', kp_pid);
fprintf('integral gain (ki): %.2f \n', ki_pid);
fprintf('derrivative gain (kd): %.2f \n', kd_pid);
% Create the PID controller
controller = pid(kp_pid, ki_pid, kd_pid);

% Connect the PID controller to the transfer function
sys_with_controller = feedback(controller * transfer_function, 1);

% Time vector
t = 0:0.01:500;   % Time span from 0 to 10 seconds

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
peak_overshoot = (max(y) - final_value) / final_value * 100;  % Percentage overshoot

% Display the results
fprintf('Rise Time: %.2f seconds\n', rise_time);
fprintf('Peak Overshoot: %.2f%%\n', peak_overshoot);

figure;
plot(t, y);
xlabel('Time (seconds)');
ylabel('Output');
title('Step Response of the PID-Controlled System for reduced FOPDT from Higher Order TF');
grid on;