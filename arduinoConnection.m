
% Create an Arduino object
arduinoObj = arduino('COM4', 'Uno'); % Replace 'COMx' and 'BoardName' with your specific port and board name

% Load and run your .ino code
arduinoObj.run('sketch_sep11a.ino'); % Replace 'YourArduinoCode.ino' with the actual filename

% Initialize the time vector and data vector
time = [];
data = [];

% Create a plot
figure;
h = plot(time, data);
xlabel('Time (s)');
ylabel('Sensor Reading');
title('Step Response of Flow Control System');
grid on;

% Start the data acquisition loop
tic;
while ishandle(h)
    % Read the data from the Arduino
    sensorValue = readVoltage(a, 'A0');  % Adjust pin 'A0' as needed
    
    % Update the time vector and data vector
    time(end+1) = toc;
    data(end+1) = sensorValue;
    
    % Update the plot
    set(h, 'XData', time, 'YData', data);
    drawnow;
    
    % Add a delay to control the data acquisition rate (adjust as needed)
    pause(0.1);
end


% Close the connection to the Arduino
clear arduinoObj;
