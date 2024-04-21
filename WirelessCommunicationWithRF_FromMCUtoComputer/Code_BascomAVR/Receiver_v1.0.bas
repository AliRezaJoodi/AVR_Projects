'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200

Config Lcdpin = Pin , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7 , E = Pina.2 , Rs = Pina.0
Config Lcd = 16 * 2
Config Pina.1 = Input
Cls
Lcd "OK" : Waitms 500 : Cls

Config Portb = Input : Portb = 0

Enable Interrupts
$baud = 9600
On Urxc Receiver_data
Enable Urxc

Dim Character_ascii As Byte
Dim Z As Byte
Dim S As String * 11

Dim Address As String * 3 : Address = "123"
Dim Status_string As String * 1
Dim Status_now As Byte
Dim Status_old As Byte : Status_old = 0
Dim Data_recive_string As String * 3
Dim Len_character As Byte

Do

Loop

End

'**************************************************
Receiver_data:
   Z = Udr
   Select Case Z
      Case 32 To 126:
         S = S + Chr(z)
      Case 13:
         Disable Urxc : Waitms 10
         Len_character = Len(s)
         Address = Mid(s , 1 , 3)
         If Address = "123" Then
            Status_string = Mid(s , 4 , 1)
            Status_now = Val(status_string)
            If Status_now <> Status_old Then
               Status_old = Status_now
               Data_recive_string = Mid(s , 5 , 3)
               Character_ascii = Val(data_recive_string)
               Gosub Lcd_drive
            End If
         End If
         S = ""
         Enable Urxc
   End Select
Return

'**************************************************
Lcd_drive:
      If Character_ascii <> 0 Then
         Select Case Character_ascii:
            Case 33 To 126:
               Lcd Chr(character_ascii)
            Case 12:
               Cls : Home
            Case 13
               Lowerline
            Case 8:
               Shiftcursor Left
               Lcd " ";
               Shiftcursor Left
         End Select
         Printbin Character_ascii
      End If
Return