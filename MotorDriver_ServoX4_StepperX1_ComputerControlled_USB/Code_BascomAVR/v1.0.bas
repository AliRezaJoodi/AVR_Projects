'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m8def.dat"
$crystal = 11059200

Enable Interrupts
$baud = 9600
On Urxc Uart_receiver
Enable Urxc

Const Servo1_min = 43
Const Servo1_normal = 83
Const Servo1_max = 140

Config Portb.2 = Output : Portb.2 = 0
Config Portb.5 = Output : Portb.5 = 0
Config Portc.1 = Output : Portc.1 = 0
Config Portc.5 = Output : Portc.5 = 0
Config Servos = 4 , Servo1 = Portb.2 , Servo2 = Portb.5 , Servo3 = Portc.1 , Servo4 = Portc.5 , Reload = 10

Config Portd.6 = Output : Portd.6 = 0 : Stepper_pin_yellow Alias Portd.6
Config Portd.7 = Output : Portd.7 = 0 : Stepper_pin_orange Alias Portd.7
Config Portb.0 = Output : Portb.0 = 0 : Stepper_pin_brown Alias Portb.0
Config Portb.1 = Output : Portb.1 = 0 : Stepper_pin_black Alias Portb.1

Dim Uart As Byte
Dim S As String * 16 : S = ""
Dim Z As String * 3

Dim Device As String * 1
Dim Controler_data As Byte

Dim Pass_1_eeprom As Eram String * 1
Dim Pass_1 As String * 1

Do

Loop

End

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
            Servo(1) = Controler_data
         Elseif Device = "B" Or Device = "b" Then
            Servo(2) = Controler_data
         Elseif Device = "C" Or Device = "c" Then
            Servo(3) = Controler_data
         Elseif Device = "D" Or Device = "d" Then
            Servo(4) = Controler_data
         Elseif Device = "E" Or Device = "e" Then
            Stepper_pin_yellow = Controler_data.0
            Stepper_pin_brown = Controler_data.1
            Stepper_pin_orange = Controler_data.2
            Stepper_pin_black = Controler_data.3
         End If
         S = "" : Uart = 0 : Z = ""
         Enable Urxc
   End Select
Return
