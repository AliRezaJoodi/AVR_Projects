'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 11059200

'$PROG &HFF,&HFF,&HD3,&H00' generated. Take care that the chip supports all fuse bytes.

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Kbd = Portb , Debounce = 50 , Delay = 100

Config Portd.4 = Output : Portd.4 = 0 : Speaker Alias Portd.4

Config PortC.0 = Output: A1 Alias PortC.0': A1 = 0
Config Portc.1 = Output: B2 Alias Portc.1': B2 = 0
Config Portc.2 = Output: A2 Alias Portc.2': A2 = 0
Config PortC.3 = Output: B1 Alias PortC.3': B1 = 0
gosub Stepper_standby

Const Step_angle = 0.087890625

Dim Key As Byte
Dim Key_status As Byte

Dim Z As Byte

Dim Number_of_steps As Integer
Dim Timing(4) As Word
Dim Timing_eeprom(4) As Eram Word

Dim Direction As Byte
Dim Motion_mode As Bit

Dim Controler_data As Byte
Dim A As Byte                                               ': Controler_data = 128
Dim A_eeprom As Eram Byte
                                              ': Controler_data_eeprom = 128
Dim I As Integer

Dim J(4) As Byte

Dim I2 As Byte

Dim Status As Byte:Status=1
Dim Status_eeprom As Eram Byte                              ' : Status_eeprom = 1

Dim D As Single

Dim Rotation(4) As Single
Dim Rotation_eeprom(4) As Eram Single
Dim Degree As Single

Dim S As String * 16

Dim Z1 As String * 16

dim k1 as Integer
dim buffer_single as Single
dim buffer_integer as integer
dim buffer_string as String * 16
'Gosub T1

Main:

Key = Getkbd() : Key = Lookup(key , Read_key)
if key=14 then
   Gosub EEPROM_Default
   z=1
end if

Gosub Load_of_the_eeprom
Gosub Chek_degree : Gosub Lcd_driver : J(status) = 1
Gosub Sound_menu
'Gosub Test_motor
'Gosub Test_keypad
if z=1 then
   wait 1
   z=0
end if

