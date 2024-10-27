'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 2000000

Config Porta = Output
Config Portb = Output
Config Portc = Output
Config Portd = Output

Dim Scan As Byte
Dim I As Word
Dim Refresh As Byte
Dim T As Byte
Dim B As Byte
Dim D As Word
Dim U As Word
Dim S As Word
Dim M As Word
Dim E As Word
Dim A As Word

Do
 For S = 0 To 48
  E = S + 7
  For Refresh = 1 To 5
   Scan = &H01
   For I = S To E

    For B = 0 To 0

     D = B * 8
     D = D + I
     Portd = Lookup(d , Text00)

     Portb = 2 ^ B
     Portb = 0

    Next B

    Porta = Scan
    Rotate Scan , Left , 1
    Waitms 2
    Porta = 0

   Next I
  Next Refresh
 Next S

Loop
End                                                   

Text00:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &HFE , &HFE , &H10 , &H10 , &H10 , &HFE , &HFE , &H00  'H
Data &H1C , &H3E , &H2A , &H2A , &H2A , &H3A , &H18 , &H00  'e
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H02 , &H00 , &H00  'l
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H02 , &H00 , &H00  'l
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H3E , &H1C , &H00  'o
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00