'GitHub Account: GitHub.com/AliRezaJoodi

$crystal = 8000000
$regfile = "attiny2313.dat"

$baud = 9600

Config Portb = Output

Dim Value As Byte

Do
   Input "Give input: " , Value
   Portb = Value
Loop

End