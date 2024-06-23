'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Portc.7 , E = Portc.5 , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Debounce = 30
Config Portd.7 = Output : Reset Portd.7 : Relay Alias Portd.7
Config Portd.5 = Input : Portd.5 = 1 : Up_key Alias Pind.5
Config Portd.6 = Input : Portd.6 = 1 : Set_key Alias Pind.6
Config Portd.2 = Input : Portd.2 = 1 : Down_key Alias Pind.2

Config Portd.3 = Input

Dim W As Word
Dim Temp As Single
Dim Setpoint As Single
Dim Setpoint_eerom As Eram Single At &H00
Dim Setpoint_max As Single
Dim Setpoint_min As Single

Dim T As Word
Dim Status As Bit
Dim Status_eerom As Bit

Deflcdchar 0 , 28 , 20 , 28 , 32 , 32 , 32 , 32 , 32

'Setpoint = 40 : Gosub Save_eeprom
Gosub Load_eeprom

Do
   Gosub Red_temp
   Gosub Show_temp
   Gosub Termostat
   Debounce Set_key , 0 , Seting_time , Sub
   If Up_key = 0 Then
      Waitms 30 : If Up_key = 0 Then Gosub Up
   End If
   If Down_key = 0 Then
      Waitms 30 : If Down_key = 0 Then Gosub Down
   End If
   Waitms T
Loop

End

'***************************************************************
Red_temp:
   W = Getadc(0)
   Temp = W / 2.048
Return

'***************************************************************
Show_temp:
   'If Temp <= 100 Then
      Locate 1 , 1 : Lcd "Temp:" ; Fusing(temp , "#.#") ; Chr(0) ; "C   "
      Locate 2 , 1 : Lcd "Setpoint:" ; Fusing(setpoint , "#.#") ; Chr(0) ; "C   "
   'Else
      'Locate 1 , 1 : Lcd "There is no sensor"
   'End If
Return

'***************************************************************
Termostat:
   'If Temp <= 100 Then
      Setpoint_max = Setpoint
      Setpoint_min = Setpoint - 5
      If Temp > Setpoint_max Then
         Reset Relay
      Elseif Temp <= Setpoint_min Then
         Set Relay
      End If
   'End If
Return

'***************************************************************
Up:
   Setpoint = Setpoint + 0.1
   Gosub Save_eeprom
   Gosub Show_temp
Return

'***************************************************************
Down:
   Setpoint = Setpoint - 0.1
   Gosub Save_eeprom
   Gosub Show_temp
Return

'***************************************************************
Seting_time:
   Toggle Status
   If Status = 0 Then
      T = 0
   Else
      T = 200
   End If
   Gosub Save_eeprom
Return

'***************************************************************
Load_eeprom:
      Setpoint = Setpoint_eerom
      Status = Status_eerom
Return

'***************************************************************
Save_eeprom:
   Setpoint_eerom = Setpoint : Waitms 10
   Status_eerom = Status : Waitms 10
Return
