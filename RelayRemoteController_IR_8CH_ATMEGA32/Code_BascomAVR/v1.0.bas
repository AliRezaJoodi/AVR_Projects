'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32DEF.DAT"
$crystal = 8000000

Config Porta.0 = Output : Porta.0 = 0 : Relay_1 Alias Porta.0
Config Porta.1 = Output : Porta.1 = 0 : Relay_2 Alias Porta.1
Config Porta.2 = Output : Porta.2 = 0 : Relay_3 Alias Porta.2
Config Porta.3 = Output : Porta.3 = 0 : Relay_4 Alias Porta.3
Config Porta.4 = Output : Porta.4 = 0 : Relay_5 Alias Porta.4
Config Porta.5 = Output : Porta.5 = 0 : Relay_6 Alias Porta.5
Config Porta.6 = Output : Porta.6 = 0 : Relay_7 Alias Porta.6
Config Porta.7 = Output : Porta.7 = 0 : Relay_8 Alias Porta.7

Config Portd.7 = Output : Portd.7 = 0 : Led Alias Portd.7

Enable Interrupts
Config Rc5 = Pind.3

Dim Command As Byte
Dim Address As Byte
Dim Status_relay As Byte
Dim Status_relay_eeprom As Eram Byte
Dim T As Word : T = 400

Gosub Eeprom_load
Gosub Driver_relay
Gosub Display_led

Do
   Getrc5(address , Command)
   If Address < 255 And Command < 255 Then
      Gosub Convert
      If Address = 0 Then
         Set Led
         Gosub Status_relay
         Gosub Eeprom_save
         Gosub Driver_relay
         Waitms T
         Reset Led
      End If
   End If
Loop

End

'******************************************
Display_led:
   Set Led : Waitms T : Reset Led
Return

'******************************************
Convert:
   Address = Address And &B00011111
   Command = Command And &B00111111
Return

'******************************************
Status_relay:
   Select Case Command
      Case 1 : Toggle Status_relay.0
      Case 2 : Toggle Status_relay.1
      Case 3 : Toggle Status_relay.2
      Case 4 : Toggle Status_relay.3
      Case 5 : Toggle Status_relay.4
      Case 6 : Toggle Status_relay.5
      Case 7 : Toggle Status_relay.6
      Case 8 : Toggle Status_relay.7
      Case 12 : Status_relay = 255
      Case 13 : Status_relay = 0
   End Select
Return

'******************************************
Driver_relay:
   Relay_1 = Status_relay.0
   Relay_2 = Status_relay.1
   Relay_3 = Status_relay.2
   Relay_4 = Status_relay.3
   Relay_5 = Status_relay.4
   Relay_6 = Status_relay.5
   Relay_7 = Status_relay.6
   Relay_8 = Status_relay.7
Return

'******************************************
Eeprom_save:
   Status_relay_eeprom = Status_relay    : waitms 10
Return

'******************************************
Eeprom_load:
   Status_relay = Status_relay_eeprom
Return

'******************************************
Setting_default:
   Status_relay = 0 : Status_relay_eeprom = Status_relay
Return