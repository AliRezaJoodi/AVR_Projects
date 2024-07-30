
$regfile = "m16def.dat"
$crystal = 16000000
$lib "glcdKS108.lib"                                        '

Config Graphlcd = 128 * 64sed , Dataport = Portd , Controlport = Portc , Ce = 1 , Ce2 = 2 , Cd = 5 , Rd = 4 , Reset = 0 , Enable = 3
Cls : Setfont Font8x8

'..............................................................................
Config Debounce = 30
Config Pinb.3 = Input : Portb.3 = 1 : Up_key Alias Pinb.3
Config Pinb.2 = Input : Portb.2 = 1 : Set_key Alias Pinb.2
Config Pinb.1 = Input : Portb.1 = 1 : Down_key Alias Pinb.1

'..............................................................................
Enable Interrupts
Config Clock = Soft : Time$ = "23:59:00"
Config Date = Ymd , Separator = / : Date$ = "90/02/28"

'..............................................................................
Config Adc = Single , Prescaler = Auto
Start Adc

Const Delay_1 = 1
Const Delay_2 = 2
Const Delay_3 = 3
Const Delay_4 = 4

Dim T As Byte : T = 0
Dim D As Byte : D = 0
Dim W As Word
Dim Temp As Single
Dim Temp_str As String * 10
Dim Status As Byte

'Gosub Create_password_1
'Gosub Czech_password_1
Gosub Czech_password_2

'Gosub Sub_status
'Readeeprom Status , &H00 : Waitms 10
'If Status = 1 Then
   'Gosub Sub_university
   'Gosub Sub_advisor
   'Gosub Sub_student
'End If
Gosub Sub_start

Do
   Debounce Set_key , 0 , Menu_hour , Sub
   Gosub Show_time
   Gosub Read_adc
   Gosub Show_temp
   Gosub Show_temp_reng
   Repeat:
Loop

End
'//////////////////////////////////////////////

U0:
$bgf "U0.bgf"

P0:
$bgf "P0.bgf"

P1:
$bgf "P1.bgf"

P2:
$bgf "P2.bgf"

'*****************************************
Sub_status:
   If Up_key = 0 Then
      Waitms 30
      If Up_key = 0 Then
         Status = 1
         Writeeeprom Status , &H00 : Waitms 10
      End If
   Elseif Down_key = 0 Then
      Waitms 30
      If Down_key = 0 Then
         Status = 0
         Writeeeprom Status , &H00 : Waitms 10
      End If
   End If
Return

'*****************************************
Sub_university:
   Cls : Setfont Font8x8
   Showpic 0 , 0 , U0 : Wait Delay_3 : Cls
   Lcdat 1 , 1 , "Islamic"
   Lcdat 2 , 1 , "Azad University"
   Setfont Font16x16 : Lcdat 5 , 1 , "Abhar"
   Setfont Font8x8 : Lcdat 7 , 1 , "           Unit"
   Wait Delay_3 : Cls
Return

'*****************************************
Sub_advisor:
   Cls : Setfont Font8x8
   Lcdat 1 , 1 , "Academic"
   Lcdat 2 , 1 , "    advisor:"
   Lcdat 4 , 1 , "engineer"
   Lcdat 5 , 1 , "    Zebardast"
   Wait Delay_4 : Cls
Return

'*****************************************
Sub_student:
   Cls : Setfont Font8x8
   Lcdat 1 , 1 , "Student:"
   Lcdat 3 , 1 , "Mohammad Reza"
   Lcdat 4 , 1 , "Khademi"
   Wait Delay_4 : Cls
Return

'*****************************************
Sub_start:
   Cls : Showpic 0 , 0 , P0 : Wait Delay_2
   Cls : Showpic 0 , 0 , P1 : Wait Delay_1
   Cls : Showpic 0 , 0 , P2 : Wait Delay_2
   Cls
Return

'*****************************************    Show_time
Show_time:
   Setfont Font16x16
   Lcdat 1 , 1 , Time$
   Setfont Font8x8
   Lcdat 3 , 1 , Date$
Return

'*****************************************    Read_adc
Read_adc:
   W = Getadc(6)
   Temp = W / 2.048
Return

'*****************************************    Show_temp
Show_temp:
   Setfont Font16x16
   Temp_str = Fusing(temp , "#.#")
   Lcdat 6 , 1 , Temp_str : Lcd "!C"
Return

