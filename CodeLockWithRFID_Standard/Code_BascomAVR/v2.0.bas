$regfile = "m8def.dat"
$crystal = 11059200

$baud = 9600
Enable Interrupts
Enable Urxc
On Urxc Uart_reciver

Config Timer1 = Timer , Prescale = 1024
On Timer1 Lable
Enable Timer1                                               ' Or  Enable Ovf1
Stop Timer1

Config Portc.5 = Output : Portc.5 = 0 : Relay Alias Portc.5
Config Portc.4 = Output : Portc.4 = 0 : Sound_pin Alias Portc.4
Config Portd.7 = Output : Portd.7 = 0 : Led_green Alias Portd.7
Config Portd.6 = Output : Portd.6 = 0 : Led_red Alias Portd.6
Config Portc.2 = Input : Portc.2 = 1 : Key_register Alias Pinc.2
Config Portc.3 = Input : Portc.3 = 1 : Key_unregister Alias Pinc.3

Const Max_card = 46

Dim Buffer_uart As Byte
Dim Buffer_serial_number As String * 10 : Buffer_serial_number = ""
Dim Serial_number(max_card) As String * 10
Dim Serial_number_eeprom(max_card) As Eram String * 10
Dim I As Byte
Dim Status_active As Byte : Status_active = 0
Dim Status_mode As Byte : Status_mode = 0

Dim Status_key_register As Bit : Status_key_register = 0
Dim Status_key_unregister As Bit : Status_key_unregister = 0
Dim Status_key_unregister_all As Bit : Status_key_unregister_all = 0

Gosub Eeprom_load
Gosub Sound_menu

If Key_unregister = 0 And Status_key_unregister = 0 Then
   Waitms 30
   If Key_unregister = 0 And Status_key_unregister = 0 Then
      Status_key_unregister_all = 1
      Set Led_red
      Gosub Eeprom_unregister_all
      Gosub Eeprom_load
   End If
End If
Do
Loop Until Key_unregister = 1
Status_key_unregister = 0 : Reset Led_red

Do

   If Key_register = 0 And Status_key_register = 0 Then
      Waitms 30
      If Key_register = 0 And Status_key_register = 0 Then
         Status_key_register = 1
         Status_mode = 1
         Timer1 = 0
         Gosub Sound_pressing
         Reset Led_red : Reset Led_green
         Set Led_green
         Timer1 = 0 : Start Timer1
      End If
   End If
   If Key_register = 1 Then Status_key_register = 0

   If Key_unregister = 0 And Status_key_unregister = 0 Then
      Waitms 30
      If Key_unregister = 0 And Status_key_unregister = 0 Then
         Status_key_unregister = 1
         Status_mode = 2

         Gosub Sound_pressing
         Reset Led_red : Reset Led_green
         Set Led_red
         Timer1 = 0 : Start Timer1
      End If
   End If
   If Key_unregister = 1 Then Status_key_unregister = 0
Loop

End

Lable:
   Stop Timer1
   Status_mode = 0 : Reset Led_green : Reset Led_red
Return

'***************************************************
Unregister_card:
      For I = 1 To Max_card
         If Serial_number(i) = Buffer_serial_number Then
            Serial_number(i) = "" : Serial_number_eeprom(i) = Serial_number(i)
            Buffer_serial_number = ""
            Gosub Sound_menu
            Gosub Run_error : Return
         End If
      Next I
      Gosub Sound_menu
   Buffer_serial_number = ""
Return

'***************************************************
Register_card:
      For I = 1 To Max_card
         If Serial_number(i) = Buffer_serial_number Then
         Gosub Sound_menu : Return
         End If
      Next

      For I = 1 To Max_card
         If Serial_number(i) = "" Then
            Serial_number(i) = Buffer_serial_number : Serial_number_eeprom(i) = Serial_number(i)
            Buffer_serial_number = ""
            Gosub Sound_menu : Return
         End If
      Next I
      Reset Led_green : Set Led_red
      Gosub Sound_error : Waitms 100 : Gosub Sound_error
      Waitms 200 : Reset Led_green : Reset Led_red
      Waitms 800 : Cls
   Buffer_serial_number = ""
Return

'***************************************************
Uart_reciver:
   Buffer_uart = Udr
   Select Case Buffer_uart
      Case 48 To 57:
         Buffer_serial_number = Buffer_serial_number + Chr(buffer_uart)
      Case 13:
         'Print Buffer_serial_number
         Locate 1 , 1 : Lcd Buffer_serial_number ; "      "
         If Status_mode = 0 Then
            Timer1 = 0 : Start Timer1
            Gosub Open_the_door
         End If
         If Status_mode = 1 Then
            Gosub Register_card
            Reset Led_green : Reset Led_red
            Status_mode = 0
         End If
         If Status_mode = 2 Then
            Gosub Unregister_card
            Reset Led_green : Reset Led_red
            Status_mode = 0
         End If
         Buffer_serial_number = ""

   End Select
Return

'***********************************************
Open_the_door:
   Status_active = 0
   For I = 1 To Max_card
      If Serial_number(i) = Buffer_serial_number Then
         Status_active = I                                  ': I = Max_card
      End If
   Next I
   If Status_active = 0 Then
      Gosub Sound_error
      Gosub Run_error
   Else
      Gosub Sound_menu
      Gosub Run_ok
   End If
Return

'***********************************************
Run_error:
   Set Led_red : Waitms 300
   Reset Led_green : Reset Led_red
Return

'***********************************************
Run_ok:
   Set Led_green
   Set Relay : Waitms 800 : Reset Relay : Waitms 50
   Reset Led_green : Reset Led_red
Return

'***************************************************
Eeprom_load:
   For I = 1 To Max_card
      Serial_number(i) = Serial_number_eeprom(i)
   Next I
Return

'***************************************************
Eeprom_save:
   For I = 1 To Max_card
      Serial_number_eeprom(i) = Serial_number(i)
   Next I
Return

'***************************************************
Eeprom_unregister_all:
   For I = 1 To Max_card
      Serial_number_eeprom(i) = ""
   Next I
   Gosub Sound_menu : Waitms 50 : Gosub Sound_menu
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
   Sound Sound_pin , 50 , 3000
Return