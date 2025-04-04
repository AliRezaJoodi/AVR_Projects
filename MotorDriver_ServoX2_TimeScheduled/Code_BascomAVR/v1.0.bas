'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 8000000

$baud = 9600
Print "ok"

Config Lcdpin = Pin , Rs = Porta.4 , E = Porta.6 , Db4 = Porta.7 , Db5 = Portc.5 , Db6 = Portc.4 , Db7 = Portc.3
Config Lcd = 16 * 2
Cursor Off
Cls

'Gosub Start_menu

Enable Interrupts

Config Timer2 = Timer , Async = On , Prescale = 128
On Timer2 Creat_1_secend
Start Timer2
Disable Timer2
'Stop Timer2

'Config Int0 = Falling
'On Int0 Read_of_the_ds1307
'Rtc_status = 0

Config Scl = Portd.3
Config Sda = Portd.4
Const Ds1307w = &HD0
Const Ds1307r = &HD1

'Config Adc = Single , Prescaler = Auto , Reference = Avcc
'Start Adc

Config Debounce = 30
Config Portc.2 = Input : Portc.2 = 1 : Up_key Alias Pinc.2
Config Portd.5 = Input : Portd.5 = 1 : Down_key Alias Pind.5
Config Portd.7 = Input : Portd.7 = 1 : Set_key Alias Pind.7
Config Portc.0 = Input : Portc.0 = 1 : Left_key Alias Pinc.0
Config Portd.6 = Input : Portd.6 = 1 : Right_key Alias Pind.6

Config Portc.1 = Output : Portc.1 = 0 : Sound_pin Alias Portc.1
Config Porta.0 = Output : Porta.0 = 0 : Led1 Alias Porta.0
Config Portb.0 = Output : Portb.0 = 0 : Led2 Alias Portb.0

Const D_min = 35
Const D_normal = 83
Const D_max = 133

'Const Servo1_min = 33
Dim Servo1_min As Byte
Dim Servo1_min_eeprom As Eram Byte
Const Servo1_normal = 83
'Const Servo1_max = 133
Dim Servo1_max As Byte
Dim Servo1_max_eeprom As Eram Byte

'Const Servo2_min = 33
Dim Servo2_min As Byte
Dim Servo2_min_eeprom As Eram Byte
Const Servo2_normal = 83
'Const Servo2_max = 133
Dim Servo2_max As Byte
Dim Servo2_max_eeprom As Eram Byte

'Dim D_max As Byte : D_max = 133
'Dim D_min As Byte : D_min = 33
'Dim D_normal As Byte : D_normal = 75

Config Porta.1 = Output : Porta.1 = 0
Config Portb.1 = Output : Portb.1 = 0
Config Servos = 2 , Servo1 = Porta.1 , Servo2 = Portb.1 , Reload = 10
   Servo1_min = Servo1_min_eeprom
   Servo1_max = Servo1_max_eeprom
   Servo2_min = Servo2_min_eeprom
   Servo2_max = Servo2_max_eeprom
Servo(1) = Servo1_min
Servo(2) = Servo2_min

Const Pres_key_max_timer = 20000

Dim Strg_x As String * 2
Dim _sec As Byte
Dim _min As Byte
Dim _hour As Byte
Dim _weekday As Byte
Dim _day As Byte
Dim _month As Byte
Dim _year As Byte

Dim Z As Byte

Dim Status As Byte
Dim Rtc_status As Bit : Rtc_status = 0

Dim N As Byte : N = 1

Dim Start_sec(2) As Byte
Dim Start_min(2) As Byte
Dim Start_hour(2) As Byte
Dim Start_min_eeprom(2) As Eram Byte
Dim Start_hour_eeprom(2) As Eram Byte

Dim R(2) As Word
Dim D(2) As Word
Dim R_eeprom(2) As Eram Word
Dim D_eeprom(2) As Eram Word

'Start_hour(1) = 16 : Start_min(1) = 59 : Start_sec(1) = 0
'Start_hour(2) = 16 : Start_min(2) = 59 : Start_sec(2) = 0

'R(1) = 2 : D(1) = 10
'R(2) = 3 : D(2) = 10
'Gosub Save_to_eeprom

'Dim Z_sec As Byte
'Dim Z_min As Byte
'Dim Z_hour As Byte

Dim Over(2) As Byte

Dim Run_sec(2) As Byte
Dim Run_min(2) As Byte
Dim Run_hour(2) As Byte

'Run_hour(1) = 16 : Run_min(1) = 44 : Run_sec(1) = 10
'Run_hour(1) = Start_hour(1) : Run_min(1) = Start_min(1) : Run_sec(1) = Start_sec(1)
'Run_hour(2) = Start_hour(2) : Run_min(2) = Start_min(2) : Run_sec(2) = Start_sec(2)


Dim Servo_status(2) As Byte

Dim Time_counter(2) As Word

