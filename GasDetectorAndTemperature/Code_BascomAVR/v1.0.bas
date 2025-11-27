'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Pinc.7 , E = Pinc.5 , Db4 = Pinc.3 , Db5 = Pinc.2 , Db6 = Pinc.1 , Db7 = Pinc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts

'Config Watchdog = 32
'Stop Watchdog

Config Adc = Single , Prescaler = Auto                      ', Reference = Internal
Start Adc

Config Timer0 = Timer , Prescale = 1024
Enable Timer0
On Timer0 32ms                                              'initial timer0 for 32ms overflow

Config Portd.6 = Input : Portd.6 = 1 : Up_key Alias Pind.6
Config Portd.4 = Input : Portd.4 = 1 : Set_key Alias Pind.4
Config Portd.3 = Input : Portd.3 = 1 : Down_key Alias Pind.3
Config Portd.0 = Output : Portd.0 = 0 : Relay_1 Alias Portd.0
Config Portd.1 = Output : Portd.1 = 0 : Relay_2 Alias Portd.1
Config Portd.2 = Output : Portd.2 = 0 : Sound_pin Alias Portd.2

Dim A As Byte
Dim W As Word
Dim W2 As Word
Dim Total_w2 As Word
Dim Final_gas As Single
Dim Final_gas_send As Byte
Dim Setpoint_gas As Single
Dim Setpoint_gas_send As Byte
Dim Setpoint_gas_eerom As Eram Single
Dim Setpoint_gas_max As Single
Dim Setpoint_gas_min As Single
Dim Gas_alarm_status As Byte : Gas_alarm_status = 1

Dim Alarm As Byte : Alarm = 0

Dim Tmp As Word
Dim Temp_average As Word
Dim Final_temp As Single
Dim Setpoint As Byte                                        ': Setpoint = 30
Dim Temp_setpoint_eeprom As Eram Byte

Dim Relay_out As Byte
Dim Relay_2_out As Byte
Dim Cs_temp As Word
Dim Count As Byte : Count = 0
'Dim Serial_data(5) As Byte
'Dim Uart As Byte
'Dim Flag As Bit
'Dim Cs As Byte

Dim Set_temp_max As Single
Dim Set_temp_min As Single

Dim Z1 As String * 5
Dim F1 As Single

Dim Set_key_status As Bit : Set_key_status = 0
Dim Down_key_status As Bit : Down_key_status = 0
'Dim Set_key_status As Bit : Set_key_status = 0

Dim Status_exit As Bit : Status_exit = 0

Deflcdchar 0 , 28 , 20 , 28 , 32 , 32 , 32 , 32 , 32

'Gosub Eeprom_default
Gosub Eeprom_load
Gosub Sound_menu

Do
   If Gas_alarm_status = 1 Then Gosub Check_off_the_gas_alarm
   'Gosub Check_off_the_gas_alarm
   If Down_key = 0 And Down_key_status = 0 Then
      Waitms 30
      If Down_key = 0 And Down_key_status = 0 Then
         Down_key_status = 1
         Gosub Sound_menu
         Gosub Alarm_setting
      End If
   End If
   If Down_key = 1 Then Down_key_status = 0

   'Debounce Set_key , 0 , Setting_setpoint_temp , Sub
   If Set_key = 0 And Set_key_status = 0 Then
      Waitms 30
      If Set_key = 0 And Set_key_status = 0 Then
         Set_key_status = 1
         Gosub Sound_menu
         Gosub Setting_setpoint_temp
      End If
   End If
   If Set_key = 1 Then Set_key_status = 0
   'Status_exit = 0
Loop

End

'***********************************************
Setting_setpoint_temp:
   Disable Interrupts
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Temp"
   Locate 2 , 1 : Lcd "Setpoint:" ; Setpoint ; Chr(0) ; "C      "
