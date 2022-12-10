'GitHub Account: GitHub.com/AliRezaJoodi

'**********************************************
Sub Display_bar(byval Percent As Single)
   Local Bar_single As Single
   Local N5 As Byte
   Local N1 As Byte
   Local Bar As Byte
   Local I As Byte

   Locate 2 , 1

   Bar_single = percent / 100 : Bar_single = Bar_single * Maximum_bars : Bar = Bar_single
   N5 = Bar / 5
   For I = 1 To N5
      Lcd Chr(5)
   Next I

   N1 = Bar Mod 5
   If N1 = 4 Then Lcd Chr(4)
   If N1 = 3 Then Lcd Chr(3)
   If N1 = 2 Then Lcd Chr(2)
   If N1 = 1 Then Lcd Chr(1)

   I = 16 - N5 : If N1 <> 0 Then I = I - 1
   Lcd Space(i)
End Sub