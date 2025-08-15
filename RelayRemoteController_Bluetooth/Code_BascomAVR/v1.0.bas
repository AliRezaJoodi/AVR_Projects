'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200

$baud = 9600
Enable Interrupts
Enable Urxc
On Urxc Uart_reciver

Config Portc.2 = Output : Portc.2 = 1 : Hc05_reset Alias Portc.2
Config Portd.6 = Output : Portd.6 = 0 : Hc05_key Alias Portd.6

Config Porta.0 = Output : Porta.0 = 0 : Relay_0 Alias Porta.0
Config Porta.1 = Output : Porta.1 = 0 : Relay_1 Alias Porta.1
Config Porta.2 = Output : Porta.2 = 0 : Relay_2 Alias Porta.2
Config Porta.3 = Output : Porta.3 = 0 : Relay_3 Alias Porta.3
Config Porta.4 = Output : Porta.4 = 0 : Relay_4 Alias Porta.4
Config Porta.5 = Output : Porta.5 = 0 : Relay_5 Alias Porta.5
Config Porta.6 = Output : Porta.6 = 0 : Relay_6 Alias Porta.6
Config Porta.7 = Output : Porta.7 = 0 : Relay_7 Alias Porta.7

Config Portd.3 = Input : Portd.3 = 0 : Key Alias Pind.3

Dim Buffer_uart As Byte
Dim S As String * 1
Dim Status_relay As Byte
Dim Status_relay_eeprom As Eram Byte
Dim Status_key As Bit : Status_key = 0

Dim T As Word : T = 500
Dim I As Byte

'Gosub Default
Gosub Eeprom_load
Gosub Driver_relay

Do
   If Key = 0 And Status_key = 0 Then
      Waitms 30
      If Key = 0 And Status_key = 0 Then
         Status_key = 1
         Gosub Preparation : Print "AT+RMAAD" ; Chr(13) ; Chr(10) : Waitms T
         Gosub Preparation : Print "AT+PSWD=1234" ; Chr(13) ; Chr(10) : Waitms T
         Gosub Preparation : Print "AT+NAME=HC-05" ; Chr(13) ; Chr(10) : Waitms T
         Gosub Preparation : Print "AT+RESET" ; Chr(13) ; Chr(10) : Waitms T
      End If
   End If
   If Key = 1 Then Status_key = 0
      Gosub Uart_transfer
   Wait 1
Loop

End

'***********************************************
Uart_transfer:
   Udr = &HEB : Waitms 5
   Udr = Status_relay : Waitms 5
Return

'**********************************************************
Uart_reciver:
   Buffer_uart = Udr : S = Chr(buffer_uart)
   Select Case S
      Case "a" : Toggle Status_relay.0
      Case "b" : Toggle Status_relay.1
      Case "c" : Toggle Status_relay.2
      Case "d" : Toggle Status_relay.3
      Case "e" : Toggle Status_relay.4
      Case "f" : Toggle Status_relay.5
      Case "g" : Toggle Status_relay.6
      Case "h" : Toggle Status_relay.7
      Case "i" : Status_relay = 255
      Case "j" : Status_relay = 0
   End Select
   Gosub Eeprom_save
   Gosub Driver_relay
   Gosub Uart_transfer
Return

'**********************************************************
Driver_relay:
   Relay_0 = Status_relay.0
   Relay_1 = Status_relay.1
   Relay_2 = Status_relay.2
   Relay_3 = Status_relay.3
   Relay_4 = Status_relay.4
   Relay_5 = Status_relay.5
   Relay_6 = Status_relay.6
   Relay_7 = Status_relay.7
Return

'**********************************************************
Preparation:
   Reset Hc05_reset : Waitms 10 : Set Hc05_reset : Waitms 1000
   Set Hc05_key : Waitms 10 : Reset Hc05_key : Waitms 100
Return

'**********************************************************
Eeprom_save:
   Status_relay_eeprom = Status_relay
Return

'**********************************************************
Eeprom_load:
   Status_relay = Status_relay_eeprom
Return

'**********************************************************
Default:
   Status_relay = 0 : Status_relay_eeprom = Status_relay
Return