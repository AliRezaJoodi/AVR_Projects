'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 11059200

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Scl = Portc.0
Config Sda = Portc.1
Const Rs02w = &HE0
Const Rs02r = &HE1

Enable Interrupts
Config Timer2 = Timer , Prescale = 32
Enable Ovf2
On Ovf2 One_sec
Stop Timer2
Timer2 = 0

'Config Portd.6 = Input : Portd.6 = 1
Config Debounce = 30
Config Portd.3 = Input : Portd.3 = 1 : Up_key Alias Pind.3
Config Portd.4 = Input : Portd.4 = 1 : Set_key Alias Pind.4
Config Portd.5 = Input : Portd.5 = 1 : Down_key Alias Pind.5
Config Portd.2 = Input : Portd.2 = 1 : Left_key Alias Pind.2
Config Portd.6 = Input : Portd.6 = 1 : Right_key Alias Pind.6

Config Watchdog = 256
Stop Watchdog

Dim Status_up_key As Bit : Status_up_key = 1
Dim Status_set_key As Bit : Status_set_key = 1
Dim Status_down_key As Bit : Status_down_key = 1
Dim Status_left_key As Bit : Status_left_key = 1
Dim Status_right_key As Bit : Status_right_key = 1

Config Portb.0 = Output : Portb.0 = 0 : Sound_pin Alias Portb.0

Const Pres_key_max_timer = 20000

Deflcdchar 0 , 14 , 4 , 4 , 4 , 4 , 4 , 4 , 14              ' Digital Meters
Deflcdchar 1 , 17 , 17 , 17 , 17 , 31 , 31 , 31 , 31        'Bathometer

Dim distance_msb As Byte : distance_msb = 0
Dim distance_lsb As Byte : distance_lsb = 0
Dim distance As Word : distance = 0
Dim Time_delay As Byte : Time_delay = 70

Dim Status_mode As Byte
Dim Status_mode_eeprom As Eram Byte

Dim Status_auto As Byte
Dim Status_auto_eeprom As Eram Byte

Dim Status As Bit

Dim I As Word : I = 0
Dim K As Word : K = 0

Dim Offset As Word
Dim Offset_eeprom As Eram Word
Dim Depth As Word
Dim Height As Word
Dim Height_eeprom As Eram Word

Dim distance_max As Word
Dim Diagonal As Word : Diagonal = 100
Dim Capacity As Single

Sound Sound_pin , 300 , 350

'Offset = 0 : Height = 50 : Status_auto = 1 : Status_mode = 1
'Gosub Save_to_eeprom

Gosub Load_of_the_eeprom
Gosub Start_menu

Do
   Debounce Set_key , 0 , Setting_height , Sub

   If Right_key = 0 And Right_key <> Status_right_key Then
      Waitms 30
      If Right_key = 0 And Right_key <> Status_right_key Then
         Status_right_key = 0
         Gosub Sound_menu
         Status_mode = 0 : Status_mode_eeprom = 0
         'Cls : Locate 1 , 1 : Lcd "Bathometer:"
         Cls : Locate 1 , 1 : Lcd "Depth Measuring"
         'Locate 2 , 8 : Lcd Chr(1)
      End If
   End If
   If Right_key = 1 Then Status_right_key = 1

   If Status_mode = 0 Then
      If Down_key = 0 And Down_key <> Status_down_key Then
         Waitms 30
         If Down_key = 0 And Down_key <> Status_down_key Then
            Status_down_key = 0
            Gosub Sound_pressing
            Status_auto = 0 : Status_auto_eeprom = 0 : Stop Timer2
            Gosub Get_srf02
            Gosub Show_depth
         End If
      End If
      If Down_key = 1 Then Status_down_key = 1
   End If

   If Status_mode = 0 Then
      If Up_key = 0 And Up_key <> Status_up_key Then
         Waitms 30
         If Up_key = 0 And Up_key <> Status_up_key Then
            Status_up_key = 0
            Gosub Sound_pressing
            'Gosub Get_srf02
            'Gosub Show_depth
            Status_auto = 1 : Status_auto_eeprom = 1 : Start Timer2
         End If
      End If
      If Up_key = 1 Then Status_up_key = 1
   End If

   If Left_key = 0 And Left_key <> Status_left_key Then
      Waitms 30
      If Left_key = 0 And Left_key <> Status_left_key Then
         Status_left_key = 0
         Gosub Sound_menu
         Status_mode = 1 : Status_mode_eeprom = 1
         Cls : Locate 1 , 1 : Lcd " Digital Meters "
         'Locate 2 , 8 : Lcd Chr(0)
      End If
   End If
   If Left_key = 1 Then Status_left_key = 1

   If Status_mode = 1 Then
      If Down_key = 0 And Down_key <> Status_down_key Then
         Waitms 30
         If Down_key = 0 And Down_key <> Status_down_key Then
            Status_down_key = 0
            Gosub Sound_pressing
            Status_auto = 0 : Status_auto_eeprom = 0 : Stop Timer2
            Gosub Get_srf02
            Gosub Show_distance
         End If
      End If
      If Down_key = 1 Then Status_down_key = 1
   End If

   If Status_mode = 1 Then
      If Up_key = 0 And Up_key <> Status_up_key Then
         Waitms 30
         If Up_key = 0 And Up_key <> Status_up_key Then
            Status_up_key = 0
            Gosub Sound_pressing
            'Gosub Get_srf02
            'Gosub Show_depth
            Status_auto = 1 : Status_auto_eeprom = 1 : Start Timer2
         End If
      End If
      If Up_key = 1 Then Status_up_key = 1
   End If
