'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000
'$crystal = 11059200

Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Portc.4 , Db5 = Portc.3 , Db6 = Portc.2 , Db7 = Portc.1 , E = Portc.5 , Rs = Portc.7
Cursor Off
Cls

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Deflcdchar 0 , 32 , 6 , 6 , 32 , 32 , 32 , 32 , 32

Dim W As Word
Dim Input_mv As Single
Dim Temp As Single

Do
   Gosub Read_adc
   Gosub Convert
   Gosub Show_temp
   Waitms 500
Loop

End

'**********************************************
Read_adc:
   W = Getadc(0)
   Input_mv = W * 4.8828125
Return

'**********************************************
Convert:
   Temp = Input_mv / 10
Return

'**********************************************
Show_temp:
   Locate 1 , 1 : Lcd "Thermometer"
   Locate 2 , 1
   Lcd "Temp= "
   Lcd Fusing(temp , "#.#") ; Chr(0) ; "C  "
Return