Dim I As Byte
Dim K1 As Word
Dim Z1 As Word
Dim Spead_counter As Byte : Spead_counter = 1
Dim Spead_timer As Byte

Dim Set_key_status As Bit : Set_key_status = 0
Dim Left_key_status As Bit : Left_key_status = 0
Dim Right_key_status As Bit : Right_key_status = 0

Dim Status_enable As Byte
Dim Status_enable_eeprom As Eram Byte
'Status_enable_eeprom = &B00000000


'_hour = 12 :_min = 24 : _sec = 0
'_year = 91   :_month = 3 :_day = 15
'Gosub Write_to_ds1307

Gosub Sound_menu

Lcd "Please Wait ..."
Print "Please Wait ..."

'Gosub Setting_defalt

Gosub Load_of_the_eeprom

Gosub Config_ds1307
'Set Led1
Gosub Read_of_the_ds1307
'Set Led2

If Status_enable.1 = 1 Then
   N = 1 : Gosub Check_run
End If

If Status_enable.2 = 1 Then
   N = 2 : Gosub Check_run
End If

'N = 1 : Gosub Check_run
'N = 2 : Gosub Check_run
'Gosub Show_next_run_time
Cls


If Set_key = 0 Then
   Waitms 30
   If Set_key = 0 Then
      Gosub Setting_servo1_min
   End If
End If
'Gosub Menu_servo1_cycle
Enable Timer2
'Rtc_status = 1
Rtc_status = 1

'Set Led1
K1 = 0 : Status = 0

Do

   Debounce Up_key , 0 , Run_servo_1 , Sub
   Debounce Down_key , 0 , Run_servo_2 , Sub
   Debounce Set_key , 0 , Menu_time_setting , Sub
   If _sec <> Z Then
      Gosub Show_time
      Z = _sec
   End If
   Status = 0
   N = 1 : Gosub Servo_driver
   N = 2 : Gosub Servo_driver

   If Status_enable.1 = 1 Then
      N = 1 : If Over(n) = 0 Then Gosub Check_run
   End If

   If Status_enable.2 = 1 Then
      N = 2 : If Over(n) = 0 Then Gosub Check_run
   End If
Loop
End

'*********************************************************
Setting_defalt:
   Servo1_min_eeprom = 33
   Servo1_max_eeprom = 133
   Servo2_min_eeprom = 33
   Servo2_max_eeprom = 133
Return

'*********************************************************
Eeprom_load:
   Servo1_min = Servo1_min_eeprom
   Servo1_max = Servo1_max_eeprom
   Servo2_min = Servo2_min_eeprom
   Servo2_max = Servo2_max_eeprom
Return

'*********************************************************
Setting_servo1_min:
   Cls
   Locate 1 , 1 : Lcd "Setting Device 1"
   Locate 2 , 1 : Lcd "Min= " ; Servo1_min ; "       "
   Set Led1 : Servo(1) = Servo1_min
   Reset Led2
   Waitms 500
   Do
      K1 = 0
      Debounce Set_key , 0 , Setting_servo1_max , Sub
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Servo1_min
            Locate 2 , 1 : Lcd "Min= " ; Servo1_min ; "       "
            Servo(1) = Servo1_min
            Servo1_min_eeprom = Servo1_min
            K1 = 0
         End If
      Loop Until Up_key = 1
      K1 = 0

      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Servo1_min
            Locate 2 , 1 : Lcd "Min= " ; Servo1_min ; "       "
            Servo(1) = Servo1_min
            Servo1_min_eeprom = Servo1_min
            K1 = 0
         End If
      Loop Until Down_key = 1
      K1 = 0

   Loop Until Status = 1
Return

'*********************************************************
Setting_servo1_max:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Setting Device 1"
   Locate 2 , 1 : Lcd "Max= " ; Servo1_max ; "       "
   Set Led1 : Servo(1) = Servo1_max
   Reset Led2
   'Waitms 500
   Do
      K1 = 0
      Debounce Set_key , 0 , Setting_servo2_min , Sub
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Servo1_max
            Locate 2 , 1 : Lcd "Max= " ; Servo1_max ; "       "
            Servo(1) = Servo1_max
            Servo1_max_eeprom = Servo1_max
            K1 = 0
         End If
      Loop Until Up_key = 1
      K1 = 0

      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Servo1_max
            Locate 2 , 1 : Lcd "Max= " ; Servo1_max ; "       "
            Servo(1) = Servo1_max
            Servo1_max_eeprom = Servo1_max
            K1 = 0
         End If
      Loop Until Down_key = 1
      K1 = 0

   Loop Until Status = 1
Return

