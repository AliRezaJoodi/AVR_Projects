'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M16DEF.DAT"
$crystal = 8000000
'$prog &HFF , &HE4 , &HD9 , &H00

Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Config Lcd = 16 * 2
Cursor Blink
Cls

Config Kbd = Portb , Debounce = 50 , Delay = 250

Config Portd.6 = Output : Portd.6 = 0 : Buzzer Alias Portd.6

Enable Interrupts

Deflcdchar 0 , 17 , 10 , 4 , 4 , 4 , 4 , 10 , 17

Dim K As Byte
Dim Address As Byte
Dim Command As Byte : Command = &B0000000
Dim Relay_number As Byte
Dim Status As String * 3 : Status = "OFF"
Dim N As Byte

Gosub Show_lcd
Gosub Read_address

End

'********************************
Read_address:
N = 0 : Address = 0
Do
    K = Getkbd()
    K = Lookup(k , Data_keypad)
    If K < 16 Then
       Select Case K
       Case 0 To 9:
         Incr N
         If N = 1 Then
            Gosub Bip_ok
            Address = K
            Locate 1 , 1 : Lcd "Base:  " : Lcd Address : Lcd "        " : Locate 1 , 9
         Elseif N = 2 Then
            Gosub Bip_ok
            Cursor Off
            Address = Address * 10 : Address = Address + K
            Locate 1 , 1 : Lcd "Base:  " : Lcd Address : Lcd "       "
         Else
            Gosub Bip_err
         End If
       Case 10:
         Gosub Bip_ok
         N = 0 : Address = 0
         Locate 1 , 1 : Lcd "Base:  " : Lcd "         " : Locate 1 , 8
       Case 11:
         Gosub Bip_err
       Case 12:
         Gosub Bip_err
       Case 13:
         Gosub Bip_err
       Case 14:
         Gosub Bip_ok
         N = 0 : Address = 0 : Relay_number = 0 : Status = "OFF"
         Gosub Show_lcd
       Case 15:
         If Address >= 0 And Address <= 15 Then
            Gosub Bip_ok
            Gosub Read_relay_number
         Else
            Gosub Bip_err
         End If
       End Select
    End If
Loop
Return

'********************************
Read_relay_number:
   N = 0 : Relay_number = 0
   Cursor Blink : Locate 2 , 8
   Do
      K = Getkbd()
      K = Lookup(k , Data_keypad)
      If K < 16 Then
         Select Case K
            Case 0 To 9:
               Incr N
               If N = 1 Then
                  Gosub Bip_ok
                  Relay_number = K
                  Locate 2 , 1 : Lcd "Relay: " : Lcd Relay_number : Lcd "     " : Lcd Chr(0) : Locate 1 , 8
               Elseif N = 2 Then
                  Cursor Off
                  Gosub Bip_ok
                  Relay_number = Relay_number * 10 : Relay_number = Relay_number + K
                  Locate 2 , 1 : Lcd "Relay: " : Lcd Relay_number : Lcd "       "
               Else
                  Gosub Bip_err
               End If
         Case 10:
            Gosub Bip_ok
            N = 0 : Relay_number = 0
            Locate 2 , 1 : Lcd "Relay: " : Lcd "     " : Locate 1 , 7
         Case 11:
            Gosub Bip_err
         Case 12:
            Gosub Bip_err
         Case 13:
            Gosub Bip_err
         Case 14:
            Gosub Bip_ok
            N = 0 : Address = 0 : Relay_number = 0 : Status = "OFF"
            Gosub Show_lcd
            Gosub Read_address
         Case 15:
            If Relay_number >= 1 And Relay_number <= 15 Then
               Gosub Bip_ok
               Gosub Read_status
            Else
               Gosub Bip_err
            End If
       End Select
    End If
Loop
Return

'********************************
Read_status:
   Cursor Off
   Locate 2 , 14 : Lcd Status
   Do
      K = Getkbd()
      K = Lookup(k , Data_keypad)
      Select Case K
         Case 0 To 9:
            Gosub Bip_err
         Case 10:
            Gosub Bip_ok
            Status = "OFF"
            Locate 2 , 14 : Lcd Status : Lcd " "
         Case 11:
            Gosub Bip_ok
            Status = "ON"
            Locate 2 , 14 : Lcd Status ; " "
         Case 12:
            Gosub Bip_ok
            Status = "OFF"
            Locate 2 , 14 : Lcd Status
         Case 13:
            Gosub Bip_ok
            Gosub Send_rc5
         Case 14:
            Gosub Bip_ok
            N = 0
            Address = 0
            Relay_number = 0
            Status = "OFF"
            Gosub Show_lcd
            Gosub Read_address
         Case 15:
            Gosub Bip_err
      End Select
   Loop
Return

'********************************
Show_lcd:
   Cls
   Locate 1 , 1 : Lcd "Base:  "
   Locate 2 , 1 : Lcd "Relay: "
   Locate 2 , 14 : Lcd Chr(0)
   Locate 1 , 8
   Cursor Blink
Return

'********************************
Bip_ok:
   Sound Buzzer , 120 , 800
Return

'********************************
Bip_err:
   Sound Buzzer , 70 , 3000
Return

'********************************
Send_rc5:
   Command = Relay_number
   If Status = "ON" Then
      Command = Command + &B00010000
   Elseif Status = "ON" Then
      Command = Command + &B00000000
   End If
   Rc5send 0 , Address , Command
Return

'********************************
Data_keypad:
Data 1 , 4 , 7 , 15 , 2 , 5 , 8 , 0 , 3 , 6 , 9 , 14 , 10 , 11 , 12 , 13