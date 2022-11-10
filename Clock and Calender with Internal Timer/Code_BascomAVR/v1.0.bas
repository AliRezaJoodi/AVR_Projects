'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Debounce = 30
Config Pinb.0 = Input : Portb.0 = 1 : Key_up Alias Pinb.0
Config Pinb.1 = Input : Portb.1 = 1 : Key_set Alias Pinb.1
Config Pinb.2 = Input : Portb.2 = 1 : Key_down Alias Pinb.2

Enable Interrupts
Config Clock = Soft , Gosub = Sectic : Time$ = "23:59:50"
Config Date = Ymd , Separator = / : Date$ = "22/11/10"
'Enable Timer2
'Start Timer2

Dim Weekday_b As Byte
Dim Weekday_str As String * 10

Gosub Sectic

Do
   Debounce Key_set , 0 , Menu_hour , Sub
   Repeat:
Loop

End

'*****************************************
Sectic:
   Weekday_b = Dayofweek()
   Weekday_str = Lookupstr(weekday_b , Data_weekdays)
   Gosub Display_time
Return

'*****************************************
Display_time:
   Locate 1 , 1 : Lcd Time$ ; "  "
   Locate 2 , 1 : Lcd Date$ ; "  "
   Locate 2 , 12 : Lcd Weekday_str ; "  "
Return

'*****************************************
Menu_hour:
Disable Timer2
Cls
Locate 1 , 1 : Lcd "hour=  " ; _hour ; "       "
Do
   Debounce Key_set , 0 , Menu_min , Sub
   Debounce Key_up , 0 , Up_hour
   Debounce Key_down , 0 , Downe_hour
Loop
Up_hour:
   Incr _hour : If _hour = 24 Then _hour = 0
   Goto Menu_hour
Downe_hour:
   Decr _hour : If _hour = 255 Then _hour = 23
   Goto Menu_hour
Return


'*****************************************
Menu_min:
Cls
Locate 1 , 1 : Lcd "min=   " ; _min ; "       "
Do
   Debounce Key_set , 0 , Menu_sec , Sub
   Debounce Key_up , 0 , Up_min
   Debounce Key_down , 0 , Downe_min
Loop
Up_min:
   Incr _min : If _min = 60 Then _min = 0
   Goto Menu_min
Downe_min:
   Decr _min : If _min = 255 Then _min = 59
   Goto Menu_min
Return


'*****************************************
Menu_sec:
Cls
Locate 1 , 1 : Lcd "sec=   " ; _sec ; "       "
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
Locate 1 , 1 : Lcd "year=   " ; _year ; "       "
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
Locate 1 , 1 : Lcd "month=   " ; _month ; "       "
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
Locate 1 , 1 : Lcd "day=   " ; _day ; "       "
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

'*****************************************
Data_weekdays:
'Data "Monday" , "Tuesday" , "Wednesday" , "Thursday" , "Friday" , "Saturday" , "Sunday"
Data "Mon." , "Tue." , "Wed." , "Thu." , "Fri." , "Sat." , "Sun."