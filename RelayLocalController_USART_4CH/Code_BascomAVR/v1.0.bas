'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8DEF.DAT"
$crystal = 8000000

Config Watchdog = 2048
Start Watchdog

$baud = 9600
Enable Interrupts
Enable Urxc
On Urxc Rs232_reciver

Config Portc.1 = Output : Portc.1 = 0 : Relay_1 Alias Portc.1
Config Portc.2 = Output : Portc.2 = 0 : Relay_2 Alias Portc.2
Config Portb.1 = Output : Portb.1 = 0 : Relay_3 Alias Portb.1
Config Portb.2 = Output : Portb.2 = 0 : Relay_4 Alias Portb.2

Config Portb.0 = Output : Portb.0 = 0 : Relay_enable Alias Portb.0

Config Portd.4 = Output : Portd.4 = 0 : Led_rc5 Alias Portd.4

Config Debounce = 30
Config Portd.7 = Input : Portd.7 = 1 : Key_set Alias Pind.7

Dim Address_hardware As Byte : Address_hardware = 0

Dim Address As Byte : Address = 255
Dim Command As Byte : Command = 255
Dim T As Word : T = 300

Dim Status_relay As Byte
Dim Status_relay_eeprom As Eram Byte

Dim Buffer As Byte
Dim Flag As Bit : Flag = 0
Dim I As Byte
Dim D(2) As Byte

Gosub Eeprom_load : Gosub Relay_driver

Gosub T1

Do
   Reset Watchdog
   Debounce Key_set , 0 , T1 , Sub
   Reset Led_rc5
Loop

End

'*************************************************
Rs232_reciver:
   Buffer = Udr
   If Flag = 0 Then
      If Buffer = 127 Then Flag = 1
   Else
      Incr I : D(i) = Buffer
      If I = 2 Then
         I = 0 : Flag = 0
         Address = D(1) : Command = D(2)
         If Address = Address_hardware Then
            Gosub Relay_status_change : Gosub Eeprom_save : Gosub Relay_driver
            Address = 255 : Command = 255
            Set Led_rc5 : Waitms 200 : Reset Led_rc5
            Waitms T
         End If
      End If
   End If
Return

'*************************************************
T1:
   'Set Relay_enable : Waitms 2 : Reset Relay_enable
   Set Led_rc5 : Waitms 500 : Reset Led_rc5
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
   Set Relay_enable : Waitms 2 : Reset Relay_enable
Return

'*************************************************
Eeprom_save:
   Status_relay_eeprom = Status_relay
Return

'*************************************************
Eeprom_load:
   Status_relay = Status_relay_eeprom
Return