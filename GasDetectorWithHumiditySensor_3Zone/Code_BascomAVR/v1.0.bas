'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
'$crystal = 8000000

Config Lcdpin = Pin , Rs = Portc.7 , E = Portc.5 , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Debounce = 30

Config Portd.4 = Input : Portd.4 = 1 : Key_set1 Alias Pind.4
Config Portd.6 = Input : Portd.6 = 1 : Key_set2 Alias Pind.6
Config Portd.5 = Input : Portd.5 = 1 : Key_set3 Alias Pind.5
Config Portd.2 = Input : Portd.2 = 1 : Key_set4 Alias Pind.2

Config Porta.0 = Output : Reset Porta.0 : Relay_mq2 Alias Porta.0
Config Porta.2 = Output : Reset Porta.2 : Relay_mq7 Alias Porta.2
Config Porta.4 = Output : Reset Porta.4 : Relay_mq135 Alias Porta.4
Config Portd.3 = Output : Reset Portd.3 : Buzzer Alias Portd.3

Config Portb.0 = Output : Sht10_sck Alias Portb.0
Sht10_dataout Alias Portb.1
Sht10_datain Alias Pinb.1

Const Pres_key_max_timer = 20000

Dim W As Word
Dim Input_voltage As Single
Dim Setpoint_mq2 As Byte
Dim Setpoint_mq2_eeprom As Eram Byte
Dim Setpoint_mq2_max As Byte
Dim Setpoint_mq2_min As Byte

Dim Setpoint_mq7 As Byte
Dim Setpoint_mq7_eeprom As Eram Byte
Dim Setpoint_mq7_max As Byte
Dim Setpoint_mq7_min As Byte

Dim Setpoint_mq135 As Byte
Dim Setpoint_mq135_eeprom As Eram Byte
Dim Setpoint_mq135_max As Byte
Dim Setpoint_mq135_min As Byte

Dim Status_disable As Bit
Dim Status_mq2_disable As Bit : Status_mq2_disable = 0
Dim Status_mq7_disable As Bit : Status_mq7_disable = 0
Dim Status_mq135_disable As Bit : Status_mq135_disable = 0
Dim State_mq2_alarm As Bit
Dim State_mq7_alarm As Bit
Dim State_mq135_alarm As Bit

Dim Status_key_set1 As Bit : Status_key_set1 = 0
Dim Status_key_set2 As Bit : Status_key_set2 = 0
Dim Status_key_set3 As Bit : Status_key_set3 = 0
Dim Status_key_set4 As Bit : Status_key_set4 = 0

Dim Setting_default_mq2 As Single
Dim Setting_default_mq2_eeprom As Eram Single
Dim Setting_default_mq7 As Single
Dim Setting_default_mq7_eeprom As Eram Single
Dim Setting_default_mq135 As Single
Dim Setting_default_mq135_eeprom As Eram Single

Dim Z1 As Single
Dim Z2 As Single
Dim S1 As Single
Dim Input_percent_mq2 As Integer
Dim Input_percent_mq7 As Integer
Dim Input_percent_mq135 As Integer

Dim K As Word : K = 0
Dim Status As Bit : Status = 0
Dim Status_display As Bit : Status_display = 1

Dim Sht10_data_byte As Byte
Dim Sht10_data_msb As Byte
Dim Sht10_data_lsb As Byte
Dim Sht10_data_word As Word
Dim Sht10_crc As Byte

Dim Sht10_temp As Single
Dim Sht10_rh_liner As Single
Dim Sht10_command As Byte

If Key_set4 = 0 Then
   Gosub Read_mq2 : Setting_default_mq2_eeprom = Input_voltage
   Gosub Read_mq7 : Setting_default_mq7_eeprom = Input_voltage
   Gosub Read_mq135 : Setting_default_mq135_eeprom = Input_voltage
   Gosub Sound_menu
   Cls : Lcd "Wait ..."
   Waitms 1000
End If

Gosub Sht10_signal_reset : Waitms 10

Gosub Eeprom_default
Gosub Sound_menu
Gosub Eeprom_load


