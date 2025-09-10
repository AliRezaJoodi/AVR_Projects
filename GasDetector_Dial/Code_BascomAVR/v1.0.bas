'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Portc.7 , E = Portc.5 , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Config Kbd = Portb , Debounce = 50 , Delay = 150

Enable Interrupts
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Timer0 = Timer , Prescale = 1024                     'PRESCALE= 1|8|64|256|1024
On Timer0 Lable
Enable Timer0                                               ' Or  Enable Ovf0
Stop Timer0

Config Debounce = 30
Config Portd.0 = Input : Portd.0 = 1 : Key_up Alias Pind.0
Config Portd.1 = Input : Portd.1 = 1 : Key_set Alias Pind.1
Config Portd.2 = Input : Portd.2 = 1 : Key_down Alias Pind.2

Config Porta.0 = Output : Reset Porta.0 : Relay Alias Porta.0
Config Portd.6 = Output : Relay_phone_line Alias Portd.6 : Reset Relay_phone_line
Config Portd.4 = Output : Reset Portd.4 : Buzzer Alias Portd.4

Dim W As Word
Dim Input_voltage As Single
Dim Setpoint As Single
Dim Setpoint_eerom As Eram Single                           ':Setpoint_eerom=2.5
Dim Setpoint_max As Single
Dim Setpoint_min As Single

Dim Status_alarm_disable As Bit : Status_alarm_disable = 0
Dim State_alarm_on As Bit

Dim Status_key_set As Bit : Status_key_set = 0

Dim Key As Byte
Dim Key_status As Byte

Dim Phone_number As String * 11
Dim Phone_number_eeprom As Eram String * 11                 ': Phone_number_eeprom = "09112204314"
Dim Z As String * 16 : Z = ""

Dim Status_dial As Bit : Status_dial = 0
Dim Status_exit As Bit : Status_exit = 0
Dim Status_enable_change_number As Bit : Status_enable_change_number = 0

Dim K1 As Word

Gosub Sound_menu

Gosub Eeprom_load

Do
   Gosub Read_the_adc
   Gosub Display_lcd
   If Status_alarm_disable = 0 Then Gosub Alarm_on_off

   Key = Getkbd() : Key = Lookup(key , Read_key)
   'If Key < 16 And Key <> Key_status Then
   If Key < 16 Then
      Select Case Key
         Case 0 To 9:
            Gosub Sound_error
         Case 10:
            Gosub Sound_menu
            Gosub Setpoint_add
            Gosub Save_on_eeprom
            Gosub Display_lcd
         Case 11:
            Gosub Sound_menu
            Gosub Setpoint_reduce
            Gosub Save_on_eeprom
            Gosub Display_lcd
         Case 12:
            Gosub Sound_menu
            Cls : Locate 1 , 1 : Lcd "Phone Number:"
            Locate 2 , 1 : Lcd Phone_number
            Z = ""
            Do
               Key = Getkbd() : Key = Lookup(key , Read_key)
               If Key < 16 And Key <> Key_status Then
                  Select Case Key
                     Case 0 To 9:
                        If Status_enable_change_number = 1 Then
                           Gosub Sound_key_pressing
                           Z = Z + Str(key)
                           Locate 2 , 1 : Lcd "                "
                           Locate 2 , 1 : Lcd Z
                        Else
                           Gosub Sound_error
                        End If
                     Case 13:
                        If Z <> "" Then
                           Gosub Sound_menu
                           Phone_number = Z : Z = ""
                           Phone_number_eeprom = Phone_number
                           Cls : Lcd "Saved" : Waitms 900 : Cls
                           Status_exit = 1
                        Else
                           Gosub Sound_error
                        End If
                     Case 14:
                        Gosub Sound_menu
                        'Phone_number = ""
                        z=""
                        Locate 2 , 1 : Lcd "                " : Locate 2 , 1
                        Cursor On : Cursor Blink
                        Status_enable_change_number = 1
                     Case 15:
                        Gosub Sound_menu
                        Status_exit = 1
                     Case Else:
                        Gosub Sound_error
                  End Select
               End If
               Key_status = Key
            Loop Until Status_exit = 1
            Status_exit = 0 : Cursor Off : Cursor Noblink : Status_alarm_disable = 0 : Status_enable_change_number = 0
         Case 15:
            Gosub Sound_menu
            Gosub Alarm_enable_disable
            Reset Relay_phone_line : Waitms 500 : Status_dial = 0
         Case Else:
            Gosub Sound_error
      End Select
   End If
   'Key_status = Key
Loop

End

'***************************************************
Lable:
   Incr K1
   If K1 = 600 Then
      Stop Timer0 : Timer0 = 0
      Status_dial = 0
      Reset Relay_phone_line : Waitms 100 : Reset Relay : Waitms 100
      K1 = 0
   End If
Return

'***************************************************
Dial:
   Set Relay_phone_line : Waitms 500
   Locate 2 , 1 : Lcd "Dial ...        " : Waitms 10
   Dtmfout Phone_number , 50
   'Start Timer0
Return

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
   W = Getadc(1)
   Input_voltage = W / 0.2048
   Input_voltage = Input_voltage / 1000
Return

'**********************************
Display_lcd:
      Locate 1 , 1 : Lcd "Input: " ; Fusing(input_voltage , "#.##") ; "v  "
      If Status_alarm_disable = 0 And State_alarm_on = 1 Then
         Locate 2 , 1 : Lcd "**** Alarm ****"
      Else
         Locate 2 , 1 : Lcd "Setpoint: " ; Fusing(setpoint , "#.#") ; "v  "
      End If
Return

'**********************************
Alarm_on_off:
      Setpoint_max = Setpoint
      Setpoint_min = Setpoint - 0.2
      If Input_voltage > Setpoint_max Then
         State_alarm_on = 1
      Elseif Input_voltage <= Setpoint_min Then
         State_alarm_on = 0
      End If
      If State_alarm_on = 1 And Status_alarm_disable = 0 Then
         If Status_dial = 0 Then
             Gosub Dial : Status_dial = 1
             Start Timer0
         End If
         Set Relay : Waitms 200
         Gosub Sound_error : Gosub Sound_menu
      Elseif State_alarm_on = 0 Then
         'Reset Relay
      End If
      If Status_dial = 1 Then
         Gosub Sound_error : Gosub Sound_menu
      End If
Return

'**********************************
Setpoint_add:
   Setpoint = Setpoint + 0.1 : If Setpoint > 5 Then Setpoint = 0
Return

'**********************************
Setpoint_reduce:
   Setpoint = Setpoint - 0.1 : If Setpoint < 0 Then Setpoint = 5
Return

'**********************************
Eeprom_load:
   Setpoint = Setpoint_eerom                                ': Waitms 10
   Phone_number = Phone_number_eeprom                       ': Waitms 10
Return

'**********************************
Save_on_eeprom:
   Setpoint_eerom = Setpoint                                ': Waitms 10
Return

'**********************************
Sound_key_pressing:
   Sound Buzzer , 100 , 250
Return

'**********************************
Sound_menu:
   Sound Buzzer , 100 , 500
Return

'**********************************
Sound_error:
   Sound Buzzer , 10 , 1500
Return

'**********************************************   Read_key
Read_key:
Data 1 , 4 , 7 , 15 , 2 , 5 , 8 , 0 , 3 , 6 , 9 , 14 , 10 , 11 , 12 , 13       ',16