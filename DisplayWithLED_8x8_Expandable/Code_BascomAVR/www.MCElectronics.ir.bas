'*********************************************
'* This Program Writing By : Hossein Lachini *
'* The Persian LED Sign Board                *
'* For to get more details visit :           *
'*                 www.HLachini.com          *
'* Contact to me by : eLachini@Gmail.com     *
'* Mobile/SMS : +98 912 381 2060             *
'*********************************************

$regfile = "m16def.dat"
'$regfile = "m8535.dat"
$crystal = 4000000

Config Porta = Output
Config Portc = Output

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

Ddrd.5 = 0 : Portd.5 = 1
Config Portb.1 = Output : Portb.1 = 0

Do


' _    _  _    _  _    _     _   _  _      _____   _____   _   _  _  __   _  _      _____   _____   _    _
'| |  | || |  | || |  | |   | | | || |    /  _  \ /  _  \ | | | || ||  \ | || |    /  _  \ /  _  \ | \  / |
'| |/\| || |/\| || |/\| |   | |_| || |    | |_| | | | |_| | |_| || ||   \| || |    | | |_| | | | | |  \/  |
'|      ||      ||      |   |  _  || |    |  _  | | |  _  |  _  || ||      || |    | |  _  | | | | |      |
'|  /\  ||  /\  ||  /\  | _ | | | || |___ | | | | | |_| | | | | || || |\   || | _  | |_| | | |_| | | |\/| |
'|_/  \_||_/  \_||_/  \_||_||_| |_||_____||_| |_| \_____/ |_| |_||_||_| \__||_||_| \_____/ \_____/ |_|  |_|
' +---------------------------+
' | Scrolling Text00 to Left  |
' +---------------------------+


 For S = 0 To 168
  E = S + 7

 Bitwait Pind.5 , Set

  For Refresh = 1 To 10
   Scan = &H01
   For I = S To E

     Portc = Lookup(i , Text00)

     'Portb = 2 ^ B
     'Portb = 0


    Porta = Scan
    Rotate Scan , Left , 1
    Waitms 2
    Porta = 0

   Next I
  Next Refresh
  'If S = 7 Or S = 14 Or S = 21 Or S = 28 Or S = 25 Or S = 48 Then
  'Portc.0 = 0 : Waitms 1 : Portc.0 = 1
  'End If
  If S = 7 Then Portb.1 = 1
 Next S

Loop
End
                                                        'end program

Text00:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H3C , &H3E , &H06 , &H1C , &H06 , &H3E , &H3C , &H00  'w
Data &H3C , &H3E , &H06 , &H1C , &H06 , &H3E , &H3C , &H00  'w
Data &H3C , &H3E , &H06 , &H1C , &H06 , &H3E , &H3C , &H00  'w
Data &H00 , &H00 , &H00 , &H06 , &H06 , &H00 , &H00 , &H00  '.
Data &HFE , &HFE , &H70 , &H38 , &H70 , &HFE , &HFE , &H00  'M
Data &H38 , &H7C , &HC6 , &H82 , &H82 , &HC6 , &H44 , &H00  'C
Data &H82 , &HFE , &HFE , &H92 , &HBA , &H82 , &HC6 , &H00  'E
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H02 , &H00 , &H00  'l
Data &H1C , &H3E , &H2A , &H2A , &H2A , &H3A , &H18 , &H00  'e
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H36 , &H14 , &H00  'c
Data &H20 , &H20 , &HFC , &HFE , &H22 , &H26 , &H04 , &H00  't
Data &H22 , &H3E , &H1E , &H32 , &H20 , &H30 , &H10 , &H00  'r
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H3E , &H1C , &H00  'o
Data &H20 , &H3E , &H1E , &H20 , &H20 , &H3E , &H1E , &H00  'n
Data &H00 , &H00 , &H22 , &HBE , &HBE , &H02 , &H00 , &H00  'i
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H36 , &H14 , &H00  'c
Data &H12 , &H3A , &H2A , &H2A , &H2A , &H2E , &H24 , &H00  's
Data &H00 , &H00 , &H00 , &H06 , &H06 , &H00 , &H00 , &H00  '.
Data &H00 , &H00 , &H22 , &HBE , &HBE , &H02 , &H00 , &H00  'i
Data &H22 , &H3E , &H1E , &H32 , &H20 , &H30 , &H10 , &H00  'r
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00