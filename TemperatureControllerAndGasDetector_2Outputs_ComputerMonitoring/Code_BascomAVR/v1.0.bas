'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200

Config Lcdpin = Pin , Rs = Pinc.7 , E = Pinc.5 , Db4 = Pinc.3 , Db5 = Pinc.2 , Db6 = Pinc.1 , Db7 = Pinc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts

$baud = 9600
Enable Urxc                                                 'enable uart data revive interrupt
On Urxc Receive_setpoint_                                   'jump to this label when reciving data from serial port

Config Watchdog = 32
Stop Watchdog

Config Adc = Single , Prescaler = Auto                      ', Reference = Internal
Start Adc

Config Timer0 = Timer , Prescale = 1024
Enable Timer0
On Timer0 32ms                                              'initial timer0 for 32ms overflow

Config Portd.6 = Input : Portd.6 = 1 : Up_key Alias Pind.6
Config Portd.5 = Input : Portd.5 = 1 : Set_key Alias Pind.5
Config Portd.4 = Input : Portd.4 = 1 : Down_key Alias Pind.4

Config Portd.2 = Output : Relay Alias Portd.2 : Reset Relay
Config Portd.3 = Output : Portd.3 = 0 : Fan_relay Alias Portd.3

Config Portc.4 = Output : Portc.4 = 0 : Sound_pin Alias Portc.4

Dim A As Byte
Dim W As Word
Dim W2 As Word
Dim Total_w2 As Word
Dim Final_gas As Single
Dim Final_gas_send As Byte
Dim Gas_setpoint As Single
Dim Gas_setpoint_send As Byte
Dim Gas_setpoint_eerom As Eram Single
Dim Gas_setpoint_max As Single
Dim Gas_setpoint_min As Single
Dim Gas_alarm_status As Byte : Gas_alarm_status = 1

Dim Alarm As Byte : Alarm = 0

Dim Tmp As Word
Dim Temp_average As Word
Dim Final_temp As Byte
Dim Setpoint As Byte                                        ': Setpoint = 30
Dim Temp_setpoint_eeprom As Eram Byte

Dim Relay_out As Byte
Dim Fan_relay_out As Byte
Dim Cs_temp As Word
Dim Count As Byte : Count = 0
Dim Serial_data(5) As Byte
Dim Uart As Byte
Dim Flag As Bit
Dim Cs As Byte

Dim Set_temp_max As Byte
Dim Set_temp_min As Byte

Dim Z1 As String * 5
Dim F1 As Single

Dim Set_key_status As Bit : Set_key_status = 0
Dim Down_key_status As Bit : Down_key_status = 0
'Dim Set_key_status As Bit : Set_key_status = 0

Deflcdchar 0 , 28 , 20 , 28 , 32 , 32 , 32 , 32 , 32

'Gas_setpoint = 2.1 : Gas_setpoint_eerom = Gas_setpoint

'Gosub Save_eeprom
Gosub Load_eeprom

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

   Debounce Set_key , 0 , Set_temp_setpoint , Sub


Loop

End

'**********************************
Set_temp_setpoint:
Disable Interrupts
'Disable Timer0
'Disable Urxc

Gosub Sound_menu
Cls
Locate 1 , 1 : Lcd "Temp"
Locate 2 , 1 : Lcd "Setpoint:" ; Setpoint ; Chr(0) ; "C      "
'Waitms 300
Do
   Debounce Set_key , 0 , Set_gas_setpoint , Sub
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
Loop
Return

'**********************************
Set_gas_setpoint:
Gosub Sound_menu
Cls
Locate 1 , 1 : Lcd "GAS"
Locate 2 , 1 : Lcd "Setpoint:" ; Fusing(gas_setpoint , "#.#") ; "Volt      "
'Waitms 300
Do
   Debounce Set_key , 0 , New_start , Sub
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
Loop
Return

