'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
'$crystal = 11059200
$crystal = 8000000
$lib "glcdKS108.lib"                                        '

Config Graphlcd = 128 * 64sed , Dataport = Portb , Controlport = Portd , Ce = 3 , Ce2 = 4 , Cd = 0 , Rd = 6 , Reset = 2 , Enable = 5
Cls : Setfont Font8x8

Declare Function Get_touch() As Byte
Declare Sub Table_plotted()

Declare Sub Sahih_number()
Declare Sub Ashar_number()

Config Debounce = 30
Config Portd.7 = Input : Portd.7 = 1 : Up_key Alias Pind.7
Config Portc.0 = Input : Portc.0 = 1 : Set_key Alias Pinc.0
Config Portc.1 = Input : Portc.1 = 1 : Down_key Alias Pinc.1

Config Portc.2 = Input
Config Portc.3 = Input
Ddra.0 = 0 : Porta.0 = 0

Config Adc = Single , Prescaler = Auto
Start Adc


Config Portc.1 = Output : Buzzer Alias Portc.1 : Reset Buzzer

Declare Sub Read_x
Declare Sub Read_y
Declare Sub Calculate

Dim Y_touch As Word
Dim X_touch As Word
Dim Key As Byte
Dim Key_status As Byte
Dim N(3) As Byte

Gosub Sound_number_key

Alpha:

Dim Row_lcd As Byte
Dim Column As Byte

Dim Count As Byte
Dim X As Single
Dim Y As Single
Dim Z As Single
Dim Mark As Byte
Dim Momayez As Byte : Momayez = 0
Dim S As String * 16

Dim Status As Byte
Dim Calculate_status As Bit : Calculate_status = 0
'Dim Key_status As Byte
Dim Status_mark As Byte : Status_mark = 0


Dim Z_sahih_number As Byte
Dim Z_status_ashar As Bit
   Dim P1 As Word
   Dim S1 As String * 3
   Dim P2 As Single
'Gosub Test

'Gosub T1

'Gosub Test3 : Wait 2

Call Table_plotted
Key = 0
Count = 1
X = 0
Y = 0
Z = 0
Mark = 0

'Gosub Start_sub


Main:

Row_lcd = 3 : Column = 64
Lcdat Row_lcd , Column , " "

'Z = 65
'Call Sahih_number()
'Lcdat Row_lcd , Column , Z_sahih_number
'Call Ashar_number()
'End

Do
   N(1) = Get_touch()
   N(2) = Get_touch()
   If N(1) = N(2) Then
      Key = N(2)
   Else
      'Waitms 10
      N(3) = Get_touch()
      If N(3) = N(2) Then
         Key = N(3)
      Else
         Key = 18
      End If
   End If

   If Key <> Key_status And Key <> 18 Then
   Select Case Key
      Case 0 To 9:
      If Calculate_status = 0 Then
         Status_mark = 0
         Gosub Sound_number_key
         If Count = 1 Then Call Read_x
         If Count = 2 Then Call Read_y
         If Momayez > 0 Then Incr Momayez
      End If
      Case 16:
         If Mark > 0 Then
          Gosub Calculate_2                                 ': Gosub Sound_menu
         End If
         Count = 2 : Mark = 16 : Momayez = 0 : Status = 1
         If Calculate_status = 1 Then
            Cls : Call Table_plotted
            'Lcdat 3 , 64 , S                                ': Gosub Sound_menu
            'Calculate_status = 0
            Row_lcd = 3 : Column = 64
            Lcdat Row_lcd , Column , " " : Lcd S
            Calculate_status = 0
         End If
         If Status_mark = 0 Then
            If Row_lcd < 7 Then Incr Row_lcd
            Lcdat Row_lcd , Column , "/"
            'Lcd "/"
            Gosub Sound_menu
            Status_mark = 1
         End If
      Case 15:
         If Mark > 0 Then
            Gosub Calculate_2                               ': Gosub Sound_menu
         End If
         Count = 2 : Mark = 15 : Momayez = 0 : Status = 1
         If Calculate_status = 1 Then
            Cls : Call Table_plotted
            Row_lcd = 3 : Column = 64
            Lcdat Row_lcd , Column , " " : Lcd S
            'Lcdat 3 , 64 , S                                ': Gosub Sound_menu
            Calculate_status = 0
         End If
         If Status_mark = 0 Then
            If Row_lcd < 7 Then Incr Row_lcd
            Lcdat Row_lcd , Column , "*"
            Gosub Sound_menu
            Status_mark = 1
         End If
      Case 14:
         If Mark > 0 Then
          Gosub Calculate_2                                 ': Gosub Sound_menu
         End If
         Count = 2 : Mark = 14 : Momayez = 0 : Status = 1
         If Calculate_status = 1 Then
         Cls : Call Table_plotted
            Row_lcd = 3 : Column = 64
            Lcdat Row_lcd , Column , " " : Lcd S
            'Lcdat 3 , 64 , S
            'Lcd S                                           ': Gosub Sound_menu
            Calculate_status = 0
         End If
         If Status_mark = 0 Then
            If Row_lcd < 7 Then Incr Row_lcd
            Lcdat Row_lcd , Column , "-"
            Gosub Sound_menu
            Status_mark = 1
         End If
      Case 13:
         If Mark > 0 Then
          Gosub Calculate_2                                 ': Gosub Sound_menu
         End If
       Count = 2 : Mark = 13 : Momayez = 0 : Status = 1
         If Calculate_status = 1 Then
            Cls : Call Table_plotted
            Row_lcd = 3 : Column = 64
            Lcdat Row_lcd , Column , " " : Lcd S
            'Lcdat 3 , 64 , S                                ': Gosub Sound_menu
            Calculate_status = 0
         End If
         If Status_mark = 0 Then
            If Row_lcd < 7 Then Incr Row_lcd
            Lcdat Row_lcd , Column , "+"
            Gosub Sound_menu
            Status_mark = 1
         End If
      Case 12:
          Status = 3
         If Count = 2 Then
          Call Calculate : Gosub Sound_menu
         End If
      Case 10:
      If Calculate_status = 0 Then

      If Momayez = 0 Then
         Status = 2
         Incr Momayez
            'If Row_lcd < 7 Then Incr Row_lcd
            'Lcdat Row_lcd , Column , "."
            Lcd "."
         Gosub Sound_number_key
      End If
      End If

      Case 17 :
         Gosub Sound_menu
         Goto Alpha
   End Select
   End If
   Key_status = Key
