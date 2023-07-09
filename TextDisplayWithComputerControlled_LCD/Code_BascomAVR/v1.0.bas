'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600

Config Lcdpin = Pin , Rs = Pina.0 , E = Pina.2 , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7
Config Lcd = 16 * 2
Cursor Blink
Cls

Dim Buffer As String * 17
Dim Command As String * 1
Dim Text As String * 16

Do
   Input Buffer
   Command = Mid(buffer , 1 , 1)
   Text = Mid(buffer , 2 , 17)

   If Command = "1" Then
      Locate 1 , 1 : Lcd "                "
      Locate 1 , 1 : Lcd Text
   Elseif Command = "2" Then
      Locate 2 , 1 : Lcd "                "
      Locate 2 , 1 : Lcd Text
   End If
Loop

End
