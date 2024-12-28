clc;
clear;
%--------------------------------------------------------------------------
fprintf('*****************************************************\r')
fprintf('*           DC Motor Control with MATLAB            *\r')
fprintf('*****************************************************\r')
fprintf('\r')
%--------------------------------------------------------------------------
s=serial('COM1');
set(s,'baudrate',9600,'Terminator',13,'Timeout',1,'InputBufferSize',16,'OutputBufferSize',8);
fopen(s);
%--------------------------------------------
fprintf('Enter number of rpm_set\r')
rpm_set=input('rpm_set=     ');

pwm = 55;
fprintf('PWM=	%d\n', pwm);
pwm_str = num2str(pwm);
fprintf(s,pwm_str);
pause(1);

pwm = 35;
fprintf('PWM=	%d\n', pwm);
pwm_str = num2str(pwm);
fprintf(s,pwm_str);
pause(3);

%--------------------------------------------   Controler
while (1)
   rpm_str = fgets(s);
   rpm = str2num(rpm_str);
   %if rpm ~= pwm ;
        if rpm >= 60 ;
            a=[rpm_set - rpm];        
            a=a/500;
            a=round(a);
            pwm=pwm+a;
            if pwm > 70 ;
                pwm = 70;
                else if pwm < 0 ;
                    pwm=0;
                end
            end
        end
            fprintf('                   \r');
            fprintf('...................\r');
            fprintf('RPM=	%d\n', rpm);
            fprintf('PWM=	%d\n', pwm);
            pwm_str = num2str(pwm);
            fprintf(s,pwm_str);
   %end
end
clear;
fclose(s);
delete(s);
