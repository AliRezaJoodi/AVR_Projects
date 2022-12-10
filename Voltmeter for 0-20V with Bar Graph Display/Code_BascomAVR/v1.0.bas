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

Deflcdchar 1 , 16 , 16 , 16 , 16 , 16 , 16 , 16 , 16
Deflcdchar 2 , 24 , 24 , 24 , 24 , 24 , 24 , 24 , 24
Deflcdchar 3 , 28 , 28 , 28 , 28 , 28 , 28 , 28 , 28
Deflcdchar 4 , 30 , 30 , 30 , 30 , 30 , 30 , 30 , 30
Deflcdchar 5 , 31 , 31 , 31 , 31 , 31 , 31 , 31 , 31

Dim W As Word
Dim Input_mv As Single
Dim Input_v As Single

Dim Z1 As Byte
Dim Z2 As Byte
Dim N5 As Byte
Dim I As Byte

Do
   Gosub Get_adc
   Gosub Display_value
   Gosub Display_bar
   Waitms 200
Loop

End

'**********************************************
Get_adc:
   W = Getadc(7)
   Input_mv = W * Gain
   Input_mv = Input_mv * 4.133333 'Modification of resistance divider
   Input_v = Input_mv / 1000
Return

'**********************************************
Display_bar:
   Locate 2 , 1
   'Input_mv = 20000 - input_mv	
   Z1 = Input_mv / 250
   N5 = Z1 / 5
   For I = 1 To N5
      Lcd Chr(5)
   Next I

   Z2 = Z1 Mod 5
   If Z2 = 4 Then Lcd Chr(4)
   If Z2 = 3 Then Lcd Chr(3)
   If Z2 = 2 Then Lcd Chr(2)
   If Z2 = 1 Then Lcd Chr(1)

   I = 16 - N5 : I = I + 1
   Lcd Space(i)
Return

'**********************************************
Display_value:
   Locate 1 , 1 : Lcd "In(0-20V):" ; Fusing(input_v , "#.###") ; "  "
Return