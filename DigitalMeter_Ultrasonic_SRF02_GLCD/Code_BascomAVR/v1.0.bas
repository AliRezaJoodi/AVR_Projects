'Github Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
$lib "glcdKS108.lib"                                        '

Config Graphlcd = 128 * 64sed , Dataport = Portd , Controlport = Portc , Ce = 1 , Ce2 = 2 , Cd = 5 , Rd = 4 , Reset = 0 , Enable = 3
Cls                                                         ': Setfont Font8x8

Config Scl = Portb.2
Config Sda = Portb.3
Const Rs02w = &HE0
Const Rs02r = &HE1

Config Porta.0 = Input
Config Porta.4 = Input
Config Portb.4 = Input

Config Debounce = 30
Config Porta.3 = Input : Porta.3 = 1 : Right_key Alias Pina.3
Config Porta.6 = Input : Porta.6 = 1 : Middle_key Alias Pina.6
Config Porta.7 = Input : Porta.7 = 1 : Left_key Alias Pina.7

Const Delay_1 = 1
Const Delay_2 = 2
Const Delay_3 = 3
Const Delay_4 = 4

Dim Lentgh_msb As Byte : Lentgh_msb = 0
Dim Lentgh_lsb As Byte : Lentgh_lsb = 0
Dim Lentgh As Integer : Lentgh = 0
Dim T As Byte : T = 70
Dim State As Bit : State = 0

Gosub Sub_start
Gosub Get_srf02

Do
   Debounce Right_key , 0 , Get_srf02 , Sub
   Debounce Left_key , 0 , Get_srf02 , Sub
   Debounce Middle_key , 0 , Real_sub , Sub
   If State = 1 Then
      Gosub Get_srf02
      Waitms 500
   End If
Loop

End

'*****************************************
Get_srf02:
   I2cstart
   I2cwbyte Rs02w
   I2cwbyte 0
   I2cwbyte &H51
   I2cstop : Waitms T
   I2cstart
   I2cwbyte Rs02w
   I2cwbyte 2
   I2cstop : Waitms T
   I2cstart
   I2cwbyte Rs02r
   I2crbyte Lentgh_msb , Ack
   I2crbyte Lentgh_lsb , Nack
   I2cstop : Waitms T
   Lentgh = Makeint(lentgh_lsb , Lentgh_msb)
   Gosub Show_lentgh
Return

'*****************************************
Show_lentgh:
   Cls : Setfont Font16x16
   Lcdat 1 , 1 , Lentgh
   Setfont Font8x8
   Lcdat 3 , 50 , "Centimeter"
   Lcdat 8 , 0 , "Digital Meters"
Return

'*****************************************
Real_sub:
   Toggle State
Return

'*****************************************
Sub_start:
   Cls : Showpic 0 , 0 , P0 : Wait Delay_3
   Cls : Showpic 0 , 0 , P1 : Wait Delay_1
   Cls : Showpic 0 , 0 , P2 : Wait Delay_2
   Cls
Return

'*****************************************
P0:
$bgf "P0.bgf"

'*****************************************
P1:
$bgf "P1.bgf"

'*****************************************
P2:
$bgf "P2.bgf"

'*****************************************
$include "font8x8.font"
$include "font16x16.font"