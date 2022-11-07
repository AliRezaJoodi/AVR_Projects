'Github Account: Github.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000
$baud = 9600

Config Portb.0 = Output : Relay1 Alias Portb.0

Dim Buffer_uart As String * 1
Dim Status_relay1 As Byte
Dim Status_relay1_eeprom As Eram Byte

Gosub Eeprom_load
Gosub Relay_driver

Print "UART Relay Controller for 1CH"
Print "Enable Relay=1"
Print "Disable Relay=0"
Print

Do
   Input "Enter Command: " , Buffer_uart
   Select Case Buffer_uart
      Case "1" :
         Status_relay1 = 1
         Gosub Eeprom_save
         Gosub Relay_driver
      Case "0" :
         Status_relay1 = 0
         Gosub Eeprom_save
         Gosub Relay_driver
   End Select
Loop

End

'*********************************************
Relay_driver:
   Relay1 = Status_relay1
Return

'*********************************************
Eeprom_save:
   Status_relay1_eeprom = Status_relay1
Return

'*********************************************
Eeprom_load:
   Status_relay1 = Status_relay1_eeprom
Return