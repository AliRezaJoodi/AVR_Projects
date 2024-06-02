'IN THE NAME OF GOD.
$regfile = "m32Def.dat"
$crystal = 8000000
$lib "gLcdKS108.lib"
Config Graphlcd = 128 * 64sed , Dataport = Portd , Controlport = Portb , Ce = 0_
     , Ce2 = 1 , Cd = 2 , Rd = 3 , Reset = 5 , Enable = 4
Dim X As Byte , Y As Byte , Temp As Word , Hossein As String * 3 , A As Byte
Dim O1 As String * 1 , O2 As String * 1 , O3 As String * 1 , Lcd_data As Byte
Dim Save As Byte , H As Byte
Config Adc = Single , Prescaler = Auto
Config Pina.1 = Input
'LEVEL1 START------------------------------------------------------------
Showpic 0 , 0 , Pic11
Do
If Pina.1 = 1 Then Exit Do
Loop
'LEVEL1 END--------------------------------------------------------------
'LEVEL2 START------------------------------------------------------------
Start Adc
Program_start1:
Temp = Getadc(0)
Temp = Temp / 2
If Temp = Save Then Goto Program_start1
Save = Temp
'LEVEL2 END--------------------------------------------------------------
'LEVEL3 START------------------------------------------------------------
Showpic 0 , 0 , Pic10
For X = 8 To 110 Step 1
Showpic X , 8 , Pic15
Next X
H = Temp + 8
For X = 8 To H Step 1
Showpic X , 8 , Pic12
Next X
'LEVEL3 END--------------------------------------------------------------
'LEVEL4 START------------------------------------------------------------
Hossein = Str(temp)
A = Len(hossein)
'LEVEL4 END--------------------------------------------------------------
'LEVEL5 START------------------------------------------------------------
Select Case A
'------------------------------------------------------------------------
   Case Is = 1
   Lcd_data = Val(hossein)
   Select Case Lcd_data
      Case Is = 0
      Showpic 0 , 32 , Pic0
      Case Is = 1
      Showpic 0 , 32 , Pic1
      Case Is = 2
      Showpic 0 , 32 , Pic2
      Case Is = 3
      Showpic 0 , 32 , Pic3
      Case Is = 1
      Showpic 0 , 32 , Pic1
      Case Is = 4
      Showpic 0 , 32 , Pic4
      Case Is = 5
      Showpic 0 , 32 , Pic5
      Case Is = 6
      Showpic 0 , 32 , Pic6
      Case Is = 7
      Showpic 0 , 32 , Pic7
      Case Is = 8
      Showpic 0 , 32 , Pic8
      Case Is = 9
      Showpic 0 , 32 , Pic9
      End Select
   Showpic 24 , 32 , Pic14
'------------------------------------------------------------------------
   Case Is = 2
   O1 = Mid(hossein , 1 , 1)
   Lcd_data = Val(o1)
   Select Case Lcd_data
      Case Is = 0
      Showpic 0 , 32 , Pic0
      Case Is = 1
      Showpic 0 , 32 , Pic1
      Case Is = 2
      Showpic 0 , 32 , Pic2
      Case Is = 3
      Showpic 0 , 32 , Pic3
      Case Is = 1
      Showpic 0 , 32 , Pic1
      Case Is = 4
      Showpic 0 , 32 , Pic4
      Case Is = 5
      Showpic 0 , 32 , Pic5
      Case Is = 6
      Showpic 0 , 32 , Pic6
      Case Is = 7
      Showpic 0 , 32 , Pic7
      Case Is = 8
      Showpic 0 , 32 , Pic8
      Case Is = 9
      Showpic 0 , 32 , Pic9
      End Select
   O2 = Mid(hossein , 2 , 1)
   Lcd_data = Val(o2)
   Select Case Lcd_data
      Case Is = 0
      Showpic 24 , 32 , Pic0
      Case Is = 1
      Showpic 24 , 32 , Pic1
      Case Is = 2
      Showpic 24 , 32 , Pic2
      Case Is = 3
      Showpic 24 , 32 , Pic3
      Case Is = 1
      Showpic 24 , 32 , Pic1
      Case Is = 4
      Showpic 24 , 32 , Pic4
      Case Is = 5
      Showpic 24 , 32 , Pic5
      Case Is = 6
      Showpic 24 , 32 , Pic6
      Case Is = 7
      Showpic 24 , 32 , Pic7
      Case Is = 8
      Showpic 24 , 32 , Pic8
      Case Is = 9
      Showpic 24 , 32 , Pic9
      End Select
   Showpic 48 , 32 , Pic14
'------------------------------------------------------------------------
End Select
Waitms 100
Goto Program_start1
'LEVEL5 END--------------------------------------------------------------
      Pic0:
      $bgf "0.bgf"
      Pic1:
      $bgf "1.bgf"
      Pic2:
      $bgf "2.bgf"
      Pic3:
      $bgf "3.bgf"
      Pic4:
      $bgf "4.bgf"
      Pic5:
      $bgf "5.bgf"
      Pic6:
      $bgf "6.bgf"
      Pic7:
      $bgf "7.bgf"
      Pic8:
      $bgf "8.bgf"
      Pic9:
      $bgf "9.bgf"
      Pic10:
      $bgf "CADR.bgf"
      Pic11:
      $bgf "TERMOMETER1.bgf"
      Pic12:
      $bgf "line.bgf"
      Pic14:
      $bgf "CANTIGRAD.bgf"
      Pic15:
      $bgf "CLS_TEMP.bgf"