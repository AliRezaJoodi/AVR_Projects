'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
'$crystal = 11059200
$crystal = 4000000
$lib "glcdKS108.lib"                                        '

Config Graphlcd = 128 * 64sed , Dataport = Portb , Controlport = Portd , Ce = 3 , Ce2 = 4 , Cd = 0 , Rd = 6 , Reset = 2 , Enable = 5
Cls : Setfont Font8x8

Enable Interrupts

Declare Function Get_touch() As Byte
Declare Sub Sahih_number()
Declare Sub Ashar_number()

Config Portc.2 = Input : Portc.2 = 1 : Set_key Alias Pinc.2

Config Portc.2 = Input
Config Portc.3 = Input
Ddra.0 = 0 : Porta.0 = 0

Config Adc = Single , Prescaler = Auto
Start Adc

Config Portc.1 = Output : Buzzer Alias Portc.1 : Reset Buzzer

Const Max_key = 19

Declare Sub Read_x
Declare Sub Read_y
Declare Sub Calculate

Dim Y_touch As Word
Dim X_touch As Word
Dim Key As Byte
Dim Key_status As Byte
Dim N(3) As Byte

Gosub Sound_number_key

Dim Pass_1_eeprom As Eram String * 1
Dim Pass_1 As String * 1

Alpha:

'Dim A As Byte
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

Dim W As Word
Dim Temp As Single
Dim Temp_string As String * 5

'Dim Temp_z As Single

'Dim I As Word : I = 0

'Gosub Test

'Gosub T1

'Gosub Table_start_text : End

'Call Table_plotted_1 : End


'Gosub Start_sub

Dim Status_loop As Bit : Status_loop = 0

Dim Error_status As Bit

'Main:

'Gosub Management_thermometer
'Z = 65
'Call Sahih_number()
'Lcdat Row_lcd , Column , Z_sahih_number
'Call Ashar_number()
'End
'Gosub Table_thermometer_menu
'Gosub Show_temp
'Gosub Management_menu

'Gosub Table_start_text

Management_menu:
   Cls : Gosub Table_select_menu
   Waitms 300
   Status_loop = 0
   Do
      N(1) = Get_touch()
      If Y_touch > 170 And Y_touch < 415 Then
         Gosub Sound_menu
         Gosub Management_calculator
      Elseif Y_touch > 454 And Y_touch < 692 Then
         Gosub Sound_menu
         Gosub Management_thermometer
      End If

      'Lcdat 6 , 1 , "X=" : Lcd X_touch ; "  "
      'Lcdat 7 , 1 , "Y=" : Lcd Y_touch ; "  "
      'Lcdat 8 , 1 , "Key=" : Lcd Key ; "  "
   Loop


End

'*********************************************
Management_calculator:
Management_calculator_satrt:
Cls : Gosub Table_calculator_menu
Setfont Font8x8
Key = Max_key
Count = 1
X = 0
Y = 0
Z = 0
Momayez = 0
Mark = 0
S = ""
Status = 0
Calculate_status = 0
Status_mark = 0
Z_sahih_number = 0
Z_status_ashar = 0
P1 = 0
P2 = 0
S1 = ""
Row_lcd = 3 : Column = 56
Lcdat Row_lcd , Column , " "
'S1:
Do
   If Set_key = 0 Then
      Waitms 30
      If Set_key = 0 Then
         Gosub Sound_menu
         Status_loop = 1
      End If
   End If
   N(1) = Get_touch()
   N(2) = Get_touch()
   If N(1) = N(2) Then
      Key = N(2)
   Else
      N(3) = Get_touch()
      If N(3) = N(2) Then
         Key = N(3)
      Else
         Key = Max_key
      End If
   End If

   'Lcdat 3 , 64 , "X=" : Lcd X_touch ; "  "
   'Lcdat 4 , 64 , "Y=" : Lcd Y_touch ; "  "
   'Lcdat 5 , 64 , "Key=" : Lcd Key ; "  "
   'Goto S1

   If Key <> Key_status And Key <> Max_key Then
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
            Cls : Gosub Table_calculator_menu               ' Call Table_plotted
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
            Cls : Gosub Table_calculator_menu               ' Call Table_plotted
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
         Cls : Gosub Table_calculator_menu                  ' Call Table_plotted
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
            Cls : Gosub Table_calculator_menu               ' Call Table_plotted
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

      Case 17:
         Gosub Sound_menu
         'Gosub Management_menu
         Status_loop = 1
         'Goto Alpha
      'Case 18:
         'Gosub Sound_menu
         'Goto Management_calculator_satrt
      If X_touch > 87 And X_touch < 380 Then
         If Y_touch > 175 And Y_touch < 246 Then
            Gosub Sound_menu
            Goto Management_calculator_satrt
         End If
      End If
   End Select
   End If
   Key_status = Key
   If X_touch > 87 And X_touch < 380 Then
         If Y_touch > 175 And Y_touch < 246 Then
            Gosub Sound_menu
            Goto Management_calculator_satrt
         End If
   End If
Loop Until Status_loop = 1
   Key = Max_key : Status_loop = 0
   Cls : Gosub Table_select_menu
   Waitms 300
Return

