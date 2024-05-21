'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
'$crystal = 11059200
$crystal = 4000000
$lib "glcdKS108.lib"                                        '

Config Graphlcd = 128 * 64sed , Dataport = Portb , Controlport = Portd , Ce = 3 , Ce2 = 4 , Cd = 0 , Rd = 6 , Reset = 2 , Enable = 5
Cls : Setfont Font8x8

Declare Function Get_touch() As Byte
Declare Sub Table_plotted()
Declare Sub Red_led_drive()
Declare Sub Yellow_led_drive()
Declare Sub Personal_status_driver()
Declare Sub Check_win()
Declare Sub Win_display()
Declare Sub Reset_all()

Config Debounce = 30
Config Portc.2 = Input : Portc.2 = 1 : Key_set Alias Pinc.2
Config Portc.1 = Output : Portc.1 = 0 : Sound_pin Alias Portc.1
Config Portc.3 = Input

Config Adc = Single , Prescaler = Auto
Start Adc

Dim Y As Word
Dim X As Word
Dim Z As Word
Dim Col As Byte
Dim Row As Byte
Dim Key As Byte

Dim N(5) As Byte

Dim Key_status As Byte
Dim Play_status As Bit : Play_status = 0
Dim Personal_status As Bit : Personal_status = 0

Dim Personal_red As Byte : Personal_red = 0
Dim Personal_yellow As Byte : Personal_yellow = 0

Dim Win_red As Bit : Win_red = 0
Dim Win_yellow As Bit : Win_yellow = 0

Dim Number_red As Byte
Dim Number_yellow As Byte

Dim Yellow_1 As Bit
Dim Yellow_2 As Bit
Dim Yellow_3 As Bit
Dim Yellow_4 As Bit
Dim Yellow_5 As Bit
Dim Yellow_6 As Bit
Dim Yellow_7 As Bit
Dim Yellow_8 As Bit
Dim Yellow_9 As Bit

Dim Red_1 As Bit
Dim Red_2 As Bit
Dim Red_3 As Bit
Dim Red_4 As Bit
Dim Red_5 As Bit
Dim Red_6 As Bit
Dim Red_7 As Bit
Dim Red_8 As Bit
Dim Red_9 As Bit

Dim Home_1 As Bit
Dim Home_2 As Bit
Dim Home_3 As Bit
Dim Home_4 As Bit
Dim Home_5 As Bit
Dim Home_6 As Bit
Dim Home_7 As Bit
Dim Home_8 As Bit
Dim Home_9 As Bit

Gosub Table_plotted
Gosub Personal_status_driver
Gosub Win_display

Gosub Sound_menu

'Win_red = 1 : Gosub Win_display

