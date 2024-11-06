'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
'$crystal = 11059200
$crystal = 8000000

$include "Attachment\Model1_v2.0_HardwareA.inc"
'$include "Attachment\Model2_v1.0_HardwareA.inc"

Enable Interrupts

'Config Watchdog = 16
'Stop Watchdog

'Waitms 500
Config Int0 = Falling
Enable Int0
On Int0 Get_pc_kepad
Ddrd.2 = 0 : Portd.2 = 1

Const Column = 16


Dim Scan As Word
Dim I As Word
Dim Refresh As Byte
Dim Spead As Byte : Spead = 5
Dim T As Word
Dim B As Word
Dim D As Word
Dim S As Word
Dim E As Word
'Dim Data_a As Byte
'Dim Data_b As Byte

Dim Segment As Byte                                         'ezafe shod

Dim Dd As Byte

Dim Text As String * 97                                     ': Text = "Ali Reza Joodi"
Dim Tx As String * 1
Dim Dat(800) As Byte
'Dim Dat(1700) As Byte
Dim L As Byte
Dim Z As Word
Dim Character As String * 1

Dim Key As Byte

Main:
Spead = 5 : Text = "AliRezaJoodi" : Gosub Save_eeprom
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
            For B = 0 To 1
               D = B * 8
               D = D + I
               Dd = Dat(d)
               If B = 0 Then
                  'Data_a = Lookup(d , Text00)
                  Data1_7 = Dd.0 : Data1_6 = Dd.1 : Data1_5 = Dd.2 : Data1_4 = Dd.3 : Data1_3 = Dd.4 : Data1_2 = Dd.5 : Data1_1 = Dd.6 : Data1_0 = Dd.7
               End If
               If B = 1 Then
                  'Data_b = Lookup(d , Text00)
                  Data2_7 = Dd.0 : Data2_6 = Dd.1 : Data2_5 = Dd.2 : Data2_4 = Dd.3 : Data2_3 = Dd.4 : Data2_2 = Dd.5 : Data2_1 = Dd.6 : Data2_0 = Dd.7
               End If
            Next B
            'Portb = Scan
            Column_h = Scan.7 : Column_g = Scan.6 : Column_f = Scan.5 : Column_e = Scan.4 : Column_d = Scan.3 : Column_c = Scan.2 : Column_b = Scan.1 : Column_a = Scan.0
            Rotate Scan , Left , 1
            Waitms 2
            Reset Column_h : Reset Column_g : Reset Column_f : Reset Column_e : Reset Column_d : Reset Column_c : Reset Column_b : Reset Column_a
         Next I
      Next Refresh
   Next S
Loop

End

'************************************
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

'************************************
Erase_varible:
   D = 0 : L = 0 : I = 0 : B = 0 : T = 0 : Scan = 0
Return

'************************************
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
'************************************
Save_eeprom:
   Writeeeprom Spead , &H00 : Waitms 10
   Writeeeprom Text , &H05 : Waitms 10
Return

'************************************
Load_eeprom:
   Readeeprom Spead , &H00 : Waitms 10
   Readeeprom Text , &H05 : Waitms 10
Return

'************************************
Get_pc_kepad:
Gosub Led_1
Config Keyboard = Pind.2 , Data = Pind.3 , Keydata = Keydata
Do
   Key = Getatkbd()
   If Key <> 0 Then
   Select Case Key:
      Case 44:
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

      Case Else:
         Text = Text + Chr(key)
      End Select
      End If
Loop
Return

'************************************
Led_1:
   Reset Column_h : Reset Column_g : Reset Column_f : Reset Column_e : Reset Column_d : Reset Column_c : Reset Column_b : Set Column_a
   Reset Data2_0 : Reset Data2_1 : Reset Data2_2 : Reset Data2_3 : Reset Data2_4 : Reset Data2_5 : Reset Data2_6 : Reset Data2_7
   Set Data1_0 : Reset Data1_1 : Reset Data1_2 : Reset Data1_3 : Reset Data1_4 : Reset Data1_5 : Reset Data1_6 : Reset Data1_7
Return

'************************************
Led_2:
   Reset Column_h : Reset Column_g : Reset Column_f : Reset Column_e : Reset Column_d : Reset Column_c : Reset Column_b : Set Column_a
   Reset Data2_0 : Reset Data2_1 : Reset Data2_2 : Reset Data2_3 : Reset Data2_4 : Reset Data2_5 : Reset Data2_6 : Reset Data2_7
   Reset Data1_0 : Reset Data1_1 : Reset Data1_2 : Reset Data1_3 : Reset Data1_4 : Reset Data1_5 : Reset Data1_6 : Set Data1_7
Return

'************************************
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

'************************************************     Keydata
Keydata:
'normal keys lower case
Data 0 , 0 , 0 , 0 , 0 , 0 , 0 , 27 , 0 , 0 , 0 , 0 , 9 , 9 , 94 , 0
Data 0 , 0 , 0 , 0 , 0 , 113 , 49 , 0 , 0 , 0 , 122 , 115 , 97 , 119 , 50 , 0
Data 0 , 99 , 120 , 100 , 101 , 52 , 51 , 0 , 0 , 32 , 118 , 102 , 116 , 114 , 53 , 0
Data 0 , 110 , 98 , 104 , 103 , 121 , 54 , 7 , 8 , 44 , 109 , 106 , 117 , 55 , 56 , 0
Data 0 , 44 , 107 , 105 , 111 , 48 , 57 , 0 , 0 , 46 , 45 , 108 , 48 , 112 , 43 , 0
Data 0 , 0 , 0 , 0 , 0 , 92 , 0 , 0 , 0 , 0 , 13 , 0 , 0 , 92 , 0 , 0
Data 0 , 60 , 0 , 0 , 0 , 0 , 8 , 0 , 0 , 49 , 0 , 52 , 55 , 0 , 0 , 0
Data 48 , 44 , 50 , 53 , 54 , 56 , 0 , 0 , 0 , 43 , 51 , 45 , 42 , 57 , 0 , 0

'shifted keys UPPER case
Data 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
Data 0 , 0 , 0 , 0 , 0 , 81 , 33 , 0 , 0 , 0 , 90 , 83 , 65 , 87 , 34 , 0
Data 0 , 67 , 88 , 68 , 69 , 0 , 35 , 0 , 0 , 32 , 86 , 70 , 84 , 82 , 37 , 0
Data 0 , 78 , 66 , 72 , 71 , 89 , 38 , 0 , 0 , 76 , 77 , 74 , 85 , 47 , 40 , 0
Data 0 , 59 , 75 , 73 , 79 , 61 , 41 , 0 , 0 , 58 , 95 , 76 , 48 , 80 , 63 , 0
Data 0 , 0 , 0 , 0 , 0 , 96 , 0 , 0 , 0 , 0 , 13 , 94 , 0 , 42 , 0 , 0
Data 0 , 62 , 0 , 0 , 0 , 8 , 0 , 0 , 49 , 0 , 52 , 55 , 0 , 0 , 0 , 0
Data 48 , 44 , 50 , 53 , 54 , 56 , 0 , 0 , 0 , 43 , 51 , 45 , 42 , 57 , 0 , 0