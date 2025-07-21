'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8DEF.DAT"
$crystal = 8000000

Config Watchdog = 2048
Start Watchdog

Enable Interrupts
Config Int0 = Rising
Enable Int0
On Int0 T4

Config Portc.1 = Output : Portc.1 = 0 : Relay_1 Alias Portc.1
Config Portc.0 = Output : Portc.0 = 0 : Relay_2 Alias Portc.0
Config Portb.5 = Output : Portb.5 = 0 : Relay_3 Alias Portb.5
Config Portb.4 = Output : Portb.4 = 0 : Relay_4 Alias Portb.4
Config Portb.1 = Output : Portb.1 = 0 : Relay_enable Alias Portb.1

Config Portd.4 = Output : Portd.4 = 0 : Led_rc5 Alias Portd.4

Config Portd.0 = Input : Portd.0 = 1 : Jamper_address Alias Pind.0
Config Portd.1 = Input : Portd.1 = 1 : Jamper_command Alias Pind.1
Config Portc.5 = Input : Portc.5 = 1 : Jamper_relay_1 Alias Pinc.5
Config Portc.4 = Input : Portc.4 = 1 : Jamper_relay_2 Alias Pinc.4
Config Portc.3 = Input : Portc.3 = 1 : Jamper_relay_3 Alias Pinc.3
Config Portc.2 = Input : Portc.2 = 1 : Jamper_relay_4 Alias Pinc.2

Config Portb.7 = Input : Portb.7 = 1 : D8 Alias Pinb.7
Config Portb.6 = Input : Portb.6 = 1 : D9 Alias Pinb.6
Config Portd.5 = Input : Portd.5 = 1 : D10 Alias Pind.5
Config Portd.3 = Input : Portd.3 = 1 : D11 Alias Pind.3

Const Delay_rc5 = 300

Dim Address_hardware As Byte : Address_hardware = 0
Dim Command_hardware As Bit : Command_hardware = 0

Dim Command As Byte : Command = 255
Dim Status_relay As Byte
Dim Status_relay_eeprom As Eram Byte

Dim Z As Byte : Z = 0

Gosub Setting_address
Gosub Setting_command

Gosub Eeprom_load : Gosub Relay_driver

Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5

Do
   Reset Watchdog
   Reset Led_rc5
If Z = 1 Then
   If Address_hardware = 1 Then
         Select Case Command
            Case 1:
               If Jamper_relay_1 = 0 Then
                  Toggle Status_relay.0 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
               Else
                  Set Led_rc5
                  Set Status_relay.0 : Gosub Eeprom_save : Gosub Relay_driver
                  Waitms 800
                  Reset Status_relay.0 : Gosub Eeprom_save : Gosub Relay_driver
                  Reset Led_rc5
               End If
            Case 2:
               If Jamper_relay_2 = 0 Then
                  Toggle Status_relay.1 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
               Else
                  Set Led_rc5
                  Set Status_relay.1 : Gosub Eeprom_save : Gosub Relay_driver
                  Waitms 800
                  Reset Status_relay.1 : Gosub Eeprom_save : Gosub Relay_driver
                  Reset Led_rc5
               End If
            Case 4:
               If Jamper_relay_3 = 0 Then
                  Toggle Status_relay.2 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
               Else
                  Set Led_rc5
                  Set Status_relay.2 : Gosub Eeprom_save : Gosub Relay_driver
                  Waitms 800
                  Reset Status_relay.2 : Gosub Eeprom_save : Gosub Relay_driver
                  Reset Led_rc5
               End If
            Case 8:
               If Jamper_relay_4 = 0 Then
                  Toggle Status_relay.3 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
               Else
                  Set Led_rc5
                  Set Status_relay.3 : Gosub Eeprom_save : Gosub Relay_driver
                  Waitms 800
                  Reset Status_relay.3 : Gosub Eeprom_save : Gosub Relay_driver
                  Reset Led_rc5
               End If
            Case Else:
               Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
         End Select
   Elseif Address_hardware = 0 Then
      Select Case Command
            Case 2:
               If Jamper_relay_1 = 0 Then
                  Toggle Status_relay.0 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
               Else
                  Set Led_rc5
                  Set Status_relay.0 : Gosub Eeprom_save : Gosub Relay_driver
                  Waitms 800
                  Reset Status_relay.0 : Gosub Eeprom_save : Gosub Relay_driver
                  Reset Led_rc5
               End If
            Case 8:
               If Jamper_relay_2 = 0 Then
                  Toggle Status_relay.1 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
               Else
                  Set Led_rc5
                  Set Status_relay.1 : Gosub Eeprom_save : Gosub Relay_driver
                  Waitms 800
                  Reset Status_relay.1 : Gosub Eeprom_save : Gosub Relay_driver
                  Reset Led_rc5
               End If
            Case 1:
               If Jamper_relay_3 = 0 Then
                  Toggle Status_relay.2 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
               Else
                  Set Led_rc5
                  Set Status_relay.2 : Gosub Eeprom_save : Gosub Relay_driver
                  Waitms 800
                  Reset Status_relay.2 : Gosub Eeprom_save : Gosub Relay_driver
                  Reset Led_rc5
               End If
            Case 4:
               If Jamper_relay_4 = 0 Then
                  Toggle Status_relay.3 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
               Else
                  Set Led_rc5
                  Set Status_relay.3 : Gosub Eeprom_save : Gosub Relay_driver
                  Waitms 800
                  Reset Status_relay.3 : Gosub Eeprom_save : Gosub Relay_driver
                  Reset Led_rc5
               End If
            Case Else:
               Set Led_rc5 : Waitms Delay_rc5 : Reset Led_rc5
         End Select
   End If
Z = 0
End If

Loop

End

T4:
   'Set Led_rc5
   Command = 0
   If D11 = 1 Then Command = Command + 1
   If D10 = 1 Then Command = Command + 2
   If D9 = 1 Then Command = Command + 4
   If D8 = 1 Then Command = Command + 8
   Z = 1
Return

'*************************************************
Setting_address:
   Address_hardware = 0
   If Jamper_address = 0 Then
       Address_hardware = 0
   Elseif Jamper_address = 1 Then
      Address_hardware = 1
   End If
Return

'*************************************************
Setting_command:
   If Jamper_command = 0 Then
      Command_hardware = 0
   Elseif Jamper_command = 1 Then
      Command_hardware = 1
   End If
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