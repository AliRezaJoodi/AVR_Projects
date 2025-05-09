'GitHub Account: GitHub.com/AliRezaJoodi


$regfile = "m32def.dat"
$crystal = 11059200

$baud = 9600

Config PortC = Output

Dim value As Byte

Do
   Input value
   PortC = value
Loop

End
