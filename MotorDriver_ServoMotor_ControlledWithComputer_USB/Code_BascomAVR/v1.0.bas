'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200

Enable Interrupts
$baud = 9600
On Urxc Uart_receiver
Enable Urxc

Const Servo1_min = 40
Const Servo1_normal = 90
Const Servo1_max = 145

Config Portc.1 = Output : Portc.1 = 0
Config Portc.6 = Output : Portc.6 = 0
Config Porta.7 = Output : Porta.7 = 0
Config Porta.2 = Output : Porta.2 = 0
Config Servos = 4 , Servo1 = Portc.1 , Servo2 = Portc.6 , Servo3 = Porta.7 , Servo4 = Porta.2 , Reload = 10

Dim Uart As Byte
Dim S As String * 16 : S = ""
Dim Z As String * 3

Dim Device As String * 1
Dim Controler_data As Byte

Dim D_eeprom(4) As Eram Byte

Gosub Eeprom_load  
Gosub Display_start_text

Do

Loop

End

'**************************************************************
Eeprom_load:
   Controler_data = D_eeprom(1) : Servo(1) = Controler_data
   Controler_data = D_eeprom(2) : Servo(2) = Controler_data
   Controler_data = D_eeprom(3) : Servo(3) = Controler_data
   Controler_data = D_eeprom(4) : Servo(4) = Controler_data
Return

'**************************************************************
Display_start_text:
   Print
   Print "                    _____________"
   Print "                   |"
   Print "                   | @"
   Print "                   |"
   Print "Servo Pulse      --|      Servo Motor Contoroler with Computer"
   Print "Servo +5V Power  --|"
   Print "Servo GND        --|"
   Print "                   |      Baud Rate= 9600"
   Print "Servo Pulse      --|      Receiver Data Format: X xxx"
   Print "Servo +5V Power  --|                            | ---  Controer DATA (0 TO 255)"
   Print "Servo GND        --|                            |"
   Print "                   |                            |____  Device (A or B or C or D)"
   Print "Servo Pulse      --|"
   Print "Servo +5V Power  --|      Example: A125"
   Print "Servo GND        --|"
   Print "                   |"
   Print "Servo Pulse      --|"
   Print "Servo +5V Power  --|"
   Print "Servo GND        --|"
   Print "                   |"
   Print "                   | @"
   Print "                   |_____________"
Return

'**************************************************************
Uart_receiver:
   Uart = Udr
   Select Case Uart
      Case 32 To 126:
         S = S + Chr(uart)
      Case 13:
         Disable Urxc
         Z = Mid(s , 1 , 1) : Device = Chr(z)
         Z = Mid(s , 2 , 3) : Controler_data = Val(z)
         If Device = "A" Or Device = "a" Then
            D_eeprom(1) = Controler_data
            Servo(1) = Controler_data
         Elseif Device = "B" Or Device = "b" Then
            D_eeprom(2) = Controler_data
            Servo(2) = Controler_data
         Elseif Device = "C" Or Device = "c" Then
            D_eeprom(3) = Controler_data
            Servo(3) = Controler_data
         Elseif Device = "D" Or Device = "d" Then
            D_eeprom(4) = Controler_data
            Servo(4) = Controler_data
         End If
         S = "" : Uart = 0 : Z = ""
         Enable Urxc
   End Select
Return