'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Portc.5 , Db5 = Portc.4 , Db6 = Portc.3 , Db7 = Portc.2 , E = Porta.7 , Rs = Porta.5
Cursor Off
Cls

Config Debounce = 30
Config Pind.7 = Input : Portd.7 = 1 : Key_set Alias Pind.7
Config Pinc.0 = Input : Portc.0 = 1 : Key_up Alias Pinc.0
Config Pind.6 = Input : Portd.6 = 1 : Key_down Alias Pind.6

Enable Interrupts
Config Clock = Soft , Gosub = Sectic : Time$ = "23:59:50"
Config Date = Ymd , Separator = / : Date$ = "23/12/01"

'Config Adc = Single , Prescaler = Auto , Reference = Avcc
Config Adc = Single , Prescaler = Auto , Reference = Internal
Start Adc

Dim T As Byte : T = 0
Dim D As Byte : D = 0
Dim W As Word
Dim Temp As Single
Dim Ex As Byte : Ex = 0
Dim Task As Byte
dim cunt as Byte

Do
   If Task = 1 Then
      Task = 0
      Gosub Display_time
      Gosub Display_temp
      Gosub Display_temp_reng
   End If
   Gosub Get_temp
   Debounce Key_set , 0 , Menu_hour , Sub
   Ex = 0
Loop
End

'*****************************************
Sectic:
   Task = 1
Return

'**************************************
Display_time:
   Locate 1 , 1 : Lcd Time$ ; "  "
   Locate 2 , 1 : Lcd Date$ ; "  "
Return

'**************************************
Get_temp:
   W = W+Getadc(0)
   incr cunt
   if cunt=10 then
      cunt=0
      W=W/10
      'Temp = W / 2.048
      Temp = W * 0.25024438
      w=0
   end if
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
Menu_hour:
   Disable Timer2
   Cls
   Locate 1 , 1 : Lcd "Hour=" ; _hour ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Do
      Debounce Key_set , 0 , Menu_min , Sub
      If Key_up = 0 Then
         Incr _hour : If _hour > 23 Then _hour = 0
         Locate 1 , 1 : Lcd "Hour=" ; _hour ; "       "
         Waitms 250
      End If
      If Key_down = 0 Then
         Decr _hour : If _hour > 23 Then _hour = 23
         Locate 1 , 1 : Lcd "Hour=" ; _hour ; "       "
         Waitms 250
      End If
   Loop Until Ex <> 0
Return

'*****************************************
Menu_min:
   Cls
   Locate 1 , 1 : Lcd "Min=" ; _min ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Do
      Debounce Key_set , 0 , Menu_sec , Sub
      If Key_up = 0 Then
         Incr _min : If _min > 59 Then _min = 0
         Locate 1 , 1 : Lcd "Min=" ; _min ; "       "
         Waitms 250
      End If
      If Key_down = 0 Then
         Decr _min : If _min > 59 Then _min = 59
         Locate 1 , 1 : Lcd "Min=" ; _min ; "       "
         Waitms 250
      End If
   Loop Until Ex <> 0
Return

'*****************************************
Menu_sec:
   Cls
   Locate 1 , 1 : Lcd "Sec=" ; _sec ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Do
      Debounce Key_set , 0 , Menu_year , Sub
      If Key_up = 0 Then
         Incr _sec : If _sec > 59 Then _sec = 0
         Locate 1 , 1 : Lcd "Sec=" ; _sec ; "       "
         Waitms 250
      End If
      If Key_down = 0 Then
         Decr _sec : If _sec > 59 Then _sec = 59
         Locate 1 , 1 : Lcd "Sec=" ; _sec ; "       "
         Waitms 250
      End If
   Loop Until Ex <> 0
Return

'*****************************************
Menu_year:
   Cls
   Locate 1 , 1 : Lcd "Year=" ; _year ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Do
      Debounce Key_set , 0 , Menu_month , Sub
      If Key_up = 0 Then
         Incr _year : If _year > 99 Then _year = 0
         Locate 1 , 1 : Lcd "Year=" ; _year ; "       "
         Waitms 250
      End If
      If Key_down = 0 Then
         Decr _year : If _year > 99 Then _year = 99
         Locate 1 , 1 : Lcd "Year=" ; _year ; "       "
         Waitms 250
      End If
   Loop Until Ex <> 0
Return

'*****************************************
Menu_month:
   Cls
   Locate 1 , 1 : Lcd "Month=" ; _month ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Do
      Debounce Key_set , 0 , Menu_day , Sub
      If Key_up = 0 Then
         Incr _month : If _month > 12 Then _month = 0
         Locate 1 , 1 : Lcd "Month=" ; _month ; "       "
         Waitms 250
      End If
      If Key_down = 0 Then
         Decr _month : If _month > 12 Then _month = 12
         Locate 1 , 1 : Lcd "Month=" ; _month ; "       "
         Waitms 250
      End If
   Loop Until Ex <> 0
Return

'*****************************************
Menu_day:
   Cls
   Locate 1 , 1 : Lcd "Day=" ; _day ; "       "
   Locate 2 , 1 : Lcd "Setting Mode"
   Bitwait Key_set , Set
   Do
      If Key_set = 0 Then
         Ex = 1
         Enable Timer2
      End If
      If Key_up = 0 Then
         Incr _day : If _day > 31 Then _day = 0
         Locate 1 , 1 : Lcd "Day=" ; _day ; "       "
         Waitms 250
      End If
      If Key_down = 0 Then
         Decr _day : If _day > 31 Then _day = 31
         Locate 1 , 1 : Lcd "Day=" ; _day ; "       "
         Waitms 250
      End If
   Loop Until Ex <> 0
Return