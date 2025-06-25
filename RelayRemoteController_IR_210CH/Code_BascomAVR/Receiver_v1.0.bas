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

Config Pinb.0 = Input : Portb.0 = 1
Config Pind.7 = Input : Portd.7 = 1
Config Pind.6 = Input : Portd.6 = 1
Config Pind.5 = Input : Portd.5 = 1

Enable Interrupts
Config Rc5 = Pinc.2
Config Pinc.2 = Input : Portc.2 = 1

Dim Command As Byte
Dim Address As Byte
Dim Address_device As Byte : Address_device = 0
Dim Status As Byte
Dim Relay_number As Byte

Gosub Scan_address_device

Do
   Getrc5(address , Command)
   If Address < 255 And Command < 255 Then
      Gosub Convert
      If Address = Address_device Or Address = 15 Then
         Gosub Drive_relay
      End If
   End If
Loop

End

'************************************
Scan_address_device:
   If Pind.5 = 1 Then Address_device = Address_device + 1
   If Pind.6 = 1 Then Address_device = Address_device + 2
   If Pind.7 = 1 Then Address_device = Address_device + 4
   If Pinb.0 = 1 Then Address_device = Address_device + 8
Return

'************************************
Convert:
   Address = Address And &B00011111
   Command = Command And &B00111111
   Relay_number = Command And &B00001111
   Status = Command And &B00010000
Return

'************************************
Drive_relay:
   Select Case Relay_number
      Case 1:
         If Status = &B00010000 Then
            Set Relay_1
         Else
            Reset Relay_1
         End If
      Case 2:
         If Status = &B00010000 Then
            Set Relay_2
         Else
            Reset Relay_2
         End If
      Case 3:
         If Status = &B00010000 Then
            Set Relay_3
         Else
            Reset Relay_3
         End If
      Case 4:
         If Status = &B00010000 Then
            Set Relay_4
         Else
            Reset Relay_4
         End If
      Case 5:
         If Status = &B00010000 Then
            Set Relay_5
         Else
            Reset Relay_5
         End If
      Case 6:
         If Status = &B00010000 Then
            Set Relay_6
         Else
            Reset Relay_6
         End If
      Case 7:
         If Status = &B00010000 Then
            Set Relay_7
         Else
            Reset Relay_7
         End If
      Case 8:
         If Status = &B00010000 Then
            Set Relay_8
         Else
            Reset Relay_8
         End If
      Case 9:
         If Status = &B00010000 Then
            Set Relay_9
         Else
         Reset Relay_9
         End If
      Case 10:
         If Status = &B00010000 Then
            Set Relay_10
         Else
            Reset Relay_10
         End If
      Case 11:
         If Status = &B00010000 Then
            Set Relay_11
         Else
            Reset Relay_11
         End If
      Case 12:
         If Status = &B00010000 Then
            Set Relay_12
         Else
            Reset Relay_12
         End If
      Case 13:
         If Status = &B00010000 Then
            Set Relay_13
         Else
            Reset Relay_13
         End If
      Case 14:
         If Status = &B00010000 Then
            Set Relay_14
         Else
            Reset Relay_14
         End If
      Case 15:
         If Status = &B00010000 Then
            Set Relay_1 : Set Relay_2 : Set Relay_3 : Set Relay_4 : Set Relay_5 : Set Relay_6 : Set Relay_7
            Set Relay_8 : Set Relay_9 : Set Relay_10 : Set Relay_11 : Set Relay_12 : Set Relay_13 : Set Relay_14
         Else
            Reset Relay_1 : Reset Relay_2 : Reset Relay_3 : Reset Relay_4 : Reset Relay_5 : Reset Relay_6 : Reset Relay_7
            Reset Relay_8 : Reset Relay_9 : Reset Relay_10 : Reset Relay_11 : Reset Relay_12 : Reset Relay_13 : Reset Relay_14
         End If
   End Select
Return