'*********************************************************
Setting_servo2_min:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Setting Device 2"
   Locate 2 , 1 : Lcd "Min= " ; Servo2_min ; "       "
   Set Led2 : Servo(2) = Servo2_min
   Reset Led1
   'Waitms 500
   Do
      K1 = 0
      Debounce Set_key , 0 , Setting_servo2_max , Sub
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Servo2_min
            Locate 2 , 1 : Lcd "Min= " ; Servo2_min ; "       "
            Servo(2) = Servo2_min
            Servo2_min_eeprom = Servo2_min
            K1 = 0
         End If
      Loop Until Up_key = 1
      K1 = 0

      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Servo2_min
            Locate 2 , 1 : Lcd "Min= " ; Servo2_min ; "       "
            Servo(2) = Servo2_min
            Servo2_min_eeprom = Servo2_min
            K1 = 0
         End If
      Loop Until Down_key = 1
      K1 = 0

   Loop Until Status = 1
Return

'*********************************************************
Setting_servo2_max:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Setting Device 2"
   Locate 2 , 1 : Lcd "Max= " ; Servo2_max ; "       "
   Set Led2 : Servo(2) = Servo2_max
   Reset Led1
   Waitms 500
   Do
      K1 = 0
      'Debounce Set_key , 0 , Setting_servo2_min , Sub
      If Set_key = 0 Then
         Waitms 30
         If Set_key = 0 Then
            Gosub Sound_menu
            Cls
            Status = 1
         End If
      End If

      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Servo2_max
            Locate 2 , 1 : Lcd "Max= " ; Servo2_max ; "       "
            Servo(2) = Servo2_max
            Servo2_max_eeprom = Servo2_max
            K1 = 0
         End If
      Loop Until Up_key = 1
      K1 = 0

      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Servo2_max
            Locate 2 , 1 : Lcd "Max= " ; Servo2_max ; "       "
            Servo(2) = Servo2_max
            Servo2_max_eeprom = Servo2_max
            K1 = 0
         End If
      Loop Until Down_key = 1
      K1 = 0

   Loop Until Status = 1
Return

'*********************************************************
Start_menu:
   Cls
   Locate 1 , 1 : Lcd "Sana Rezaee"
   Locate 2 , 1 : Lcd "Somaye Azimi"
   Wait 4 : Cls
Return

'*********************************************************
Run_servo_1:
   N = 1
   Rtc_status = 0
   Waitms 100
   If Servo_status(n) = 1 Then
      Servo_status(n) = 0
      Time_counter(n) = 0
      Servo(1) = Servo1_min
   Else
      Servo_status(n) = 1
      If N = 1 Then Servo(n) = Servo1_max
      If N = 2 Then Servo(n) = Servo2_max
   End If
   'Servo(n) = D_max
   'Servo_status(n) = 1
   'Gosub Find_next_run_time
   'Rtc_status = 1
   Rtc_status = 1
Return

'*********************************************************
Run_servo_2:
   N = 2
   Rtc_status = 0
   Waitms 100
   If Servo_status(n) = 1 Then
      Servo_status(n) = 0
      Time_counter(n) = 0
      Servo(n) = Servo2_min
   Else
      Servo_status(n) = 1
      'Servo(n) = D_max
      If N = 1 Then Servo(n) = Servo1_max
      If N = 2 Then Servo(n) = Servo2_max
   End If
   'Servo(n) = D_max
   'Servo_status(n) = 1
   'Gosub Find_next_run_time
   'Rtc_status = 1
   Rtc_status = 1
Return

'*********************************************************
Check_run:
If Over(n) = 0 Then
   If Run_hour(n) < _hour Then
      Gosub Find_next_run_time
   Elseif Run_hour(n) = _hour Then
      If Run_min(n) < _min Then
         Gosub Find_next_run_time
      Elseif Run_min(n) = _min Then
         If Run_sec(n) < _sec Then
            Gosub Find_next_run_time
            '_sec = _sec + 5
         'Elseif Run_sec(n) = _sec Then
            'Gosub Find_next_run_time
         End If
      End If
   End If
End If
Return

'*********************************************************
Save_to_eeprom:
   For I = 1 To 2
      Start_min_eeprom(i) = Start_min(i)
      Start_hour_eeprom(i) = Start_hour(i)
      R_eeprom(i) = R(i)
      D_eeprom(i) = D(i)
   Next I
   Status_enable_eeprom = Status_enable
Return

'*********************************************************
Load_of_the_eeprom:
   For I = 1 To 2
      Start_min(i) = Start_min_eeprom(i)
      Start_hour(i) = Start_hour_eeprom(i)
      R(i) = R_eeprom(i)
      D(i) = D_eeprom(i)
   Next I
   Run_hour(1) = Start_hour(1) : Run_min(1) = Start_min(1) : Run_sec(1) = Start_sec(1)
   Run_hour(2) = Start_hour(2) : Run_min(2) = Start_min(2) : Run_sec(2) = Start_sec(2)
   Status_enable = Status_enable_eeprom

   Servo1_min = Servo1_min_eeprom
   Servo1_max = Servo1_max_eeprom
   Servo2_min = Servo2_min_eeprom
   Servo2_max = Servo2_max_eeprom

Return

