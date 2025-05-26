'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8DEF.DAT"
$crystal = 8000000

Config Watchdog = 2048
Start Watchdog

Enable Interrupts

Config Rc5 = Pind.2

Config Portc.1 = Output : Portc.1 = 0 : Relay1 Alias Portc.1
Config Portc.0 = Output : Portc.0 = 0 : Relay2 Alias Portc.0
Config Portb.5 = Output : Portb.5 = 0 : Relay3 Alias Portb.5
Config Portb.4 = Output : Portb.4 = 0 : Relay4 Alias Portb.4
Config Portb.1 = Output : Portb.1 = 0 : Relay_enable Alias Portb.1
Config Portd.4 = Output : Portd.4 = 0 : Led_IR Alias Portd.4
Config Portd.0 = Input : Portd.0 = 1 : Jumper_address Alias Pind.0
Config Portd.1 = Input : Portd.1 = 1 : Jumper_command Alias Pind.1
Config Portc.5 = Input : Portc.5 = 1 : Jumper_Relay1 Alias Pinc.5
Config Portc.4 = Input : Portc.4 = 1 : Jumper_Relay2 Alias Pinc.4
Config Portc.3 = Input : Portc.3 = 1 : Jumper_Relay3 Alias Pinc.3
Config Portc.2 = Input : Portc.2 = 1 : Jumper_Relay4 Alias Pinc.2

Const Delay_IR = 300
Const Delay_Relay = 800

Dim Address_hardware As Byte : Address_hardware = 0
Dim Command_hardware As Bit : Command_hardware = 0

Dim Address As Byte : Address = 255
Dim Command As Byte : Command = 255
Dim Status_relay As Byte
Dim Status_relay_eeprom As Eram Byte

Gosub Setting_address
Gosub Setting_command

Gosub Eeprom_load
Gosub Relay_driver

Set Led_IR : Waitms Delay_IR : Reset Led_IR

Do
   Reset Watchdog
   Reset Led_IR
   Getrc5(address , Command) : Gosub Convert
   If Address = Address_hardware Then
      If Command_hardware = 0 Then
         Select Case Command
            Case 1:
               If Jumper_Relay1 = 0 Then
                  Toggle Status_relay.0 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_IR : Waitms Delay_IR : Reset Led_IR
               Else
                  Set Led_IR
                  Set Status_relay.0 : Gosub Relay_driver
                  Waitms Delay_Relay
                  Reset Status_relay.0  : Gosub Relay_driver
                  Reset Led_IR
               End If
            Case 2:
               If Jumper_Relay2 = 0 Then
                  Toggle Status_relay.1 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_IR : Waitms Delay_IR : Reset Led_IR
               Else
                  Set Led_IR
                  Set Status_relay.1  : Gosub Relay_driver
                  Waitms Delay_Relay
                  Reset Status_relay.1  : Gosub Relay_driver
                  Reset Led_IR
               End If
            Case 3:
               If Jumper_Relay3 = 0 Then
                  Toggle Status_relay.2 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_IR : Waitms Delay_IR : Reset Led_IR
               Else
                  Set Led_IR
                  Set Status_relay.2  : Gosub Relay_driver
                  Waitms Delay_Relay
                  Reset Status_relay.2  : Gosub Relay_driver
                  Reset Led_IR
               End If
            Case 4:
               If Jumper_Relay4 = 0 Then
                  Toggle Status_relay.3 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_IR : Waitms Delay_IR : Reset Led_IR
               Else
                  Set Led_IR
                  Set Status_relay.3  : Gosub Relay_driver
                  Waitms Delay_Relay
                  Reset Status_relay.3  : Gosub Relay_driver
                  Reset Led_IR
               End If
            Case 12:
               Reset Status_relay.0 : Reset Status_relay.1 : Reset Status_relay.2 : Reset Status_relay.3
               Gosub Eeprom_save : Gosub Relay_driver
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
            Case 0:
               Reset Status_relay.0 : Reset Status_relay.1 : Reset Status_relay.2 : Reset Status_relay.3
               Gosub Eeprom_save : Gosub Relay_driver
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
            Case Else:
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
         End Select
      Elseif Command_hardware = 1 Then
         Select Case Command
            Case 5:
               If Jumper_Relay1 = 0 Then
                  Toggle Status_relay.0 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_IR : Waitms Delay_IR : Reset Led_IR
               Else
                  Set Led_IR
                  Set Status_relay.0  : Gosub Relay_driver
                  Waitms Delay_Relay
                  Reset Status_relay.0  : Gosub Relay_driver
                  Reset Led_IR
               End If
            Case 6:
               If Jumper_Relay2 = 0 Then
                  Toggle Status_relay.1 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_IR : Waitms Delay_IR : Reset Led_IR
               Else
                  Set Led_IR
                  Set Status_relay.1  : Gosub Relay_driver
                  Waitms Delay_Relay
                  Reset Status_relay.1  : Gosub Relay_driver
                  Reset Led_IR
               End If
            Case 7:
               If Jumper_Relay3 = 0 Then
                  Toggle Status_relay.2 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_IR : Waitms Delay_IR : Reset Led_IR
               Else
                  Set Led_IR
                  Set Status_relay.2  : Gosub Relay_driver
                  Waitms Delay_Relay
                  Reset Status_relay.2  : Gosub Relay_driver
                  Reset Led_IR
               End If
            Case 8:
               If Jumper_Relay4 = 0 Then
                  Toggle Status_relay.3 : Gosub Eeprom_save : Gosub Relay_driver
                  Set Led_IR : Waitms Delay_IR : Reset Led_IR
               Else
                  Set Led_IR
                  Set Status_relay.3  : Gosub Relay_driver
                  Waitms Delay_Relay
                  Reset Status_relay.3  : Gosub Relay_driver
                  Reset Led_IR
               End If
            Case 12:
               Reset Status_relay.0 : Reset Status_relay.1 : Reset Status_relay.2 : Reset Status_relay.3
               Gosub Eeprom_save : Gosub Relay_driver
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
            Case 0:
               Reset Status_relay.0 : Reset Status_relay.1 : Reset Status_relay.2 : Reset Status_relay.3
               Gosub Eeprom_save : Gosub Relay_driver
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
            Case Else:
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
         End Select
      End If
   End If
Loop

End

'*************************************************
Setting_address:
   Address_hardware = 0
   If Jumper_address = 0 Then
       Address_hardware = 0
   Elseif Jumper_address = 1 Then
      Address_hardware = 1
   End If
Return

'*************************************************
Setting_command:
   If Jumper_command = 0 Then
      Command_hardware = 0
   Elseif Jumper_command = 1 Then
      Command_hardware = 1
   End If
Return

'*************************************************
Convert:
   Address = Address And &B00011111
   Command = Command And &B00111111
Return

'*************************************************
Relay_driver:
   Relay1 = Status_relay.0
   Relay2 = Status_relay.1
   Relay3 = Status_relay.2
   Relay4 = Status_relay.3
   Set Relay_enable : Waitms 2 : Reset Relay_enable
Return

'*************************************************
Eeprom_save:
   Status_relay_eeprom = Status_relay :waitms 10
Return

'*************************************************
Eeprom_load:
   Status_relay = Status_relay_eeprom
Return