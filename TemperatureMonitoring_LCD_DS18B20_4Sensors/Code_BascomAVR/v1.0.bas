'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Rs = Porta.5 , E = Porta.7 , Db4 = Portc.5 , Db5 = Portc.4 , Db6 = Portc.3 , Db7 = Portc.2
Config Lcd = 16 * 2
Cursor Off
Cls

Config 1wire = Portb.0

Dim Temperature As String * 6
Dim Digital_output As Integer

Dim Sensor_1(8) As Byte
Dim Sensor_2(8) As Byte
Dim Sensor_3(8) As Byte
Dim Sensor_4(8) As Byte

'Dim I As Byte
'For I = 1 To 8
   'Dsid2(i) = 0
'Next I

Deflcdchar 0 , 232 , 244 , 232 , 227 , 228 , 228 , 227 , 224

Sensor_1(1) = 1wsearchfirst()
Sensor_2(1) = 1wsearchnext()
Sensor_3(1) = 1wsearchnext()
Sensor_4(1) = 1wsearchnext()

'Do
   'Cls
   'Locate 1 , 1 : Lcd Dsid2(1) ; " " ; Dsid2(2) ; " " ; Dsid2(3) ; " " ; Dsid2(4)
   'Locate 2 , 1 : Lcd Dsid2(5) ; " " ; Dsid2(6) ; " " ; Dsid2(7) ; " " ; Dsid2(8)
   'Locate 2 , 1 : Lcd Dsid3(2)
   'Locate 2 , 8 : Lcd Dsid4(2)
   'End
'Loop

Do

   1wreset
   1wwrite &HCC
   1wwrite &H44
   Waitms 750

   1wreset
   1wwrite &H55
   1wverify Sensor_1(1)
   1wwrite &HBE
   Digital_output = 1wread(2)
   Gosub Conversion
   'Locate 1 , 1 : Lcd "1:" ; Temperature ; Chr(0)
   Locate 1 , 9 : Lcd "3:" ; Temperature ; Chr(0)

   1wreset
   1wwrite &H55
   1wverify Sensor_2(1)
   1wwrite &HBE
   Digital_output = 1wread(2)
   Gosub Conversion
   'Locate 2 , 1 : Lcd "2:" ; Temperature ; Chr(0)
   Locate 2 , 9 : Lcd "4:" ; Temperature ; Chr(0)

   1wreset
   1wwrite &H55
   1wverify Sensor_3(1)
   1wwrite &HBE
   Digital_output = 1wread(2)
   Gosub Conversion
   'Locate 1 , 9 : Lcd "3:" ; Temperature ; Chr(0)
   Locate 2 , 1 : Lcd "2:" ; Temperature ; Chr(0)

   1wreset
   1wwrite &H55
   1wverify Sensor_4(1)
   1wwrite &HBE
   Digital_output = 1wread(2)
   Gosub Conversion
   'Locate 2 , 9 : Lcd "4:" ; Temperature ; Chr(0)
   Locate 1 , 1 : Lcd "1:" ; Temperature ; Chr(0)
Loop

End

'***********************************
Conversion:
   Digital_output = Digital_output * 10
   Digital_output = Digital_output \ 16
   Temperature = Str(digital_output)
   Temperature = Format(temperature , "0.0")
Return