'*********************************************************
Find_next_run_time:
S1:


   'Rtc_status = 0
   I = 0
   'Z_sec =Run_sec(n)
   'Z_min = Run_min(n)
   'Z_hour = Run_hour(n)
   Do
      'Incr Run_sec(n)
      'If Run_sec(n) > 59 Then
         'Run_sec(n) = 0
         Incr Run_min(n)
         If Run_min(n) > 59 Then
            Run_min(n) = 0
            Incr Run_hour(n)
            If Run_hour(n) > 23 Then
                Run_hour(n) = 0
                Over(n) = 1
            End If
         End If
      'End If
      Incr I
   Loop Until I >= R(n)
   'Run_hour(n) = Z_hour : Run_min(n) = Z_min : Run_sec(n) = Z_sec

   'Gosub Show_next_run_time
   If Over(n) = 0 Then
      If Run_hour(n) < _hour Then
         Goto S1
      Elseif Run_hour(n) = _hour Then
         If Run_min(n) < _min Then
            Goto S1
         Elseif Run_min(n) = _min Then
            If Run_sec(n) < _sec Then
               Goto S1
            '_sec = _sec + 5
         'Elseif Run_sec(n) = _sec Then
            'Gosub Find_next_run_time
            End If
         End If
      End If
   End If
   'Gosub Check_run
   Gosub Show_next_run_time
Return

'*********************************************************
Show_next_run_time:
   'Locate N , 1
   'Strg_x = Str(run_hour(n)) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd ":"
   'Strg_x = Str(run_min(n)) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd ":"
   'Strg_x = Str(run_sec(n)) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd " "
   Print "RUN_" ; 1 ; "= " ; Run_hour(1) ; ":" ; Run_min(1) ; ":" ; Run_sec(1)
   Print "RUN_" ; 2 ; "= " ; Run_hour(2) ; ":" ; Run_min(2) ; ":" ; Run_sec(2)
   Print
Return

'*********************************************************
Creat_1_secend:

   If Rtc_status = 1 Then Gosub Read_of_the_ds1307

   'N = 1
   If Start_hour(1) = _hour And Start_min(1) = _min Then
      Set Status_enable.1 : Status_enable_eeprom = Status_enable
   End If

   'N = 2
   If Start_hour(2) = _hour And Start_min(2) = _min Then
      Set Status_enable.2 : Status_enable_eeprom = Status_enable
   End If
   'Status_enable = &B00000110

'Gosub Sound_pressing
   Led1 = Servo_status(1).0
   Led2 = Servo_status(2).0

   If Status_enable.1 = 1 Or Status_enable.2 = 1 Then
      If Servo_status(1) = 1 Or Servo_status(2) = 1 Then Gosub Sound_pressing
   End If
   'Gosub Sound_pressing
   If Servo_status(1) = 1 Then Incr Time_counter(1)
   If Servo_status(2) = 1 Then Incr Time_counter(2)
   'If Servo_status(2) = 1 Then Incr Time_counter(2)
   If Time_counter(1) >= D(1) Then
      Servo(1) = Servo1_min
      Servo_status(1) = 0
      'Over(1) = 0
      'reset led1
      Time_counter(1) = 0
   End If
   If Time_counter(2) >= D(2) Then
      Servo(2) = Servo2_min
      Servo_status(2) = 0
      'Over(2) = 0
      'Reset Led2
      Time_counter(2) = 0
   End If
   If _hour = 0 Then
      Over(1) = 0
      Over(2) = 0
   End If
   'Gosub Servo_driver
   'Print "Time_counter(1)= " ; Time_counter(1)
   'Print "Servo_status(1)= " ; Servo_status(n)
   Incr Spead_timer
Return

'*********************************************************
Servo_driver:
   'Led1 = Servo_status(1).0
   'Led2 = Servo_status(2).0
   If Servo_status(n) = 0 Then
      'If Run_hour(n) = _hour And Run_min(n) = _min And Run_sec(n) = _sec Then
      If Run_hour(n) = _hour And Run_min(n) = _min Then
         Rtc_status = 0
         'print" RUN SERVO"
         'enable
         Waitms 100
         'Servo(n) = D_max
         If N = 1 Then Servo(n) = Servo1_max
         If N = 2 Then Servo(n) = Servo2_max
         Servo_status(n) = 1
         Gosub Find_next_run_time
         'If Run_hour(n) <= _hour And Run_min(n) <= _min And Run_sec(n) <= _sec Then Gosub Find_next_run_time
         'Gosub Find_next_run_time
         Rtc_status = 1
      End If
   End If
Return

'*********************************************************
Read_of_the_ds1307:
'Set Led1
   I2cstart
   I2cwbyte Ds1307w
   I2cwbyte 0
   I2cstart
   I2cwbyte Ds1307r
   I2crbyte _sec , Ack
   I2crbyte _min , Ack
   I2crbyte _hour , Ack
   _hour = _hour And &B00111111
   I2crbyte _weekday , Ack
   I2crbyte _day , Ack
   I2crbyte _month , Ack
   I2crbyte _year , Nack
   I2cstop
   Gosub Bcd_to_decimal
