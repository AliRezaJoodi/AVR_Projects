'*********************************************
'* This Program Writing By : Alireza khalili *
'* grafical lcd                              *
'* For to get more details visit :           *
'*                 alirezaavr.blogfa.com     *
'* Contact to me by : alirezalahij@yahoo.com *
'*********************************************

$regfile = "m16def.dat"                                     ' specify the used micro
$crystal = 8000000                                          ' used crystal frequency

$hwstack = 32                                               ' default use 32 for the hardware stack
$swstack = 10                                               ' default use 10 for the SW stack
$framesize = 40                                             ' default use 40 for the frame space


$lib "glcdKS108.lib"


Config Graphlcd = 128 * 64sed , Dataport = Portc , Controlport = Porta , Ce = 2 , Ce2 = 1 , Cd = 4 , Rd = 3 , Reset = 6 , Enable = 0

Setfont Font16x16

Wait 1
Cls

Lcdat 1 , 1 , "MCE"

Wait 5 : Cls

Setfont Font8x8
Lcdat 1 , 1 , "Line 1"
Lcdat 4 , 1 , "Line 4"

End                                                         'end program

$include "font8x8.font"
$include "font16x16.font"

