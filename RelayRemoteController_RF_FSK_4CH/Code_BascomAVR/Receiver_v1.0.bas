'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m8def.dat"
$crystal = 11059200

Enable Interrupts
$baud = 9600
On Urxc Receiver_data
Enable Urxc

Config Portd.2 = Input
Config Portd.4 = Input

Config Portc.0 = Output : Portc.0 = 0 : Relay_1 Alias Portc.0
Config Portc.1 = Output : Portc.1 = 0 : Relay_2 Alias Portc.1
Config Portc.2 = Output : Portc.2 = 0 : Relay_3 Alias Portc.2
Config Portc.3 = Output : Portc.3 = 0 : Relay_4 Alias Portc.3

Config Portc.5 = Output : Portc.5 = 0 : Led Alias Portc.5

Dim Z As Byte
Dim S As String * 11

Dim Address As String * 3 : Address = "123"
Dim Relay_status As Byte
Dim Relay_status_eeprom As Eram Byte
Dim Relay_status_string As String * 1 : Relay_status_string = "0"

Print "OK"

Relay_status = Relay_status_eeprom
Gosub Relay_driver

Do
   Reset Led
Loop

End

'**************************************************
Relay_driver:
   Relay_1 = Relay_status.0
   Relay_2 = Relay_status.1
   Relay_3 = Relay_status.2
   Relay_4 = Relay_status.3
Return

'**************************************************
Receiver_data:
   Z = Udr
   Set Led
   Select Case Z
      Case 32 To 126:
         S = S + Chr(z)
      Case 13:
         Disable Urxc : Waitms 10
         Address = Mid(s , 1 , 3)
         If Address = "123" Then
            Set Led
               Relay_status_string = Mid(s , 4 , 2)
               Relay_status = Val(relay_status_string)
               Relay_status = Relay_status And &B00001111
               Relay_status_eeprom = Relay_status
               Print Relay_status
               Gosub Relay_driver
         End If
         S = ""
         Enable Urxc
   End Select
Return