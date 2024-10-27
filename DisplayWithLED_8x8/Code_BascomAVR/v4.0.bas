'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
'$crystal = 8000000
$crystal = 11059200

'$PROG &HFF,&HE1,&H99,&H00' generated. Take care that the chip supports all fuse bytes.

Config Portd.7 = Output : Portd.7 = 0 : Data_0 Alias Portd.7
Config Portc.0 = Output : Portc.0 = 0 : Data_1 Alias Portc.0
Config Portc.1 = Output : Portc.1 = 0 : Data_2 Alias Portc.1
Config Portc.2 = Output : Portc.2 = 0 : Data_3 Alias Portc.2
Config Portc.3 = Output : Portc.3 = 0 : Data_4 Alias Portc.3
Config Portc.4 = Output : Portc.4 = 0 : Data_5 Alias Portc.4
Config Portc.5 = Output : Portc.5 = 0 : Data_6 Alias Portc.5
Config Portc.6 = Output : Portc.6 = 0 : Data_7 Alias Portc.6

Config Porta.0 = Output : Porta.0 = 0 : Column_a Alias Porta.0
Config Porta.1 = Output : Porta.1 = 0 : Column_b Alias Porta.1
Config Porta.2 = Output : Porta.2 = 0 : Column_c Alias Porta.2
Config Porta.3 = Output : Porta.3 = 0 : Column_d Alias Porta.3
Config Porta.4 = Output : Porta.4 = 0 : Column_e Alias Porta.4
Config Porta.7 = Output : Porta.7 = 0 : Column_f Alias Porta.7
Config Porta.6 = Output : Porta.6 = 0 : Column_g Alias Porta.6
Config Porta.5 = Output : Porta.5 = 0 : Column_h Alias Porta.5

'Waitms 10
Config Portb.1 = Output : Portb.1 = 0 : Matrix_1 Alias Portb.1
Config Portb.2 = Output : Portb.2 = 0 : Matrix_2 Alias Portb.2
Config Portb.3 = Output : Portb.3 = 0 : Matrix_3 Alias Portb.3

'Enable Interrupts
'$baud = 9600
'Config Com1 = Dummy , Synchrone = 0 , Parity = None , Stopbits = 1 , Databits = 8 , Clockpol = 0
'Enable Urxc
'On Urxc Lable
'Print "Running ..." : Waitms 10


'Config Watchdog = 16
'Stop Watchdog

'Waitms 500
Ddrd.2 = 0 : Portd.2 = 1
Config Int0 = Falling
On Int0 Get_pc_kepad
Enable Int0
Enable Interrupts


Const Column = 8
'Const Row = 8
'Const Spead = 3

Dim Scan As Word
Dim I As Word
Dim Refresh As Byte
Dim Spead As Byte : Spead = 1
Dim T As Word
Dim B As Word
Dim D As Word
'Dim U As Word
Dim S As Word
'Dim M As Word
Dim E As Word
'Dim A As Word
Dim Segment As Byte

Dim Dd As Byte

Dim Text As String * 97
Dim Tx As String * 1
Dim Dat(800) As Byte
'Dim Dat(1700) As Byte
Dim L As Byte
Dim Z As Word
Dim Character As String * 1

Dim Key As Byte
Dim Status As Bit : Status = 0

Main:

'Spead = 5 : Text = "HELLO" : Gosub Save_eeprom

Gosub Load_eeprom
Gosub Erase_data
Gosub Decode_data
Gosub Erase_varible