Do
   If Key_set = 0 Then
      Waitms 30
      If Key_set = 0 Then
         Goto F1
      End If
   End If

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
         Key = 0
      End If
   End If

   If Key <> Key_status And Key <> 0 Then
      Select Case Key
         Case 1:
            If Play_status = 0 And Home_1 = 0 And Personal_status = 0 Then
               Set Red_1 : Home_1 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 1
               Gosub Sound_pressing
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_1 = 0 And Personal_status = 1 Then
               Set Yellow_1 : Home_1 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 1
               Gosub Sound_pressing
               Gosub Personal_status_driver
            End If
         Case 2:
            If Play_status = 0 And Home_2 = 0 And Personal_status = 0 Then
               Set Red_2 : Home_2 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 2
               Gosub Sound_pressing
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_2 = 0 And Personal_status = 1 Then
               Set Yellow_2 : Home_2 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 2
               Gosub Sound_pressing
               Gosub Personal_status_driver
            End If
         Case 3:
            If Play_status = 0 And Home_3 = 0 And Personal_status = 0 Then
               Set Red_3 : Home_3 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 3
               Gosub Personal_status_driver
               Gosub Sound_pressing
            Elseif Play_status = 0 And Home_3 = 0 And Personal_status = 1 Then
               Set Yellow_3 : Home_3 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 3
               Gosub Sound_pressing
               Gosub Personal_status_driver
            End If
         Case 4:
            If Play_status = 0 And Home_4 = 0 And Personal_status = 0 Then
               Set Red_4 : Home_4 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 4
               Gosub Sound_pressing
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_4 = 0 And Personal_status = 1 Then
               Set Yellow_4 : Home_4 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 4
               Gosub Sound_pressing
               Gosub Personal_status_driver
            End If
         Case 5:
            If Play_status = 0 And Home_5 = 0 And Personal_status = 0 Then
               Set Red_5 : Home_5 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 5
               Gosub Sound_pressing
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_5 = 0 And Personal_status = 1 Then
               Set Yellow_5 : Home_5 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 5
               Gosub Sound_pressing
               Gosub Personal_status_driver
            End If
         Case 6:
            If Play_status = 0 And Home_6 = 0 And Personal_status = 0 Then
               Set Red_6 : Home_6 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 6
               Gosub Sound_pressing
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_6 = 0 And Personal_status = 1 Then
               Set Yellow_6 : Home_6 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 6
               Gosub Sound_pressing
               Gosub Personal_status_driver
            End If
         Case 7:
            If Play_status = 0 And Home_7 = 0 And Personal_status = 0 Then
               Set Red_7 : Home_7 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 7
               Gosub Sound_pressing
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_7 = 0 And Personal_status = 1 Then
               Set Yellow_7 : Home_7 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 7
               Gosub Sound_pressing
               Gosub Personal_status_driver
            End If
         Case 8:
            If Play_status = 0 And Home_8 = 0 And Personal_status = 0 Then
               Set Red_8 : Home_8 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 8
               Gosub Sound_pressing
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_8 = 0 And Personal_status = 1 Then
               Set Yellow_8 : Home_8 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 8
               Gosub Sound_pressing
               Gosub Personal_status_driver
            End If
            'Incr K
         Case 9:
            If Play_status = 0 And Home_9 = 0 And Personal_status = 0 Then
               Set Red_9 : Home_9 = 1 : Gosub Red_led_drive
               Personal_red = Personal_red + 9
               Gosub Sound_pressing
               Gosub Personal_status_driver
            Elseif Play_status = 0 And Home_9 = 0 And Personal_status = 1 Then
               Set Yellow_9 : Home_9 = 1 : Gosub Yellow_led_drive
               Personal_yellow = Personal_yellow + 9
               Gosub Sound_pressing
               Gosub Personal_status_driver
            End If
         Case 10:
            F1:
            'Play_status = 0
            Gosub Sound_menu
            Cls
            Gosub Table_plotted
            Gosub Reset_all
            'Gosub Red_led_drive
            'Gosub Yellow_led_drive
            Gosub Personal_status_driver
            'Lcdat 2 , 78 , "A=" : Lcd Number_red : Lcd " "
            Lcdat 3 , 85 , "=" : Lcd Number_red : Lcd "  "
            'Lcdat 3 , 78 , "B=" : Lcd Number_yellow : Lcd " "
            Lcdat 5 , 85 , "=" : Lcd Number_yellow : Lcd "  "
         Case 11:
            Gosub Sound_menu
            'Play_status = 0
            Cls
            Gosub Table_plotted
            Gosub Reset_all
            'Gosub Red_led_drive
            'Gosub Yellow_led_drive
            Gosub Personal_status_driver
            Number_red = 0 : Number_yellow = 0
            'Lcdat 2 , 78 , "A=" : Lcd Number_red : Lcd " "
            Lcdat 3 , 85 , "=" : Lcd Number_red : Lcd "  "
            'Lcdat 3 , 78 , "B=" : Lcd Number_yellow : Lcd " "
            Lcdat 5 , 85 , "=" : Lcd Number_yellow : Lcd "  "
      End Select
      Gosub Check_win
      If Play_status = 0 Then
         If Win_red = 1 Or Win_yellow = 1 Then
            Gosub Win_display
            Play_status = 1
         End If
      End If
      Key_status = Key
   End If
   'WAITMS 300
   'waitms 500: gosub  RESET_ALL
Loop

End

