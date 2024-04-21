'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600

Config Lcdpin = Pin , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7 , E = Pina.2 , Rs = Pina.0
Config Lcd = 16 * 2
Config Pina.1 = Input
Cls

Config Keyboard = Pinc.1 , Data = Pinc.0 , Keydata = Keydata

Enable Interrupts
Config Timer0 = Timer , Prescale = 256                      'PRESCALE= 1|8|64|256|1024
On Timer0 Sending_data
Enable Timer0
Start Timer0

Dim Character_ascii As Byte : Character_ascii = 12
Dim T As Word : T = 30
Dim Address As String * 3 : Address = "123"
Dim Status_string As String * 1 : Status_string = "0"
Dim Status_bit As Bit : Status_bit = 0
Dim Data_string As String * 3 : Data_string = "127"

Do
      Character_ascii = Getatkbd()
      If Character_ascii <> 0 Then
         Select Case Character_ascii:
            Case 33 To 126:
               Lcd Chr(character_ascii)
            Case 12:
               Cls : Home
            Case 13
               Lowerline
            Case 8:
               'Shiftcursor Left
               'Lcd " ";
               'Shiftcursor Left
         End Select
         Data_string = Str(character_ascii)
         Toggle Status_bit : Status_string = Str(status_bit)
      End If
Loop

End

'************************************************
Sending_data:
   Incr T
   If T > 9 Then
      Stop Timer0
      Print Address ; Status_string ; Data_string
   Start Timer0
   T = 0
   End If
Return

'************************************************     Keydata
Keydata:
'normal keys lower case
Data 0 , 0 , 0 , 0 , 0 , 0 , 0 , 27 , 0 , 0 , 0 , 0 , 9 , 9 , 94 , 0
Data 0 , 0 , 0 , 0 , 0 , 113 , 49 , 0 , 0 , 0 , 122 , 115 , 97 , 119 , 50 , 0
Data 0 , 99 , 120 , 100 , 101 , 52 , 51 , 0 , 0 , 32 , 118 , 102 , 116 , 114 , 53 , 0
Data 0 , 110 , 98 , 104 , 103 , 121 , 54 , 7 , 8 , 12 , 109 , 106 , 117 , 55 , 56 , 0
Data 0 , 12 , 107 , 105 , 111 , 48 , 57 , 0 , 0 , 46 , 45 , 108 , 48 , 112 , 43 , 0
Data 0 , 0 , 0 , 0 , 0 , 92 , 0 , 0 , 0 , 0 , 13 , 0 , 0 , 92 , 0 , 0
Data 0 , 60 , 0 , 0 , 0 , 0 , 8 , 0 , 0 , 49 , 0 , 52 , 55 , 0 , 0 , 0
Data 48 , 12 , 50 , 53 , 54 , 56 , 0 , 0 , 0 , 43 , 51 , 45 , 42 , 57 , 0 , 0

'shifted keys UPPER case
Data 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
Data 0 , 0 , 0 , 0 , 0 , 81 , 33 , 0 , 0 , 0 , 90 , 83 , 65 , 87 , 34 , 0
Data 0 , 67 , 88 , 68 , 69 , 0 , 35 , 0 , 0 , 32 , 86 , 70 , 84 , 82 , 37 , 0
Data 0 , 78 , 66 , 72 , 71 , 89 , 38 , 0 , 0 , 76 , 77 , 74 , 85 , 47 , 40 , 0
Data 0 , 59 , 75 , 73 , 79 , 61 , 41 , 0 , 0 , 58 , 95 , 76 , 48 , 80 , 63 , 0
Data 0 , 0 , 0 , 0 , 0 , 96 , 0 , 0 , 0 , 0 , 13 , 94 , 0 , 42 , 0 , 0
Data 0 , 62 , 0 , 0 , 0 , 8 , 0 , 0 , 49 , 0 , 52 , 55 , 0 , 0 , 0 , 0
Data 48 , 12 , 50 , 53 , 54 , 56 , 0 , 0 , 0 , 43 , 51 , 45 , 42 , 57 , 0 , 0