'Reset Led1
Return

'*****************************************
Write_to_ds1307:
   Gosub Decimal_to_bcd
   I2cstart
   I2cwbyte Ds1307w
   I2cwbyte 0
   I2cwbyte _sec
   I2cwbyte _min
   _hour = _hour And &B00111111
   I2cwbyte _hour
   I2cwbyte _weekday
   I2cwbyte _day
   I2cwbyte _month
   I2cwbyte _year
   I2cstop
   Cls
   Gosub Sound_menu
   Rtc_status = 1 : Waitms 100
   'Goto Repeat
   Status = 1
Return

'*****************************************
Config_ds1307:
   I2cstart
   I2cwbyte Ds1307w
   I2cwbyte &H07
   I2cwbyte &B00010000
   I2cstop
Return

'*****************************************
Bcd_to_decimal:
   _sec = Makedec(_sec)
   _min = Makedec(_min)
   _hour = Makedec(_hour)
   _weekday = Makedec(_weekday)
   _day = Makedec(_day)
   _month = Makedec(_month)
    _year = Makedec(_year)
Return

'*****************************************
Decimal_to_bcd:
   _sec = Makebcd(_sec)
   _min = Makebcd(_min)
   _hour = Makebcd(_hour)
   _weekday = Makebcd(_weekday)
   _day = Makebcd(_day)
   _month = Makebcd(_month)
   _year = Makebcd(_year)
Return

'*****************************************
Show_time:
   Locate 1 , 1
   Strg_x = Str(_hour) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd ":"
   Strg_x = Str(_min) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd ":"
   Strg_x = Str(_sec) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd " "
   'Print _hour ; ":" ; _min ; ":" ; _sec
   'Locate 2 , 1
   'Strg_x = Str(_year) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd "/"
   'Strg_x = Str(_month) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd "/"
   'Strg_x = Str(_day) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd " "

   Locate 2 , 1
   Lcd "1)"
   Strg_x = Str(run_hour(1)) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd ":"
   Strg_x = Str(run_min(1)) : Strg_x = Format(strg_x , "00") : Lcd Strg_x

   Locate 2 , 10
   Lcd "2)"
   Strg_x = Str(run_hour(2)) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd ":"
   Strg_x = Str(run_min(2)) : Strg_x = Format(strg_x , "00") : Lcd Strg_x

Return

'*****************************************      Menu_hour
Menu_time_setting:
   Gosub Sound_menu
   Rtc_status = 0
   Cls
   Locate 1 , 1 : Lcd "Setting RTC Time"
   Do
      Debounce Left_key , 0 , Menu_hour
      Debounce Set_key , 0 , Menu_servo1_setting , Sub
      Debounce Right_key , 0 , Menu_hour
   Loop Until Status = 1
Return

'*********************************************************
Menu_servo1_setting:
   Gosub Sound_menu
   Rtc_status = 0
   Cls
   Locate 1 , 1 : Lcd "Setting Device 1"
   Do
      'Debounce Left_key , 0 , Menu_servo1_start_time_hour
      If Left_key = 0 And Left_key_status = 0 Then
         Waitms 30
         If Left_key = 0 And Left_key_status = 0 Then
            Gosub Sound_menu
            Left_key_status = 1
            N = 1 : Gosub Menu_servo1_start_time_hour
         End If
      End If
      If Left_key = 1 Then Left_key_status = 0

      Debounce Set_key , 0 , Menu_servo2_setting , Sub
      'Debounce Right_key , 0 , Menu_servo1_start_time_hour
      If Right_key = 0 And Right_key_status = 0 Then
         Waitms 30
         If Right_key = 0 And Right_key_status = 0 Then
            Gosub Sound_menu
            Right_key_status = 1
            N = 1 : Gosub Menu_servo1_start_time_hour
         End If
      End If
      If Right_key = 1 Then Right_key_status = 0

   Loop Until Status = 1
Return

'*********************************************************
Menu_servo1_start_time_hour:
   'Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Start Time " ; N
   Locate 2 , 1 : Lcd "Hour=" ; Start_hour(n)
   Do
      Debounce Set_key , 0 , Menu_servo1_start_time_min , Sub
      'Debounce Up_key , 0 , Incr_start_hour
      K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Start_hour(n)
            If Start_hour(n) > 23 Then Start_hour(n) = 0
            Start_hour_eeprom(n) = Start_hour(n)
            Locate 2 , 1 : Lcd "Hour=" ; Start_hour(n) ; "   "
            K1 = 0
         End If
      Loop Until Up_key = 1
      K1 = 0

      'Debounce Down_key , 0 , Decr_start_hour
      K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Start_hour(n)
            If Start_hour(n) > 23 Then Start_hour(n) = 23
            Start_hour_eeprom(n) = Start_hour(n)
            Locate 2 , 1 : Lcd "Hour=" ; Start_hour(n) ; "   "
            K1 = 0
         End If
      Loop Until Down_key = 1
      K1 = 0

   Loop Until Status = 1
   'Incr_start_hour:
      'Gosub Sound_pressing
      'Incr Start_hour(n) : If Start_hour(n) > 23 Then Start_hour(n) = 0
      'Start_hour_eeprom(n) = Start_hour(n)
      'If Status = 0 Then Goto Menu_servo1_start_time_hour
   'Decr_start_hour:
      'Gosub Sound_pressing
      'Decr Start_hour(n) : If Start_hour(n) > 23 Then Start_hour(n) = 23
      'Start_hour_eeprom(n) = Start_hour(n)
      'If Status = 0 Then Goto Menu_servo1_start_time_hour
