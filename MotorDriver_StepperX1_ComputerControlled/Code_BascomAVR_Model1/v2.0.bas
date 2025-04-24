'GitHub Account: GitHub.com/AliRezaJoodi

$crystal = 8000000
$regfile = "attiny2313.dat"

$baud = 9600


Dim Value As Byte

Config Portb = Output

Do
   Input "Give input: " , Value
   Porta = Value
Loop

End