Do
 For S = 0 To Z
  E = S + 7
  For Refresh = 1 To Spead
   Scan = &H01
   For I = S To E
    'For B = 0 To 0
     D = B * 8
     D = D + I
     Dd = Dat(d)
     Data_7 = Dd.0 : Data_6 = Dd.1 : Data_5 = Dd.2 : Data_4 = Dd.3 : Data_3 = Dd.4 : Data_2 = Dd.5 : Data_1 = Dd.6 : Data_0 = Dd.7
     'Segment = 2 ^ B
     'Matrix_1 = Segment.0 : Matrix_2 = Segment.1 : Matrix_3 = Segment.2
     'Reset Matrix_1 : Reset Matrix_2 : Reset Matrix_3
    'Next B
     Column_h = Scan.7 : Column_g = Scan.6 : Column_f = Scan.5 : Column_e = Scan.4 : Column_d = Scan.3 : Column_c = Scan.2 : Column_b = Scan.1 : Column_a = Scan.0
    Rotate Scan , Left , 1
    Waitms 1
    Reset Column_h : Reset Column_g : Reset Column_f : Reset Column_e : Reset Column_d : Reset Column_c : Reset Column_b : Reset Column_a
   Next I
  Next Refresh
 Next S
Loop
End

'******************************
Decode_data:
   D = Column
   L = Len(text)
   Z = Column \ 8 : Z = Z + L : Z = Z * 8
   For I = 1 To L
   Tx = Mid(text , I , 1)
   B = Asc(tx)
   B = B -30 : B = B * 8
   T = B + 7
   For Scan = B To T
      Dat(d) = Lookup(scan , Text01) : Incr D
   Next Scan
   Next I
Return

'******************************
Erase_varible:
   D = 0 : L = 0 : I = 0 : B = 0 : T = 0 : Scan = 0
Return

'******************************
Erase_data:
   For I = 1 To 255
      Dat(i) = 0
   Next I
      I = 0
Return

'(Lable:
   Input , Text
   Input "Spead= " , Spead
   Input "Text= " , Text
 'Input Text , Spead
 Gosub Save_eeprom
 Start Watchdog
Return
')

'******************************
Save_eeprom:
   Writeeeprom Spead , &H00 : Waitms 10
   Writeeeprom Text , &H05 : Waitms 10
Return

'******************************
Load_eeprom:
   Readeeprom Spead , &H00 ': Waitms 10
   Readeeprom Text , &H05 ': Waitms 10
   'Spead = 8
   'Text = "y"
Return

'******************************
Get_pc_kepad:
Gosub Led_1
Config Keyboard = Pind.2 , Data = Pind.3 , Keydata = Keydata
Do
   Key = Getatkbd()
   If Key <> 0 Then
   If Key = 25 Then
      Toggle Status
      If Status = 1 Then
            Set Data_1                                      ':Text = ""
         Else
            Reset Data_1
      End If
   End If
   Select Case Key:
      Case 18:
         Text = ""
      Case 13:
         Gosub Led_2 : Waitms 100
         Do
         Key = Getatkbd()
         If Key <> 0 Then
            Character = Chr(key)
            Spead = Val(character)
            Waitms 300
            Exit Do
         End If
         Loop
         Gosub Save_eeprom
         Start Watchdog
      Case 8:

      Case 32 To 126:
         If Status = 1 And Key > 96 Then Key = Key - 32
         Text = Text + Chr(key)
      End Select
      End If
Loop
Return

'******************************
Led_1:
   Reset Column_h : Reset Column_g : Reset Column_f : Reset Column_e : Reset Column_d : Reset Column_c : Reset Column_b : Set Column_a
   Set Data_0 : Reset Data_1 : Reset Data_2 : Reset Data_3 : Reset Data_4 : Reset Data_5 : Reset Data_6 : Reset Data_7
Return

'******************************
Led_2:
   Reset Column_h : Reset Column_g : Reset Column_f : Reset Column_e : Reset Column_d : Reset Column_c : Reset Column_b : Set Column_a
   Reset Data_0 : Reset Data_1 : Reset Data_2 : Reset Data_3 : Reset Data_4 : Reset Data_5 : Reset Data_6 : Set Data_7
Return