Do
   Key = Getkbd() : Key = Lookup(key , Read_key)
   If Key <> Key_status Then
      Key_status = Key
      Select Case Key
         Case 10:
            Gosub Sound_menu
            Status = 1
            J(2) = 0 : J(3) = 0 : J(4) = 0
            If J(status) = 0 Then
               Status_eeprom = Status
               Gosub Lcd_driver
               J(status) = 1
            Elseif J(status) = 1 Then
               Gosub Chek_degree : Gosub Run
            End If
         Case 11:
            Gosub Sound_menu
            Status = 2
            J(1) = 0 : J(3) = 0 : J(4) = 0
            If J(status) = 0 Then
               Status_eeprom = Status
               Gosub Lcd_driver
               J(status) = 1
            Elseif J(status) = 1 Then
               Gosub Chek_degree : Gosub Run
            End If
         Case 12:
            Gosub Sound_menu
            Status = 3
            J(1) = 0 : J(2) = 0 : J(4) = 0
            If J(status) = 0 Then
               Status_eeprom = Status
               Gosub Lcd_driver
               J(status) = 1
            Elseif J(status) = 1 Then
               Gosub Chek_degree : Gosub Run
            End If
         Case 13:
            Gosub Sound_menu
            Status = 4
            J(1) = 0 : J(2) = 0 : J(3) = 0
            If J(status) = 0 Then
               Status_eeprom = Status
               Gosub Lcd_driver
               J(status) = 1
            Elseif J(status) = 1 Then
               Gosub Chek_degree : Gosub Run
            End If
         Case 14:
            Gosub Sound_menu
            Status = 1 : Gosub Chek_degree : Gosub Lcd_driver : Gosub Run
            Status = 2 : Gosub Chek_degree : Gosub Lcd_driver : Gosub Run
            Status = 3 : Gosub Chek_degree : Gosub Lcd_driver : Gosub Run
            Status = 4 : Gosub Chek_degree : Gosub Lcd_driver : Gosub Run
            Status_eeprom = Status
         Case 15:
            Gosub Sound_menu
            Cls : Locate 1 , 1 : Lcd "Rotation:"
            Locate 2 , 15 : Lcd "F" ; Status
            Z1 = "" : S = "" : Motion_mode = 0
            Do
               Key = Getkbd() : Key = Lookup(key , Read_key)
               If Key <> Key_status Then
                  Key_status = Key
                  Select Case Key
                     Case 0 To 9:
                        Gosub Sound_pressing
                        S = Str(key)
                        Z1 = Z1 + S
                        If Motion_mode = 0 And Z1 <> "" Then
                           Cls : Locate 1 , 1 : Lcd "Rotation:" ; "+" ; Z1
                           Locate 2 , 15 : Lcd "F" ; Status
                        Elseif Motion_mode = 1 And Z1 <> "" Then
                           Cls : Locate 1 , 1 : Lcd "Rotation:" ; "-" ; Z1
                           Locate 2 , 15 : Lcd "F" ; Status
                        End If
                     Case 10:
                        If Z1 <> "" Then Toggle Motion_mode
                        If Motion_mode = 0 And Z1 <> "" Then
                           Gosub Sound_menu
                           Cls : Locate 1 , 1 : Lcd "Rotation:" ; "+" ; Z1
                           Locate 2 , 15 : Lcd "F" ; Status
                        Elseif Motion_mode = 1 And Z1 <> "" Then
                           Gosub Sound_menu
                           Cls : Locate 1 , 1 : Lcd "Rotation:" ; "-" ; Z1
                           Locate 2 , 15 : Lcd "F" ; Status
                        Else
                           Gosub Sound_error
                        End If
                     Case 11:
                        Gosub Sound_menu
                        Z1 = "" : S = "" : Motion_mode = 0
                        Cls : Locate 1 , 1 : Lcd "Rotation:"
                        Locate 2 , 15 : Lcd "F" ; Status
                     Case 15:
                        If Z1 <> "" Then
                           'Gosub Sound_menu
                           If Motion_mode = 0 Then
                              Rotation(status) = Val(z1)
                           Else
                              Rotation(status) = Val(z1)
                              Rotation(status) = Rotation(status) * -1
                           End If
                        Else
                           'Gosub Sound_error
                        End If
                        Gosub Save_to_eeprom
                        Lable1:
                        Gosub Sound_menu
                        Cls : Lcd "Timing: "
                        Locate 2 , 15 : Lcd "F" ; Status
                        Z1 = ""
                        Do
                           Key = Getkbd() : Key = Lookup(key , Read_key)
                           If Key <> Key_status Then
                              Key_status = Key
                              Select Case Key
                                 Case 0 To 9:
                                    Gosub Sound_pressing
                                    S = Str(key)
                                    Z1 = Z1 + S
                                    If Z1 <> "" Then
                                       Cls : Locate 1 , 1 : Lcd "Timing: " ; Z1 ; "ms "
                                       Locate 2 , 15 : Lcd "F" ; Status
                                    Else
                                       Gosub Sound_error
                                    End If
                                 Case 11:
                                    Gosub Sound_menu
                                    Z1 = "" : S = ""
                                    Cls : Lcd "Timing: "
                                    Locate 2 , 15 : Lcd "F" ; Status
                                 Case 14:
                                    If Z1 <> "" Then
                                       Gosub Sound_menu
                                       Timing(status) = Val(z1)
                                    Else
                                       Gosub Sound_error
                                    End If
                                    Gosub Save_to_eeprom
                                    Goto Main
                                 Case 15:
                                    If Z1 <> "" Then
                                       Gosub Sound_menu
                                       Timing(status) = Val(z1)
                                    Else
                                       Gosub Sound_error
                                    End If
                                    Gosub Save_to_eeprom
                                    Goto Main
                                 Case 10 : Gosub Sound_error
                                 Case 12 : Gosub Sound_error
                                 Case 13 : Gosub Sound_error
                              End Select
                           End If
                        Loop
                     Case 14:
                        If Z1 <> "" Then
                           'Gosub Sound_menu
                           If Motion_mode = 0 Then
                              Rotation(status) = Val(z1)
                           Else
                              Rotation(status) = Val(z1)
                              Rotation(status) = Rotation(status) * -1
                           End If
                        Else
                           'Gosub Sound_error
                        End If
                        Gosub Save_to_eeprom
                        'Goto Main
                        Goto Lable1
                     Case 12 : Gosub Sound_error
                     Case 13 : Gosub Sound_error
                  End Select
               End If
            Loop
         Case 0 To 9 : Gosub Sound_error
      End Select
   End If

Loop

End

'****************************************************
Test_keypad:
   Do
      Key = Getkbd()                                        ': Key = Lookup(key , Read_key)
      Cls : Lcd Key
   Loop
Return

'****************************************************
Test_motor:
   Do
      SET A1:RESET A2:RESET B1:RESET B2 :Waitms 3:incr k1
      SET A1:RESET A2:SET B1:RESET B2 :Waitms 3:incr k1
      RESET A1:RESET A2:SET B1:RESET B2 :Waitms 3:incr k1
      RESET A1:SET A2:SET B1:RESET B2 :Waitms 3:incr k1
      RESET A1:SET A2:RESET B1:RESET B2 :Waitms 3:incr k1
      RESET A1:SET A2:RESET B1:SET B2 :Waitms 3:incr k1
      RESET A1:RESET A2:RESET B1:SET B2 :Waitms 3:incr k1
      SET A1:RESET A2:RESET B1:SET B2 :Waitms 3:incr k1
   Loop until k1>=4096
   RESET A1:RESET A2:RESET B1:RESET B2
Return

'***************************************************
T0:
   Cls
   Locate 1 , 1 : Lcd "Sajad"
   End
Return

'***************************************************
T1:
   Status_eeprom = 1
   Rotation_eeprom(1) = -181 : Timing_eeprom(1) = 200
   Rotation_eeprom(2) = 360 : Timing_eeprom(2) = 200
   Rotation_eeprom(3) = 30 : Timing_eeprom(3) = 200
   Rotation_eeprom(4) = 90 : Timing_eeprom(4) = 500
