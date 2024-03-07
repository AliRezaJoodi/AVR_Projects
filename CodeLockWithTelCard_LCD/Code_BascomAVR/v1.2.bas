               $regfile = "m16def.dat"
'$crystal = 11059200
$crystal = 8000000

Config Lcdpin = Pin , Rs = Portc.7 , E = Portc.5 , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Config Portd.7 = Output : Portd.7 = 0 : Relay Alias Portd.7
Config Portc.4 = Output : Portc.4 = 0 : Buzzer Alias Portc.4
Config Porta.6 = Output : Porta.6 = 0 : Led_green Alias Porta.6
Config Porta.7 = Output : Porta.7 = 0 : Led_red Alias Porta.7

Config Debounce = 30
Config Portd.4 = Input : Portd.4 = 0 : Key_get Alias Pind.4
Config Portd.5 = Input : Portd.5 = 0 : Key_register Alias Pind.5
Config Portd.6 = Input : Portd.6 = 0 : Key_unregister Alias Pind.6

Config Portb.4 = Output : Portb.4 = 0 : Telcard_rst Alias Portb.4
Config Portb.3 = Output : Portb.3 = 0 : Telcard_Clk Alias Portb.3
Config Portb.1 = Input : Portb.1 = 1 : Telcard_Data Alias Pinb.1
Config Portb.0 = Input : Portb.0 = 1 : Telcard_key Alias Pinb.0

Const Max_card = 128
Dim Capacity As Word                                        ': Capacity = 511
Capacity = Max_card * 4 : Capacity = Capacity -1

Dim D(65) As Byte
Dim I As Word
Dim J As Word

Dim K As Word
Dim Z1(5) As Byte

Dim Serialnumber As Long : Serialnumber = 0
Dim Z2 As Long
'Dim Sn_string As String * 11

Dim Status_key_get As Boolean
Dim Status_key_register As Boolean
Dim Status_key_unregister As Boolean
Dim Status_telcard_key1 As Boolean
Dim Status_telcard_key2 As Boolean

Locate 1 , 1 : Lcd "Code Lock"
Gosub Sound_ok

Do
   If Key_get = 0 And Status_key_get = 0 Then
      Status_key_get = 1
      Gosub Erase_variable
      Gosub Read_mode
      Gosub Read_data
      Gosub Calculation_sn
      Gosub Display_sn
      Gosub Open_the_door
   End If
   If Key_get = 1 Then Status_key_get = 0

   If Key_register = 0 And Status_key_register = 0 Then
      Status_key_register= 1
      Gosub Erase_variable
      Gosub Read_mode
      Gosub Read_data
      Gosub Calculation_sn
      Gosub Display_sn
      Gosub Register_card
   End If
   If Key_register = 1 Then Status_key_register = 0

   If Key_unregister = 0 And Status_key_unregister = 0 Then
      Status_key_unregister= 1
      Gosub Erase_variable
      Gosub Read_mode
      Gosub Read_data
      Gosub Calculation_sn
      Gosub Display_sn
      Gosub Unregister_card
   End If
   If Key_unregister = 1 Then Status_key_unregister = 0

   If Telcard_key = 0 And Status_telcard_key1 = 0 Then
      Status_telcard_key1 = 1
      Waitms 300
      Gosub Erase_variable
      Gosub Read_mode
      Gosub Read_data
      Gosub Calculation_sn
      Gosub Display_sn
      Gosub Open_the_door
   End If
   If Telcard_key = 1 Then Status_telcard_key1 = 0

   If Telcard_key = 1 And Status_telcard_key2 = 0 Then
      Status_telcard_key2 = 1
      'Serialnumber = 0 : Sn_string = ""
      Cls
      Locate 1 , 1 : Lcd "Code Lock"
   End If
   If Telcard_key = 0 Then Status_telcard_key2 = 0

   If Key_get = 0 And Key_register = 0 And Key_unregister = 0 Then
      Gosub Unregister_all_card
   End If
Loop

End

'***********************************************
Open_the_door:
   If D(5) = &HFF And D(6) = &HFF And D(7) = &HFF And D(8) = &HFF Then
      Set Led_red
      Gosub Sound_error
      Waitms 200 : Reset Led_green : Reset Led_red
      Goto End_open_the_door
   End If
   For K = 0 To Capacity Step 4
      I = K
      Readeeprom Z1(1) , I                                  ': Waitms 10
      Incr I : Readeeprom Z1(2) , I                         ': Waitms 10
      Incr I : Readeeprom Z1(3) , I                         ': Waitms 10
      Incr I : Readeeprom Z1(4) , I                         ': Waitms 10
      If Z1(1) = D(5) And Z1(2) = D(6) And Z1(3) = D(7) And Z1(4) = D(8) Then
         Set Led_green
         Gosub Sound_ok
         Set Relay : Waitms 800 : Reset Relay : Waitms 50
         Reset Led_green : Reset Led_red
         Goto End_open_the_door
      End If
   Next K
   Reset Led_green : Set Led_red
   Waitms 200 : Reset Led_green : Reset Led_red
   Gosub Sound_error
End_open_the_door:
Return


