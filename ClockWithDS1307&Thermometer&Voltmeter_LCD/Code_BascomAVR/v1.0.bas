'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Porta.5 , E = Porta.7 , Db4 = Portc.5 , Db5 = Portc.4 , Db6 = Portc.3 , Db7 = Portc.2
Config Lcd = 16 * 2
Cursor Off
Cls
Gosub Display_loading

Enable Interrupts

Ddrd.3 = 0 : Portd.3 = 1
Config Int1 = Falling
On Int1 Int1_tasks
Enable Int1

Config Scl = Portc.0
Config Sda = Portc.1
Const Ds1307w = &HD0
Const Ds1307r = &HD1


Config Adc = Single , Prescaler = Auto , Reference = Avcc : Const Gain = 4.8828125
'Config Adc = Single , Prescaler = Auto , Reference = Internal : Const Gain = 2.5024438
Start Adc
Const Ch_lm35 = 0
Const Ch_volt = 1

Config Debounce = 30
Config Portd.6 = Input : Portd.6 = 1 : Button_set Alias Pind.6
Config Portd.4 = Input : Portd.4 = 1 : Button_up Alias Pind.4
Config Portd.5 = Input : Portd.5 = 1 : Button_down Alias Pind.5

Config Portd.7 = Output : Portd.7 = 0 : Buzzer Alias Portd.7

Dim Strg_x As String * 2
Dim _sec As Byte
Dim _min As Byte
Dim _hour As Byte
Dim _weekday As Byte
Dim _day As Byte
Dim _month As Byte
Dim _year As Byte


Dim W As Word
Dim I As Byte
Dim Temp As Single
Dim Temp_old As Single

Dim W2 As Word
Dim I2 As Byte
Dim Volt As Single
Dim Volt_old As Single

Dim Ex As Byte
Dim Task_time_1s As Byte : Task_time_1s = 0
Dim Task_time_set As Byte

Gosub Config_ds1307
Gosub Sound_menu

Do
   Gosub Get_temp
   If Temp <> Temp_old Then
      Temp_old = Temp
      Gosub Display_temp
   End If

   Gosub Get_volt
   If Volt <> Volt_old Then
      Volt_old = Volt
      Gosub Display_volt
   End If

   If Task_time_1s = 1 Then
      Task_time_1s = 0
      Gosub Read_of_the_ds1307
      Gosub Display_time
      Gosub Display_temp
      Gosub Display_volt
   End If
   
   Debounce Button_set , 0 , Set_hour , Sub
   Ex = 0
Loop
End

'****************************************
Int1_tasks:
   Task_time_1s = 1
Return

'*****************************************
Display_loading:
   Cls
   Locate 1 , 1 : Lcd "Loading ..."
   Wait 1 : Cls
Return

'*****************************************
Get_temp:
   W = W + Getadc(ch_lm35)
   Incr I
   If I = 10 Then
      I = 0
      W = W / 10
      Temp = W * Gain : Temp = Temp / 10
      W = 0
   End If
Return

'*****************************************
Display_temp:
   Deflcdchar 0 , 7 , 5 , 7 , 32 , 32 , 32 , 32 , 32
   Locate 1 , 9
   Lcd "  " ; Fusing(temp , "#.#") ; Chr(0) ; "C  "
Return

'*****************************************
Get_volt:
   W2 = W2 + Getadc(ch_volt)
   Incr I2
   If I2 = 10 Then
      I2 = 0
      W2 = W2 / 10
      Volt = W2 * Gain : Volt = Volt / 1000 : Volt = Volt * 6.55555556
      W2 = 0
   End If
Return

'*****************************************
Display_volt:
   Locate 2 , 11 : Lcd Fusing(volt , "#.#") ; "V  "
Return

'*****************************************
Read_of_the_ds1307:
   I2cstart
   I2cwbyte Ds1307w
   I2cwbyte 0
   I2cstart
   I2cwbyte Ds1307r
   I2crbyte _sec , Ack
   I2crbyte _min , Ack
   I2crbyte _hour , Ack
   I2crbyte _weekday , Ack
   I2crbyte _day , Ack
   I2crbyte _month , Ack
   I2crbyte _year , Nack
   I2cstop

   _hour = _hour And &B00111111
   _sec = _sec And &B01111111
   Gosub Bcd_to_decimal
Return

'*****************************************
Write_to_ds1307:
   Gosub Decimal_to_bcd
   _sec = _sec And &B01111111
   _hour = _hour And &B00111111
   I2cstart
   I2cwbyte Ds1307w
   I2cwbyte 0
   I2cwbyte _sec
   I2cwbyte _min
   I2cwbyte _hour
   I2cwbyte _weekday
   I2cwbyte _day
   I2cwbyte _month
   I2cwbyte _year
   I2cstop
Return

'*****************************************
Config_ds1307:
   I2cstart
   I2cwbyte Ds1307w
   I2cwbyte &H00
   I2cwbyte &B00000000
   I2cstop

   Waitms 10
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
Display_time:
   Locate 1 , 1
   Strg_x = Str(_hour) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd ":"
   Strg_x = Str(_min) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd ":"
   Strg_x = Str(_sec) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd " "
   Locate 2 , 1
   Strg_x = Str(_year) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd "/"
   Strg_x = Str(_month) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd "/"
   Strg_x = Str(_day) : Strg_x = Format(strg_x , "00") : Lcd Strg_x : Lcd " "
Return

'*****************************************
Set_hour:
   Gosub Sound_menu
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
   Gosub Sound_menu
   Cls
   Locate 1 , 1 : Lcd "Day=" ; _day ; "  "
   Locate 2 , 1 : Lcd "Setting Mode"
   Bitwait Button_set , Set
   Do
      If Button_set = 0 Then
         Gosub Sound_menu
         Gosub Write_to_ds1307
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