'Github Account: Github.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 1000000

Config Portd = Output
Portd = 255

Dim I As Byte
Dim Z As Byte

Do
   Z = 1
   For I = 1 To 8
      Portd = Z
      Z = Z * 2
      Waitms 100
   Next I
   Z = 128
   For I = 1 To 8
      Portd = Z
      Z = Z \ 2
      Waitms 100
   Next I
Loop

End