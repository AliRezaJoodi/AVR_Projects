%--------------------------------------------------------------------------
clc;
clear;
%--------------------------------------------------------------------------
fprintf('**************************************************************\r')
fprintf('* Title         :  Stepper Motor Driver With Matlab          *\r')
fprintf('**************************************************************\r')
fprintf('\r')
%--------------------------------------------------------------------------
s=serial('COM1');
set(s,'baudrate',9600,'Terminator',13,'Timeout',1,'InputBufferSize',16,'OutputBufferSize',8);
fopen(s);
%--------------------------------------------------------------------------
stepper_data=1;
while (1)
    %----------------------------------------------------------------------
    fprintf('\r')
    step=input('How many steps you want to move?  ');
    speed=input('How quickly you move?  ');
    sake=input('Want to move in what direction? L/R  ','S');
    %----------------------------------------------------------------------
    if sake=='L' || sake=='l' ;
        fprintf('Running ... \r')
        for i=1:step
            stepper_data=stepper_data/2;
            if (stepper_data < 16) stepper_data=128; end
            stepper_data_str=num2str(stepper_data); fprintf(s,stepper_data_str); pause(speed); 
        end
     end
    %----------------------------------------------------------------------
    if sake=='R' || sake=='r' ;
        fprintf('Running ... \r')
        for i=1:step
            stepper_data=stepper_data*2;
            if (stepper_data > 128) stepper_data=16; end
            stepper_data_str=num2str(stepper_data); fprintf(s,stepper_data_str); pause(speed); 
        end
    end
end
%--------------------------------------------------------------------------
clear;
fclose(s);
delete(s);