'*****************************************    Show_temp_reng
Show_temp_reng:
   Setfont Font8x8
   Select Case Temp
      Case Is =< 10:
         Lcdat 8 , 1 , "Low    "
      Case 11 To 34:
         Lcdat 8 , 1 , "Normal "
      Case Is >= 35
         Lcdat 8 , 1 , "High   "
   End Select
Return

'*****************************************      Menu_hour
Menu_hour:
   Disable Timer2
   Setfont Font16x16
   Cls : Lcdat 1 , 1 , "Hour=" : Lcd _hour
   Do
      Debounce Set_key , 0 , Menu_min , Sub
      Debounce Up_key , 0 , Up_hour
      Debounce Down_key , 0 , Downe_hour
   Loop
   Up_hour:
      Incr _hour
      If _hour = 24 Then _hour = 0
      Goto Menu_hour
   Downe_hour:
      Decr _hour
      If _hour = 255 Then _hour = 23
      Goto Menu_hour
Return

'*****************************************      Menu_min
Menu_min:
   Cls : Setfont Font16x16
   Lcdat 1 , 1 , "Min=" : Lcd _min
   Do
      Debounce Set_key , 0 , Menu_sec , Sub
      Debounce Up_key , 0 , Up_min
      Debounce Down_key , 0 , Downe_min
   Loop
   Up_min:
      Incr _min : If _min = 60 Then _min = 0
      Goto Menu_min
   Downe_min:
      Decr _min : If _min = 255 Then _min = 59
      Goto Menu_min
Return

'*****************************************      Menu_sec
Menu_sec:
   Cls : Setfont Font16x16
   Lcdat 1 , 1 , "Sec=" : Lcd _sec
   Do
      Debounce Set_key , 0 , Menu_year , Sub
      Debounce Up_key , 0 , Up_sec
      Debounce Down_key , 0 , Downe_sec
   Loop
   Up_sec:
      Incr _sec : If _sec = 60 Then _sec = 0
      Goto Menu_sec
   Downe_sec:
      Decr _sec : If _sec = 255 Then _sec = 59
      Goto Menu_sec
Return

'*****************************************      Menu_year
Menu_year:
   Cls : Setfont Font16x16
   Lcdat 1 , 1 , "Year=" : Lcd _year
   Do
      Debounce Set_key , 0 , Menu_month , Sub
      Debounce Up_key , 0 , Up_year
      Debounce Down_key , 0 , Downe_year
   Loop
   Up_year:
      Incr _year
      Goto Menu_year
   Downe_year:
      Decr _year
      Goto Menu_year
Return

'*****************************************      Menu_month
Menu_month:
   Cls : Setfont Font16x16
   Lcdat 1 , 1 , "Month=" : Lcd _month
   Do
      Debounce Set_key , 0 , Menu_day , Sub
      Debounce Up_key , 0 , Up_month
      Debounce Down_key , 0 , Downe_month
   Loop
   Up_month:
      Incr _month : If _month = 13 Then _month = 1
      Goto Menu_month
   Downe_month:
      Decr _month : If _month = 0 Then _month = 12
      Goto Menu_month
Return

'*****************************************      Menu_day
Menu_day:
   Cls : Setfont Font16x16
   Lcdat 1 , 1 , "Day=" : Lcd _day
   Do
      Debounce Set_key , 0 , Starter
      Debounce Up_key , 0 , Up_day
      Debounce Down_key , 0 , Downe_day
   Loop
   Up_day:
      Incr _day : If _day = 32 Then _day = 1
      Goto Menu_day
   Return
   Downe_day:
      Decr _day : If _day = 0 Then _day = 31
      Goto Menu_day
   Return
   Starter:
      Waitms 100 : Cls
      Enable Timer2
      Goto Repeat
Return

'*************************************************
Create_password_1:
   Dim Pass_1 As String * 1 : Pass_1 = "_"
   Writeeeprom Pass_1 , &H126
Return

'*************************************************
Czech_password_1:
   Dim Pass_2 As String * 1
   Readeeprom Pass_2 , &H126
   If Pass_2 <> "_" Then
      Do
      Loop
   End If

'*************************************************
Czech_password_2:
   Config Porta.2 = Output : Porta.2 = 0
   Config Pina.1 = Input : Porta.1 = 1
   Bitwait Pina.1 , Reset : Waitms 100
Return

$include "font8x8.font"
$include "font16x16.font"