'*****************************************
Function Get_touch() As Byte
   Ddra.1 = 1 : Porta.1 = 0
   Ddra.3 = 1 : Porta.3 = 1
   Ddra.0 = 0 : Porta.0 = 0
   Ddra.2 = 0 : Porta.2 = 0
   Waitms 20 : Y = Getadc(0)
   Ddra.0 = 1 : Porta.0 = 0
   Ddra.2 = 1 : Porta.2 = 1
   Ddra.1 = 0 : Porta.1 = 0
   Ddra.3 = 0 : Porta.3 = 0
   Waitms 20 : X = Getadc(1)
   If X > 100 And X < 210 Then
      If Y > 185 And Y < 350 Then Key = 1
      If Y > 385 And Y < 550 Then Key = 4
      If Y > 575 And Y < 740 Then Key = 7
   Elseif X > 227 And X < 337 Then
      If Y > 185 And Y < 350 Then Key = 2
      If Y > 385 And Y < 550 Then Key = 5
      If Y > 575 And Y < 740 Then Key = 8
   Elseif X > 350 And X < 460 Then
      If Y > 185 And Y < 350 Then Key = 3
      If Y > 385 And Y < 550 Then Key = 6
      If Y > 575 And Y < 740 Then Key = 9
   Elseif X > 515 And X < 647 Then
      If Y > 695 And Y < 750 Then Key = 10
   Elseif X > 750 And X < 864 Then
      If Y > 682 And Y < 735 Then Key = 11
   Else
      Key = 0
   End If
   Get_touch = Key
End Function

'*****************************************
Sub Table_plotted()
For X = 2 To 62 Step 20
   Line(x , 2) -(x , 62) , 255
   'Line(2 , 2) -(2 , 62) , 255
   'Line(22 , 2) -(22 , 62) , 255
   'Line(42 , 2) -(42 , 62) , 255
   'Line(62 , 2) -(62 , 62) , 255
Next X
For Y = 2 To 62 Step 20
   Line(2 , Y) -(62 , Y) , 255
   'Line(2 , 2) -(62 , 2) , 255
   'Line(2 , 22) -(62 , 22) , 255
   'Line(2 , 42) -(62 , 42) , 255
   'Line(2 , 62) -(62 , 62) , 255
Next Y
'Line(2 , 32) -(62 , 32) , 255

   Lcdat 8 , 70 , "CLS"
   Lcdat 8 , 106 , "NEW"
   Circle(75 , 18) , 4 , 255
   Lcdat 3 , 85 , "=" : Lcd Number_red
   Line(71 , 30) -(79 , 38) , 255 : Line(71 , 38) -(79 , 30) , 255
   Lcdat 5 , 85 , "=" : Lcd Number_yellow
End Sub

'*****************************************
Draw_a_circle:
   Circle(12 , 12) , 6 , 255
   Circle(32 , 12) , 6 , 255
   Circle(52 , 12) , 6 , 255

   Circle(12 , 32) , 6 , 255
   Circle(32 , 32) , 6 , 255
   Circle(52 , 32) , 6 , 255

   Circle(12 , 52) , 6 , 255
   Circle(32 , 52) , 6 , 255
   Circle(52 , 52) , 6 , 255
Return

'*****************************************
Multiply_line:
   Line(7 , 7) -(17 , 17) , 255 : Line(7 , 17) -(17 , 7) , 255
   Line(27 , 7) -(37 , 17) , 255 : Line(27 , 17) -(37 , 7) , 255
   Line(47 , 7) -(57 , 17) , 255 : Line(47 , 17) -(57 , 7) , 255

   Line(7 , 27) -(17 , 37) , 255 : Line(7 , 37) -(17 , 27) , 255
   Line(27 , 27) -(37 , 37) , 255 : Line(27 , 37) -(37 , 27) , 255
   Line(47 , 27) -(57 , 37) , 255 : Line(47 , 37) -(57 , 27) , 255

   Line(7 , 47) -(17 , 57) , 255 : Line(7 , 57) -(17 , 47) , 255
   Line(27 , 47) -(37 , 57) , 255 : Line(27 , 57) -(37 , 47) , 255
   Line(47 , 47) -(57 , 57) , 255 : Line(47 , 57) -(57 , 47) , 255
Return

T1:
   Circle(12 , 12) , 6 , 0
   Line(7 , 7) -(17 , 17) , 255 : Line(7 , 17) -(17 , 7) , 255
   Waitms 500
   Line(7 , 7) -(17 , 17) , 0 : Line(7 , 17) -(17 , 7) , 0
   Circle(12 , 12) , 6 , 255
Return

