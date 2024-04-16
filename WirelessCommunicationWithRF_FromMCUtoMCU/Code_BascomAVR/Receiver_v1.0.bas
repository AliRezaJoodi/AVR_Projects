'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 11059200
$baud = 19200

Enable Interrupts
Enable Urxc
On Urxc Reciver_uart

Config Portd.1 = Input

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Portb.0 = Output : Portb.0 = 0 : Led Alias Portb.0

Dim Key As Byte                                             ': Key = 65
Dim Key_string As String * 3
Dim Status_capslock As Bit : Status_capslock = 0
Dim Status_line As Byte : Status_line = 1

Dim I As Byte : I = 0
Dim I_string As String * 1

Dim Buffer_uart As Byte
Dim Buffer_data As String * 7

Dim Address As String * 3
Dim Status As Byte

Set Led
Gosub Display_start
Cursor On : Cursor Blink
Reset Led

Do

Loop

End

'***********************************************
Reciver_uart:
   Buffer_uart = Udr
   Select Case Buffer_uart
      Case 32 To 126:
         Buffer_data = Buffer_data + Chr(buffer_uart)
      Case 13:
         Disable Urxc
         Address = Mid(buffer_data , 1 , 3)
         If Address = "123" Then
            I_string = Mid(buffer_data , 4 , 1) : I = Val(i_string)
            Key_string = Mid(buffer_data , 5 , 3) : Key = Val(key_string)
            If I <> Status Then
               Set Led
               Status = I
               Gosub Display_chart
            End If
         End If
         Buffer_data = "" : Reset Led
         Enable Urxc
   End Select
Return

'***********************************************
Display_start:
   Cls : Lcd "Press Key " : Waitms 700 : Cls
Return

'***********************************************
Display_chart:
   Select Case Key:
      Case 18:
         Cls : Home : Status_line = 1
      Case 13:
         If Status_line = 1 Then
            Lowerline
            Status_line = 2
         End If
      Case 16:
         Shiftcursor Left : Lcd " " : Shiftcursor Left
      Case 32 To 126:
         Lcd Chr(key)
      End Select
Return