Loop

End

'*********************************
Setting_height:
   Stop Timer2
   Cls : Lcd "Setting:"
   Locate 2 , 1 : Lcd "Height=" ; Height ; " CM"
Do
   K = 0
   Do
      Incr K
      If K > Pres_key_max_timer Then
         Gosub Sound_pressing
         Incr Height
         If Height > 600 Then Height = 0
         Height_eeprom = Height
         Locate 2 , 1 : Lcd "Height=" ; Height ; " CM  "
         K = 0
      End If
   Loop Until Up_key = 1
   K = 0

   K = 0
   Do
      Incr K
      If K > Pres_key_max_timer Then
         Gosub Sound_pressing
         Decr Height
         If Height > 600 Then Height = 600
         Height_eeprom = Height
         Locate 2 , 1 : Lcd "Height=" ; Height ; " CM  "
         K = 0
      End If
   Loop Until Down_key = 1
   K = 0

   If Set_key = 0 And Status_set_key = 0 Then
      Waitms 30
      If Set_key = 0 And Status_set_key = 0 Then
         Status_set_key = 1
         Gosub Sound_menu
         Gosub Setting_offset
      End If
   End If
   If Set_key = 1 Then Status_set_key = 0

Loop Until Status = 1
Return

'*********************************
Setting_offset:
   'Status_set_key = 0
   Cls : Lcd "Setting:"
   Locate 2 , 1 : Lcd "OffSet=" ; Offset ; " CM"
   Do
      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Offset
            If Offset > 600 Then Offset = 0
            Offset_eeprom = Offset
            Locate 2 , 1 : Lcd "OffSet=" ; Offset ; " CM  "
            K = 0
         End If
      Loop Until Up_key = 1
      K = 0

      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Offset
            If Offset > 600 Then Offset = 600
            Offset_eeprom = Offset
            Locate 2 , 1 : Lcd "OffSet=" ; Offset ; " CM  "
            K = 0
         End If
      Loop Until Down_key = 1
      K = 0

      Debounce Set_key , 0 , Menu_exit , Sub

   Loop Until Status = 1
Return

'*********************************
Menu_exit:
   Gosub Sound_menu
   'Start Watchdog
Return

'*********************************
Start_menu:
   If Status_mode = 0 Then
      Cls : Locate 1 , 1 : Lcd "Depth Measuring"
      'Locate 2 , 8 : Lcd Chr(1)
   Else
      Cls : Locate 1 , 1 : Lcd " Digital Meters "
      'Locate 2 , 8 : Lcd Chr(0)
   End If

   If Status_auto = 1 Then Start Timer2
Return

'*********************************
Save_to_eeprom:
   Status_mode_eeprom = Status_mode
   Offset_eeprom = Offset
   Height_eeprom = Height
   Status_auto_eeprom = Status_auto
Return

'*********************************
Load_of_the_eeprom:
   Status_mode = Status_mode_eeprom
   Offset = Offset_eeprom
   Height = Height_eeprom
   Status_auto = Status_auto_eeprom
Return

'*********************************
One_sec:
   Incr I
   If I > 675 Then
      Stop Timer2 : I = 0
      Gosub Get_srf02
      'Gosub Show_distance
      If Status_mode = 0 Then
         Gosub Show_depth
      Else
         Gosub Show_distance
      End If
      Start Timer2
   End If
Return

'*********************************
Get_srf02:
   'If Z = 0 Then Sound Buzzer , 200 , 300
   I2cstart
   I2cwbyte Rs02w
   I2cwbyte 0
   I2cwbyte &H51
   I2cstop : Waitms Time_delay
   I2cstart
   I2cwbyte Rs02w
   I2cwbyte 2
   I2cstop : Waitms Time_delay
   I2cstart
   I2cwbyte Rs02r
   I2crbyte distance_msb , Ack
   I2crbyte distance_lsb , Nack
   I2cstop : Waitms Time_delay
   distance = Makeint(distance_lsb , distance_msb)
   'Reset Buzzer
   'Gosub Show_distance
Return

'*********************************
Show_depth:
   distance_max = Height + Offset
   Cls
   If distance <= distance_max Then
      Depth = Height + Offset
      Depth = Depth - distance
      'Depth = 20
      Locate 1 , 1 : Lcd Chr(0) : Lcd ": " ; Depth ; " CM"
      Capacity = Diagonal / 2
      Capacity = Capacity * Capacity
      Capacity = Capacity * 3.14
      Capacity = Capacity * Depth
      Capacity = Capacity / 1000
      Locate 2 , 1 : Lcd Chr(1) : Lcd ": " ; Fusing(capacity , "#.##") ; " m^3"
   Else
      Locate 1 , 1 : Lcd Chr(0) : Lcd ": " ; "ERROR"
      Locate 2 , 1 : Lcd Chr(1) : Lcd ": " ; "ERROR"
   End If
Return

'*********************************
Show_distance:
   Cls
   Locate 1 , 1 : Lcd "Digital Meters:"
   Locate 2 , 1 : Lcd "Distance= " ; Distance ; "CM  "
Return


'*********************************
Sound_pressing:
   Sound Sound_pin , 100 , 250
Return

'*********************************
Sound_menu:
   Sound Sound_pin , 100 , 500
Return

'*********************************
Sound_error:
   Sound Sound_pin , 30 , 2000
Return