'*****************************************    Show_temp
Show_temp:
   Setfont Font8x8
   'Lcdat 2 , 78 , "X=" : Lcd X : Lcd "  "
   'Lcdat 3 , 78 , "Y=" : Lcd Y : Lcd "  "
   Lcdat 4 , 78 , "Key=" : Lcd Key : Lcd "  "
Return

'*****************************************
Sub Red_led_drive()
   If Red_1 = 1 Then Circle(12 , 12) , 6 , 255
   If Red_2 = 1 Then Circle(32 , 12) , 6 , 255
   If Red_3 = 1 Then Circle(52 , 12) , 6 , 255
   If Red_4 = 1 Then Circle(12 , 32) , 6 , 255
   If Red_5 = 1 Then Circle(32 , 32) , 6 , 255
   If Red_6 = 1 Then Circle(52 , 32) , 6 , 255
   If Red_7 = 1 Then Circle(12 , 52) , 6 , 255
   If Red_8 = 1 Then Circle(32 , 52) , 6 , 255
   If Red_9 = 1 Then Circle(52 , 52) , 6 , 255
End Sub

'*****************************************
Sub Yellow_led_drive()
   If Yellow_1 = 1 Then
      Line(7 , 7) -(17 , 17) , 255 : Line(7 , 17) -(17 , 7) , 255
   End If
   If Yellow_2 = 1 Then
      Line(27 , 7) -(37 , 17) , 255 : Line(27 , 17) -(37 , 7) , 255
   End If
   If Yellow_3 = 1 Then
      Line(47 , 7) -(57 , 17) , 255 : Line(47 , 17) -(57 , 7) , 255
   End If
   If Yellow_4 = 1 Then
      Line(7 , 27) -(17 , 37) , 255 : Line(7 , 37) -(17 , 27) , 255
   End If
   If Yellow_5 = 1 Then
      Line(27 , 27) -(37 , 37) , 255 : Line(27 , 37) -(37 , 27) , 255
   End If
   If Yellow_6 = 1 Then
      Line(47 , 27) -(57 , 37) , 255 : Line(47 , 37) -(57 , 27) , 255
   End If
   If Yellow_7 = 1 Then
      Line(7 , 47) -(17 , 57) , 255 : Line(7 , 57) -(17 , 47) , 255
   End If
   If Yellow_8 = 1 Then
      Line(27 , 47) -(37 , 57) , 255 : Line(27 , 57) -(37 , 47) , 255
   End If
   If Yellow_9 = 1 Then
      Line(47 , 47) -(57 , 57) , 255 : Line(47 , 57) -(57 , 47) , 255
   End If
End Sub

'*****************************************
Sub Personal_status_driver()
   Toggle Personal_status
   'Personal_status = 1
   If Personal_status = 0 Then
      Line(115 , 1) -(125 , 11) , 0 : Line(115 , 11) -(125 , 1) , 0
      Circle(120 , 6) , 6 , 255
   Else
      Circle(120 , 6) , 6 , 0
      Line(115 , 1) -(125 , 11) , 255 : Line(115 , 11) -(125 , 1) , 255
   End If
End Sub