Do
   'Debounce Set_key , 0 , Setting_setpoint_gas , Sub
   If Set_key = 0 And Set_key_status = 0 Then
      Waitms 30
      If Set_key = 0 And Set_key_status = 0 Then
         Set_key_status = 1
         Gosub Sound_menu
         Gosub Setting_setpoint_gas
      End If
   End If
   If Set_key = 1 Then Set_key_status = 0

   Do
      If Up_key = 0 Then
         Waitms 50
         If Up_key = 0 Then
            Gosub Sound_pressing
            Gosub Add_to_temp_setpoint
            'Gosub Sound_pressing
         End If
      End If
   Loop Until Up_key = 1
   Do
      If Down_key = 0 Then
         Waitms 50
         If Down_key = 0 Then
            Gosub Sound_pressing
            Gosub Reduce_temp_setpoint
            'Gosub Sound_pressing
         End If
      End If
   Loop Until Down_key = 1
Loop Until Status_exit = 1
Status_exit = 0                                             ': Waitms 300
Enable Interrupts
Return

'***********************************************
Setting_setpoint_gas:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "GAS"
   Locate 2 , 1 : Lcd "Setpoint:" ; Fusing(setpoint_gas , "#.#") ; "V      "
Do
   'Debounce Set_key , 0 , New_start , Sub

   If Set_key = 0 And Set_key_status = 0 Then
      Waitms 30
      If Set_key = 0 And Set_key_status = 0 Then
         Set_key_status = 1
         Gosub Sound_menu
         Status_exit = 1                                    ': Waitms 300
      End If
   End If
   If Set_key = 1 Then Set_key_status = 0

   Do
      If Up_key = 0 Then
         Waitms 50
         If Up_key = 0 Then
            Gosub Sound_pressing
            Gosub Add_to_gas_setpoint
            'Gosub Sound_pressing
         End If
      End If
   Loop Until Up_key = 1
   Do
      If Down_key = 0 Then
         Waitms 50
         If Down_key = 0 Then
            Gosub Sound_pressing
            Gosub Reduce_gas_setpoint
            'Gosub Sound_pressing
         End If
      End If
   Loop Until Down_key = 1
Loop Until Status_exit = 1

Return

New_start:
   'Gosub Sound_menu
   'Start Watchdog
   'Enable Interrupts
   'Enable Timer0
   'Enable Urxc
Return

'**********************************
Add_to_temp_setpoint:
   Setpoint = Setpoint + 1
   If Setpoint > 99 Then Setpoint = 0
   Locate 2 , 1 : Lcd "Setpoint:" ; Setpoint ; Chr(0) ; "C      "
   Gosub Eeprom_save
   'Gosub Show_menu
Return

'**********************************
Reduce_temp_setpoint:
   Setpoint = Setpoint - 1
   If Setpoint > 99 Then Setpoint = 99
   Locate 2 , 1 : Lcd "Setpoint:" ; Setpoint ; Chr(0) ; "C      "
   Gosub Eeprom_save
   'Gosub Show_menu
Return

'**********************************
Add_to_gas_setpoint:
   Setpoint_gas = Setpoint_gas + 0.1
   If Setpoint_gas > 5 Then Setpoint_gas = 0
   Locate 2 , 1 : Lcd "Setpoint:" ; Fusing(setpoint_gas , "#.#") ; "V      "
   Gosub Eeprom_save
   'Gosub Show_menu
Return

'**********************************
Reduce_gas_setpoint:
   Setpoint_gas = Setpoint_gas - 0.1
   If Setpoint_gas < 0 Then Setpoint_gas = 5
   Locate 2 , 1 : Lcd "Setpoint:" ; Fusing(setpoint_gas , "#.#") ; "V      "
   Gosub Eeprom_save
   'Gosub Show_menu
Return

'**********************************
Alarm_setting:
   If Gas_alarm_status = 0 Then
      Gas_alarm_status = 1
   Else
      Gas_alarm_status = 0
      Alarm = 0
   End If

   If Gas_alarm_status = 0 Then
      Locate 1 , 16 : Lcd "X"
   Else
      Locate 1 , 16 : Lcd " "
   End If
