'*********************************************
'* This Program Writing By : Alireza khalili *
'* grafical lcd                              *
'* For to get more details visit :           *
'*                 alirezaavr.blogfa.com     *
'* Contact to me by : alirezalahij@yahoo.com *
'*********************************************


$regfile = "m16def.dat"                                     ' specify the used micro
$crystal = 16000000                                         ' used crystal frequency

$hwstack = 32                                               ' default use 32 for the hardware stack
$swstack = 10                                               ' default use 10 for the SW stack
$framesize = 40                                             ' default use 40 for the frame space



'some routines to control the display are in the glcdKS108.lib file
$lib "glcdKS108.lib"
'$include "font8x8.font"                                     '
'First we define that we use a graphic LCD
Config Graphlcd = 128 * 64sed , Dataport = Portd , Controlport = Portc , Ce = 2 , Ce2 = 1 , Cd = 5 , Rd = 4 , Reset = 0 , Enable = 3
'Mishod Payeh Shomareh 5 Ra Braye Reser Entekhab Konim - Man Shomareh 6 Ra Gharar Dadam Va Reset Lcd Ra Mostaghim Be Vcc Vasl Kardam.

'The dataport is the portname that is connected to the data lines of the LCD
'The controlport is the portname which pins are used to control the lcd
'CE =CS1  Chip select
'CE2=CS2  Chip select second chip
'CD=Data/instruction
'RD=Read
'RESET = reset
'ENABLE= Chip Enable

'specify the font we want to use
Setfont Font8x8

'Setfont Font16x16

Dim I As Byte , I2 As Byte

'Gosub Test

Showpic 0 , 0 , Pic5
Wait 2
End


Showpic 0 , 0 , Pic1
Lcdat 7 , 70 , "Mohsen "
Waitms 1500


For I = 0 To 64
Line(0 , I) -(128 , I) , 0
Waitms 10
Next I




Showpic 0 , 0 , Pic1 , 1
Lcdat 5 , 70 , "Dokhaie" , 1
Waitms 500


For I = 64 To 0 Step -1
Line(0 , I) -(128 , I) , 0
Waitms 10
Next I



Showpic 0 , 0 , Pic1
Waitms 500


For I2 = 0 To 80
Line(i2 , 0) -(i2 , 64) , 0
Waitms 10
Next I2

Showpic 0 , 0 , Pic1 , 1
Waitms 500

For I2 = 128 To 0 Step -1
Line(i2 , 0) -(i2 , 64) , 0
Waitms 10
Next I2











For I = 1 To 10

Showpic 0 , 0 , Pic3
Waitms 500
Showpic 0 , 0 , Pic3 , 1
Waitms 500
Showpic 0 , 0 , Pic4
Waitms 500
Showpic 0 , 0 , Pic4 , 1
Waitms 500
Showpic 0 , 0 , Pic5
Waitms 500
Showpic 0 , 0 , Pic5 , 1
Waitms 500
Next I
Cls





'LCDAT Y , COL, value
Lcdat 4 , 1 , "Dokhaie"
Wait 1
Circle(59 , 27) , 7 , 1
Wait 1

Line(0 , 0) -(128 , 63) , 1                                 'make line
Wait 1

Pset 50 , 18 , 1
Pset 50 , 36 , 1
Pset 68 , 18 , 1
Pset 68 , 36 , 1
Wait 1
Setfont Font8x8
Lcdat 1 , 16 , "Mohsen"
Lcdat 8 , 1 , "Khazar"




End                                                         'end program



$include "font8x8.font"
'$include "font16x16.font"

Pic1:
$bgf "1.bgf"
Pic2:
$bgf "2.bgf"
Pic3:
$bgf "3.bgf"
Pic4:
$bgf "4.bgf"
Pic5:
$bgf "5.bgf"