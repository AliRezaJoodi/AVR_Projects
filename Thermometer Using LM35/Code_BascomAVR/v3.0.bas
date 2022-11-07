'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls
Gosub Display_loading
Gosub Display_advertising

Enable Interrupts

Config Adc = Single , Prescaler = Auto , Reference = Internal
Const Gain = 2560 / 1023
Start Adc

Config Timer0 = Timer , Prescale = 256 'PRESCALE= 1|8|64|256|1024
On Timer0 Adc_isr
Enable Ovf0
Start Timer0

Dim W As Word
Dim Input_mv As Single
Dim Input_v As Single
Dim Temp As Single
Dim I As Byte
Dim Sum_temp As Single
Dim Average_temp As Single

Do
   Idle
Loop

End

'**********************************************
Adc_isr:
   Incr I
   Gosub Read_the_adc
   Gosub Convert
   Gosub Display_voltage
   Sum_temp = Sum_temp + Temp
   If I = 10 Then
      Stop Timer0
      Average_temp = Sum_temp / 10
      Gosub Display_temp
      Sum_temp = 0 : I = 0
      Start Timer0
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
Display_voltage:
   Locate 1 , 1 : Lcd "In(V): " ; Fusing(input_v , "#.###") ; "  "
Return

'**********************************************
Display_temp:
   Deflcdchar 0 , 7 , 5 , 7 , 32 , 32 , 32 , 32 , 32
   Locate 2 , 1 : Lcd "T(" ; Chr(0) ; "C): " ; Fusing(average_temp , "#.#") ; "  "
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