'***********************************************
Unregister_card:
   If D(5) = &HFF And D(6) = &HFF And D(7) = &HFF And D(8) = &HFF Then
      Set Led_red
      Gosub Sound_error
      Waitms 200 : Reset Led_green : Reset Led_red
      Goto End_unregister_card
   End If
   For K = 0 To Capacity Step 4
      I = K
      Readeeprom Z1(1) , I                                  ': Waitms 10
   If Z1(1) <> &HFF Then
      Incr I : Readeeprom Z1(2) , I                         ': Waitms 10
      Incr I : Readeeprom Z1(3) , I                         ': Waitms 10
      Incr I : Readeeprom Z1(4) , I                         ': Waitms 10
      If Z1(1) = D(5) And Z1(2) = D(6) And Z1(3) = D(7) And Z1(4) = D(8) Then
         Z1(1) = &HFF : Z1(2) = &HFF : Z1(3) = &HFF : Z1(4) = &HFF
         I = K
         Writeeeprom Z1(1) , I
         Incr I : Writeeeprom Z1(2) , I                     ': Waitms 10
         Incr I : Writeeeprom Z1(3) , I                     ': Waitms 10
         Incr I : Writeeeprom Z1(4) , I                     ': Waitms 10
         Set Led_red
         Gosub Sound_ok
         Waitms 200 : Reset Led_green : Reset Led_red
         Goto End_unregister_card
      End If
   End If
   Next K
   Set Led_red
   Gosub Sound_ok : Waitms 200 : Gosub Sound_ok
   Waitms 200 : Reset Led_green : Reset Led_red
   End_unregister_card:
Return


'***********************************************
Register_card:
   If D(5) = &HFF And D(6) = &HFF And D(7) = &HFF And D(8) = &HFF Then
      Set Led_red
      Gosub Sound_error
      Waitms 200 : Reset Led_green : Reset Led_red
      Goto End_register_card
   End If
   For K = 0 To Capacity Step 4
      I = K
      Readeeprom Z1(1) , I                                  ': Waitms 10
      Incr I : Readeeprom Z1(2) , I                         ': Waitms 10
      Incr I : Readeeprom Z1(3) , I                         ': Waitms 10
      Incr I : Readeeprom Z1(4) , I                         ': Waitms 10
      If Z1(1) = D(5) And Z1(2) = D(6) And Z1(3) = D(7) And Z1(4) = D(8) Then
         Set Led_green
         Gosub Sound_ok : Waitms 200 : Gosub Sound_ok
         Set Led_green : Reset Led_red
         Waitms 200 : Reset Led_green : Reset Led_red
         Goto End_register_card
      End If
   Next K
   For K = 0 To Capacity Step 4
      Readeeprom Z1(1) , K
      If Z1(1) = &HFF Then
         I = K
         Writeeeprom D(5) , I                               ': Waitms 10
         Incr I : Writeeeprom D(6) , I                      ': Waitms 10
         Incr I : Writeeeprom D(7) , I                      ': Waitms 10
         Incr I : Writeeeprom D(8) , I                      ': Waitms 10
         Set Led_green
         Gosub Sound_ok
         Set Led_green : Reset Led_red
         Waitms 200 : Reset Led_green : Reset Led_red
         Goto End_register_card
      End If
   Next K
   If K > Capacity Then
      Set Led_red
      Gosub Sound_error : Waitms 200 : Gosub Sound_error
      Waitms 200 : Reset Led_green : Reset Led_red
   End If
   End_register_card:
Return

'***********************************************
Read_mode:
   Set Telcard_rst
      Set Telcard_Clk
         Waitus 5
      Reset Telcard_Clk
   Reset Telcard_rst
Return

'***********************************************
Read_data:
   For J = 1 To 8
      For I = 1 To 8
         Set Telcard_Clk : Waitus 5
         Shift D(j) , Left
         If Telcard_Data = 1 Then
            D(j) = D(j) Or &B00000001
         End If
         Reset Telcard_Clk : Waitus 5
      Next I
   Next J



   Gosub Calculation_sn
   Gosub Display_sn


Return

'***********************************************
Display_sn:
   Cls
   Locate 1 , 1 : Lcd "Code Lock"
   'Lcd D(1) ; " " ; D(2) ; " " ; D(3) ; " " ; D(4) ; " ";
   If Serialnumber <> 0 Then
      'Sn_string = Str(serialnumber)
      Locate 2 , 1 : Lcd "SN:" ; "xxxx" ; Serialnumber
   'Else
      'Serialnumber = 0 : Sn_string = ""
   End If
   'Locate 2 , 1 : Lcd "SN:" ; "xxxx" ; Sn_string
Return

'***********************************************
Calculation_sn:
   Serialnumber = 0
   Z2 = 0 : Z2 = 256 ^ 2 : Z2 = Z2 * D(6) : Serialnumber = Serialnumber + Z2
   Z2 = 0 : Z2 = 256 ^ 1 : Z2 = Z2 * D(7) : Serialnumber = Serialnumber + Z2
   Z2 = 0 : Z2 = 256 ^ 0 : Z2 = Z2 * D(8) : Serialnumber = Serialnumber + Z2
   If Serialnumber = 16777215 Then Serialnumber = 0
Return

'***********************************************
Erase_variable:
   For I = 1 To 64
      D(i) = 0
   Next I
Return

'***********************************************
Unregister_all_card:
   Set Led_red
   Gosub Sound_ok
   Gosub Sound_error
   Gosub Sound_ok
   Z1(1) = &HFF
   For K = 0 To Capacity Step 1
      Writeeeprom Z1(1) , K                                 ': Waitms 10
   Next K
    Reset Led_green : Reset Led_red
Return

'***********************************************
Sound_error:
   Sound Buzzer , 50 , 3000
Return

'***********************************************
Sound_ok:
   Sound Buzzer , 100 , 250
Return

'***********************************************
Sound_menu:
   Sound Buzzer , 100 , 500
Return