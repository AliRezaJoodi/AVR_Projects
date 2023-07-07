'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Portc.5 , Db5 = Portc.4 , Db6 = Portc.3 , Db7 = Portc.2 , E = Porta.7 , Rs = Porta.5
Cursor Off
Cls

Config Pina.3 = Input

Config Debounce = 30
Config Pind.7 = Input : Portd.7 = 1 : Key_set Alias Pind.7
Config Pinc.0 = Input : Portc.0 = 1 : Key_up Alias Pinc.0
Config Pind.6 = Input : Portd.6 = 1 : Key_down Alias Pind.6

Enable Interrupts
Config Clock = Soft : Time$ = "23:59:50"
Config Date = Ymd , Separator = / : Date$ = "23/12/01"

Config Adc = Single , Prescaler = Auto , Reference = Avcc
'Config Adc = Single , Prescaler = Auto , Reference = Internal
Start Adc

Dim T As Byte : T = 0
Dim D As Byte : D = 0
Dim W As Word
Dim Temp As Single

Do
   Gosub Show_time
   Debounce Key_set , 0 , Menu_hour , Sub
   Gosub Read_adc
   Gosub Show_temp
   Gosub Show_temp_reng
   Repeat:
Loop
End

Show_time:
Locate 1 , 1 : Lcd Time$ ; "  "
Locate 2 , 1 : Lcd Date$ ; "  "
Return

Read_adc:
   W = Getadc(0)
   Temp = W / 2.048
   'Temp = W / 4
Return

Show_temp:
Deflcdchar 0 , 32 , 6 , 6 , 32 , 32 , 32 , 32 , 32
Locate 1 , 11
Lcd Fusing(temp , "#.#") ; Chr(0) ; "c  "
Return

Show_temp_reng:
Select Case Temp
Case Is =< 10:
Locate 2 , 11
Lcd "Low   "
Case 11 To 34:
Locate 2 , 11
Lcd "Normal"
Case Is >= 35
Locate 2 , 11
Lcd "High  "
End Select
Return

'*****************************************
Menu_hour:
Disable Timer2
Cls
Locate 1 , 1 : Lcd "Hour=" ; _hour ; "       "
Do
   Debounce Key_set , 0 , Menu_min , Sub
   Debounce Key_up , 0 , Up_hour
   Debounce Key_down , 0 , Downe_hour
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


'*****************************************
Menu_min:
Cls
Locate 1 , 1 : Lcd "Min=" ; _min ; "       "
Do
   Debounce Key_set , 0 , Menu_sec , Sub
   Debounce Key_up , 0 , Up_min
   Debounce Key_down , 0 , Downe_min
Loop
Up_min:
   Incr _min
   If _min = 60 Then _min = 0
   Goto Menu_min
Downe_min:
   Decr _min
   If _min = 255 Then _min = 59
   Goto Menu_min
Return


'*****************************************
Menu_sec:
Cls
Locate 1 , 1 : Lcd "Sec=" ; _sec ; "       "
Do
   Debounce Key_set , 0 , Menu_year , Sub
   Debounce Key_up , 0 , Up_sec
   Debounce Key_down , 0 , Downe_sec
Loop
Up_sec:
   Incr _sec : If _sec = 60 Then _sec = 0
   Goto Menu_sec
Downe_sec:
   Decr _sec : If _sec = 255 Then _sec = 59
   Goto Menu_sec
Return

'*****************************************
Menu_year:
Cls
Locate 1 , 1 : Lcd "Year=" ; _year ; "       "
Do
   Debounce Key_set , 0 , Menu_month , Sub
   Debounce Key_up , 0 , Up_year
   Debounce Key_down , 0 , Downe_year
Loop
Up_year:
   Incr _year
   Goto Menu_year
Downe_year:
   Decr _year
   Goto Menu_year
Return

'*****************************************
Menu_month:
Cls
Locate 1 , 1 : Lcd "Month=" ; _month ; "       "
Do
   Debounce Key_set , 0 , Menu_day , Sub
   Debounce Key_up , 0 , Up_month
   Debounce Key_down , 0 , Downe_month
Loop
Up_month:
   Incr _month : If _month = 13 Then _month = 1
   Goto Menu_month
Downe_month:
   Decr _month : If _month = 0 Then _month = 12
   Goto Menu_month
Return

'*****************************************
Menu_day:
Cls
Locate 1 , 1 : Lcd "Day=" ; _day ; "       "
Do
   Debounce Key_set , 0 , Starter
   Debounce Key_up , 0 , Up_day
   Debounce Key_down , 0 , Downe_day
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
   Enable Timer2
   Goto Repeat
Return