'**********************************
New_start:
   'Gosub Sound_menu
   Start Watchdog
   'Enable Interrupts
   'Enable Timer0
   'Enable Urxc
Return

'**********************************
Add_to_temp_setpoint:
   Setpoint = Setpoint + 1
   If Setpoint > 99 Then Setpoint = 0
   Locate 2 , 1 : Lcd "Setpoint:" ; Setpoint ; Chr(0) ; "C      "
   Gosub Save_eeprom
   'Gosub Show_menu
Return

'**********************************
Reduce_temp_setpoint:
   Setpoint = Setpoint - 1
   If Setpoint > 99 Then Setpoint = 99
   Locate 2 , 1 : Lcd "Setpoint:" ; Setpoint ; Chr(0) ; "C      "
   Gosub Save_eeprom
   'Gosub Show_menu
Return

'**********************************
Add_to_gas_setpoint:
   Gas_setpoint = Gas_setpoint + 0.1
   If Gas_setpoint > 5 Then Gas_setpoint = 0
   Locate 2 , 1 : Lcd "Setpoint:" ; Fusing(gas_setpoint , "#.#") ; "Volt      "
   Gosub Save_eeprom
   'Gosub Show_menu
Return

'**********************************
Reduce_gas_setpoint:
   Gas_setpoint = Gas_setpoint - 0.1
   If Gas_setpoint < 0 Then Gas_setpoint = 5
   Locate 2 , 1 : Lcd "Setpoint:" ; Fusing(gas_setpoint , "#.#") ; "Volt      "
   Gosub Save_eeprom
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

'**********************************
Show_temp:

   Locate 1 , 1 : Lcd "Temp: " ; Final_temp ; " " ; Chr(0) ; "C      "
   Locate 2 , 1 : Lcd "GAS: " ; Fusing(final_gas , "#.#") ; " Volt   "

   If Gas_alarm_status = 0 Then
      Locate 1 , 16 : Lcd "X"
   Else
      Locate 1 , 16 : Lcd " "
   End If

   'Locate 1 , 1 : Lcd "Temp: " ; Setpoint ; Chr(0) ; "C        "
   'Locate 2 , 1 : Lcd "GAS: " ; Fusing(gas_setpoint , "#.#") ; "Volt     "
Return

'**********************************
32ms:
   Incr Count
   W = Getadc(0) : Cs_temp = W + Cs_temp
   W2 = Getadc(3) : Total_w2 = Total_w2 + W2


   If Count = 30 Then
      Stop Timer0

      Final_gas = Total_w2 / 30 : Total_w2 = 0
      Final_gas = Final_gas / 0.2048
      Final_gas = Final_gas / 1000
      'Final_gas = 0.9
      F1 = Final_gas * 10 : Z1 = Fusing(f1 , "#.#") : Final_gas_send = Val(z1)

      Temp_average = Cs_temp / 30
      'Temp_average = Temp_average - 558
      Final_temp = Temp_average / 2
      'Final_temp = 27
      Gosub Send_data
      Count = 0
      Gosub Termostat
      Gosub Set_fan
      Gosub Show_temp
      Start Timer0
   End If
Return

'**********************************
Send_data:
   Udr = &HEB : Waitms 5
   'Final_temp=  Final_gas_send
   Udr = Final_temp : Waitms 5
   Udr = Final_gas_send : Waitms 5
   Udr = Setpoint : Waitms 5
   F1 = Gas_setpoint * 10 : Z1 = Fusing(f1 , "#.#") : Gas_setpoint_send = Val(z1)
   Udr = Gas_setpoint_send
   Udr = Relay_out : Waitms 5
   Udr = Fan_relay_out : Waitms 5
   Udr = Alarm : Waitms 5
   'Cs_temp = &HEB + Final_temp
   'Cs_temp = Cs_temp + Final_gas_send
   'Cs_temp = Cs_temp + Setpoint
   'Cs_temp = Cs_temp + Relay_out
   'Udr = Cs_temp : Waitms 5
   Cs_temp = 0
