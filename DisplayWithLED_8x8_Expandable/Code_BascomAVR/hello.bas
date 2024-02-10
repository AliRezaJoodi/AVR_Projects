'*********************************************
'* This Program Writing By : Hossein Lachini *
'* The Persian LED Sign Board                *
'* For to get more details visit :           *
'*                 www.HLachini.com          *
'* Contact to me by : eLachini@Gmail.com     *
'* Mobile/SMS : +98 912 381 2060             *
'*********************************************

$regfile = "m16def.dat"
$crystal = 2000000

Config Porta = Output


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


Ddrc.7 = 0 : Portc.7 = 1
Config Portc.0 = Output : Portc.7 = 0


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

 For S = 0 To 48
  E = S + 7

 Bitwait Pinc.7 , Set

  For Refresh = 1 To 5
   Scan = &H01
   For I = S To E

     Portd = Lookup(i , Text00)

     Portb = 2 ^ B
     Portb = 0


    Porta = Scan
    Rotate Scan , Left , 1
    Waitms 2
    Porta = 0

   Next I
  Next Refresh
  'If S = 7 Or S = 14 Or S = 21 Or S = 28 Or S = 25 Or S = 48 Then
  'Portc.0 = 0 : Waitms 1 : Portc.0 = 1
  'End If
  If S = 7 Then Portc.0 = 1
 Next S

Loop
End                                                         'end program

Text00:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &HFE , &HFE , &H10 , &H10 , &H10 , &HFE , &HFE , &H00  'H
Data &H1C , &H3E , &H2A , &H2A , &H2A , &H3A , &H18 , &H00  'e
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H02 , &H00 , &H00  'l
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H02 , &H00 , &H00  'l
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H3E , &H1C , &H00  'o
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00