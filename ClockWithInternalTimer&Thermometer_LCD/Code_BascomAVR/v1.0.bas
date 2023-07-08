'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Portc.5 , Db5 = Portc.4 , Db6 = Portc.3 , Db7 = Portc.2 , E = Porta.7 , Rs = Porta.5
Cursor Off
Cls

Config Debounce = 30
Config Pind.7 = Input : Portd.7 = 1 : Button_set Alias Pind.7
Config Pinc.0 = Input : Portc.0 = 1 : Button_up Alias Pinc.0
Config Pind.6 = Input : Portd.6 = 1 : Button_down Alias Pind.6

Config Portc.1 = Output : Portc.1 = 0 : Buzzer Alias Portc.1

Enable Interrupts
Config Clock = Soft , Gosub = Sectic : Time$ = "23:59:50"
Config Date = Ymd , Separator = / : Date$ = "23/12/01"

'Config Adc = Single , Prescaler = Auto , Reference = Avcc : Const Gain = 4.8828125
Config Adc = Single , Prescaler = Auto , Reference = Internal : Const Gain = 2.5024438
Start Adc
Const Ch_lm35 = 0

Dim T As Byte : T = 0
Dim D As Byte : D = 0
Dim W As Word
Dim I As Byte
Dim Input_voltage As Single
Dim Temp As Single
Dim Ex As Byte : Ex = 0
Dim Task_time_1s As Byte
Dim Task_time_set As Byte


Do
   If Task_time_1s = 1 Then
      Task_time_1s = 0
      Gosub Display_time
      Gosub Display_temp
      Gosub Display_temp_reng
   End If
   Gosub Get_temp

   Debounce Button_set , 0 , Set_hour , Sub

   If Task_time_set = 1 Then
      Task_time_set = 0
      Enable Timer2
   End If
Loop
End

'*****************************************
Sectic:
   Task_time_1s = 1
Return

'**************************************
Display_time:
   Locate 1 , 1 : Lcd Time$ ; "  "
   Locate 2 , 1 : Lcd Date$ ; "  "
Return

'*****************************************
Get_temp:
   W = W + Getadc(ch_lm35)
   Incr I
   If I = 10 Then
      I = 0
      W = W / 10
      Input_voltage = W * Gain
      Temp = Input_voltage / 10
      W = 0
   End If
Return

'**************************************
Display_temp:
   Deflcdchar 0 , 32 , 6 , 6 , 32 , 32 , 32 , 32 , 32
   Locate 1 , 11
   Lcd Fusing(temp , "#.#") ; Chr(0) ; "c  "
Return

'**************************************
Display_temp_reng:
   Select Case Temp
      Case Is =< 10:
         Locate 2 , 11 : Lcd "Low   "
      Case 11 To 34:
         Locate 2 , 11 : Lcd "Normal"
      Case Is >= 35
         Locate 2 , 11 : Lcd "High  "
   End Select
Return

'*****************************************
Set_hour:
   Gosub Sound_menu
   Disable Timer2
   Ex = 0
   Cls
   Locate 1 , 1 : Lcd "Hour=" ; _hour ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Bitwait Button_set , Set
   Do
      Debounce Button_set , 0 , Set_min , Sub
      If Button_up = 0 Then
         Gosub Sound_pressing
         Incr _hour : If _hour > 23 Then _hour = 0
         Locate 1 , 1 : Lcd "Hour=" ; _hour ; "       "
         Waitms 250
      End If
      If Button_down = 0 Then
         Gosub Sound_pressing
         Decr _hour : If _hour > 23 Then _hour = 23
         Locate 1 , 1 : Lcd "Hour=" ; _hour ; "       "
         Waitms 250
      End If
   Loop Until Ex = 1
Return

'*****************************************
Set_min:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Min=" ; _min ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Do
      Debounce Button_set , 0 , Set_sec , Sub
      If Button_up = 0 Then
         Gosub Sound_pressing
         Incr _min : If _min > 59 Then _min = 0
         Locate 1 , 1 : Lcd "Min=" ; _min ; "       "
         Waitms 250
      End If
      If Button_down = 0 Then
         Gosub Sound_pressing
         Decr _min : If _min > 59 Then _min = 59
         Locate 1 , 1 : Lcd "Min=" ; _min ; "       "
         Waitms 250
      End If
   Loop Until Ex = 1
Return

'*****************************************
Set_sec:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Sec=" ; _sec ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Do
      Debounce Button_set , 0 , Set_year , Sub
      If Button_up = 0 Then
         Gosub Sound_pressing
         Incr _sec : If _sec > 59 Then _sec = 0
         Locate 1 , 1 : Lcd "Sec=" ; _sec ; "       "
         Waitms 250
      End If
      If Button_down = 0 Then
         Gosub Sound_pressing
         Decr _sec : If _sec > 59 Then _sec = 59
         Locate 1 , 1 : Lcd "Sec=" ; _sec ; "       "
         Waitms 250
      End If
   Loop Until Ex = 1
Return

'*****************************************
Set_year:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Year=" ; _year ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Do
      Debounce Button_set , 0 , Set_month , Sub
      If Button_up = 0 Then
         Gosub Sound_pressing
         Incr _year : If _year > 99 Then _year = 0
         Locate 1 , 1 : Lcd "Year=" ; _year ; "       "
         Waitms 250
      End If
      If Button_down = 0 Then
         Gosub Sound_pressing
         Decr _year : If _year > 99 Then _year = 99
         Locate 1 , 1 : Lcd "Year=" ; _year ; "       "
         Waitms 250
      End If
   Loop Until Ex = 1
Return

'*****************************************
Set_month:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Month=" ; _month ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Do
      Debounce Button_set , 0 , Set_day , Sub
      If Button_up = 0 Then
         Gosub Sound_pressing
         Incr _month : If _month > 12 Then _month = 0
         Locate 1 , 1 : Lcd "Month=" ; _month ; "       "
         Waitms 250
      End If
      If Button_down = 0 Then
         Gosub Sound_pressing
         Decr _month : If _month < 1 Then _month = 12
         Locate 1 , 1 : Lcd "Month=" ; _month ; "       "
         Waitms 250
      End If
   Loop Until Ex = 1
Return

'*****************************************
Set_day:
   Cls
   Locate 1 , 1 : Lcd "Day=" ; _day ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Bitwait Button_set , Set
   Do
      If Button_set = 0 Then
         Gosub Sound_menu
         Task_time_set = 1
         Ex = 1
      End If
      If Button_up = 0 Then
         Gosub Sound_pressing
         Incr _day : If _day > 31 Then _day = 1
         Locate 1 , 1 : Lcd "Day=" ; _day ; "       "
         Waitms 250
      End If
      If Button_down = 0 Then
         Gosub Sound_pressing
         Decr _day : If _day < 1 Then _day = 31
         Locate 1 , 1 : Lcd "Day=" ; _day ; "       "
         Waitms 250
      End If
   Loop Until Ex = 1
Return

'***************************************************
Sound_pressing:
   Sound Buzzer , 100 , 250
Return

'***************************************************
Sound_menu:
   Sound Buzzer , 100 , 500
Return

'***************************************************
Sound_error:
   Sound Buzzer , 30 , 2000
Return