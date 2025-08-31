'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
'$crystal = 11059200
$crystal = 8000000

Config Lcdpin = Pin , Rs = Portc.7 , E = Portc.5 , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Debounce = 30
Config Portd.5 = Input : Portd.5 = 1 : Key_up Alias Pind.5
Config Portd.6 = Input : Portd.6 = 1 : Key_set Alias Pind.6
Config Portd.2 = Input : Portd.2 = 1 : Key_down Alias Pind.2

Config Portd.7 = Output : Reset Portd.7 : Relay Alias Portd.7
Config Portc.4 = Output : Reset Portc.4 : Buzzer Alias Portc.4

Config Portb.0 = Input
Config Porta.3 = Input
Config Portd.3 = Input

Dim W As Word
Dim Input_voltage As Single
Dim Setpoint As Byte
Dim Setpoint_eeprom As Eram Byte
Dim Setpoint_max As Byte
Dim Setpoint_min As Byte

Dim Status_alarm_disable As Bit : Status_alarm_disable = 0
Dim State_alarm_on As Bit

Dim Status_key_set As Bit : Status_key_set = 0

Dim Setting_min As Single
Dim Setting_min_eeprom As Eram Single
Dim M2 As Single
Dim M3 As Single
Dim S1 As Single
Dim Input_percent As Integer

If Key_set = 0 Then
   Gosub Read_the_adc
   Setting_min_eeprom = Input_voltage
   Gosub Sound_menu
End If

Gosub Sound_menu
Gosub Eeprom_load

Do
   Gosub Read_the_adc
   Gosub Convert
   Gosub Display_lcd
   If Status_alarm_disable = 0 Then Gosub Alarm_on_off

   If Key_set = 0 And Status_key_set = 0 Then
      Waitms 30
      If Key_set = 0 And Status_key_set = 0 Then
         Status_key_set = 1
         Gosub Sound_menu
         Gosub Alarm_enable_disable
      End If
   End If
   If Key_set = 1 Then Status_key_set = 0

   Do
      If Key_up = 0 Then
         Waitms 30
         If Key_up = 0 Then
            Gosub Sound_key_pressing
            Gosub Setpoint_add
            Gosub Save_on_eeprom
            Gosub Display_lcd
         End If
      End If
   Loop Until Key_up = 1

   Do
      If Key_down = 0 Then
         Waitms 30
         If Key_down = 0 Then
            Gosub Sound_key_pressing
            Gosub Setpoint_reduce
            Gosub Save_on_eeprom
            Gosub Display_lcd
         End If
      End If
   Loop Until Key_down = 1

Loop

End

'*********************************
Alarm_enable_disable:
   Toggle Status_alarm_disable
   If Status_alarm_disable = 1 Then
      Locate 1 , 16 : Lcd "X"
      Reset Relay
   Else
      Locate 1 , 16 : Lcd " "
   End If
Return

'**********************************
Read_the_adc:
   W = Getadc(0)
   Input_voltage = W / 0.2048
   Input_voltage = Input_voltage / 1000
Return

'**********************************
Convert:
   M2 = Input_voltage -setting_min : M2 = M2 * 100
   M3 = 5 - Setting_min
   Input_percent = M2 / M3
Return

'**********************************
Display_lcd:
      Locate 1 , 1 : Lcd "Status: " ; Input_percent ; "%   "
      'If Status_alarm_disable = 0 And State_alarm_on = 1 Then
         'Locate 2 , 1 : Lcd "**** Alarm ****"
      'Else
         Locate 2 , 1 : Lcd "Setpoint: " ; Setpoint ; "%   "
      'End If
Return

'**********************************
Alarm_on_off:
      Setpoint_max = Setpoint
      Setpoint_min = Setpoint - 3
      If Input_percent > Setpoint_max Then
         State_alarm_on = 1
      Elseif Input_percent <= Setpoint_min Then
         State_alarm_on = 0
      End If
      If State_alarm_on = 1 And Status_alarm_disable = 0 Then
         Set Relay
         Gosub Sound_error : Gosub Sound_menu
      Elseif State_alarm_on = 0 Then
         Reset Relay
      End If
Return

'**********************************
Setpoint_add:
   Setpoint = Setpoint + 1 : If Setpoint > 100 Then Setpoint = 0
Return

'**********************************
Setpoint_reduce:
   Setpoint = Setpoint - 1 : If Setpoint > 100 Then Setpoint = 100
Return

'**********************************
Eeprom_load:
   Setpoint = Setpoint_eeprom                               ': Waitms 10
   Setting_min = Setting_min_eeprom
Return

'**********************************
Save_on_eeprom:
   Setpoint_eeprom = Setpoint                               ': Waitms 10
Return

'**********************************
Sound_key_pressing:
   Sound Buzzer , 400 , 200
Return

'**********************************
Sound_menu:
   Sound Buzzer , 400 , 250
Return

'**********************************
Sound_error:
   Sound Buzzer , 100 , 500
Return