'*********************************************
Management_thermometer:
   Cls : Gosub Table_thermometer_menu
   'Start Timer2
   S = ""
   Do
      If Set_key = 0 Then
         Waitms 30
         If Set_key = 0 Then
            Gosub Sound_menu
            Status_loop = 1
         End If
      End If

      Gosub Red_temp
      If Temp_string <> S Then
         S = Temp_string
         Gosub Show_temp
         Waitms 300
      End If

      N(1) = Get_touch()
      N(2) = Get_touch()
      If N(1) = N(2) Then
         Key = N(2)
      Else
         N(3) = Get_touch()
         If N(3) = N(2) Then
            Key = N(3)
         Else
            Key = Max_key
         End If
      End If

      If Key <> Key_status And Key <> 18 Then
         If Key = 17 Then
            Gosub Sound_menu
            Status_loop = 1
         End If
      End If
      Key_status = Key
   Loop Until Status_loop = 1
   Key = Max_key : Status_loop = 0
   Cls : Gosub Table_select_menu
   Waitms 300
Return


'*********************************************
Red_temp:
   W = Getadc(6)
   Temp = W / 2.048
   Temp_string = Fusing(temp , "#.#")
Return

'*********************************************
Show_temp:
   'Do
      'Gosub Red_temp
      'Temp_string = Fusing(temp , "#.#")
      'Temp_z = Val(temp_string)
      Setfont Font16x16 : Lcdat 5 , 15 , Temp_string ; "!" ; "C"
   'Loop
Return

'*********************************************
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
      If Y_touch > 280 And Y_touch < 363 Then Key = 1
      If Y_touch > 394 And Y_touch < 483 Then Key = 4
      If Y_touch > 515 And Y_touch < 607 Then Key = 7
      If Y_touch > 637 And Y_touch < 717 Then Key = 10
   Elseif X_touch > 170 And X_touch < 230 Then
      If Y_touch > 280 And Y_touch < 363 Then Key = 2
      If Y_touch > 394 And Y_touch < 483 Then Key = 5
      If Y_touch > 515 And Y_touch < 607 Then Key = 8
      If Y_touch > 637 And Y_touch < 717 Then Key = 0
   Elseif X_touch > 245 And X_touch < 315 Then
      If Y_touch > 280 And Y_touch < 363 Then Key = 3
      If Y_touch > 394 And Y_touch < 483 Then Key = 6
      If Y_touch > 515 And Y_touch < 607 Then Key = 9
      If Y_touch > 637 And Y_touch < 717 Then Key = 12
   Elseif X_touch > 325 And X_touch < 395 Then
      If Y_touch > 280 And Y_touch < 363 Then Key = 13
      If Y_touch > 394 And Y_touch < 483 Then Key = 14
      If Y_touch > 515 And Y_touch < 607 Then Key = 15
      If Y_touch > 637 And Y_touch < 717 Then Key = 16
    Elseif X_touch > 818 And X_touch < 869 Then
      If Y_touch > 166 And Y_touch < 250 Then Key = 17
    Elseif X_touch > 87 And X_touch < 380 Then
      If Y_touch > 175 And Y_touch < 246 Then Key = 18
   Else
      Key = Max_key
   End If
Get_touch = Key
End Function

'*********************************************
Table_start_text:
   Cls : Setfont Font8x8
   Lcdat 1 , 1 , "Master:"
   Lcdat 2 , 1 , "Somaye Hashemi"
   Lcdat 4 , 1 , "Student:"
   Lcdat 5 , 1 , "Behzad"
   Lcdat 6 , 49 , "Misaghiyan"
   Lcdat 7 , 1 , "Ghodrat"
   Lcdat 8 , 58 , "Nemati"
   Wait 4
   Cls
   Lcdat 1 , 1 , "   Electronic   "
   Lcdat 2 , 1 , "     Course     "
   Lcdat 3 , 1 , "   Management   "
   Lcdat 4 , 1 , "     Group:     "
   Lcdat 6 , 1 , "  DR.Zebardast  "
   Wait 4
Return

'*********************************************
Table_select_menu:
   Cls : Showpic 0 , 0 , P5
Return

'*********************************************
Table_calculator_menu:
   Cls : Showpic 0 , 0 , Pic2
Return

'*********************************************
Table_thermometer_menu:
   Cls : Showpic 0 , 0 , P3
Return

'*********************************************
Sound_error:
   Sound Buzzer , 10 , 1500
Return

'*********************************************
Sound_number_key:
   Sound Buzzer , 100 , 250
Return

'*********************************************
Sound_menu:
   Sound Buzzer , 70 , 300
Return

'*********************************************
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

'*********************************************
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

'*********************************************
Calculate:
Select Case Mark
Case 16:
   Z = X / Y
   If Y = 0 Then Error_status = 1
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
If Error_status = 1 Then S = "ERROR"
'If Z > 9999999 Or Z < -9999999 Then S = "OUT"

N(1) = Len(s)
If N(1) > 8 Then
   S = Fusing(z , "#.#")
   N(1) = Len(s)
   N(2) = N(1) - 2
   If N(1) > 8 Then
      S = Mid(s , 1 , N(2))
      N(1) = Len(s)
      If N(1) > 8 Then
         S = "OUT"
      End If
   End If
End If

Lcd S
Error_status = 0
'X1 = Z
Calculate_status = 1
Status_mark = 0
X = Z : Y = 0 : Momayez = 0
Return

'*********************************************
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

'*********************************************
Sub Sahih_number()
   P1 = Round(z)
   'P1 = P1 + 1
   'Lcdat 4 , 64 , P1
   S1 = Str(p1)
   'S1 = "KJ"
   Lcdat 5 , 64 , S1
   Z_sahih_number = Len(s1)
End Sub

'*********************************************
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

'*********************************************
Pic2:
$bgf "Pictures/P2.bgf"

'*********************************************
P3:
$bgf "Pictures/P3.bgf"

'*********************************************
P5:
$bgf "Pictures/P5.bgf"

'*********************************************
$include "Fonts/font8x8.font"
$include "Fonts/font16x16.font"