'*****************************************
Sub Check_win()
   If Red_1 = 1 And Red_2 = 1 And Red_3 = 1 Then
         Win_red = 1 : Line(2 , 12) -(62 , 12) , 255
      Elseif Red_4 = 1 And Red_5 = 1 And Red_6 = 1 Then
         Win_red = 1 : Line(2 , 32) -(62 , 32) , 255
      Elseif Red_7 = 1 And Red_8 = 1 And Red_9 = 1 Then
         Win_red = 1 : Win_yellow = 1 : Line(2 , 52) -(62 , 52) , 255
      Elseif Red_1 = 1 And Red_4 = 1 And Red_7 = 1 Then
         Win_red = 1
         Line(12 , 2) -(12 , 62) , 255
      Elseif Red_2 = 1 And Red_5 = 1 And Red_8 = 1 Then
         Win_red = 1
         Line(32 , 2) -(32 , 62) , 255
      Elseif Red_3 = 1 And Red_6 = 1 And Red_9 = 1 Then
         Win_red = 1
         Line(52 , 2) -(52 , 62) , 255
      Elseif Red_1 = 1 And Red_5 = 1 And Red_9 = 1 Then
         Win_red = 1
         Line(2 , 2) -(62 , 62) , 255
      Elseif Red_3 = 1 And Red_5 = 1 And Red_7 = 1 Then
         Win_red = 1
         Line(2 , 62) -(62 , 2) , 255
   End If

   If Yellow_1 = 1 And Yellow_2 = 1 And Yellow_3 = 1 Then
         Win_yellow = 1 : Line(2 , 12) -(62 , 12) , 255
      Elseif Yellow_4 = 1 And Yellow_5 = 1 And Yellow_6 = 1 Then
         Win_yellow = 1 : Line(2 , 32) -(62 , 32) , 255
      Elseif Yellow_7 = 1 And Yellow_8 = 1 And Yellow_9 = 1 Then
         Win_yellow = 1 : Line(2 , 52) -(62 , 52) , 255
      Elseif Yellow_1 = 1 And Yellow_4 = 1 And Yellow_7 = 1 Then
         Win_yellow = 1
         Line(12 , 2) -(12 , 62) , 255
      Elseif Yellow_2 = 1 And Yellow_5 = 1 And Yellow_8 = 1 Then
         Win_yellow = 1
         Line(32 , 2) -(32 , 62) , 255
      Elseif Yellow_3 = 1 And Yellow_6 = 1 And Yellow_9 = 1 Then
         Win_yellow = 1
         Line(52 , 2) -(52 , 62) , 255
      Elseif Yellow_1 = 1 And Yellow_5 = 1 And Yellow_9 = 1 Then
         Win_yellow = 1
         Line(2 , 2) -(62 , 62) , 255
      Elseif Yellow_3 = 1 And Yellow_5 = 1 And Yellow_7 = 1 Then
         Win_yellow = 1
         Line(2 , 62) -(62 , 2) , 255
   End If

   'If Win_red = 1 Then Incr Number_red
   'If Win_yellow = 1 Then Incr Number_yellow

End Sub

'*****************************************
Sub Win_display()
   If Win_red = 1 Then
      Incr Number_red
      'Lcdat 6 , 78 , "Win A"
      'Lcdat 2 , 78 , "A=" : Lcd Number_red                  ': Lcd " "
      Lcdat 3 , 85 , "=" : Lcd Number_red : Lcd "  "
      Win_red = 0
      Lcdat 1 , 78 , "WIN"
      Line(115 , 1) -(125 , 11) , 0 : Line(115 , 11) -(125 , 1) , 0
      Circle(120 , 6) , 6 , 255
   End If
   If Win_yellow = 1 Then
      'Lcdat 6 , 78 , "Win B"
      Incr Number_yellow
      'Lcdat 3 , 78 , "B=" : Lcd Number_yellow               ': Lcd " "
      Lcdat 5 , 85 , "=" : Lcd Number_yellow
      Win_yellow = 0
      Lcdat 1 , 78 , "WIN" : Lcd "  "
      Circle(120 , 6) , 6 , 0
      Line(115 , 1) -(125 , 11) , 255 : Line(115 , 11) -(125 , 1) , 255
   End If
End Sub

'*****************************************
Sub Reset_all()
      Reset Yellow_1 : Reset Yellow_2 : Reset Yellow_3
      Reset Yellow_4 : Reset Yellow_5 : Reset Yellow_6
      Reset Yellow_7 : Reset Yellow_8 : Reset Yellow_9
      Reset Red_1 : Reset Red_2 : Reset Red_3
      Reset Red_4 : Reset Red_5 : Reset Red_6
      Reset Red_7 : Reset Red_8 : Reset Red_9
      Personal_red = 0 : Personal_yellow = 0
      Home_1 = 0 : Home_2 = 0 : Home_3 = 0
      Home_4 = 0 : Home_5 = 0 : Home_6 = 0
      Home_7 = 0 : Home_8 = 0 : Home_9 = 0

      Win_red = 0
      Win_yellow = 0
      Play_status = 0

      Lcdat 1 , 78 , "    "
      'If Win_red = 1 Then Lcdat 6 , 78 , "     "
End Sub

'*****************************************
Sound_pressing:
   Sound Sound_pin , 100 , 250
Return

'*****************************************
Sound_menu:
   Sound Sound_pin , 100 , 500
Return

'*****************************************
Sound_error:
   Sound Sound_pin , 30 , 2000
Return

$include "font8x8.font"
'$include "font16x16.font"