'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config 1wire = Porta.0

Dim Buffer As Integer
Dim Temp As Single

Deflcdchar 0 , 232 , 244 , 232 , 227 , 228 , 228 , 227 , 224

Do
   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 100

   1wreset
   1wwrite &HCC
   1wwrite &HBE
   Buffer = 1wread(2)

   Temp = Buffer : Temp = Temp * 0.0625
   Gosub Display_temp
   Waitms 300
Loop

End

'*****************************
Display_temp:
   'Locate 1 , 1 : Lcd "Temp: " ; Fusing(temp , "#.#") ; Chr(0) ; "   "
   Locate 1 , 1 : Lcd "Temp(" ; ; Chr(0) ; "):" ; Fusing(temp , "#.#") ; "   "
   Locate 2 , 1 : Lcd "DS1820 Sensor"
Return