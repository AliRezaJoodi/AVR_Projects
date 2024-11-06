'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 8000000

Config Porta = Output
Config Portb = Output
Config Portc = Output

Dim Scan As Byte
Dim I As Word
Dim Refresh As Byte
Dim B As Byte
Dim D As Word
Dim S As Word
Dim E As Word
Dim Data_a As Byte
Dim Data_b As Byte

Do
   For S = 0 To 152
      E = S + 7
      For Refresh = 1 To 10
         Scan = &H01
         For I = S To E
            For B = 0 To 1
               D = B * 8
               D = D + I
               If B = 0 Then
                  Data_a = Lookup(d , Text00)
                  Porta.0 = Data_a.7 : Porta.1 = Data_a.6 : Porta.2 = Data_a.5 : Porta.3 = Data_a.4 : Porta.4 = Data_a.3 : Porta.5 = Data_a.2 : Porta.6 = Data_a.1 : Porta.7 = Data_a.0
               End If
               If B = 1 Then
                  Data_b= Lookup(d , Text00)
                  PortC.0 = Data_B.7 : PortC.1 = Data_B.6 : PortC.2 = Data_B.5 : PortC.3 = Data_B.4 : PortC.4 = Data_B.3 : PortC.5 = Data_B.2 : PortC.6 = Data_B.1 : PortC.7 = Data_B.0
               End If
            Next B
            Portb = Scan
            Rotate Scan , Left , 1
            Waitms 2
            Portb = 0
         Next I
      Next Refresh
   Next S
Loop

End
                                                       'end program
Text00:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &HFE , &HFE , &H10 , &H10 , &H10 , &HFE , &HFE , &H00  'H
Data &H1C , &H3E , &H2A , &H2A , &H2A , &H3A , &H18 , &H00  'e
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H02 , &H00 , &H00  'l
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H02 , &H00 , &H00  'l
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H3E , &H1C , &H00  'o
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00