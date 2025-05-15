'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "attiny2313.dat"
$crystal = 8000000
$baud = 9600

'OUT0 Alias Portb.0: Config OUT0 = Output
'OUT1 Alias Portb.1 : Config OUT1 = Output
'OUT2 Alias PortB.2 : Config OUT2 = Output
'OUT3 Alias PortB.3 : Config OUT3 = Output
OUT4 Alias Portb.4 : Config OUT4 = Output
OUT5 Alias Portb.5 : Config OUT5 = Output
OUT6 Alias Portb.6 : Config OUT6 = Output
OUT7 Alias Portb.7 : Config OUT7 = Output

Dim Value As Byte

Do
   Input "Enter Input: " , Value

   'OUT0=Value.0
   'OUT1=Value.1
   'OUT2=Value.2
   'OUT3=Value.3
   OUT4=Value.4
   OUT5=Value.5
   OUT6=Value.6
   OUT7=Value.7
Loop

End