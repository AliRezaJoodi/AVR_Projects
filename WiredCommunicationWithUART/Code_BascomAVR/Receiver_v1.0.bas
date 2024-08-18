'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
'$crystal = 11059200
$crystal = 8000000
$baud = 9600

Enable Interrupts
Enable Urxc
On Urxc Reciver_uart

Config Portd.1 = Input

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Portd.7 = Output : Portd.7 = 0 : Led_capslock Alias Portd.7

Dim A As Byte
Dim Status_capslock As Bit : Status_capslock = 0
Dim Status_line As Byte : Status_line = 1

Set Led_capslock

Gosub Display_start_text
Cursor On : Cursor Blink


Do

Loop

End

'***********************************************
Reciver_uart:
   A = Udr
   If A <> 0 Then
      If A = 25 Then
         Toggle Status_capslock
         If Status_capslock = 1 Then
            Set Led_capslock
         Else
            Reset Led_capslock
         End If
      End If
      If Status_capslock = 1 Then
         If A >= 97 And A <= 122 Then A = A - 32
      End If
      Gosub Display_chart
   End If
Return

'***********************************************
Display_start_text:
   Cls : Lcd "Press Key " : Waitms 700 : Cls
   Reset Led_capslock
Return

'***********************************************
Display_chart:
   Select Case A:
      Case 18:
         Cls
         Home
         Status_line = 1
      Case 13:
         If Status_line = 1 Then
            Lowerline
            Status_line = 2
         End If
      Case 16:
         Shiftcursor Left
         Lcd " ";
         Shiftcursor Left
      Case 32 To 126:
         Lcd Chr(a)
      End Select
Return