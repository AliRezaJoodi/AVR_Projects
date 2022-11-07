'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls
Gosub Display_loading
Gosub Display_advertising

Config Adc = Single , Prescaler = Auto , Reference = Internal
Const Gain = 2560 / 1023
On Adc Adc_isr
Enable Interrupts
Enable Adc
Start Adc

Dim W As Word
Dim Input_mv As Single
Dim Input_v As Single
Dim Temp As Single
Dim old_Temp As Single

Do
   Idle
Loop

End

'**********************************************
Adc_isr:
   Gosub Read_the_adc
   Gosub Convert
   If Temp <> Old_temp Then
      Gosub Display_value
      Old_temp = Temp
   End If
Return

'**********************************************
Read_the_adc:
   W = Getadc(7)
   Input_mv = W * Gain
   Input_v = Input_mv / 1000
Return

'**********************************************
Convert:
   Temp = Input_mv / 10                                     'Lm35 outputs 10mv for each C degree
Return

'**********************************************
Display_value:
   Deflcdchar 0 , 7 , 5 , 7 , 32 , 32 , 32 , 32 , 32
   Locate 1 , 1 : Lcd "In(V): " ; Fusing(input_v , "#.###") ; "  "
   Locate 2 , 1 : Lcd "T(" ; Chr(0) ; "C): " ; Fusing(temp , "#.#") ; "  "
Return

'**********************************************
Display_loading:
   Cls
   Locate 1 , 1 : Lcd "Testing the LCD"
   Locate 2 , 1 : Lcd "Loading ..."
   Waitms 500 : Cls
Return

'**********************************************
Display_advertising:
   Locate 1 , 1 : Lcd "GitHub.com"
   Locate 2 , 1 : Lcd "AliRezaJoodi"
   Waitms 500 : Cls
Return