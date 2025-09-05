'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000


Config Lcdpin = Pin , Db7 = Portc.0 , Db6 = Portc.1 , Db5 = Portc.2 , Db4 = Portc.3 , E = Portc.4 , Rs = Portc.5
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Portd.6 = Output : Bizzer Alias Portd.6 : Reset Bizzer
Config Portb.0 = Output : Led_sensor_1 Alias Portb.0 : Reset Led_sensor_1
Config Portb.1 = Output : Led_sensor_2 Alias Portb.1 : Reset Led_sensor_2
Config Portb.2 = Output : Led_sensor_3 Alias Portb.2 : Reset Led_sensor_3

Dim W As Word
Dim Sens_1 As Single
Dim Sens_2 As Single
Dim Sens_3 As Single
Dim Setpoint_1 As Single : Setpoint_1 = 2.5
Dim Setpoint_2 As Single : Setpoint_2 = 2.5
Dim Setpoint_3 As Single : Setpoint_3 = 2.5

'Gosub Loading

Do
   Gosub Red_sensor
   Gosub Show_sens
   Gosub Led_driver
   Gosub Bizzer_driver
   Waitms 200
Loop

End

'***************************************************************
Loading:
   Sound Bizzer , 100 , 400
   Cls : Lcd "Please Wait"
   Wait 15
   Cls
Return

'***************************************************************
Red_sensor:
   W = Getadc(2) : Sens_1 = W / 0.2048 : Sens_1 = Sens_1 / 1000
   W = Getadc(0) : Sens_2 = W / 0.2048 : Sens_2 = Sens_2 / 1000
   W = Getadc(4) : Sens_3 = W / 0.2048 : Sens_3 = Sens_3 / 1000
Return

'***************************************************************
Show_sens:
   Locate 1 , 1 : Lcd "S1:" ; Fusing(sens_1 , "#.#") ; "V "
   Locate 1 , 9 : Lcd "S2:" ; Fusing(sens_2 , "#.#") ; "V "
   Locate 2 , 1 : Lcd "S3:" ; Fusing(sens_3 , "#.#") ; "V "
Return

'***************************************************************
Led_driver:
   If Sens_1 > Setpoint_1 Then
      Set Led_sensor_1
   Else
      Reset Led_sensor_1
   End If

   If Sens_2 > Setpoint_1 Then
      Set Led_sensor_2
   Else
      Reset Led_sensor_2
   End If

   If Sens_3 > Setpoint_3 Then
      Set Led_sensor_3
   Else
      Reset Led_sensor_3
   End If
Return

'***************************************************************
Bizzer_driver:
   If Sens_1 > Setpoint_1 Or Sens_2 > Setpoint_2 Or Sens_3 > Setpoint_3 Then
      Sound Bizzer , 10 , 3000
   Else
      Reset Bizzer
   End If
Return