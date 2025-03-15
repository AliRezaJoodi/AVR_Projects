'*********************************************
'* This Program Writing By : Hossein Lachini *
'* The Persian LED Sign Board                *
'* For to get more details visit :           *
'*                 www.HLachini.com          *
'* Contact to me by : eLachini@Gmail.com     *
'* Mobile/SMS : +98 912 381 2060             *
'*********************************************

$regfile = "m16def.dat"
$crystal = 1000000

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


' _    _  _    _  _    _     _   _  _      _____   _____   _   _  _  __   _  _      _____   _____   _    _
'| |  | || |  | || |  | |   | | | || |    /  _  \ /  _  \ | | | || ||  \ | || |    /  _  \ /  _  \ | \  / |
'| |/\| || |/\| || |/\| |   | |_| || |    | |_| | | | |_| | |_| || ||   \| || |    | | |_| | | | | |  \/  |
'|      ||      ||      |   |  _  || |    |  _  | | |  _  |  _  || ||      || |    | |  _  | | | | |      |
'|  /\  ||  /\  ||  /\  | _ | | | || |___ | | | | | |_| | | | | || || |\   || | _  | |_| | | |_| | | |\/| |
'|_/  \_||_/  \_||_/  \_||_||_| |_||_____||_| |_| \_____/ |_| |_||_||_| \__||_||_| \_____/ \_____/ |_|  |_|
' +---------------------------+
' | Scrolling Text00 to Left  |
' +---------------------------+

 For S = 0 To 104
  E = S + 7
  For Refresh = 1 To 9
   Scan = &H01
   For I = S To E

    For B = 0 To 2

     D = B * 8
     D = D + I
     Portd = Lookup(d , Text00)

     Portb = 2 ^ B
     If B = 0 Then Portc = Lookup(d , Text00)
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
End                                                         'end program

Text00:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H3C , &H3E , &H06 , &H1C , &H06 , &H3E , &H3C , &H00  'w
Data &H3C , &H3E , &H06 , &H1C , &H06 , &H3E , &H3C , &H00  'w
Data &H3C , &H3E , &H06 , &H1C , &H06 , &H3E , &H3C , &H00  'w
Data &H00 , &H00 , &H00 , &H06 , &H06 , &H00 , &H00 , &H00  '.
Data &HFE , &HFE , &H70 , &H38 , &H70 , &HFE , &HFE , &H00  'M
Data &H44 , &HC6 , &H92 , &H92 , &H92 , &HFE , &H6C , &H00  '3
Data &H42 , &HC6 , &H8E , &H9A , &H92 , &HF6 , &H66 , &H00  '2
Data &H00 , &H00 , &H00 , &H06 , &H06 , &H00 , &H00 , &H00  '.
Data &H00 , &H00 , &H22 , &HBE , &HBE , &H02 , &H00 , &H00  'i
Data &H22 , &H3E , &H1E , &H32 , &H20 , &H30 , &H10 , &H00  'r
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00