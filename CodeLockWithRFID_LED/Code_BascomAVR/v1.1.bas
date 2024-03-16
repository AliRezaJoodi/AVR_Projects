$regfile = "m16def.dat"
$crystal = 11059200

$baud = 9600
Enable Interrupts
Enable Urxc
On Urxc Uart_reciver

Config Porta.1 = Input
Config Portd.3 = Input

Config Portc.0 = Output : Portc.0 = 0 : Relay Alias Portc.0
Config Portd.7 = Output : Portd.7 = 0 : Sound_pin Alias Portd.7
Config Portd.6 = Output : Portd.6 = 0 : Led_green Alias Portd.6
Config Portd.5 = Output : Portd.5 = 0 : Led_red Alias Portd.5

'Config Debounce = 30
Config Porta.3 = Input : Porta.3 = 1 : Key_register Alias Pina.3
Config Portc.7 = Input : Portc.7 = 1 : Key_unregister Alias Pinc.7
Config Portc.3 = Input : Portc.3 = 1 : Key_unregister_all Alias Pinc.3

Const Max_card = 5

Dim Buffer_uart As Byte
Dim Buffer_serial_number As String * 10 : Buffer_serial_number = ""
Dim Serial_number(max_card) As String * 10
Dim Serial_number_eeprom(max_card) As Eram String * 10
Dim I As Byte
Dim Status_active As Byte : Status_active = 0
Dim Status_mode As Byte : Status_mode = 0

'Gosub Eeprom_del
Gosub Eeprom_load
Gosub Sound_menu
'Gosub P1
Print "ok"

Do
   'Debounce Key_register , 0 , P1 , Sub
   'Debounce Key_register , 0 , P1 , Sub
   'Debounce Key_unregister , 0 , Eeprom_unregister_all , Sub
   If Key_register = 0 Then
      Waitms 30
      If Key_register = 0 Then
         Status_mode = 1
      End If
   End If

   If Key_unregister = 0 Then
      Waitms 30
      If Key_unregister = 0 Then
         Gosub Eeprom_unregister_all
         Gosub Eeprom_load
      End If
   End If
   'Led_red = Key_unregister_all
Loop

End

'***************************************************
register_card:
   Status_active = 0
   For I = 1 To Max_card
      If Serial_number(i) = Buffer_serial_number Then
         Status_active = I
      End If
   Next I
   If Status_active = 0 Then
      For I = 1 To Max_card
         If Serial_number(i) <> "" Then
            Serial_number(i) = Buffer_serial_number : Serial_number_eeprom(i) = Serial_number(i)
            Buffer_serial_number = ""
            'Serial_number(i) = Buffer_serial_number
            Gosub Run_ok : Return
         End If
      Next I
   Else
      Set Led_green
      Gosub Sound_error : Waitms 100 : Gosub Sound_error
      Waitms 200 : Reset Led_green : Reset Led_red
   End If
   Buffer_serial_number = ""
End_register_card:
Return

'***************************************************
Uart_reciver:
   Buffer_uart = Udr
   Select Case Buffer_uart
      Case 48 To 57:
         Buffer_serial_number = Buffer_serial_number + Chr(buffer_uart)
      Case 13:
         'Gosub Sound_menu
         Print Buffer_serial_number
         'Serial_number(19) = Buffer_serial_number : Serial_number_eeprom(19) = Serial_number(19)
         If Status_mode = 0 Then Gosub Open_the_door
         'Buffer_serial_number = ""
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
P1:
   For I = 1 To Max_card
      Print "Serial_number(" ; I ; ")= " ; Serial_number(i)
   Next I
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
   Sound Sound_pin , 30 , 3000
Return