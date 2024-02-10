
'.......................................................................
$regfile = "m16def.dat"
$crystal = 4000000
'.......................................................................

'.......................................................................
Config Porta = Output
Config Portc = Output
Config Pind.5 = Input : Portd.5 = 1
Config Portb.1 = Output : Portb.1 = 0
'.......................................................................

'.......................................................................
Dim Scan As Byte
Dim I As Word
Dim Refresh As Byte
Dim S As Word
Dim E As Word
'.......................................................................

Do
   For S = 0 To 200
      E = S + 7
      Bitwait Pind.5 , Set
      For Refresh = 1 To 10
         Scan = &H01
         For I = S To E
            Portc = Lookup(i , Text00)
            Porta = Scan
            Rotate Scan , Left , 1
            Waitms 2
            Porta = 0
         Next I
      Next Refresh
      If S = 7 Then Portb.1 = 1
   Next S
Loop
End

'*****************************************************************      Text00
Text00:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data  &H3E , &H7E , &HD0 , &H90 , &HD0 , &H7E , &H3E , &H00 'A
Data  &H82 , &HFE , &HFE , &H82 , &H02 , &H06 , &H0E , &H00 'L
Data  &H82 , &HFE , &HFE , &H82 , &H02 , &H06 , &H0E , &H00 'L
Data  &H3E , &H7E , &HD0 , &H90 , &HD0 , &H7E , &H3E , &H00 'A
Data  &HFE , &HFE , &H70 , &H38 , &H70 , &HFE , &HFE , &H00 'M
Data  &H82 , &HFE , &HFE , &H92 , &HBA , &H82 , &HC6 , &H00 'E
Data  &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 '
Data  &HFE , &HFE , &H70 , &H38 , &H70 , &HFE , &HFE , &H00 'M
Data  &H7C , &HFE , &H82 , &H82 , &H82 , &HFE , &H7C , &H00 'O
Data  &HFE , &HFE , &H10 , &H10 , &H10 , &HFE , &HFE , &H00 'H
Data  &H3E , &H7E , &HD0 , &H90 , &HD0 , &H7E , &H3E , &H00 'A
Data  &H82 , &HFE , &HFE , &H82 , &HC6 , &H7C , &H38 , &H00 'D
Data  &H82 , &HFE , &HFE , &H92 , &HBA , &H82 , &HC6 , &H00 'E
Data  &H00 , &H44 , &HE6 , &HB2 , &H9A , &HCE , &H44 , &H00 'S
Data  &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 '
Data  &HFE , &HFE , &H60 , &H30 , &H18 , &HFE , &HFE , &H00 'N
Data  &H7C , &HFE , &H82 , &H82 , &H82 , &HFE , &H7C , &H00 'O
Data  &H82 , &HFE , &HFE , &H90 , &H98 , &HFE , &H66 , &H00 'R
Data  &H00 , &H00 , &H82 , &HFE , &HFE , &H82 , &H00 , &H00 'I
Data  &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 '
Data  &HFE , &HFE , &H60 , &H30 , &H18 , &HFE , &HFE , &H00 'N
Data  &H7C , &HFE , &H82 , &H82 , &H82 , &HFE , &H7C , &H00 'O
Data  &H7C , &HFE , &H82 , &H82 , &H82 , &HFE , &H7C , &H00 'O
Data  &H82 , &HFE , &HFE , &H90 , &H98 , &HFE , &H66 , &H00 'R
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00