Loop

End


'****************************
Test3:
   Setfont Font8x8
   Lcdat 1 , 1 , "Line 1"
   Lcdat 2 , 1 , "Line 2"
   Lcdat 3 , 1 , "Line 3"
   Lcdat 4 , 1 , "Line 4"
   Lcdat 5 , 1 , "Line 5"
   Lcdat 6 , 1 , "Line 6"
   Lcdat 7 , 1 , "Line 7"
   Lcdat 8 , 1 , "Line 8"
Return

'****************************
Test:
   Call Table_plotted
   Lcdat 3 , 64 , " " : Lcd "98"
   Lcdat 4 , 64 , "+" : Lcd "5"
   Lcdat 5 , 64 , "-" : Lcd "71"
   Lcdat 6 , 64 , "/" : Lcd "5"
   Lcdat 7 , 64 , "=" : Lcd "6.4"
   End
Return

'****************************
Function Get_touch() As Byte
   Ddra.1 = 1 : Porta.1 = 0
   Ddra.3 = 1 : Porta.3 = 1
   Ddra.0 = 0 : Porta.0 = 0
   Ddra.2 = 0 : Porta.2 = 0
   Waitms 20 : Y_touch = Getadc(0)
   Ddra.0 = 1 : Porta.0 = 0
   Ddra.2 = 1 : Porta.2 = 1
   Ddra.1 = 0 : Porta.1 = 0
   Ddra.3 = 0 : Porta.3 = 0
   Waitms 20 : X_touch = Getadc(1)
   If X_touch > 89 And X_touch < 155 Then
      If Y_touch > 305 And Y_touch < 415 Then Key = 1
      If Y_touch > 440 And Y_touch < 545 Then Key = 4
      If Y_touch > 565 And Y_touch < 675 Then Key = 7
      If Y_touch > 688 And Y_touch < 776 Then Key = 10
   Elseif X_touch > 170 And X_touch < 230 Then
      If Y_touch > 305 And Y_touch < 415 Then Key = 2
      If Y_touch > 440 And Y_touch < 545 Then Key = 5
      If Y_touch > 565 And Y_touch < 675 Then Key = 8
      If Y_touch > 688 And Y_touch < 776 Then Key = 0
   Elseif X_touch > 245 And X_touch < 315 Then
      If Y_touch > 305 And Y_touch < 415 Then Key = 3
      If Y_touch > 440 And Y_touch < 545 Then Key = 6
      If Y_touch > 565 And Y_touch < 675 Then Key = 9
      If Y_touch > 688 And Y_touch < 776 Then Key = 12
   Elseif X_touch > 325 And X_touch < 395 Then
      If Y_touch > 305 And Y_touch < 415 Then Key = 13
      If Y_touch > 440 And Y_touch < 545 Then Key = 14
      If Y_touch > 565 And Y_touch < 675 Then Key = 15
      If Y_touch > 688 And Y_touch < 776 Then Key = 16
    Elseif X_touch > 800 And X_touch < 875 Then
      If Y_touch > 185 And Y_touch < 265 Then Key = 17
   Else
      Key = 18
   End If

   Get_touch = Key
