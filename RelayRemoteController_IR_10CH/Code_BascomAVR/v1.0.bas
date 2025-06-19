'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8DEF.DAT"
$crystal = 8000000

Config Portd.0 = Output : Portd.0 = 0 : Relay_1 Alias Portd.0
Config Portd.2 = Output : Portd.2 = 0 : Relay_2 Alias Portd.2
Config Portc.5 = Output : Portc.5 = 0 : Relay_3 Alias Portc.5
Config Portc.4 = Output : Portc.4 = 0 : Relay_4 Alias Portc.4
Config Portc.3 = Output : Portc.3 = 0 : Relay_5 Alias Portc.3
Config Portc.1 = Output : Portc.1 = 0 : Relay_6 Alias Portc.1
Config Portc.0 = Output : Portc.0 = 0 : Relay_7 Alias Portc.0
Config Portb.5 = Output : Portb.5 = 0 : Relay_8 Alias Portb.5
Config Portb.3 = Output : Portb.3 = 0 : Relay_9 Alias Portb.3
Config Portb.1 = Output : Portb.1 = 0 : Relay_10 Alias Portb.1

Enable Interrupts
Config Rc5 = Pinc.2

Dim Command As Byte
Dim Address As Byte
Dim T As Word : T = 500

Do
   Getrc5(address , Command)
   If Address < 255 And Command < 255 Then
      Gosub Convert
      If Address = 0 Then
         Gosub Drive_relay : Waitms T
      End If
   End If
Loop

End

'*************************************************
Convert:
   Address = Address And &B00011111
   Command = Command And &B00111111
Return

'*************************************************
Drive_relay:
   Select Case Command
      Case 1:
         Toggle Relay_1
      Case 2:
         Toggle Relay_2
      Case 3:
         Toggle Relay_3
      Case 4:
         Toggle Relay_4
      Case 5:
         Toggle Relay_5
      Case 6:
         Toggle Relay_6
      Case 7:
         Toggle Relay_7
      Case 8:
         Toggle Relay_8
      Case 9:
         Toggle Relay_9
      Case 0:
         Toggle Relay_10
      Case 12:
            Set Relay_1 : Set Relay_2 : Set Relay_3 : Set Relay_4 : Set Relay_5
            Set Relay_6 : Set Relay_7 : Set Relay_8 : Set Relay_9 : Set Relay_10
      Case 13:
            Reset Relay_1 : Reset Relay_2 : Reset Relay_3 : Reset Relay_4 : Reset Relay_5
            Reset Relay_6 : Reset Relay_7 : Reset Relay_8 : Reset Relay_9 : Reset Relay_10
   End Select
Return
