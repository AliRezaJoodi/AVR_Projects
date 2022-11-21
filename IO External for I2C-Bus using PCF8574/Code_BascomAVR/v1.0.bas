'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 1000000
'$baud = 9600
'Print "ok"

Config Scl = Portc.0
Config Sda = Portc.1

Const Pcf8574 = &B01000000
Const Pcf8574a = &B01110000
Const Write_pcf = 0
Const Read_pcf = 1

Const A0_pcf1 = 0
Const A1_pcf1 = 0
Const A2_pcf1 = 0

Const A0_pcf2 = 1
Const A1_pcf2 = 0
Const A2_pcf2 = 0

Dim Wa1 As Byte                                             'Write Address for the Chip Number 1
Wa1 = Pcf8574
Wa1.0 = Write_pcf
Wa1.1 = A0_pcf1
Wa1.2 = A1_pcf1
Wa1.3 = A2_pcf1
'Print WA1
Dim Ra1 As Byte                                             'Read Address for the Chip Number 1
Ra1 = Pcf8574
Ra1.0 = Read_pcf
Ra1.1 = A0_pcf1
Ra1.2 = A1_pcf1
Ra1.3 = A2_pcf1
'Print RA1

Dim Wa2 As Byte                                             'Write Address for the Chip Number 2
Wa2 = Pcf8574
Wa2.0 = Write_pcf
Wa2.1 = A0_pcf2
Wa2.2 = A1_pcf2
Wa2.3 = A2_pcf2
'Print Wa2
Dim Ra2 As Byte                                             'Read Address for the Chip Number 2
Ra2 = Pcf8574
Ra2.0 = Read_pcf
Ra2.1 = A0_pcf2
Ra2.2 = A1_pcf2
Ra2.3 = A2_pcf2
'Print RA2

Dim I1 As Byte : I1 = 0
Dim I2 As Byte

Do
   Incr I1 : Gosub Set_pcf1
   Gosub Read_pcf1 : Gosub Set_pcf2
   Wait 1
Loop

End

'*************************************
Set_pcf1:
   I2cstart
   I2cwbyte Wa1
   I2cwbyte I1
   I2cstop
Return

'*************************************
Set_pcf2:
   I2cstart
   I2cwbyte Wa2
   I2cwbyte I2
   I2cstop
Return

'*************************************
Read_pcf1:
   I2cstart : Waitms 10
   I2cwbyte Ra1
   I2crbyte I2 , Nack
   I2cstop
   'Print I2
Return