Return

'**********************************
Receive_setpoint_:
   Uart = Udr
   If Uart = &HAA And Count = 0 Then
      Count = 1
      Serial_data(count) = Uart
      Cs = Uart
      'Exit Sub
      Goto E1
   End If
   If Count <> 0 Then
      Count = Count + 1
      Serial_data(count) = Uart
      If Count = 3 Then
         'If Serial_data(3) = Cs Then
            If Serial_data(2) <> 255 Then Setpoint = Serial_data(2)
            'Cls
            'Locate 1 , 1 : Lcd Serial_data(2)
            If Serial_data(3) < 50 Then
               Final_gas_send = Serial_data(3)
               Gas_setpoint = Final_gas_send / 10
               'Gosub Save_eeprom : Gosub Load_eeprom
               'Locate 2 , 1 : Lcd Fusing(gas_setpoint , "#.#")
            End If
            Gosub Save_eeprom : Gosub Load_eeprom
         'End If
         Count = 0
      End If
      Cs = Cs + Uart
   End If
   E1:
Return

'**********************************
Receive_setpoint:
   Uart = Udr                                               'reading uart data register (udr)
   If Flag = 0 Then
      If Uart = &HAA Then                                   'finding the first byte of frame
         Cs = &HAA
         Flag = 1
         Count = 1
      End If
   Else
      Serial_data(count) = Uart
      If Count = 2 Then                                     'counting 2 byte after detecting first byte
         If Cs = Serial_data(2) Then                        'compare calculated cs with reciving cs
            If Serial_data(1) <> 255 Then Setpoint = Serial_data(1)       'the cs is good   byte 2 if setpoint
            'Gas_setpoint = Serial_data(2)
            Gosub Save_eeprom
         End If
         Count = 0                                          'reset serial data counter
         Flag = 0
      End If
      Incr Count
      Cs = Cs + Uart                                        'cs(check sum) calculation
   End If
Return

'**********************************
Check_off_the_gas_alarm:
      Gas_setpoint_max = Gas_setpoint
      Gas_setpoint_min = Gas_setpoint - 0.2
      If Final_gas > Gas_setpoint_max Then
         Alarm = 1
         'Sound Sound_pin , 300 , 100
         'Sound Sound_pin , 100 , 300
         Gosub Sound_error
         Gosub Sound_menu
      Elseif Final_gas <= Gas_setpoint_min Then
         Alarm = 0
      End If
Return

'**********************************
Termostat:
   Set_temp_max = Setpoint
   Set_temp_min = Setpoint - 1
   If Final_temp > Set_temp_max Then
      Relay_out = 0 : Reset Relay
   Elseif Final_temp <= Set_temp_min Then
      Relay_out = 1 : Set Relay
   End If
Return


'**********************************
Set_fan:
   Set_temp_max = Setpoint + 1
   Set_temp_min = Setpoint
   If Final_temp > Set_temp_max Then
      Fan_relay_out = 1 : Set Fan_relay
   Elseif Final_temp <= Set_temp_min Then
      Fan_relay_out = 0 : Reset Fan_relay
   End If
Return

'**********************************
Load_eeprom:
   'Readeeprom Setpoint , &H0000                             'read saved setpoint from eeprom
   Setpoint = Temp_setpoint_eeprom
   Gas_setpoint = Gas_setpoint_eerom
Return

'**********************************
Save_eeprom:
   'Writeeeprom Setpoint , &H0000
   Temp_setpoint_eeprom = Setpoint
   Gas_setpoint_eerom = Gas_setpoint
Return


'**********************************
Sound_pressing:
   Sound Sound_pin , 100 , 250
Return

'**********************************
Sound_menu:
   Sound Sound_pin , 100 , 500
Return

'**********************************
Sound_error:
   Sound Sound_pin , 30 , 2000
Return
