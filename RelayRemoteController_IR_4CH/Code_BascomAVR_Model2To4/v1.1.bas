'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8DEF.DAT"
$crystal = 8000000

Config Watchdog = 2048
Start Watchdog

Enable Interrupts

$include "Attachment\Hardware_Model4_v2.0.inc"

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
      If Command_hardware = 1 Then
         Select Case Command
            Case 1:
               If Jumper_Relay1 = 1 Then
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
               If Jumper_Relay2 = 1 Then
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
               If Jumper_Relay3 = 1 Then
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
               If Jumper_Relay4 = 1 Then
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
               Gosub Eeprom_save
               Gosub Relay_driver
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
            Case 0:
               Reset Status_relay.0 : Reset Status_relay.1 : Reset Status_relay.2 : Reset Status_relay.3
               Gosub Eeprom_save
               Gosub Relay_driver
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
            Case Else:
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
         End Select
      Elseif Command_hardware = 0 Then
         Select Case Command
            Case 5:
               If Jumper_Relay1 = 1 Then
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
               If Jumper_Relay2 = 1 Then
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
               If Jumper_Relay3 = 1 Then
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
               If Jumper_Relay4 = 1 Then
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
               Gosub Eeprom_save
               Gosub Relay_driver
               Set Led_IR : Waitms Delay_IR : Reset Led_IR
            Case 0:
               Reset Status_relay.0 : Reset Status_relay.1 : Reset Status_relay.2 : Reset Status_relay.3
               Gosub Eeprom_save
               Gosub Relay_driver
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
   If Jumper_address = 1 Then
      Address_hardware = 0
   Else
      Address_hardware = 1
   End If
Return

'*************************************************
Setting_command:
   If Jumper_command = 0 Then
      Command_hardware = 0
   Else
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