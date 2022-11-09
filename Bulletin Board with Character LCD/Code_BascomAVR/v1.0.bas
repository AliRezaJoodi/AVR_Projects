'GitHub Account: Github.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls

Dim Txt As String * 16
Dim Letter As String * 1
Dim Length As Byte
Dim W As Byte
Dim X As Byte
Dim Y As Byte
Dim I As Byte

Gosub Test1
Gosub Test2
Waitms 500
Gosub Test3

Do
Loop

End

'*******************************
Test3:
   Dim Txt2 As String * 32 : Txt2 = "Github.com/Alirezajoodi"
   Length = Len(txt2) : Length = Length + 16
   Cls : Locate 1 , 16 : Lcd Txt2
   For I = 1 To Length
      Shiftlcd Left
      Waitms 150
   Next
Return

'*******************************
Test2:
   Txt = "AliRezaJoodi"
   Length = Len(txt)
   Y = 17
   For W = Length To 1 Step -1
      Letter = Mid(txt , W , 1)
      Decr Y
      For I = 1 To Y
         X = I
         Locate 2 , X : Lcd Letter
         Decr X : Locate 2 , X : Lcd " "
         Waitms 10
      Next
   Next
Return

'*******************************
Test1:
   Txt = "GitHub.com"
   Length = Len(txt)
   For W = 1 To Length
      Letter = Mid(txt , W , 1)
      Y = 16 - W
      For I = 1 To Y
         X = 16 - I
         Locate 1 , X : Lcd Letter
         Incr X : Locate 1 , X : Lcd " "
         Waitms 10
      Next
   Next
Return