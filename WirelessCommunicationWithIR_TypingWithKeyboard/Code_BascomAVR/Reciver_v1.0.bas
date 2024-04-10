'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M16def.dat"
$crystal = 11059200

Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Config Lcd = 16 * 2
Cls

Enable Interrupts
Config Rc5 = Pind.7

Config Portb.1 = Output : Portb.1 = 0 : Led Alias Portb.1

Dim Msb As Byte
Dim Lsb As Byte
Dim Z As Byte
Dim S_asc As Byte

Dim Status_line As Byte : Status_line = 1

'Gosub Display_test

Do
   Reset Led
   Getrc5(msb , Lsb)
   'Set Led
   If Msb <> 255 Then
      Set Led
      Lsb = Lsb And &B00001111
      Gosub Convert
      Gosub Display_chart:
   End If
Loop

End

'***********************************************
Display_test:
   Cls : Lcd "Test LCD" : Waitms 800 : Cls
Return

'***********************************************     Show_on_the_lcd
Display_chart:
   Select Case S_asc:
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
         Lcd Chr(s_asc)
      End Select
Return

'*************************************************     Convert
Convert:
   Z = 16 * Msb
   S_asc = Z + Lsb
Return