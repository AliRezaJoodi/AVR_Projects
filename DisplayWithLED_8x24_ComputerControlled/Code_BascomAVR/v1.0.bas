'*********************************************
'* This Program Writing By : Hossein Lachini *
'* The Persian LED Sign Board                *
'* For to get more details visit :           *
'*                 www.HLachini.com          *
'* Contact to me by : eLachini@Gmail.com     *
'* Mobile/SMS : +98 912 381 2060             *
'*********************************************

$regfile = "m8def.dat"
$crystal = 1000000

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
Dim Segment As Byte                                         'ezafe shod

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

 For S = 0 To 136
  E = S + 7
  For Refresh = 1 To 5
   Scan = &H01
   For I = S To E

    For B = 0 To 3

     D = B * 8
     D = D + I
     Portd = Lookup(d , Text00)

     Segment = 2 ^ B
     Portb.0 = Segment.0 : Portb.1 = Segment.1 : Portb.2 = Segment.2  : Portb.3 = Segment.3
     Reset Portb.0 : Reset Portb.1 : Reset Portb.2 : Reset Portb.3

    Next B

     Portb.4 = Scan.7 : Portb.5 = Scan.6 : Portc.0 = Scan.5 : Portc.1 = Scan.4 : Portc.2 = Scan.3 : Portc.3 = Scan.2 : Portc.4 = Scan.1 : Portc.5 = Scan.0
    Rotate Scan , Left , 1
    Waitms 2
    Reset Portb.4 : Reset Portb.5 : Reset Portc.0 : Reset Portc.1 : Reset Portc.2 : Reset Portc.3 : Reset Portc.4 : Reset Portc.5

   Next I
  Next Refresh
 Next S

' _    _  _    _  _    _     _   _  _      _____   _____   _   _  _  __   _  _      _____   _____   _    _
'| |  | || |  | || |  | |   | | | || |    /  _  \ /  _  \ | | | || ||  \ | || |    /  _  \ /  _  \ | \  / |
'| |/\| || |/\| || |/\| |   | |_| || |    | |_| | | | |_| | |_| || ||   \| || |    | | |_| | | | | |  \/  |
'|      ||      ||      |   |  _  || |    |  _  | | |  _  |  _  || ||      || |    | |  _  | | | | |      |
'|  /\  ||  /\  ||  /\  | _ | | | || |___ | | | | | |_| | | | | || || |\   || | _  | |_| | | |_| | | |\/| |
'|_/  \_||_/  \_||_/  \_||_||_| |_||_____||_| |_| \_____/ |_| |_||_||_| \__||_||_| \_____/ \_____/ |_|  |_|
' +---------------------------+
' | Scrolling Text01 to Left  |
' +---------------------------+

 For S = 0 To 128
  E = S + 7
  For Refresh = 1 To 5
   Scan = &H01
   For I = S To E

    For B = 0 To 3

     D = B * 8
     D = D + I
     Portd = Lookup(d , Text01)

     Segment = 2 ^ B
     Portb.0 = Segment.0 : Portb.1 = Segment.1 : Portb.2 = Segment.2  : Portb.3 = Segment.3
     Reset Portb.0 : Reset Portb.1 : Reset Portb.2 : Reset Portb.3

    Next B

     Portb.4 = Scan.7 : Portb.5 = Scan.6 : Portc.0 = Scan.5 : Portc.1 = Scan.4 : Portc.2 = Scan.3 : Portc.3 = Scan.2 : Portc.4 = Scan.1 : Portc.5 = Scan.0
    Rotate Scan , Left , 1
    Waitms 2
    Reset Portb.4 : Reset Portb.5 : Reset Portc.0 : Reset Portc.1 : Reset Portc.2 : Reset Portc.3 : Reset Portc.4 : Reset Portc.5

   Next I
  Next Refresh
 Next S