'******************************
Text01:
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
Data &H00 , &H00 , &H60 , &HFA , &HFA , &H60 , &H00 , &H00  '!
Data &H00 , &HC0 , &HE0 , &H00 , &H00 , &HE0 , &HC0 , &H00 '"
Data &H28 , &HFE , &HFE , &H28 , &HFE , &HFE , &H28 , &H00  '#
Data &H00 , &H24 , &H74 , &HD6 , &HD6 , &H5C , &H48 , &H00  '$
Data &H62 , &H66 , &H0C , &H18 , &H30 , &H66 , &H46 , &H00  '%
Data &H0C , &H5E , &HF2 , &HBA , &HEC , &H5E , &H12 , &H00  '&
Data &H00 , &H00 , &H20 , &HE0 , &HC0 , &H00 , &H00 , &H00  ''
Data &H00 , &H00 , &H38 , &H7C , &HC6 , &H82 , &H00 , &H00  '
Data &H00 , &H00 , &H82 , &HC6 , &H7C , &H38 , &H00 , &H00  ')
Data &H10 , &H54 , &H7C , &H38 , &H38 , &H7C , &H54 , &H10  '*
Data &H00 , &H10 , &H10 , &H7C , &H7C , &H10 , &H10 , &H00  '+
Data &H00 , &H00 , &H01 , &H07 , &H06 , &H00 , &H00 , &H00  ',
Data &H00 , &H10 , &H10 , &H10 , &H10 , &H10 , &H10 , &H00  '-
Data &H00 , &H00 , &H00 , &H06 , &H06 , &H00 , &H00 , &H00  '.
Data &H06 , &H0C , &H18 , &H30 , &H60 , &HC0 , &H80 , &H00  '/
Data &H38 , &H7C , &HC6 , &H92 , &HC6 , &H7C , &H38 , &H00  '0
Data &H00 , &H02 , &H42 , &HFE , &HFE , &H02 , &H02 , &H00  '1
Data &H42 , &HC6 , &H8E , &H9A , &H92 , &HF6 , &H66 , &H00  '2
Data &H44 , &HC6 , &H92 , &H92 , &H92 , &HFE , &H6C , &H00  '3
Data &H18 , &H38 , &H68 , &HCA , &HFE , &HFE , &H0A , &H00  '4
Data &HF4 , &HF6 , &H92 , &H92 , &H92 , &H9E , &H8C , &H00  '5
Data &H3C , &H7E , &HD2 , &H92 , &H92 , &H1E , &H0C , &H00  '6
Data &HC0 , &HC0 , &H8E , &H9E , &HB0 , &HE0 , &HC0 , &H00  '7
Data &H6C , &HFE , &H92 , &H92 , &H92 , &HFE , &H6C , &H00  '8
Data &H60 , &HF2 , &H92 , &H92 , &H96 , &HFC , &H78 , &H00  '9
Data &H00 , &H00 , &H00 , &H66 , &H66 , &H00 , &H00 , &H00  ':
Data &H00 , &H00 , &H01 , &H67 , &H66 , &H00 , &H00 , &H00  ';
Data &H00 , &H00 , &H10 , &H38 , &H6C , &HC6 , &H82 , &H00  '<
Data &H00 , &H24 , &H24 , &H24 , &H24 , &H24 , &H24 , &H00  '=
Data &H00 , &H82 , &HC6 , &H6C , &H38 , &H10 , &H00 , &H00  '>
Data &H40 , &HC0 , &H80 , &H9A , &HBA , &HE0 , &H40 , &H00  '?
Data &H7C , &HFE , &H82 , &HBA , &HBA , &HF8 , &H78 , &H00  '@
Data &H3E , &H7E , &HD0 , &H90 , &HD0 , &H7E , &H3E , &H00  'A
Data &H82 , &HFE , &HFE , &H92 , &H92 , &HFE , &H6C , &H00  'B
Data &H38 , &H7C , &HC6 , &H82 , &H82 , &HC6 , &H44 , &H00  'C
Data &H82 , &HFE , &HFE , &H82 , &HC6 , &H7C , &H38 , &H00  'D
Data &H82 , &HFE , &HFE , &H92 , &HBA , &H82 , &HC6 , &H00  'E
Data &H82 , &HFE , &HFE , &H92 , &HB8 , &H80 , &HC0 , &H00  'F
Data &H38 , &H7C , &HC6 , &H82 , &H8A , &HCC , &H4E , &H00  'G
Data &HFE , &HFE , &H10 , &H10 , &H10 , &HFE , &HFE , &H00  'H
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H82 , &H00 , &H00  'I
Data &H0C , &H0E , &H02 , &H82 , &HFE , &HFC , &H80 , &H00  'J
Data &H82 , &HFE , &HFE , &H10 , &H38 , &HEE , &HC6 , &H00  'K
Data &H82 , &HFE , &HFE , &H82 , &H02 , &H06 , &H0E , &H00  'L
Data &HFE , &HFE , &H70 , &H38 , &H70 , &HFE , &HFE , &H00  'M
Data &HFE , &HFE , &H60 , &H30 , &H18 , &HFE , &HFE , &H00  'N
Data &H7C , &HFE , &H82 , &H82 , &H82 , &HFE , &H7C , &H00  'O
Data &H82 , &HFE , &HFE , &H92 , &H90 , &HF0 , &H60 , &H00  'P
Data &H7C , &HFE , &H82 , &H82 , &H87 , &HFF , &H7D , &H00  'Q
Data &H82 , &HFE , &HFE , &H90 , &H98 , &HFE , &H66 , &H00  'R
Data &H00 , &H44 , &HE6 , &HB2 , &H9A , &HCE , &H44 , &H00  'S
Data &H00 , &HE0 , &HC2 , &HFE , &HFE , &HC2 , &HE0 , &H00  'T
Data &HFC , &HFE , &H02 , &H02 , &H02 , &HFE , &HFC , &H00  'U
Data &HF8 , &HFC , &H06 , &H02 , &H06 , &HFC , &HF8 , &H00  'V
Data &HFC , &HFE , &H06 , &H1C , &H06 , &HFE , &HFC , &H00  'W
Data &HC6 , &HEE , &H38 , &H10 , &H38 , &HEE , &HC6 , &H00  'X
Data &H00 , &HE0 , &HF2 , &H1E , &H1E , &HF2 , &HE0 , &H00  'Y
Data &HE2 , &HC6 , &H8E , &H9A , &HB2 , &HE6 , &HCE , &H00  'Z
Data &H00 , &H00 , &HFE , &HFE , &H82 , &H82 , &H00 , &H00  '[
Data &H80 , &HC0 , &H60 , &H30 , &H18 , &H0C , &H06 , &H00  '\
Data &H00 , &H00 , &H82 , &H82 , &HFE , &HFE , &H00 , &H00  ']
Data &H10 , &H30 , &H60 , &HC0 , &H60 , &H30 , &H10 , &H00  '^
Data &H01 , &H01 , &H01 , &H01 , &H01 , &H01 , &H01 , &H01  '_
Data &H00 , &H00 , &H20 , &HE0 , &HC0 , &H00 , &H00 , &H00  ''
Data &H04 , &H2E , &H2A , &H2A , &H3C , &H1E , &H02 , &H00  'a
Data &H82 , &HFE , &HFC , &H22 , &H22 , &H3E , &H1C , &H00  'b
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H36 , &H14 , &H00  'c
Data &H1C , &H3E , &H22 , &HA2 , &HFC , &HFE , &H02 , &H00  'd
Data &H1C , &H3E , &H2A , &H2A , &H2A , &H3A , &H18 , &H00  'e
Data &H12 , &H7E , &HFE , &H92 , &H90 , &HC0 , &H40 , &H00  'f
Data &H19 , &H3D , &H25 , &H25 , &H1F , &H3E , &H20 , &H00  'g
Data &H82 , &HFE , &HFE , &H10 , &H20 , &H3E , &H1E , &H00  'h
Data &H00 , &H00 , &H22 , &HBE , &HBE , &H02 , &H00 , &H00  'i
Data &H00 , &H06 , &H07 , &H01 , &H01 , &HBF , &HBE , &H00  'j
Data &H82 , &HFE , &HFE , &H08 , &H1C , &H36 , &H22 , &H00  'k
Data &H00 , &H00 , &H82 , &HFE , &HFE , &H02 , &H00 , &H00  'l
Data &H3E , &H3E , &H30 , &H1E , &H30 , &H3E , &H1E , &H00  'm
Data &H20 , &H3E , &H1E , &H20 , &H20 , &H3E , &H1E , &H00  'n
Data &H1C , &H3E , &H22 , &H22 , &H22 , &H3E , &H1C , &H00  'o
Data &H21 , &H3F , &H1F , &H25 , &H24 , &H3C , &H18 , &H00  'p
Data &H18 , &H3C , &H24 , &H25 , &H1F , &H3F , &H21 , &H00  'q
Data &H22 , &H3E , &H1E , &H32 , &H20 , &H30 , &H10 , &H00  'r
Data &H12 , &H3A , &H2A , &H2A , &H2A , &H2E , &H24 , &H00  's
Data &H20 , &H20 , &HFC , &HFE , &H22 , &H26 , &H04 , &H00  't
Data &H3C , &H3E , &H02 , &H02 , &H3C , &H3E , &H02 , &H00  'u
Data &H38 , &H3C , &H06 , &H02 , &H06 , &H3C , &H38 , &H00  'v
Data &H3C , &H3E , &H06 , &H1C , &H06 , &H3E , &H3C , &H00  'w
Data &H22 , &H36 , &H1C , &H08 , &H1C , &H36 , &H22 , &H00  'x
Data &H39 , &H3D , &H05 , &H05 , &H05 , &H3F , &H3E , &H00  'y
Data &H00 , &H32 , &H26 , &H2E , &H3A , &H32 , &H26 , &H00  'z
Data &H00 , &H10 , &H10 , &H7C , &HEE , &H82 , &H82 , &H00  '{
Data &H00 , &H00 , &H00 , &HFE , &HFE , &H00 , &H00 , &H00  '|
Data &H00 , &H82 , &H82 , &HEE , &H7C , &H10 , &H10 , &H00  '}
Data &H40 , &HC0 , &H80 , &HC0 , &H40 , &HC0 , &H80 , &H00  '~
'Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
'Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00
'Data &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00 , &H00