Do
   Gosub Read_mq2
   Gosub Read_mq7
   Gosub Read_mq135
   If Status_display = 0 Then
      Gosub Display_mq
   Else
      Sht10_command = &B00000101 : Gosub Sht10_get : Gosub Sht10_calcula_rh_liner_12bit
      Sht10_command = &B00000011 : Gosub Sht10_get : Gosub Sht10_calcula_temp_14bit
      Gosub Display_sht
   End If

   If Status_mq2_disable = 0 Then Gosub Alarm_mq2
   If Status_mq7_disable = 0 Then Gosub Alarm_mq7
   If Status_mq135_disable = 0 Then Gosub Alarm_mq135

   If Key_set1 = 0 And Status_key_set1 = 0 Then
      Waitms 30
      If Key_set1 = 0 And Status_key_set1 = 0 Then
         Status_key_set1 = 1
         Gosub Sound_menu
         Toggle Status_display
         Cls
         If Status_display = 1 Then
          Gosub Sht10_signal_reset
         End If
      End If
   End If
   If Key_set1 = 1 Then Status_key_set1 = 0

   If Key_set2 = 0 And Status_key_set2 = 0 Then
      Waitms 30
      If Key_set2 = 0 And Status_key_set2 = 0 Then
         Status_key_set2 = 1
         Gosub Sound_menu
         'Toggle Status_mq7_disable
      End If
   End If
   If Key_set2 = 1 Then Status_key_set2 = 0

   If Key_set3 = 0 And Status_key_set3 = 0 Then
      Waitms 30
      If Key_set3 = 0 And Status_key_set3 = 0 Then
         Status_key_set3 = 1
         Gosub Sound_menu
         Toggle Status_disable
         If Status_disable = 0 Then
            Status_mq2_disable = 0
            Status_mq7_disable = 0
            Status_mq135_disable = 0
         Else
            Status_mq2_disable = 1
            Status_mq7_disable = 1
            Status_mq135_disable = 1
         End If
      End If
   End If
   If Key_set3 = 1 Then Status_key_set3 = 0

   Debounce Key_set4 , 0 , Setting_setpoint_mq2 , Sub
   Status = 0

   'Waitms 100
Loop

End

'*******************************************
Sht10_signal_reset:
   'Config Sht10_sck = Output
   Config Portb.1 = Output
   Reset Sht10_sck : Set Sht10_dataout : Waitus 1
   For K = 1 To 9
      Set Sht10_sck : : Waitus 1 :
      Reset Sht10_dataout : Waitus 1
   Next k
Return

'*******************************************
Sht10_get:
   Gosub Sht10_signal_start
   Gosub Sht10_send_command
   Gosub Sht10_signal_ack
   Gosub Sht10_wait_for_data_ready
   Gosub Sht10_read_byte : Sht10_data_msb = Sht10_data_byte
   Gosub Sht10_signal_ack
   Gosub Sht10_read_byte : Sht10_data_lsb = Sht10_data_byte
   Gosub Sht10_signal_ack
   Gosub Sht10_read_byte : Sht10_crc = Sht10_data_byte
   Gosub Sht10_signal_end
   Sht10_data_msb = Sht10_data_msb And &B00111111
   Sht10_data_word = Makeint(sht10_data_lsb , Sht10_data_msb)
Return

'*******************************************
Sht10_signal_start:
   'Config Sht10_sck = Output
   Config Portb.1 = Output
   Reset Sht10_sck : Set Sht10_dataout : Waitus 1
   Set Sht10_sck : : Waitus 1 :
   Reset Sht10_dataout : Waitus 1
   Reset Sht10_sck : Waitus 1
   Set Sht10_sck : Waitus 1
   Set Sht10_dataout : : Waitus 1
   Reset Sht10_sck : Waitus 1
   Sht10_crc = 0
Return

'*******************************************
Sht10_send_command:
   'Config Sht10_sck = Output : Sht10_sck = 0
   Config Portb.1 = Output : Portb.1 = 0
   Shiftout Sht10_dataout , Sht10_sck , Sht10_command , 1
Return

'*******************************************
Sht10_signal_ack:
   'Config Sht10_sck = Output
   Config Portb.1 = Output
   Reset Sht10_dataout : Reset Sht10_sck
   Set Sht10_sck : Waitus 1
   Reset Sht10_sck
   'Set Dataout