Return

'***************************************************
Load_of_the_eeprom:
   Status = Status_eeprom
   For I = 1 To 4
      Timing(i) = Timing_eeprom(i) : Waitms 10
      Rotation(i) = Rotation_eeprom(i) : Waitms 10
   Next I
Return

'***************************************************
Save_to_eeprom:
   Status_eeprom = Status
   For I = 1 To 4
      Timing_eeprom(i) = Timing(i) : Waitms 10
      Rotation_eeprom(i) = Rotation(i) : Waitms 10
   Next I
Return

'***************************************************
EEPROM_Default:
   Status_eeprom = Status
   Rotation_eeprom(1) = 360 : Waitms 10
   Timing_eeprom(1) = 1 : Waitms 10

   Rotation_eeprom(2) = -90 : Waitms 10
   Timing_eeprom(2) = 1 : Waitms 10

   Rotation_eeprom(3) = 90 : Waitms 10
   Timing_eeprom(3) = 1 : Waitms 10

   Rotation_eeprom(4) = -360 : Waitms 10
   Timing_eeprom(4) = 1 : Waitms 10
Return

'***************************************************
Chek_degree:
   Degree = Abs(rotation(status))
   Number_of_steps = Degree \ Step_angle
   'Number_of_steps = Number_of_steps * 2
   'Degree = Number_of_steps / 2 :
   'Degree = Degree * Step_angle
   If Rotation(status) > 0 Then
      Rotation(status) = Degree
   Elseif Rotation(status) < 0 Then
      Rotation(status) = Degree * -1
   End If
   Rotation_eeprom(status) = Rotation(status)
Return

'***************************************************
Run:
   'Locate 1 , 1 : Lcd Number_of_steps
   If Rotation(status) < 0 Then
      Gosub Half_step_driver_clockwise
   Elseif Rotation(status) > 0 Then
      Gosub Half_step_driver_anticlockwise
   End If
   'Gosub Stepper_standby
Return

'***************************************************
Lcd_driver:
   'buffer_single=round(Rotation(status)):buffer_string=STR(buffer_single)
   buffer_integer=Rotation(status)
   buffer_string = Str(buffer_integer)

   If Rotation(status) <= 0 Then
      Cls: Locate 1 , 1: Lcd "Rotation:"; buffer_string


      '; FUSING(Rotation(status),"#.#");" "
      '; Rotation(status) ; "   "
      's=str(Rotation(status))
      'LCD FUSING(Rotation(status),"#.#")
   Else
      Cls : Locate 1 , 1 : Lcd "Rotation:";Format(buffer_string , "+" )

      'buffer_string = Format(buffer_string , "+" )
      'Lcd buffer_string
   'Else
      'Cls : Locate 1 , 1 : Lcd "Rotation:" ; 0
   End If
   Locate 2 , 1 : Lcd "Timing:" ; Timing(status) ; "ms  "
   Locate 2 , 15 : Lcd "F" ; Status
Return

'***************************************************
Half_step_driver_anticlockwise:
   I = 0
   A = A_eeprom: waitms 10
   Do
      Incr I
      A = A + 1 : If A > 7 Then A = 0
      Controler_data = Lookup(a , Stepper_data)
      'A_eeprom = A
      D = D - 7.5
      Gosub Stepper_driver
      'Locate 2 , 1 : Lcd I
      'Gosub Lcd_drive
      Waitms Timing(status)
   Loop Until I >= Number_of_steps
   A_eeprom = A: waitms 10
Return

'***************************************************
Half_step_driver_clockwise:
   I = 0
   A = A_eeprom: waitms 10
   Do
      Incr I
      A = A - 1 : If A > 7 Then A = 7
      Controler_data = Lookup(a , Stepper_data)
      'A_eeprom = A
      D = D + 7.5
      Gosub Stepper_driver
      'Gosub Lcd_drive
      Waitms Timing(status)
   Loop Until I >= Number_of_steps
   A_eeprom = A: waitms 10
Return

'***************************************************
Stepper_driver:
   A1=Controler_data.0
   B1=Controler_data.1
   A2=Controler_data.2
   B2=Controler_data.3
Return

'***************************************************
Stepper_standby:
   RESET A1:RESET A2:RESET B1:RESET B2
Return

'***************************************************
Sound_pressing:
   Sound Speaker , 100 , 250
Return

'***************************************************
Sound_menu:
   Sound Speaker , 100 , 500
Return

'***************************************************
Sound_error:
   Sound Speaker , 30 , 2000
Return

'***************************************************
Read_key:
Data 1 , 4 , 7 , 15 , 2 , 5 , 8 , 0 , 3 , 6 , 9 , 14 , 10 , 11 , 12 , 13 , 16

'***************************************************
Stepper_data:
Data &B00000001
Data &B00000011
Data &B00000010
Data &B00000110
Data &B00000100
Data &B00001100
Data &B00001000
Data &B00001001