'**********************************************
Keydata:
'normal keys lower case
Data 000 , 009 , 000 , 005 , 003 , 001 , 002 , 012 , 000 , 010
Data 008 , 006 , 004 , 035 , 094 , 000 , 000 , 022 , 000 , 000
Data 020 , 113 , 049 , 000 , 000 , 000 , 122 , 115 , 097 , 119
Data 050 , 019 , 000 , 099 , 120 , 100 , 101 , 052 , 051 , 000
Data 000 , 032 , 118 , 102 , 116 , 114 , 053 , 000 , 000 , 110
Data 098 , 104 , 103 , 121 , 054 , 007 , 008 , 044 , 109 , 106
Data 117 , 055 , 056 , 000 , 000 , 044 , 107 , 105 , 111 , 048
Data 057 , 000 , 000 , 046 , 047 , 108 , 059 , 112 , 045 , 000
Data 000 , 000 , 039 , 000 , 091 , 061 , 000 , 000 , 025 , 000
Data 013 , 093 , 000 , 092 , 000 , 000 , 000 , 060 , 000 , 000
Data 000 , 000 , 016 , 000 , 000 , 049 , 000 , 052 , 055 , 000
Data 000 , 000 , 048 , 018 , 050 , 053 , 054 , 056 , 034 , 029
Data 011 , 043 , 051 , 045 , 042 , 057 , 028 , 000

