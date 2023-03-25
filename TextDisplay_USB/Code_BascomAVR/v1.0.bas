'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600

Config Lcdpin = Pin , Rs = Pina.0 , E = Pina.2 , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7
Config Lcd = 16 * 2
Cursor Blink
Cls


Dim Txt As String * 22
Dim Command As String * 5
Dim Content As String * 16

Do
   Input Txt
   Command = Mid(txt , 1 , 1)
   Content = Mid(txt , 2 , 17)

   If Command = "1" Then
      Locate 1 , 1 : Lcd "                "
      Locate 1 , 1 : Lcd Content
   Elseif Command = "2" Then
      Locate 2 , 1 : Lcd "                "
      Locate 2 , 1 : Lcd Content
   End If
Loop

End

