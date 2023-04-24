'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M16def.dat"
$crystal = 4000000
'$crystal = 11059200

Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Config Lcd = 16 * 2
Cursor Off
Cls


Config Portc.0 = Output : Portc.0 = 0
Config Portc.1 = Input : Portc.1 = 1

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

Config Portb.1 = Output : Portb.1 = 0 : Relay Alias Portb.1

Config Watchdog = 256
Stop Watchdog

Dim Status_up_key As Bit : Status_up_key = 1
Dim Status_set_key As Bit : Status_set_key = 1
Dim Status_down_key As Bit : Status_down_key = 1
Dim Status_left_key As Bit : Status_left_key = 1
Dim Status_right_key As Bit : Status_right_key = 1

'...........................................................................................................
Config Portb.0 = Output : Portb.0 = 0 : Sound_pin Alias Portb.0


Const Pres_key_max_timer = 20000


'Deflcdchar [0] , 14 , 4 , 4 , 4 , 4 , 4 , 4 , 14            ' Digital Meters
'Deflcdchar [1] , 17 , 17 , 17 , 17 , 31 , 31 , 31 , 31      'Bathometer

'...........................................................................................................
Dim Lentgh_msb As Byte : Lentgh_msb = 0
Dim Lentgh_lsb As Byte : Lentgh_lsb = 0
Dim Lentgh As Word : Lentgh = 0
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

Dim Lentgh_max As Word

Dim D As Word : D = 0

Dim Fixed As Word
Dim Fixed_eeprom As Eram Word

Sound Sound_pin , 300 , 350


'Offset = 0 : Capacity = 50 : Status_auto = 1 : Status_mode = 1
'Gosub Save_to_eeprom

Gosub Load_of_the_eeprom
Gosub Start_menu

Do

   Debounce Set_key , 0 , Setting_height , Sub

   If Status_mode = 0 Then
      If Depth > Fixed Then
         Set Relay
      Else
         Reset Relay
      End If
   End If

   If Right_key = 0 And Right_key <> Status_right_key Then
      Waitms 30
      If Right_key = 0 And Right_key <> Status_right_key Then
         Status_right_key = 0
         Gosub Sound_menu
         Status_mode = 0 : Status_mode_eeprom = 0
         'Cls : Locate 1 , 1 : Lcd "Bathometer:"
         Cls : Locate 1 , 1 : Lcd "Depth Measuring:"
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
            Gosub Get_srf05
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
            'Gosub Get_srf05
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
         Cls : Locate 1 , 1 : Lcd "Digital Meters:"
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
            Gosub Get_srf05
            Gosub Show_lentgh
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
            'Gosub Get_srf05
            'Gosub Show_depth
            Status_auto = 1 : Status_auto_eeprom = 1 : Start Timer2
         End If
      End If
      If Up_key = 1 Then Status_up_key = 1
   End If

Loop

End
'/////////////////////////////////////////////////     End Program

'***************************************************
Setting_height:
   Stop Timer2
   Gosub Sound_menu
   Cls : Lcd "Setting:"
   Locate 2 , 1 : Lcd "Height=" ; Height ; " CM"
Do
   K = 0
   Do
      Incr K
      If K > Pres_key_max_timer Then
         Gosub Sound_pressing
         Incr Height
         If Height > 400 Then Height = 0
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
         If Height > 400 Then Height = 400
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

'***************************************************
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
            If Offset > 400 Then Offset = 0
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
            If Offset > 400 Then Offset = 400
            Offset_eeprom = Offset
            Locate 2 , 1 : Lcd "OffSet=" ; Offset ; " CM  "
            K = 0
         End If
      Loop Until Down_key = 1
      K = 0

   If Set_key = 0 And Status_set_key = 0 Then
      Waitms 30
      If Set_key = 0 And Status_set_key = 0 Then
         Status_set_key = 1
         Gosub Sound_menu
         Gosub Setting_fixed
      End If
   End If
   If Set_key = 1 Then Status_set_key = 0



   Loop Until Status = 1
Return

'***************************************************
Setting_fixed:
   Cls : Lcd "Setting:"
   Locate 2 , 1 : Lcd "Fixed=" ; Fixed ; " CM"
   Do
      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Fixed
            If Fixed > 400 Then Fixed = 0
            Fixed_eeprom = Fixed
            Locate 2 , 1 : Lcd "Fixed=" ; Fixed ; " CM  "
            K = 0
         End If
      Loop Until Up_key = 1
      K = 0

      K = 0
      Do
         Incr K
         If K > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Fixed
            If Fixed > 400 Then Fixed = 400
            Fixed_eeprom = Fixed
            Locate 2 , 1 : Lcd "Fixed=" ; Fixed ; " CM  "
            K = 0
         End If
      Loop Until Down_key = 1
      K = 0

      Debounce Set_key , 0 , Menu_exit , Sub

   Loop Until Status = 1
Return

'***************************************************
Menu_exit:
   Gosub Sound_menu
   Start Watchdog
Return

'***************************************************
Start_menu:
   If Status_mode = 0 Then
      Cls : Locate 1 , 1 : Lcd "Depth Measuring:"
   Else
      Cls : Locate 1 , 1 : Lcd "Digital Meters:"
   End If

   If Status_auto = 1 Then Start Timer2
Return

'***************************************************
One_sec:
   Incr I
   If I > 675 Then
      Stop Timer2 : I = 0
      Gosub Get_srf05
      'Gosub Show_lentgh
      If Status_mode = 0 Then
         Gosub Show_depth
      Else
         Gosub Show_lentgh
      End If
      Start Timer2
   End If
Return

'***************************************************
Get_srf05:
   Pulseout Portc , 0 , 15
   Pulsein D , Pinc , 1 , 1
   Lentgh = D * 20 : Lentgh = Lentgh / 111
   'Lentgh = D * 10 : Lentgh = Lentgh / X
   'Lentgh = D * 335 : Lentgh = Lentgh / 1687
   'Lentgh = D * 335 : Lentgh = Lentgh / X : Lentgh = Lentgh + 1
Return

'***************************************************
Show_depth:
   Lentgh_max = Height + Offset
   Cls
   Locate 1 , 1 : Lcd "Depth Measuring:"
   If Lentgh <= Lentgh_max Then
      Depth = Height + Offset
      Depth = Depth - Lentgh
      Locate 2 , 1 : Lcd "Depth= " ; Depth ; " CM"
   Else
      Locate 2 , 1 : Lcd "Depth= ERROR"
   End If
Return

'***************************************************
Show_lentgh:
   Cls
   'Locate 1 , 1 : Lcd "DD=" ; D
   Locate 1 , 1 : Lcd "Digital Meters:"
   Locate 2 , 1 : Lcd "Lentgh= " ; Lentgh ; " CM"
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

'***************************************************
Save_to_eeprom:
   Status_mode_eeprom = Status_mode
   Offset_eeprom = Offset
   Height_eeprom = Height
   Status_auto_eeprom = Status_auto
Return

'***************************************************
Load_of_the_eeprom:
   Status_mode = Status_mode_eeprom
   Offset = Offset_eeprom
   Height = Height_eeprom
   Status_auto = Status_auto_eeprom
   Fixed = Fixed_eeprom
Return