Return

'***********************************************    Show_lcd
Show_temp:
   Locate 1 , 1 : Lcd "Temp: " ; Fusing(final_temp , "#.#") ;  Chr(0) ; "C      "
   Locate 2 , 1 : Lcd "GAS: " ; Fusing(final_gas , "#.#") ; "V         "

   If Gas_alarm_status = 0 Then
      Locate 1 , 16 : Lcd "X"
   Else
      Locate 1 , 16 : Lcd " "
   End If

   'Locate 1 , 1 : Lcd "Temp: " ; Setpoint ; Chr(0) ; "C        "
   'Locate 2 , 1 : Lcd "GAS: " ; Fusing(gas_setpoint , "#.#") ; "V     "
Return

'***********************************************    32ms
32ms:
   Incr Count
   W = Getadc(0) : Cs_temp = W + Cs_temp
   W2 = Getadc(2) : Total_w2 = Total_w2 + W2


   If Count = 30 Then
      Stop Timer0

      Final_gas = Total_w2 / 30 : Total_w2 = 0
      Final_gas = Final_gas / 0.2048
      Final_gas = Final_gas / 1000
      'Final_gas = 0.9
      F1 = Final_gas * 10 : Z1 = Fusing(f1 , "#.#") : Final_gas_send = Val(z1)

      Temp_average = Cs_temp / 30 : Cs_temp = 0
      'Temp_average = Temp_average - 558
      Final_temp = Temp_average / 0.2048 : Final_temp = Final_temp / 10
      'Final_temp = 27
      'Gosub Send_data
      Count = 0
      Gosub Driver_relay1
      Gosub Driver_relay2
      Gosub Show_temp
      Start Timer0
   End If
Return


'**********************************
Check_off_the_gas_alarm:
      Setpoint_gas_max = Setpoint_gas
      Setpoint_gas_min = Setpoint_gas - 0.2
      If Final_gas > Setpoint_gas_max Then
         Alarm = 1
         'Sound Sound_pin , 300 , 100
         'Sound Sound_pin , 100 , 300
         Gosub Sound_error
         Gosub Sound_menu
      Elseif Final_gas <= Setpoint_gas_min Then
         Alarm = 0
      End If
Return

'***********************************************
Driver_relay:
   Setpoint_gas_min = Setpoint_gas - 0.2
   If Final_gas > Setpoint_gas Then
      Set Relay_1
   Elseif Final_gas < Setpoint_gas_min Then
      Reset Relay_1
   End If
Return

'***********************************************
Driver_relay1:
   Set_temp_max = Setpoint
   Set_temp_min = Setpoint - 1
   If Final_temp > Set_temp_max Then
      Relay_out = 0 : Reset Relay_1
   Elseif Final_temp <= Set_temp_min Then
      Relay_out = 1 : Set Relay_1
   End If
Return


'***************************************************************
Driver_relay2:
   Set_temp_max = Setpoint + 1
   Set_temp_min = Setpoint
   If Final_temp > Set_temp_max Then
      Relay_2_out = 1 : Set Relay_2
   Elseif Final_temp <= Set_temp_min Then
      Relay_2_out = 0 : Reset Relay_2
   End If
Return

'***********************************************
Eeprom_load:
   Setpoint = Temp_setpoint_eeprom
   Setpoint_gas = Setpoint_gas_eerom
Return

'***********************************************
Eeprom_default:
   Temp_setpoint_eeprom = 50
   Setpoint_gas_eerom = 2.5
Return

'***********************************************
Eeprom_save:
   Temp_setpoint_eeprom = Setpoint
   Setpoint_gas_eerom = Setpoint_gas
Return

'***************************************************
Sound_pressing:
   Sound Sound_pin , 100 , 250
Return

'***************************************************
Sound_menu:
   Sound Sound_pin , 100 , 500
Return

'***************************************************
Sound_error:
   Sound Sound_pin , 30 , 2000
Return