Return

'*******************************************
Sht10_wait_for_data_ready:
   'Config Sht10_sck = Output
   Config Portb.1 = Input : Portb.1 = 1
   For K = 1 To 255
      If Sht10_datain = 0 Then Exit For
      Waitms 1
   Next
Return

'*******************************************
Sht10_read_byte:
   'Config Sht10_sck = Output : Sht10_sck = 0
   Config Portb.1 = Input : Portb.1 = 1
   Shiftin Sht10_datain , Sht10_sck , Sht10_data_byte , 1
Return

'*******************************************
Sht10_signal_end:
   'Config Sht10_sck = Output
   Config Portb.1 = Output
   Set Sht10_dataout : Waitus 1
   Set Sht10_sck : Waitus 1
   Reset Sht10_sck : Waitus 1
Return

'*******************************************
Sht10_calcula_rh_liner_12bit:
   Sht10_rh_liner = Sht10_data_word * Sht10_data_word
   Sht10_rh_liner = Sht10_rh_liner * -0.0000015955
   Z1 = 0.0367 * Sht10_data_word
   Sht10_rh_liner = Sht10_rh_liner + Z1
   Sht10_rh_liner = Sht10_rh_liner - 2.0468
Return

'*******************************************
Sht10_calcula_temp_14bit:
   Sht10_temp = 0.01 * Sht10_data_word
   Sht10_temp = Sht10_temp - 40.1
Return


'**********************************
Setting_setpoint_mq2:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Smoke Detector"
   Locate 2 , 1 : Lcd "Setting: " ; Setpoint_mq2 ; "% "
   If Status_mq2_disable = 0 Then
      Locate 2 , 16 : Lcd " "
   Else
      Locate 2 , 16 : Lcd "X"
   End If
   Do
      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Setpoint_mq2
            If Setpoint_mq2 > 100 Then Setpoint_mq2 = 0
            Setpoint_mq2_eeprom = Setpoint_mq2
            Locate 2 , 1 : Lcd "Setting: " ; Setpoint_mq2 ; "%   "
            K = 0
         End If
      Loop Until Key_set1 = 1

      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Setpoint_mq2
            If Setpoint_mq2 > 100 Then Setpoint_mq2 = 100
            Setpoint_mq2_eeprom = Setpoint_mq2
            Locate 2 , 1 : Lcd "Setting: " ; Setpoint_mq2 ; "%   "
            K = 0
         End If
      Loop Until Key_set2 = 1

      If Key_set3 = 0 And Status_key_set3 = 0 Then
         Waitms 30
         If Key_set3 = 0 And Status_key_set3 = 0 Then
            Status_key_set3 = 1
            Gosub Sound_menu
            Toggle Status_mq2_disable
            If Status_mq2_disable = 0 Then
               Locate 2 , 16 : Lcd " "
            Else
               Locate 2 , 16 : Lcd "X"
            End If
         End If
      End If
      If Key_set3 = 1 Then Status_key_set3 = 0

      If Key_set4 = 0 And Status_key_set4 = 0 Then
         Waitms 30
         If Key_set4 = 0 And Status_key_set4 = 0 Then
            Status_key_set4 = 1
            Gosub Sound_menu
            Gosub Setting_setpoint_mq7
         End If
      End If
      If Key_set4 = 1 Then Status_key_set4 = 0

   Loop Until Status = 1
Return


