'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
'$crystal = 11059200
$crystal = 1000000

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
'Cursor Off
Cls

Config Kbd = Portd , Debounce = 30 , Delay = 100

Config Portb.0 = Output : Buzzer Alias Portb.0 : Reset Buzzer

Deflcdchar 0 , 32 , 4 , 32 , 31 , 32 , 4 , 32 , 32          ' /
Deflcdchar 1 , 32 , 17 , 10 , 4 , 10 , 17 , 32 , 32         ' *

Declare Sub Read_x
Declare Sub Read_y
Declare Sub Calculate

Dim A As Byte
Dim Count As Byte
Dim X As Single
Dim Y As Single
Dim Z As Single
Dim Mark As Byte
Dim Momayez As Byte : Momayez = 0
Dim S As String * 16

Dim Status As Byte
Dim Calculate_status As Bit : Calculate_status = 0
Dim Key_status As Byte
Dim Status_mark As Byte : Status_mark = 0

Alpha:

A = 0
Count = 1
X = 0
Y = 0
Z = 0
Mark = 0

Gosub Start_sub
Gosub Sound_number_key

Main:

Do
   A = Getkbd() : A = Lookup(a , Read_key)
   If A <> Key_status And A < 16 Then
   Select Case A
      Case 0 To 9:
      If Calculate_status = 0 Then
         Status_mark = 0
         Gosub Sound_number_key
         If Count = 1 Then Call Read_x
         If Count = 2 Then Call Read_y
         If Momayez > 0 Then Incr Momayez
      End If
      Case 10:
         If Mark > 0 Then
          Gosub Calculate_2                                 ': Gosub Sound_menu
         End If
         Count = 2 : Mark = 10 : Momayez = 0 : Status = 1
         If Calculate_status = 1 Then
            Cls
            Locate 1 , 1
            Lcd S                                           ': Gosub Sound_menu
            Calculate_status = 0
         End If
         If Status_mark = 0 Then
            Lcd Chr(0) : Gosub Sound_menu
            Status_mark = 1
         End If
      Case 11:
               If Mark > 0 Then
          Gosub Calculate_2                                 ': Gosub Sound_menu
         End If
         Count = 2 : Mark = 11 : Momayez = 0 : Status = 1
         If Calculate_status = 1 Then
            Cls
            Locate 1 , 1
            Lcd S                                           ': Gosub Sound_menu
            Calculate_status = 0
         End If
         If Status_mark = 0 Then
            Lcd Chr(1) : Gosub Sound_menu
            Status_mark = 1
         End If
      Case 12:
               If Mark > 0 Then
          Gosub Calculate_2                                 ': Gosub Sound_menu
         End If
         Count = 2 : Mark = 12 : Momayez = 0 : Status = 1
         If Calculate_status = 1 Then
            Cls
            Locate 1 , 1
            Lcd S                                           ': Gosub Sound_menu
            Calculate_status = 0
         End If
         If Status_mark = 0 Then
            Lcd "-" : Gosub Sound_menu
            Status_mark = 1
         End If
      Case 13:
         If Mark > 0 Then
          Gosub Calculate_2                                 ': Gosub Sound_menu
         End If
       Count = 2 : Mark = 13 : Momayez = 0 : Status = 1
         If Calculate_status = 1 Then
            Cls
            Locate 1 , 1
            Lcd S                                           ': Gosub Sound_menu
            Calculate_status = 0
         End If
         If Status_mark = 0 Then
            Lcd "+" : Gosub Sound_menu
            Status_mark = 1
         End If
      Case 14:
          Status = 3
         If Count = 2 Then
          Call Calculate : Gosub Sound_menu
         End If
      Case 15:
      If Calculate_status = 0 Then

      If Momayez = 0 Then
         Status = 2
         Incr Momayez
         Lcd "." : Gosub Sound_number_key
      End If
      End If
   End Select
  End If
  Key_status = A
Loop

End

Start_sub:
   Cls : Lcd "Calculator" : Waitms 600 : Cls
Return

'***************************************************
Sound_error:
Sound Buzzer , 10 , 1500
Return

Sound_number_key:
Sound Buzzer , 100 , 250
Return

Sound_menu:
Sound Buzzer , 70 , 300
Return

'**************************** RED Keyboard
Read_key:
'Data 13 , 14 , 0 , 15 , 11 , 6 , 5 , 4 , 10 , 9 , 8 , 7 , 12 , 3 , 2 , 1
Data 10 , 14 , 0 , 15 , 12 , 6 , 5 , 4 , 11 , 9 , 8 , 7 , 13 , 3 , 2 , 1

'**************************** Reading X
Read_x:
Status = 1
Lcd A
If Momayez = 0 Then
   Z = A / 1 : X = X * 10 : X = X + Z
Elseif Momayez = 1 Then
   Z = A / 10 : X = X + Z
Elseif Momayez = 2 Then
   Z = A / 100 : X = X + Z
Elseif Momayez = 3 Then
   Z = A / 1000 : X = X + Z
Elseif Momayez = 4 Then
   Z = A / 10000 : X = X + Z
End If
Return


'**************************** Reading Y
Read_y:
Status = 2
Lcd A
If Momayez = 0 Then
   Y = Y * 10 : Y = Y + A
Elseif Momayez = 1 Then
   Z = A / 10 : Y = Y + Z
Elseif Momayez = 2 Then
   Z = A / 100 : Y = Y + Z
Elseif Momayez = 3 Then
   Z = A / 1000 : Y = Y + Z
Elseif Momayez = 4 Then
   Z = A / 10000 : Y = Y + Z
End If
Return

'**************************** Calculate
Calculate:
Select Case Mark
Case 10:
Z = X / Y
Case 11:
Z = X * Y
Case 12:
Z = X - Y
Case 13:
Z = X + Y
End Select
Locate 2 , 1
Lcd "="
S = Fusing(z , "#.##")
Lcd S
'X1 = Z
Calculate_status = 1
Status_mark = 0
X = Z : Y = 0 : Momayez = 0
Return

'**************************** Calculate
Calculate_2:
Select Case Mark
Case 10:
Z = X / Y
Case 11:
Z = X * Y
Case 12:
Z = X - Y
Case 13:
Z = X + Y
End Select

X = Z : Y = 0
Return