'shifted keys UPPER case
Data 000 , 000
Data 000 , 007 , 000 , 000 , 000 , 000 , 000 , 000 , 000 , 000
Data 000 , 000 , 126 , 000 , 000 , 000 , 000 , 000 , 000 , 081
Data 033 , 000 , 000 , 000 , 090 , 083 , 065 , 087 , 064 , 000
Data 000 , 067 , 088 , 068 , 069 , 036 , 035 , 000 , 000 , 032
Data 086 , 070 , 084 , 082 , 037 , 000 , 000 , 078 , 066 , 072
Data 071 , 089 , 094 , 000 , 000 , 076 , 077 , 074 , 085 , 038
Data 042 , 000 , 000 , 060 , 075 , 073 , 079 , 041 , 040 , 000
Data 000 , 062 , 063 , 076 , 058 , 080 , 095 , 000 , 000 , 000
Data 034 , 000 , 123 , 043 , 000 , 000 , 000 , 000 , 013 , 125
Data 000 , 124 , 000 , 000 , 000 , 062 , 000 , 000 , 000 , 008
Data 000 , 000 , 049 , 000 , 052 , 055 , 000 , 000 , 000 , 000
Data 048 , 044 , 050 , 053 , 054 , 056 , 000 , 000 , 000 , 043
Data 051 , 045 , 042 , 057 , 000 , 000