' _    _  _    _  _    _     _   _  _      _____   _____   _   _  _  __   _  _      _____   _____   _    _
'| |  | || |  | || |  | |   | | | || |    /  _  \ /  _  \ | | | || ||  \ | || |    /  _  \ /  _  \ | \  / |
'| |/\| || |/\| || |/\| |   | |_| || |    | |_| | | | |_| | |_| || ||   \| || |    | | |_| | | | | |  \/  |
'|      ||      ||      |   |  _  || |    |  _  | | |  _  |  _  || ||      || |    | |  _  | | | | |      |
'|  /\  ||  /\  ||  /\  | _ | | | || |___ | | | | | |_| | | | | || || |\   || | _  | |_| | | |_| | | |\/| |
'|_/  \_||_/  \_||_/  \_||_||_| |_||_____||_| |_| \_____/ |_| |_||_||_| \__||_||_| \_____/ \_____/ |_|  |_|
' +---------------------------+
' | Scrolling Text02 to Right |
' +---------------------------+

 For S = 0 To 128
  M = 128 - S
  E = M + 7
  For Refresh = 1 To 5
   Scan = &H01
   For I = M To E

    For B = 0 To 3

     D = B * 8
     D = D + I
     Portd = Lookup(d , Text02)

     Segment = 2 ^ B
     Portb.0 = Segment.0 : Portb.1 = Segment.1 : Portb.2 = Segment.2  : Portb.3 = Segment.3
     Reset Portb.0 : Reset Portb.1 : Reset Portb.2 : Reset Portb.3

    Next B

     Portb.4 = Scan.7 : Portb.5 = Scan.6 : Portc.0 = Scan.5 : Portc.1 = Scan.4 : Portc.2 = Scan.3 : Portc.3 = Scan.2 : Portc.4 = Scan.1 : Portc.5 = Scan.0
    Rotate Scan , Left , 1
    Waitms 2
    Reset Portb.4 : Reset Portb.5 : Reset Portc.0 : Reset Portc.1 : Reset Portc.2 : Reset Portc.3 : Reset Portc.4 : Reset Portc.5

   Next I
  Next Refresh
 Next S

' _    _  _    _  _    _     _   _  _      _____   _____   _   _  _  __   _  _      _____   _____   _    _
'| |  | || |  | || |  | |   | | | || |    /  _  \ /  _  \ | | | || ||  \ | || |    /  _  \ /  _  \ | \  / |
'| |/\| || |/\| || |/\| |   | |_| || |    | |_| | | | |_| | |_| || ||   \| || |    | | |_| | | | | |  \/  |
'|      ||      ||      |   |  _  || |    |  _  | | |  _  |  _  || ||      || |    | |  _  | | | | |      |
'|  /\  ||  /\  ||  /\  | _ | | | || |___ | | | | | |_| | | | | || || |\   || | _  | |_| | | |_| | | |\/| |
'|_/  \_||_/  \_||_/  \_||_||_| |_||_____||_| |_| \_____/ |_| |_||_||_| \__||_||_| \_____/ \_____/ |_|  |_|
' +---------------------------+
' | Scrolling Text03 to Right |
' +---------------------------+

 For S = 0 To 136
  M = 136 - S
  E = M + 7
  For Refresh = 1 To 5
   Scan = &H01
   For I = M To E

    For B = 0 To 3

     D = B * 8
     D = D + I
     Portd = Lookup(d , Text03)

     Segment = 2 ^ B
     Portb.0 = Segment.0 : Portb.1 = Segment.1 : Portb.2 = Segment.2  : Portb.3 = Segment.3
     Reset Portb.0 : Reset Portb.1 : Reset Portb.2 : Reset Portb.3

    Next B

     Portb.4 = Scan.7 : Portb.5 = Scan.6 : Portc.0 = Scan.5 : Portc.1 = Scan.4 : Portc.2 = Scan.3 : Portc.3 = Scan.2 : Portc.4 = Scan.1 : Portc.5 = Scan.0
    Rotate Scan , Left , 1
    Waitms 2
    Reset Portb.4 : Reset Portb.5 : Reset Portc.0 : Reset Portc.1 : Reset Portc.2 : Reset Portc.3 : Reset Portc.4 : Reset Portc.5

   Next I
  Next Refresh
 Next S

Loop
End                                                         'end program

