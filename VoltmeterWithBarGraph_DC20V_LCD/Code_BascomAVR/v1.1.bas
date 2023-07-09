'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc
Const Gain = 5000 / 1023

Dim W As Word
Dim Input_mv As Single
Dim Input_v As Single
Dim Input_percent As Single

$include "Attachment\BarGraph_Define.inc"

Do
   Gosub Get_adc
   Gosub Display_value
   Input_percent = Input_v / 20 : Input_percent = Input_percent * 100
   Call Display_bar(input_percent)
   Waitms 250
Loop

End

$include "Attachment\BarGraph_Functions.inc"

'**********************************************
Get_adc:
   W = Getadc(7)
   Input_mv = W * Gain
   Input_mv = Input_mv * 4.133333                           'Modification of resistance divider
   Input_v = Input_mv / 1000
Return

'**********************************************
Display_value:
   Locate 1 , 1 : Lcd "In(0-20V):" ; Fusing(input_v , "#.###") ; "  "
Return