Return

'*********************************************************
Menu_servo1_start_time_min:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Start Time " ; N
   Locate 2 , 1 : Lcd "Min=" ; Start_min(n)
   Do
      Debounce Set_key , 0 , Menu_servo1_cycle , Sub
      'Debounce Up_key , 0 , Incr_start_min
      'Debounce Down_key , 0 , Decr_start_min
      K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr Start_min(n)
            If Start_min(n) > 59 Then Start_min(n) = 0
            Start_min_eeprom(n) = Start_min(n)
            Locate 2 , 1 : Lcd "Min=" ; Start_min(n) ; "   "
            K1 = 0
         End If
      Loop Until Up_key = 1
      K1 = 0

      'Debounce Down_key , 0 , Decr_start_min
      K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr Start_min(n)
            If Start_min(n) > 59 Then Start_min(n) = 59
            Start_min_eeprom(n) = Start_min(n)
            Locate 2 , 1 : Lcd "Min=" ; Start_min(n) ; "   "
            K1 = 0
         End If
      Loop Until Down_key = 1
      K1 = 0

   Loop Until Status = 1
   'Incr_start_min:
      'Gosub Sound_pressing
      'Incr Start_min(n) : If Start_min(n) > 59 Then Start_min(n) = 0
      'Start_min_eeprom(n) = Start_min(n)
      'If Status = 0 Then Goto Menu_servo1_start_time_min
   'Decr_start_min:
      'Gosub Sound_pressing
      'Decr Start_min(n) : If Start_min(n) > 59 Then Start_min(n) = 59
      'Start_min_eeprom(n) = Start_min(n)
      'If Status = 0 Then Goto Menu_servo1_start_time_min
Return

'*********************************************************
Menu_servo1_cycle:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Repeat Time " ; N
   Locate 2 , 1 : Lcd "Time=" : Lcd R(n) ; " Minute  "

   'Cls : Locate 1 , 1 : Lcd "R1= " ; R(1) ; "   "
   Do

      K1 = 0 : Spead_counter = 1 : Spead_timer = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            R(n) = R(n) + Spead_counter
            If R(n) > 1440 Then R(n) = 0
            R_eeprom(n) = R(n)
            Locate 2 , 1 : Lcd "Time=" : Lcd R(n) ; " Minute   "
            K1 = 0
         End If
         If Spead_timer = 5 Then
            Spead_counter = 10
            Spead_timer = 0
         End If
      Loop Until Up_key = 1
      K1 = 0 : Spead_counter = 1 : Spead_timer = 0

      K1 = 0 : Spead_counter = 1 : Spead_timer = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            R(n) = R(n) - Spead_counter
            If R(n) > 1440 Then R(n) = 1440
            R_eeprom(n) = R(n)
            Locate 2 , 1 : Lcd "Time=" : Lcd R(n) ; " Minute   "
            K1 = 0
         End If
         If Spead_timer = 5 Then
            Spead_counter = 10
            Spead_timer = 0
         End If
      Loop Until Down_key = 1
      K1 = 0 : Spead_counter = 1 : Spead_timer = 0

      Debounce Set_key , 0 , Menu_servo1_active_time , Sub
   Loop Until Status = 1

Return