Text00:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H3E , &H7E , &HD0 , &H90 , &HD0 , &H7E , &H3E , &H00  'A
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H02 , &H00 , &H00  'l
Data &H00 , &H00 , &H22 , &HBE , &HBE , &H02 , &H00 , &H00  'i
Data &H22 , &H3E , &H1E , &H32 , &H20 , &H30 , &H10 , &H00  'r
Data &H1C , &H3E , &H2A , &H2A , &H2A , &H3A , &H18 , &H00  'e
Data &H00 , &H32 , &H26 , &H2E , &H3A , &H32 , &H26 , &H00  'z
Data &H04 , &H2E , &H2A , &H2A , &H3C , &H1E , &H02 , &H00  'a
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00  '
Data &H0C , &H0E , &H02 , &H82 , &HFE , &HFC , &H80 , &H00  'J
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H3E , &H1C , &H00  'o
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H3E , &H1C , &H00  'o
Data &H1C , &H3E , &H22 , &HA2 , &HFC , &HFE , &H02 , &H00  'd
Data &H00 , &H00 , &H22 , &HBE , &HBE , &H02 , &H00 , &H00  'i
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Text01:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00  '
Data &H38 , &H7C , &HC6 , &H92 , &HC6 , &H7C , &H38 , &H00  '0
Data &H60 , &HF2 , &H92 , &H92 , &H96 , &HFC , &H78 , &H00  '9
Data &H00 , &H02 , &H42 , &HFE , &HFE , &H02 , &H02 , &H00  '1
Data &H00 , &H02 , &H42 , &HFE , &HFE , &H02 , &H02 , &H00  '1
Data &H42 , &HC6 , &H8E , &H9A , &H92 , &HF6 , &H66 , &H00  '2
Data &H42 , &HC6 , &H8E , &H9A , &H92 , &HF6 , &H66 , &H00  '2
Data &H38 , &H7C , &HC6 , &H92 , &HC6 , &H7C , &H38 , &H00  '0
Data &H18 , &H38 , &H68 , &HCA , &HFE , &HFE , &H0A , &H00  '4
Data &H44 , &HC6 , &H92 , &H92 , &H92 , &HFE , &H6C , &H00  '3
Data &H00 , &H02 , &H42 , &HFE , &HFE , &H02 , &H02 , &H00  '1
Data &H18 , &H38 , &H68 , &HCA , &HFE , &HFE , &H0A , &H00  '4
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Text02:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H06 , &H01 , &H01 , &H01 , &H11 , &H29 , &H26 , &H00  'Farsi character
Data &H00 , &H00 , &H00 , &H08 , &H48 , &H48 , &H28 , &H10  'Farsi character
Data &H00 , &H00 , &H00 , &H01 , &H01 , &H39 , &H2A , &H1C  'Farsi character
Data &H08 , &H08 , &H08 , &H28 , &H4A , &H48 , &H28 , &H10  'Farsi character
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00  'Farsi character
Data &H00 , &H00 , &H00 , &HF0 , &H08 , &H08 , &H08 , &H08  'Farsi character
Data &H08 , &H08 , &H08 , &H10 , &H08 , &H18 , &HA8 , &H10  'Farsi character
Data &H00 , &H00 , &H00 , &H01 , &H01 , &H02 , &H24 , &H18  'Farsi character
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00  'Farsi character
Data &H06 , &H01 , &H01 , &H01 , &H0D , &H0B , &H08 , &H08  'Farsi character
Data &H08 , &H08 , &H08 , &H08 , &H08 , &H08 , &H08 , &HF0  'Farsi character
Data &H08 , &H08 , &H38 , &H48 , &H48 , &H28 , &H00 , &H00  'Farsi character
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Text03:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H3F , &H44 , &H44 , &H44 , &H3F , &H00 , &H00 , &H00  'A
Data &H00 , &H41 , &H7F , &H01 , &H00 , &H00 , &H00 , &H00  'l
Data &H00 , &H11 , &H5F , &H01 , &H00 , &H00 , &H00 , &H00  'i
Data &H1F , &H08 , &H10 , &H10 , &H08 , &H00 , &H00 , &H00  'r
Data &H0E , &H15 , &H15 , &H15 , &H0C , &H00 , &H00 , &H00  'e
Data &H11 , &H13 , &H15 , &H19 , &H11 , &H00 , &H00 , &H00  'z
Data &H02 , &H15 , &H15 , &H15 , &H0F , &H00 , &H00 , &H00  'a
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00  '
Data &H02 , &H01 , &H41 , &H7E , &H40 , &H00 , &H00 , &H00  'J
Data &H0E , &H11 , &H11 , &H11 , &H0E , &H00 , &H00 , &H00  'o
Data &H0E , &H11 , &H11 , &H11 , &H0E , &H00 , &H00 , &H00  'o
Data &H0E , &H11 , &H11 , &H09 , &H7F , &H00 , &H00 , &H00  'd
Data &H00 , &H11 , &H5F , &H01 , &H00 , &H00 , &H00 , &H00  'i
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00