'**********************************
Setting_setpoint_mq7:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "CO Detector"
   Locate 2 , 1 : Lcd "Setting: " ; Setpoint_mq7 ; "% "
   If Status_mq7_disable = 0 Then
      Locate 2 , 16 : Lcd " "
   Else
      Locate 2 , 16 : Lcd "X"
   End If
   Do
      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Setpoint_mq7
            If Setpoint_mq7 > 100 Then Setpoint_mq7 = 0
            Setpoint_mq7_eeprom = Setpoint_mq7
            Locate 2 , 1 : Lcd "Setting: " ; Setpoint_mq7 ; "%   "
            K = 0
         End If
      Loop Until Key_set1 = 1

      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Setpoint_mq7
            If Setpoint_mq7 > 100 Then Setpoint_mq7 = 100
            Setpoint_mq7_eeprom = Setpoint_mq7
            Locate 2 , 1 : Lcd "Setting: " ; Setpoint_mq7 ; "%   "
            K = 0
         End If
      Loop Until Key_set2 = 1

      If Key_set3 = 0 And Status_key_set3 = 0 Then
         Waitms 30
         If Key_set3 = 0 And Status_key_set3 = 0 Then
            Status_key_set3 = 1
            Gosub Sound_menu
            Toggle Status_mq7_disable
            If Status_mq7_disable = 0 Then
               Locate 2 , 16 : Lcd " "
            Else
               Locate 2 , 16 : Lcd "X"
            End If
         End If
      End If
      If Key_set3 = 1 Then Status_key_set3 = 0

      If Key_set4 = 0 And Status_key_set4 = 0 Then
         Waitms 30
         If Key_set4 = 0 And Status_key_set4 = 0 Then
            Status_key_set4 = 1
            Gosub Sound_menu
            Gosub Setting_setpoint_mq135
         End If
      End If
      If Key_set4 = 1 Then Status_key_set4 = 0

   Loop Until Status = 1
Return

'**********************************
Setting_setpoint_mq135:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "CO2 Detector"
   Locate 2 , 1 : Lcd "Setting: " ; Setpoint_mq135 ; "% "
   If Status_mq135_disable = 0 Then
      Locate 2 , 16 : Lcd " "
   Else
      Locate 2 , 16 : Lcd "X"
   End If
   Do
      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Setpoint_mq135
            If Setpoint_mq135 > 100 Then Setpoint_mq135 = 0
            Setpoint_mq135_eeprom = Setpoint_mq135
            Locate 2 , 1 : Lcd "Setting: " ; Setpoint_mq135 ; "%   "
            K = 0
         End If
      Loop Until Key_set1 = 1

      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Setpoint_mq135
            If Setpoint_mq135 > 100 Then Setpoint_mq135 = 100
            Setpoint_mq135_eeprom = Setpoint_mq135
            Locate 2 , 1 : Lcd "Setting: " ; Setpoint_mq135 ; "%   "
            K = 0
         End If
      Loop Until Key_set2 = 1

      If Key_set3 = 0 And Status_key_set3 = 0 Then
         Waitms 30
         If Key_set3 = 0 And Status_key_set3 = 0 Then
            Status_key_set3 = 1
            Gosub Sound_menu
            Toggle Status_mq135_disable
            If Status_mq135_disable = 0 Then
               Locate 2 , 16 : Lcd " "
            Else
               Locate 2 , 16 : Lcd "X"
            End If
         End If
      End If
      If Key_set3 = 1 Then Status_key_set3 = 0

      If Key_set4 = 0 And Status_key_set4 = 0 Then
         Waitms 30
         If Key_set4 = 0 And Status_key_set4 = 0 Then
            Status_key_set4 = 1
            Gosub Sound_menu
            Cls : Status = 1
         End If
      End If
      If Key_set4 = 1 Then Status_key_set4 = 0

   Loop Until Status = 1
Return

'**********************************
Read_mq2:
   W = Getadc(1)
   Input_voltage = W / 0.2048
   Input_voltage = Input_voltage / 1000
   Z1 = Input_voltage -setting_default_mq2 : Z1 = Z1 * 100
   Z2 = 5 - Setting_default_mq2
   Input_percent_mq2 = Z1 / Z2
Return

'**********************************
Read_mq7:
   W = Getadc(3)
   Input_voltage = W / 0.2048
   Input_voltage = Input_voltage / 1000
   Z1 = Input_voltage -setting_default_mq7 : Z1 = Z1 * 100
   Z2 = 5 - Setting_default_mq7
   Input_percent_mq7 = Z1 / Z2
Return

'**********************************
Read_mq135:
   W = Getadc(5)
   Input_voltage = W / 0.2048
   Input_voltage = Input_voltage / 1000
   Z1 = Input_voltage -setting_default_mq135 : Z1 = Z1 * 100
   Z2 = 5 - Setting_default_mq7
   Input_percent_mq135 = Z1 / Z2
