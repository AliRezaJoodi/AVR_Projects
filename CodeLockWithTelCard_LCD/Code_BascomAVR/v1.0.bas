$regfile = "m16def.dat"
'$crystal = 11059200
$crystal = 8000000

Config Lcdpin = Pin , Rs = Portc.7 , E = Portc.5 , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0
Config Lcd = 16 * 2
Cursor Off
Cls
Locate 1 , 1 : Lcd "Code Lock"

Config Portd.7 = Output : Portd.7 = 0 : Relay Alias Portd.7
Config Portc.4 = Output : Portc.4 = 0 : Buzzer Alias Portc.4
Config Porta.6 = Output : Porta.6 = 0 : Led_green Alias Porta.6
Config Porta.7 = Output : Porta.7 = 0 : Led_red Alias Porta.7

Config Debounce = 30
Config Portd.4 = Input : Portd.4 = 0 : Key_start Alias Pind.4
Config Portd.5 = Input : Portd.5 = 0 : Key_register Alias Pind.5
Config Portd.6 = Input : Portd.6 = 0 : Key_unregister Alias Pind.6

Config Portb.4 = Output : Portb.4 = 0 : Rst Alias Portb.4
Config Portb.3 = Output : Portb.3 = 0 : Clk Alias Portb.3
Config Portb.1 = Input : Portb.1 = 1 : Data_pin Alias Pinb.1
Config Portb.0 = Input : Portb.0 = 1 : Telcard_key Alias Pinb.0

Const Max_card = 128
Dim Capacity As Word                                        ': Capacity = 511
Capacity = Max_card * 4 : Capacity = Capacity -1

Dim D(65) As Byte
Dim I As Word
Dim J As Word

Dim K As Word
Dim Z1(5) As Byte

Dim Serialnumber As Long
Dim Z2 As Long
Dim Sn_string As String * 11


If Key_unregister = 0 Then
   Waitms 30
   If Key_unregister = 0 Then
      Gosub Unregister_all_card                             ': Wait 3
   End If
End If

Gosub Sound_ok

Do
   Debounce Key_start , 0 , Open_the_door , Sub
   Debounce Key_register , 0 , Register_card , Sub
   Debounce Key_unregister , 0 , Unregister_card , Sub
   'Led_red = Not Telcard_key
Loop

End


'***********************************************
Open_the_door:
   Gosub Erase_variable
   Gosub Read_mode
   Gosub Read_data
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
   Gosub Erase_variable
   Gosub Read_mode
   Gosub Read_data
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
   Gosub Erase_variable
   Gosub Read_mode
   Gosub Read_data
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
   Set Rst
      Set Clk
         Waitus 5
      Reset Clk
   Reset Rst
Return

'***********************************************
Read_data:
   For J = 1 To 8
      For I = 1 To 8
         Set Clk : Waitus 5
         Shift D(j) , Left
         If Data_pin = 1 Then
            D(j) = D(j) Or &B00000001
         End If
         Reset Clk : Waitus 5
      Next I
   Next J

   Cls
   Locate 1 , 1 : Lcd "Code Lock"
   'Lcd D(1) ; " " ; D(2) ; " " ; D(3) ; " " ; D(4) ; " ";
   Serialnumber = 0
   Z2 = 0 : Z2 = 256 ^ 2 : Z2 = Z2 * D(6) : Serialnumber = Serialnumber + Z2
   Z2 = 0 : Z2 = 256 ^ 1 : Z2 = Z2 * D(7) : Serialnumber = Serialnumber + Z2
   Z2 = 0 : Z2 = 256 ^ 0 : Z2 = Z2 * D(8) : Serialnumber = Serialnumber + Z2

   Sn_string = Str(serialnumber)
   Locate 2 , 1 : Lcd "SN:" ; "xxxx" ; Serialnumber

Return

'***********************************************
Erase_variable:
   For I = 1 To 64
      D(i) = 0
   Next I
Return

'++++++++++++++++++++++++++++++++++++++++++++++++++
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