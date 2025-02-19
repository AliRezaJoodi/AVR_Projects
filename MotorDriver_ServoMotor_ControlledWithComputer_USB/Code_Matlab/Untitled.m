clc;
clear;

fprintf('**************************************************************\r')
fprintf('Servo Motor controler :\r')
fprintf('GitHub.com/AliRezaJoodi\r')
fprintf('                    _____________\r')
fprintf('                   |\r')
fprintf('                   | @\r')
fprintf('                   |\r')
fprintf('Servo Pulse      --|      Servo Motor Contoroler with Computer\r')
fprintf('Servo +5V Power  --|\r')
fprintf('Servo GND        --|\r')
fprintf('                   |      Baud Rate= 9600\r')
fprintf('Servo Pulse      --|      Receiver Data Format: X xxx\r')
fprintf('Servo +5V Power  --|                            | ---   Controer DATA (0 TO 255)\r')
fprintf('Servo GND        --|                            |\r')
fprintf('                   |                            |____   Device (A or B or C or D)\r')
fprintf('Servo Pulse      --|\r')
fprintf('Servo +5V Power  --|      Example: A125\r')
fprintf('Servo GND        --|      Example: B41\r')
fprintf('                   |      Example: A201\r')
fprintf('Servo Pulse      --|      Example: C170\r')
fprintf('Servo +5V Power  --|\r')
fprintf('Servo GND        --|\r')
fprintf('                   |\r')
fprintf('                   | @\r')
fprintf('                   |_____________\r')
fprintf('\r')
fprintf('**************************************************************\r')
fprintf('\r')

s=serial('COM3');
set(s,'baudrate',9600,'Terminator',13,'Timeout',1,'InputBufferSize',16,'OutputBufferSize',8);
fopen(s);

while (1)
    Buffer=input('Enter Contoroler Data=     ','S');
	fprintf(s,Buffer);    
end

clear;
fclose(s);
delete(s);
