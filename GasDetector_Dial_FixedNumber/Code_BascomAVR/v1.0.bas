'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Portc.7 , E = Portc.5 , Db4 = Portc.4 , Db5 = Portc.3 , Db6 = Portc.2 , Db7 = Portc.1
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Debounce = 30
Config Portd.6 = Input : Portd.6 = 1 : Up_key Alias Pind.6
Config Portd.4 = Input : Portd.4 = 1 : Set_key Alias Pind.4
Config Portd.3 = Input : Portd.3 = 1 : Down_key Alias Pind.3

Config Portd.2 = Output : Reset Portd.2 : Relay Alias Portd.2
Config Portd.7 = Output : Reset Portd.7 : Sound_pin Alias Portd.7
Config Portc.0 = Output : Relay_phone_line Alias Portc.0 : Reset Relay_phone_line

Config Porta.1 = Input
Config Porta.2 = Input
Config Portb.0 = Input

Dim W As Word
Dim Input_voltage As Single
Dim Setpoint As Single
Dim Setpoint_eerom As Eram Single
Dim Setpoint_max As Single
Dim Setpoint_min As Single

Dim Status As Bit
Dim Dial_status As Bit

Dim Set_key_status As Bit : Set_key_status = 0

Dim Phone_number As String * 11
Phone_number = "09112204314"

Sound Sound_pin , 400 , 250

'Setpoint = 0.9: Gosub Save_eeprom
Gosub Load_of_the_eeprom

'Gosub Dial

Do
   Gosub Read_the_adc
   Gosub Show_menu
   If Status = 0 Then Gosub Check_off_the_alarm

   If Set_key = 0 And Set_key_status = 0 Then
      Waitms 30
      If Set_key = 0 And Set_key_status = 0 Then
         Set_key_status = 1
         Sound Sound_pin , 400 , 200
         Gosub Alarm_setting
      End If
   End If
   If Set_key = 1 Then Set_key_status = 0

   Do
      If Up_key = 0 Then
         Waitms 30
         If Up_key = 0 Then
            Gosub Add_to_setpoint
            Sound Sound_pin , 400 , 200
         End If
      End If
   Loop Until Up_key = 1

   Do
      If Down_key = 0 Then
         Waitms 30
         If Down_key = 0 Then
            Gosub Reduce_setpoint
            Sound Sound_pin , 400 , 200
         End If
      End If
   Loop Until Down_key = 1
   If Input_voltage <= Setpoint_min Then
      Reset Relay_phone_line : Dial_status = 0
   End If
Loop

End

'***************************************************
Dial:
   Set Relay_phone_line : Waitms 500
   Locate 2 , 1 : Lcd "Dial ...        " : Waitms 10
   Dtmfout Phone_number , 50
Return

Alarm_setting:
   Toggle Status
   If Status = 1 Then
      Locate 1 , 16 : Lcd "X"
      Reset Relay
      Reset Relay_phone_line : Dial_status = 1
   Else
      Dial_status = 0
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
Show_menu:
      Locate 1 , 1 : Lcd "Input: " ; Fusing(input_voltage , "#.##") ; "v  "
      Locate 2 , 1 : Lcd "Setpoint: " ; Fusing(setpoint , "#.#") ; "v  "
Return

'**********************************
Check_off_the_alarm:
      Setpoint_max = Setpoint
      Setpoint_min = Setpoint - 0.2
      If Input_voltage > Setpoint_max Then
         Set Relay
         Sound Sound_pin , 100 , 500
         Sound Sound_pin , 400 , 250
         If Dial_status = 0 Then
            Gosub Dial
            Dial_status = 1
         End If
      Elseif Input_voltage <= Setpoint_min Then
         Reset Relay
      End If
Return


'**********************************
Add_to_setpoint:
   Setpoint = Setpoint + 0.1
   If Setpoint > 5 Then Setpoint = 0
   Gosub Save_on_eeprom
   Gosub Show_menu
Return

'**********************************
Reduce_setpoint:
   Setpoint = Setpoint - 0.1
   If Setpoint < 0 Then Setpoint = 5
   Gosub Save_on_eeprom
   Gosub Show_menu
Return

'**********************************
Load_of_the_eeprom:
      Setpoint = Setpoint_eerom                             ': Waitms 10
      'Status = Status_eerom
Return

'**********************************     Save_eeprom
Save_on_eeprom:
   Setpoint_eerom = Setpoint                                ': Waitms 10
   'Status_eerom = Status
Return