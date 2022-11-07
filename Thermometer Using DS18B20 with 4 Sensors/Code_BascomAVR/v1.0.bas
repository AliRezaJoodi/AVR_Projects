'Github Account: Github.com/AliRezaJoodi
'Compiler version: 1.11.9.8

$regfile = "m32def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Rs = Pind.0 , E = Pind.2 , Db4 = Pind.4 , Db5 = Pind.5 , Db6 = Pind.6 , Db7 = Pind.7
Config Lcd = 16 * 2
Cursor Off
Cls

Config 1wire = Porta.0

Dim Temperature As String * 6
Dim Buffer_digital As Integer

Dim Ds18b20_id_1(8) As Byte
Dim Ds18b20_id_2(8) As Byte
Dim Ds18b20_id_3(8) As Byte
Dim Ds18b20_id_4(8) As Byte

Deflcdchar 0 , 232 , 244 , 232 , 227 , 228 , 228 , 227 , 224
Gosub Display_loding

Ds18b20_id_1(1) = 1wsearchfirst() : Waitms 10
Ds18b20_id_2(1) = 1wsearchnext() : Waitms 10
Ds18b20_id_3(1) = 1wsearchnext() : Waitms 10
Ds18b20_id_4(1) = 1wsearchnext() : Waitms 10

Dim Temp1 As Single
Dim Temp2 As Single
Dim Temp3 As Single
Dim Temp4 As Single

Do
   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 750

   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_1(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Temp1 = Buffer_digital : Temp1 = Temp1 * 0.0625

   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_2(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Temp2 = Buffer_digital : Temp2 = Temp2 * 0.0625

   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_3(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Temp3 = Buffer_digital : Temp3 = Temp3 * 0.0625

   1wreset
   1wwrite &H55
   1wverify Ds18b20_id_4(1)
   1wwrite &HBE
   Buffer_digital = 1wread(2)
   Temp4 = Buffer_digital : Temp4 = Temp4 * 0.0625

   Gosub Display_temps
Loop

End

'*****************************
Display_temps:
   Locate 1 , 1 : Lcd "1:" ; Fusing(temp1 , "#.#") ; Chr(0) ; " "
   Locate 1 , 9 : Lcd "2:" ; Fusing(temp2 , "#.#") ; Chr(0) ; " "
   Locate 2 , 1 : Lcd "3:" ; Fusing(temp3 , "#.#") ; Chr(0) ; " "
   Locate 2 , 9 : Lcd "4:" ; Fusing(temp4 , "#.#") ; Chr(0) ; " "
Return

'**********************************************
Display_loding:
   Cls :
   Locate 1 , 1 : Lcd "DS18B20 Driver"
   Locate 2 , 1 : Lcd "Loading ..."
   'Wait 2 : Cls : Waitms 200
Return