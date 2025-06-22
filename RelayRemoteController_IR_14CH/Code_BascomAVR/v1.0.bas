'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8DEF.DAT"
$crystal = 8000000

Config Portd.0 = Output : Portd.0 = 0 : Relay_1 Alias Portd.0
Config Portd.1 = Output : Portd.1 = 0 : Relay_2 Alias Portd.1
Config Portd.2 = Output : Portd.2 = 0 : Relay_3 Alias Portd.2
Config Portd.3 = Output : Portd.3 = 0 : Relay_4 Alias Portd.3
Config Portc.5 = Output : Portc.5 = 0 : Relay_5 Alias Portc.5
Config Portc.4 = Output : Portc.4 = 0 : Relay_6 Alias Portc.4
Config Portc.3 = Output : Portc.3 = 0 : Relay_7 Alias Portc.3
Config Portc.1 = Output : Portc.1 = 0 : Relay_8 Alias Portc.1
Config Portc.0 = Output : Portc.0 = 0 : Relay_9 Alias Portc.0
Config Portb.5 = Output : Portb.5 = 0 : Relay_10 Alias Portb.5
Config Portb.4 = Output : Portb.4 = 0 : Relay_11 Alias Portb.4
Config Portb.3 = Output : Portb.3 = 0 : Relay_12 Alias Portb.3
Config Portb.2 = Output : Portb.2 = 0 : Relay_13 Alias Portb.2
Config Portb.1 = Output : Portb.1 = 0 : Relay_14 Alias Portb.1

Enable Interrupts
Config Rc5 = Pinc.2

Dim Command As Byte
Dim Address As Byte
Dim T As Word : T = 450

Dim Relay_status As Word
Dim Relay_status_eeprom As Eram Word

Gosub Load_eeprom
Gosub Relay_drive

Dim Pass_1 As String * 1
Dim Pass_1_eeprom As Eram String * 1


Do
   Getrc5(address , Command)
   If Address < 255 And Command < 255 Then
      Gosub Convert
      If Address = 0 Then
      'Command = 15
         Gosub Command_relay
         Gosub Save_eeprom
         Gosub Relay_drive
         Waitms T
      End If
   End If
Loop

End


'*************************************
Convert:
   Address = Address And &B00011111
   Command = Command And &B00111111
Return

'*************************************
Command_relay:
   Select Case Command
      Case 1:
         Toggle Relay_status.1
      Case 2:
         Toggle Relay_status.2
      Case 3:
         Toggle Relay_status.3
      Case 4:
         Toggle Relay_status.4
      Case 5:
         Toggle Relay_status.5
      Case 6:
         Toggle Relay_status.6
      Case 7:
         Toggle Relay_status.7
      Case 8:
         Toggle Relay_status.8
      Case 9:
         Toggle Relay_status.9
      Case 10:
         Toggle Relay_status.10
      Case 0:
         Toggle Relay_status.11
      Case 15:
         'Toggle Relay_status.12
         If Relay_status.12 = 0 Then
            Relay_status.12 = 1
            Else
            Relay_status.12 = 0
         End If
      Case 56:
         Toggle Relay_status.13
      Case 59:
         Toggle Relay_status.14
      Case 12:
         Relay_status = &HFFFF
      Case 13:
         Relay_status = &H0000
   End Select
Return

'*************************************
Relay_drive:
   Relay_1 = Relay_status.1
   Relay_2 = Relay_status.2
   Relay_3 = Relay_status.3
   Relay_4 = Relay_status.4
   Relay_5 = Relay_status.5
   Relay_6 = Relay_status.6
   Relay_7 = Relay_status.7
   Relay_8 = Relay_status.8
   Relay_9 = Relay_status.9
   Relay_10 = Relay_status.10
   Relay_11 = Relay_status.11
   Relay_12 = Relay_status.12
   Relay_13 = Relay_status.13
   Relay_14 = Relay_status.14
Return

'*************************************
Save_eeprom:
   Relay_status_eeprom = Relay_status : Waitms 10
Return

'*************************************
Load_eeprom:
   Relay_status = Relay_status_eeprom 
Return
