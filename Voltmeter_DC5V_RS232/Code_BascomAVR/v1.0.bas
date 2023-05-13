'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600

Config Lcdpin = Pin , Rs = Pinc.7 , E = Pinc.5 , Db4 = Pinc.3 , Db5 = Pinc.2 , Db6 = Pinc.1 , Db7 = Pinc.0
Config Lcd = 16 * 2
Cursor Off
Cls

Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Dim W As Word
Dim Input_mv As Single
Dim Input_v As Single

Do
   Gosub Get_adc
   Gosub Display_value
   Print Fusing(input_mv , "#.#")
   Waitms 500
Loop

End

'**********************************************
Get_adc:
   W = Getadc(0)
   Input_mv = W * 4.8828125
   Input_v = Input_mv / 1000
Return

'**********************************************
Display_value:
   Locate 1 , 1 : Lcd "Input(V):" ; Fusing(input_v , "#.#") ; "   "
   Locate 2 , 1 : Lcd "Input(mV):" ; Fusing(input_mv , "#.#") ; "   "
Return