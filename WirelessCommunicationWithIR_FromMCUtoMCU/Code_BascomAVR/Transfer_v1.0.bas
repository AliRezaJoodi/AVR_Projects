'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 11059200

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cls

Config Keyboard = Pind.7 , Data = Pinc.0 , Keydata = Keydata

Config Portd.4 = Output : Portd.4 = 0 : Led_capslock Alias Portd.4

Enable Interrupts

Dim A As Byte
Dim Msb As Byte
Dim Lsb As Byte
Dim Z As Byte
Dim A_asc As Byte

Dim Status_capslock As Bit : Status_capslock = 0
Dim Status_line As Byte : Status_line = 1
'Gosub T1

Do
   A = Getatkbd()
   If A <> 0 Then
      If A = 25 Then
         Toggle Status_capslock
         If Status_capslock = 1 Then
            Set Led_capslock
         Else
            Reset Led_capslock
         End If
      End If
      If Status_capslock = 1 Then
         If A >= 97 And A <= 122 Then A = A - 32
      End If
      Gosub Display_chart
      Gosub Convert
      Gosub Send
   End If

Loop

End
'//////////////////////////////////////////     End Program

T1:
   Cls
   Lcd "OK"
   Do
   Loop
Return

'*************************************************     Show_on_the_lcd
Display_chart:
   Select Case A:
      Case 18:
         Cls
         Home
         Status_line = 1
      Case 13:
         If Status_line = 1 Then
            Lowerline
            Status_line = 2
         End If
      Case 16:
         Shiftcursor Left
         Lcd " ";
         Shiftcursor Left
      Case 32 To 126:
         Lcd Chr(a)
      End Select
Return

'*************************************************     send
Send:
   Rc5send 0 , Msb , Lsb
Return

'*************************************************     Convert
Convert:
   A_asc = Asc(a)
   Msb = A_asc \ 16
   Z = 16 * Msb
   Lsb = A_asc - Z
Return


'************************************************
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


'************************************************
Keydata_:
Data 000 , 001 , 002 , 003 , 004 , 005 , 006 , 007 , 008 , 009
Data 010 , 011 , 012 , 013 , 014 , 015 , 016 , 017 , 018 , 019
Data 020 , 021 , 022 , 023 , 024 , 025 , 026 , 027 , 028 , 029
Data 030 , 031 , 032 , 033 , 034 , 035 , 036 , 037 , 038 , 039
Data 040 , 041 , 042 , 043 , 044 , 045 , 046 , 047 , 048 , 049
Data 050 , 051 , 052 , 053 , 054 , 055 , 056 , 057 , 058 , 059
Data 060 , 061 , 062 , 063 , 064 , 065 , 066 , 067 , 068 , 069
Data 070 , 071 , 072 , 073 , 074 , 075 , 076 , 077 , 078 , 079
Data 080 , 081 , 082 , 083 , 084 , 085 , 086 , 087 , 088 , 089
Data 090 , 091 , 092 , 093 , 094 , 095 , 096 , 097 , 098 , 099
Data 100 , 101 , 102 , 103 , 104 , 105 , 106 , 107 , 108 , 109
Data 110 , 111 , 112 , 113 , 114 , 115 , 116 , 117 , 118 , 119
Data 120 , 121 , 122 , 123 , 124 , 125 , 126 , 127

Data 128 , 129
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