'Github Account: Github.com/Alirezajoodi

$regfile = "m32def.dat"
$crystal = 8000000
$baud = 9600

Config Portc.5 = Output : Portc.5 = 0 : Led0 Alias Portc.5
Config Portc.4 = Output : Portc.4 = 0 : Led1 Alias Portc.4
Config Portc.3 = Output : Portc.3 = 0 : Led2 Alias Portc.3
Config Portc.2 = Output : Portc.2 = 0 : Led3 Alias Portc.2
Config Portc.0 = Output : Portc.0 = 0 : Led4 Alias Portc.0
Config Portd.7 = Output : Portd.7 = 0 : Led5 Alias Portd.7
Config Portb.2 = Output : Portb.2 = 0 : Led6 Alias Portb.2
Config Portd.3 = Output : Portd.3 = 0 : Led7 Alias Portd.3

Dim S As String * 1

Print "UART Relay Controller for 8CH"

Do
   Input "Enter Command: " , S
   Select Case S
      Case "0" : Gosub Relay_all_off
      Case "1" : Toggle Led0
      Case "2" : Toggle Led1
      Case "3" : Toggle Led2
      Case "4" : Toggle Led3
      Case "5" : Toggle Led4
      Case "6" : Toggle Led5
      Case "7" : Toggle Led6
      Case "8" : Toggle Led7
      Case "9" : Gosub Relay_all_on
   End Select
Loop

End

'*******************************
Relay_all_off:
   Reset Led0
   Reset Led1
   Reset Led2
   Reset Led3
   Reset Led4
   Reset Led5
   Reset Led6
   Reset Led7
Return

'*******************************
Relay_all_on:
   Set Led0
   Set Led1
   Set Led2
   Set Led3
   Set Led4
   Set Led5
   Set Led6
   Set Led7
Return