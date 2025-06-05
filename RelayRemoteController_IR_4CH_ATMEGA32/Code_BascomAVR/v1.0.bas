'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32DEF.DAT"
$crystal = 8000000
'$crystal = 11059200

Config Watchdog = 2048
Start Watchdog

Config Porta.1 = Output : Porta.1 = 0 : Relay_1 Alias Porta.1
Config Porta.2 = Output : Porta.2 = 0 : Relay_2 Alias Porta.2
Config Porta.3 = Output : Porta.3 = 0 : Relay_3 Alias Porta.3
Config Porta.4 = Output : Porta.4 = 0 : Relay_4 Alias Porta.4

Config Portd.7 = Output : Portd.7 = 0 : Led_rc5 Alias Portd.7

Enable Interrupts
Config Rc5 = Pind.2
'Config Pinc.2 = Input : Portc.2 = 1

Dim Command As Byte
Dim Address As Byte
Dim T As Word : T = 500

Dim Status_relay As Byte
Dim Status_relay_eeprom As Eram Byte

Gosub Eeprom_load : Gosub Relay_driver
Reset Watchdog

Gosub Display_start
'Gosub Test_all

Do
   Reset Watchdog
   Getrc5(address , Command)
   If Address < 255 And Command < 255 Then
      Gosub Convert
      If Address = 0 Then
         Gosub Relay_status_change : Gosub Eeprom_save : Gosub Relay_driver
         Set Led_rc5 : Waitms 200 : Reset Led_rc5
         Waitms 300
         Reset Watchdog
      End If
   End If
   Reset Led_rc5
Loop

End

'*************************************************
Test_all:
   Do

      Command = 1
      Gosub Relay_status_change : Gosub Eeprom_save : Gosub Relay_driver
      Set Led_rc5 : Waitms 200 : Reset Led_rc5
      Waitms 300
      Reset Watchdog
      Wait 1
      Reset Watchdog

      Command = 2
      Gosub Relay_status_change : Gosub Eeprom_save : Gosub Relay_driver
      Set Led_rc5 : Waitms 200 : Reset Led_rc5
      Waitms 300
      Reset Watchdog
      Wait 1
      Reset Watchdog

      Command = 3
      Gosub Relay_status_change : Gosub Eeprom_save : Gosub Relay_driver
      Set Led_rc5 : Waitms 200 : Reset Led_rc5
      Waitms 300
      Reset Watchdog
      Wait 1
      Reset Watchdog

      Command = 4
      Gosub Relay_status_change : Gosub Eeprom_save : Gosub Relay_driver
      Set Led_rc5 : Waitms 200 : Reset Led_rc5
      Waitms 300
      Reset Watchdog
      Wait 1
      Reset Watchdog

   Loop
Return

'*************************************************
Display_start:
   Set Led_rc5 : Waitms 400 : Reset Led_rc5
Return


'*************************************************
Convert:
   Address = Address And &B00011111
   Command = Command And &B00111111
Return

'*************************************************
Relay_status_change:
   Select Case Command
      Case 1:
         Toggle Status_relay.0
      Case 2:
         Toggle Status_relay.1
      Case 3:
         Toggle Status_relay.2
      Case 4:
         Toggle Status_relay.3
      Case 12:
         Set Status_relay.0 : Set Status_relay.1 : Set Status_relay.2 : Set Status_relay.3
      Case 0:
         Reset Status_relay.0 : Reset Status_relay.1 : Reset Status_relay.2 : Reset Status_relay.3
   End Select
Return

'*************************************************
Relay_driver:
   Relay_1 = Status_relay.0
   Relay_2 = Status_relay.1
   Relay_3 = Status_relay.2
   Relay_4 = Status_relay.3
Return

'*************************************************
Eeprom_save:
   Status_relay_eeprom = Status_relay: waitms 10
Return

'*************************************************
Eeprom_load:
   Status_relay = Status_relay_eeprom
Return