'*********************************************************
Menu_servo1_active_time:
   'Gosub Sound_menu
   Gosub Sound_menu
   Cls : Locate 1 , 1 : Lcd "Active Time " ; N
   Locate 2 , 1 : Lcd "Time=" : Lcd D(n) ; " Second  "
   Do
      K1 = 0 : Spead_counter = 1 : Spead_timer = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            'Gosub Sound_pressing
            D(n) = D(n) + Spead_counter
            If D(n) > 1440 Then D(n) = 0
            Z1 = R(n) * 60 : Z1 = Z1 -1
            If D(n) > Z1 Then
               D(n) = Z1
               Gosub Sound_error
            Else
               Gosub Sound_pressing
            End If
            D_eeprom(n) = D(n)
            Locate 2 , 1 : Lcd "Time=" : Lcd D(n) ; " Second  "
            K1 = 0
         End If
         If Spead_timer = 5 Then
            Spead_counter = 10
            Spead_timer = 0
         End If
      Loop Until Up_key = 1
      K1 = 0 : Spead_counter = 1 : Spead_timer = 0

      K1 = 0 : Spead_counter = 1 : Spead_timer = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            'Gosub Sound_pressing
            D(n) = D(n) - Spead_counter
            If D(n) > 1440 Then D(n) = 1440
            Z1 = R(n) * 60 : Z1 = Z1 -1
            If D(n) > Z1 Then
               D(n) = Z1
               Gosub Sound_error
            Else
               Gosub Sound_pressing
            End If
            D_eeprom(n) = D(n)
            Locate 2 , 1 : Lcd "Time=" : Lcd D(n) ; " Second  "
            K1 = 0
         End If
         If Spead_timer = 5 Then
            Spead_counter = 10
            Spead_timer = 0
         End If
      Loop Until Down_key = 1
      K1 = 0 : Spead_counter = 1 : Spead_timer = 0

      'Debounce Set_key , 0 , Menu_servo2_setting , Sub
      If Set_key = 0 And Set_key_status = 0 Then
         Waitms 30
         If Set_key = 0 And Set_key_status = 0 Then
            Gosub Sound_menu
            Set_key_status = 1

            If N = 1 Then
               Reset Status_enable.1 : Status_enable_eeprom = Status_enable
               Gosub Load_of_the_eeprom
               If Status_enable.1 = 1 Then
                  Gosub Check_run
               End If
            End If

            If N = 1 Then Gosub Menu_servo2_setting
            If N = 2 Then
               Cls
               'Waitms 300

            'If N = 2 Then
               Reset Status_enable.2 : Status_enable_eeprom = Status_enable
               Gosub Load_of_the_eeprom
               If Status_enable.2 = 1 Then
                  Gosub Check_run
               End If
            'End If

               Rtc_status = 1
               Status = 1
            End If
         End If
      End If
      If Set_key = 1 Then Set_key_status = 0

   Loop Until Status = 1
Return

'*********************************************************
Menu_servo2_setting:
   Gosub Sound_menu
   Rtc_status = 0
   Cls
   Locate 1 , 1 : Lcd "Setting Device 2"
   Do
      'Debounce Left_key , 0 , Menu_servo1_setting
      'Debounce Menu_servo1_setting , 0 , Menu_hour , Sub
      If Left_key = 0 And Left_key_status = 0 Then
         Waitms 30
         If Left_key = 0 And Left_key_status = 0 Then
            Gosub Sound_menu
            Left_key_status = 1
            N = 2 : Gosub Menu_servo1_start_time_hour
         End If
      End If
      If Left_key = 1 Then Left_key_status = 0

      If Set_key = 0 Then
         Waitms 30
         If Set_key = 0 Then
            Gosub Sound_menu
            Cls
            'Waitms 300
               'Status_enable_eeprom = &B00000000
               'Gosub Load_of_the_eeprom
               'N = 1 : Gosub Check_run
               'N = 2 : Gosub Check_run
            Rtc_status = 1
            Status = 1
         End If
      End If

      If Right_key = 0 And Right_key_status = 0 Then
         Waitms 30
         If Right_key = 0 And Right_key_status = 0 Then
            Gosub Sound_menu
            Right_key_status = 1
            N = 2 : Gosub Menu_servo1_start_time_hour
         End If
      End If
      If Right_key = 1 Then Right_key_status = 0

      'Debounce Right_key , 0 , Menu_exit
   Loop Until Status = 1
Return

'*********************************************************
Menu_exit:
   Gosub Sound_menu
   Rtc_status = 0
   Cls
   Locate 1 , 1 : Lcd "Exit"
   Do
      Debounce Left_key , 0 , Menu_servo2_setting
      'Debounce Set_key , 0 , Menu_hour , Sub
      If Set_key = 0 Then
         Waitms 30
         If Set_key = 0 Then
            Waitms 300
            Rtc_status = 1
            Status = 1
         End If
      End If
      Debounce Right_key , 0 , Menu_time_setting
   Loop Until Status = 1
Return


'*****************************************      Menu_hour
Menu_hour:
   Gosub Sound_menu
   Rtc_status = 0
   Cls
   Locate 1 , 1 : Lcd "Setting RTC Time"
   Locate 2 , 1 : Lcd "Hour= " ; _hour ; "       "
   Do
      Debounce Set_key , 0 , Menu_min , Sub
      'Debounce Up_key , 0 , Incr_hour
      'Debounce Down_key , 0 , Decr_hour
            K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr _hour
            If _hour > 23 Then _hour = 0
            Locate 2 , 1 : Lcd "Hour= " ; _hour ; "   "
            K1 = 0
         End If
      Loop Until Up_key = 1
      K1 = 0

      K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr _hour
            If _hour > 23 Then _hour = 23
            Locate 2 , 1 : Lcd "Hour= " ; _hour ; "   "
            K1 = 0
         End If
      Loop Until Down_key = 1
      K1 = 0

   Loop Until Status = 1
   'Incr_hour:
      'Gosub Sound_pressing
      'Incr _hour
      'If _hour > 23 Then _hour = 0
      'If Status = 0 Then Goto Menu_hour
   'Decr_hour:
      'Gosub Sound_pressing
      'Decr _hour
      'If _hour > 23 Then _hour = 23
      'If Status = 0 Then Goto Menu_hour
