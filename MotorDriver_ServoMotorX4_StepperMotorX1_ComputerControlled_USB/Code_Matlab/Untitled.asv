clc;
clear;

fprintf('**************************************************************\r')
fprintf('GitHub.com/AliRezaJoodi\r')
fprintf('\r')

s=serial('COM15');
set(s,'baudrate',9600,'Terminator',13,'Timeout',1,'InputBufferSize',16,'OutputBufferSize',8);
fopen(s);

fprintf('Enter Controler Data\r')

while (1)
    Buffer=input('Motor data driver=     ','S');
	fprintf(s,Buffer);    
end

clear;
fclose(s);
delete(s);