Return

'**********************************
Display_sht:
   Deflcdchar 0 , 7 , 5 , 7 , 32 , 32 , 32 , 32 , 32
   Locate 1 , 1 : Lcd "Temp    Humidity"
   Locate 2 , 1 : Lcd Fusing(sht10_temp , "#.#") ; Chr(0) ; "C  "
   Locate 2 , 9 : Lcd Fusing(sht10_rh_liner , "#.#") ; "%    "
Return

'**********************************
Display_mq:
   Locate 1 , 1 : Lcd "Smoke  CO   CO2 "

   If Status_mq2_disable = 0 Then
      Locate 2 , 1 : Lcd Input_percent_mq2 ; "%   "
   Else
      Locate 2 , 1 : Lcd " X "
      Reset Relay_mq2
   End If

   If Status_mq7_disable = 0 Then
      Locate 2 , 8 : Lcd Input_percent_mq7 ; "%   "
   Else
      Locate 2 , 8 : Lcd " X "
      Reset Relay_mq7
   End If

   If Status_mq135_disable = 0 Then
      Locate 2 , 13 : Lcd Input_percent_mq135 ; "%    "
   Else
      Locate 2 , 13 : Lcd " X   "
      Reset Relay_mq135
   End If

Return

'**********************************
Alarm_mq2:
   Setpoint_mq2_max = Setpoint_mq2
   Setpoint_mq2_min = Setpoint_mq2 - 3
   If Input_percent_mq2 > Setpoint_mq2_max Then
      State_mq2_alarm = 1
      If Status_mq2_disable = 0 Then Set Relay_mq2
      Status_display = 0
      Gosub Sound_error : Gosub Sound_menu
   Elseif Input_percent_mq2 <= Setpoint_mq2_min Then
      State_mq2_alarm = 0
      Reset Relay_mq2
   End If
Return

'**********************************
Alarm_mq7:
   Setpoint_mq7_max = Setpoint_mq7
   Setpoint_mq7_min = Setpoint_mq7 - 3
   If Input_percent_mq7 > Setpoint_mq7_max Then
      State_mq7_alarm = 1
      If Status_mq7_disable = 0 Then Set Relay_mq7
      Status_display = 0
      Gosub Sound_error : Gosub Sound_menu
   Elseif Input_percent_mq7 <= Setpoint_mq7_min Then
      State_mq7_alarm = 0
      Reset Relay_mq7
   End If
Return

'**********************************
Alarm_mq135:
   Setpoint_mq135_max = Setpoint_mq135
   Setpoint_mq135_min = Setpoint_mq135 - 3
   If Input_percent_mq135 > Setpoint_mq135_max Then
      State_mq135_alarm = 1
      If Status_mq135_disable = 0 Then Set Relay_mq135
      Status_display = 0
      Gosub Sound_error : Gosub Sound_menu
   Elseif Input_percent_mq135 <= Setpoint_mq135_min Then
      State_mq135_alarm = 0
      Reset Relay_mq135
   End If
Return

'**********************************
Eeprom_default:
   Setpoint_mq2_eeprom = 30
   Setpoint_mq7_eeprom = 30
   Setpoint_mq135_eeprom = 30
   'Setting_default_mq2_eeprom = 0
   'Setting_default_mq7_eeprom = 0
   'Setting_default_mq135_eeprom = 0
Return

'**********************************
Eeprom_load:
   Setpoint_mq2 = Setpoint_mq2_eeprom
   Setpoint_mq7 = Setpoint_mq7_eeprom
   Setpoint_mq135 = Setpoint_mq135_eeprom
   Setting_default_mq2 = Setting_default_mq2_eeprom
   Setting_default_mq7 = Setting_default_mq7_eeprom
   Setting_default_mq135 = Setting_default_mq135_eeprom
Return

'**********************************
Eeprom_save:
   Setpoint_mq2_eeprom = Setpoint_mq2
   Setpoint_mq7_eeprom = Setpoint_mq7
   Setpoint_mq135_eeprom = Setpoint_mq135
Return

'**********************************
Sound_pressing:
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