Return

'*********************************************************
Menu_min:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Setting RTC Time"
   Locate 2 , 1 : Lcd "Min= " ; _min ; "  "
   Do
      Debounce Set_key , 0 , Menu_sec , Sub
      'Debounce Up_key , 0 , Incr_min
      'Debounce Down_key , 0 , Decr_min
      K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr _min
            If _min > 59 Then _min = 0
            Locate 2 , 1 : Lcd "Min= " ; _min ; " "
            K1 = 0
         End If
      Loop Until Up_key = 1
      K1 = 0

      K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr _min
            If _min > 59 Then _min = 59
            Locate 2 , 1 : Lcd "Min= " ; _min ; "  "
            K1 = 0
         End If
      Loop Until Down_key = 1
      K1 = 0

   Loop Until Status = 1
   'Incr_min:
      'Gosub Sound_pressing
      'Incr _min
      'If _min > 59 Then _min = 0
      'If Status = 0 Then Goto Menu_min
   'Decr_min:
      'Gosub Sound_pressing
      'Decr _min
      'If _min > 59 Then _min = 59
      'If Status = 0 Then Goto Menu_min
Return

'*****************************************
Menu_sec:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Setting RTC Time"
   Locate 2 , 1 : Lcd "Second= " ; _sec ; "  "
   Do
      Debounce Set_key , 0 , Write_to_ds1307 , Sub
      'Debounce Up_key , 0 , Incr_sec
      'Debounce Down_key , 0 , Decr_sec
            K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Incr _sec
            If _sec > 59 Then _sec = 0
            Locate 2 , 1 : Lcd "Second= " ; _sec ; "  "
            K1 = 0
         End If
      Loop Until Up_key = 1
      K1 = 0

      K1 = 0
      Do
         Incr K1
         If K1 > Pres_key_max_timer Then
            Gosub Sound_pressing
            Decr _sec
            If _sec > 59 Then _sec = 59
            Locate 2 , 1 : Lcd "Second= " ; _sec ; "  "
            K1 = 0
         End If
      Loop Until Down_key = 1
      K1 = 0

   Loop Until Status = 1
   'Incr_sec:
      'Gosub Sound_pressing
      'Incr _sec
      'If _sec > 59 Then _sec = 0
      'If Status = 0 Then Goto Menu_sec
   'Decr_sec:
      'Gosub Sound_pressing
      'Decr _sec
      'If _sec > 59 Then _sec = 59
      'If Status = 0 Then Goto Menu_sec
Return

'*****************************************
Menu_year:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Year= " ; _year ; "       "
   Do
      Debounce Set_key , 0 , Menu_month , Sub
      Debounce Up_key , 0 , Incr_year
      Debounce Down_key , 0 , Decr_year
   Loop Until Status = 1
   Incr_year:
      Gosub Sound_pressing
      Incr _year
      If _year > 99 Then _year = 0
      If Status = 0 Then Goto Menu_year
   Decr_year:
      Gosub Sound_pressing
      Decr _year
      If _year > 99 Then _year = 99
      If Status = 0 Then Goto Menu_year
Return

'*****************************************
Menu_month:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Month= " ; _month ; "       "
   Do
      Debounce Set_key , 0 , Menu_day , Sub
      Debounce Up_key , 0 , Incr_month
      Debounce Down_key , 0 , Decr_month
   Loop Until Status = 1
   Incr_month:
      Gosub Sound_pressing
      Incr _month
      If _month > 12 Then _month = 1
      If Status = 0 Then Goto Menu_month
   Decr_month:
      Gosub Sound_pressing
      Decr _month
      If _month < 1 Then _month = 12
      If Status = 0 Then Goto Menu_month
Return


'*****************************************
Menu_day:
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Day= " ; _day ; "       "
   Do
      Debounce Set_key , 0 , Write_to_ds1307 , Sub
      Debounce Up_key , 0 , Incr_day
      Debounce Down_key , 0 , Decr_day
   Loop Until Status = 1
   Incr_day:
      Gosub Sound_pressing
      Incr _day
      If _day > 31 Then _day = 1
      If Status = 0 Then Goto Menu_day
   Decr_day:
      Gosub Sound_pressing
      Decr _day
      If _day < 1 Then _day = 31
      If Status = 0 Then Goto Menu_day
Return

'***************************************************
Sound_pressing:
   Sound Sound_pin , 100 , 250
Return

'***************************************************
Sound_menu:
   Sound Sound_pin , 100 , 500
Return

'***************************************************
Sound_error:
   Sound Sound_pin , 30 , 2000
Return