'(
'************************************************     Keydata_
Keydata_:
Data 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9
Data 10 , 11 , 12 , 13 , 14 , 15 , 16 , 17 , 18 , 19
Data 20 , 21 , 22 , 23 , 24 , 25 , 26 , 27 , 28 , 29
Data 30 , 31 , 32 , 33 , 34 , 35 , 36 , 37 , 38 , 39
Data 40 , 41 , 42 , 43 , 44 , 45 , 46 , 47 , 48 , 49
Data 50 , 51 , 52 , 53 , 54 , 55 , 56 , 57 , 58 , 59
Data 60 , 61 , 62 , 63 , 64 , 65 , 66 , 67 , 68 , 69
Data 70 , 71 , 72 , 73 , 74 , 75 , 76 , 77 , 78 , 79
Data 80 , 81 , 82 , 83 , 84 , 85 , 86 , 87 , 88 , 89
Data 90 , 91 , 92 , 93 , 94 , 95 , 96 , 97 , 98 , 99
Data 100 , 101 , 102 , 103 , 104 , 105 , 106 , 107 , 108 , 109
Data 110 , 111 , 112 , 113 , 114 , 115 , 116 , 117 , 118 , 119
Data 120 , 121 , 122 , 123 , 124 , 125 , 126 , 127 , 128 , 129
Data 130 , 131 , 132 , 133 , 134 , 135 , 136 , 137 , 138 , 139
Data 140 , 141 , 142 , 143 , 144 , 145 , 146 , 147 , 148 , 149
Data 150 , 151 , 152 , 153 , 154 , 155 , 156 , 157 , 158 , 159
Data 160 , 161 , 162 , 163 , 164 , 165 , 166 , 167 , 168 , 169
Data 170 , 171 , 172 , 173 , 174 , 175 , 176 , 177 , 178 , 179
Data 180 , 181 , 182 , 183 , 184 , 185 , 186 , 187 , 188 , 189
Data 190 , 191 , 192 , 193 , 194 , 195 , 196 , 197 , 198 , 199
Data 200 , 201 , 202 , 203 , 204 , 205 , 206 , 207 , 208 , 209
Data 210 , 211 , 212 , 213 , 214 , 215 , 216 , 217 , 218 , 219
Data 220 , 221 , 222 , 223 , 224 , 225 , 226 , 227 , 228 , 229
Data 230 , 231 , 232 , 233 , 234 , 235 , 236 , 237 , 238 , 239
Data 240 , 241 , 242 , 243 , 244 , 245 , 246 , 247 , 248 , 249
Data 250 , 251 , 252 , 253 , 254 , 255
')