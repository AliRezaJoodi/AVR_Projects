'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

$baud = 9600
Config Serialin = Buffered , Size = 20
Config Serialout = Buffered , Size = 20
Enable Interrupts

Dim T As Byte : T = 100

Baud = 300 : Print "300" : Waitms T
Baud = 600 : Print "600" : Waitms T
Baud = 1200 : Print "1200" : Waitms T
Baud = 2400 : Print "2400" : Waitms T
Baud = 4800 : Print "4800" : Waitms T
Baud = 9600 : Print "9600" : Waitms T
Baud = 19200 : Print "19200" : Waitms T
Baud = 38400 : Print "38400" : Waitms T
Baud = 57600 : Print "57600" : Waitms T
Baud = 128000 : Print "128000" : Waitms T
Baud = 256000 : Print "256000" : Waitms T
Baud = 115200 : Print "115200" : Waitms T

End