End Function

'****************************
Sub Table_plotted()
   Cls
   Showpic 0 , 0 , Pic2
   'Lcdat 3 , 56 , "0"
   'Lcdat 3 , 64 , "32*/"
End Sub

'****************************
T1:
Do
   Ddra.2 = 1 : Porta.2 = 0
   Ddra.4 = 1 : Porta.4 = 1
   Ddra.1 = 0 : Porta.1 = 0
   Ddra.3 = 0 : Porta.3 = 0
   Waitms 20 : Y_touch = Getadc(1)
   Ddra.1 = 1 : Porta.1 = 0
   Ddra.3 = 1 : Porta.3 = 1
   Ddra.2 = 0 : Porta.2 = 0
   Ddra.4 = 0 : Porta.4 = 0
   Waitms 20 : X_touch = Getadc(2)

   Lcdat 3 , 64 , "X=" : Lcd X_touch ; "  "
   Lcdat 4 , 64 , "Y=" : Lcd Y_touch ; "  "
   Lcdat 5 , 64 , "Key=" : Lcd Key ; "  "
Loop
Return

'****************************
Sound_error:
Sound Buzzer , 10 , 1500
Return

'****************************
Sound_number_key:
Sound Buzzer , 100 , 250
Return

'****************************
Sound_menu:
Sound Buzzer , 70 , 300
Return

'****************************
Read_x:
Status = 1
Lcd Key
If Momayez = 0 Then
   Z = Key / 1 : X = X * 10 : X = X + Z
Elseif Momayez = 1 Then
   Z = Key / 10 : X = X + Z
Elseif Momayez = 2 Then
   Z = Key / 100 : X = X + Z
Elseif Momayez = 3 Then
   Z = Key / 1000 : X = X + Z
Elseif Momayez = 4 Then
   Z = Key / 10000 : X = X + Z
End If
Return


'****************************
Read_y:
Status = 2
Lcd Key
If Momayez = 0 Then
   Y = Y * 10 : Y = Y + Key
Elseif Momayez = 1 Then
   Z = Key / 10 : Y = Y + Z
Elseif Momayez = 2 Then
   Z = Key / 100 : Y = Y + Z
Elseif Momayez = 3 Then
   Z = Key / 1000 : Y = Y + Z
Elseif Momayez = 4 Then
   Z = Key / 10000 : Y = Y + Z
End If
Return

'****************************
Calculate:
Select Case Mark
Case 16:
Z = X / Y
Case 15:
Z = X * Y
Case 14:
Z = X - Y
Case 13:
Z = X + Y
End Select
'Locate 2 , 1
'Lcdat 5 , 64 , "="
S = Fusing(z , "#.##")
    If Row_lcd < 8 Then Incr Row_lcd
    Lcdat Row_lcd , Column , "="
'Lcdat 5 , 64 , "="
Lcd S
'X1 = Z
Calculate_status = 1
Status_mark = 0
X = Z : Y = 0 : Momayez = 0
Return

'****************************
Calculate_2:
   Select Case Mark
      Case 16:
         Z = X / Y
      Case 15:
         Z = X * Y
      Case 14:
         Z = X - Y
      Case 13:
         Z = X + Y
   End Select
   X = Z : Y = 0
Return

'****************************
Sub Sahih_number()
   P1 = Round(z)
   'P1 = P1 + 1
   'Lcdat 4 , 64 , P1
   S1 = Str(p1)
   'S1 = "KJ"
   Lcdat 5 , 64 , S1
   Z_sahih_number = Len(s1)
End Sub

'****************************
Sub Ashar_number()
   P2 = Z - P1
   'Lcdat 6 , 64 , P2
   If P2 = 0 Then
      Z_status_ashar = 0
     Else
     Z_status_ashar = 1
    End If
    Lcdat 6 , 64 , Z_status_ashar
End Sub

'****************************
Pic2:
$bgf "P2.bgf"

'****************************
$include "font8x8.font"
'$include "font16x16.font"