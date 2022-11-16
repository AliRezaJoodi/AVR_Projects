'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 10000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config Timer1 = Timer , Prescale = 1
Enable Timer1
Stop Timer1
Timer1 = 0

Config Portb.7 = Input : Smt160_pin Alias Pinb.7

Dim Duty_reset As Word
Dim Duty_set As Word
Dim Temp As Single
Dim S As String * 16

Do
   Gosub Read_smt160
   Gosub Display_temp
   Waitms 300
Loop

End

'**********************************************
Read_smt160:
   Bitwait Smt160_pin , Reset
   Bitwait Smt160_pin , Set
   Bitwait Smt160_pin , Reset
   Bitwait Smt160_pin , Set : Start Timer1
   Bitwait Smt160_pin , Reset : Stop Timer1
   Duty_set = Timer1 : Timer1 = 0

   Bitwait Smt160_pin , Set
   Bitwait Smt160_pin , Reset
   Bitwait Smt160_pin , Set
   Bitwait Smt160_pin , Reset : Start Timer1
   Bitwait Smt160_pin , Set : Stop Timer1
   Duty_reset = Timer1 : Timer1 = 0

   Temp = Duty_set + Duty_reset
   Temp = Duty_set / Temp
   Temp = Temp - 0.32
   Temp = Temp / 0.0047
   'Temp = Temp - 0.7
Return

'**********************************************
Display_temp:
   Deflcdchar 0 , 7 , 5 , 7 , 32 , 32 , 32 , 32 , 32
   Locate 1 , 1 : Lcd "Temp: " ; Fusing(temp , "#.#") ; Chr(0) ; "C  "
Return