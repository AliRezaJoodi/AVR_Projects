'Github Account: Github.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 1000000

Config Pinb.0 = Output : Sound_port Alias Portb.0

Const La = 114
Const Lad = 107
Const Si = 101
Const Doo = 96
Const Dod = 90
Const Re = 85
Const Red = 80
Const Mi = 76
Const Fa = 72
Const Fad = 68
Const Sol = 64
Const Sold = 60
Const Mt = 1

Dim I As Word
Dim Note As Byte
Dim Length As Byte
Dim Duration As Word

'Soltan Ghalbha
For I = 0 To 149
   Note = Lookup(i , Table_note) : Note = Note * 2
   Length = Lookup(i , Table_length)
   Duration = 5000 / Note : Duration = Duration * Length
   Sound Sound_port , Duration , Note
Next I

Do
Loop

End

'****************************
Table_note:
Data La , Si , Doo , Mi , Fa , Mi
Data Fa , Mi , Fa , Mi , Fa , Mi , Re , Mi
Data Re , Mi , Re , Mi , Re , Mi
Data Re , Doo , Re , Doo , Re , Doo
Data Si , La , Sold , La , Si , Mt
Data Fa , Mi , Mt
Data La , Si , Doo , Mi , Fa , Mi
Data Fa , Mi , Fa , Mi , Fa , Mi , Re , Mi
Data Re , Mi , Re , Mi , Re , Mi
Data Re , Doo , Re , Doo , Re , Doo
Data Si , La , Sold , La , Si , Mt
Data Fa , Mi , Mt ,
Data La , Sol , Fa , Mi , Fa , Mi
Data Re , Fa , Mi , Re , Fa , Sol
Data Fa , Mi , Re , Mi , Re , Doo
Data Mi , Re , Doo , Mi , Fa , Mi
Data Re , Doo , Re , Doo , Si , Re
Data Doo , Si , Re , Re , Mi , Sol
Data Fa , Mi , Sold , La , Mt
Data La , Sol , Fa , Mi , Fa , Mi
Data Re , Fa , Mi , Re , Fa , Sol
Data Fa , Mi , Re , Mi , Re , Doo
Data Mi , Re , Doo , Mi , Fa , Mi
Data Re , Doo , Re , Doo , Si , Re
Data Doo , Si , Re , Mi , Mi , Doo
Data Si , La , Mt

'****************************
Table_length:
Data 4 , 4 , 4 , 8 , 4 , 8
Data 4 , 8 , 4 , 4 , 4 , 4 , 8 , 4
Data 8 , 4 , 8 , 4 , 4 , 4
Data 4 , 8 , 4 , 8 , 4 , 8
Data 4 , 4 , 4 , 4 , 6 , 4
Data 8 , 4 , 4
Data 4 , 4 , 4 , 8 , 4 , 8
Data 4 , 8 , 4 , 4 , 4 , 4 , 8 , 4
Data 8 , 4 , 8 , 4 , 4 , 4
Data 4 , 8 , 4 , 8 , 4 , 8
Data 4 , 4 , 4 , 4 , 6 , 4
Data 8 , 4 , 4
Data 4 , 4 , 4 , 4 , 6 , 2
Data 4 , 6 , 2 , 4 , 8 , 4
Data 4 , 4 , 4 , 6 , 2 , 4
Data 6 , 2 , 4 , 8 , 4 , 4
Data 4 , 4 , 6 , 2 , 4 , 6
Data 2 , 4 , 8 , 4 , 4 , 4
Data 4 , 12 , 12 , 8 , 4
Data 4 , 4 , 4 , 4 , 6 , 2
Data 4 , 6 , 2 , 4 , 8 , 4
Data 4 , 4 , 4 , 6 , 2 , 4
Data 6 , 2 , 4 , 8 , 4 , 4
Data 4 , 4 , 6 , 2 , 4 , 6
Data 2 , 4 , 8 , 4 , 4 , 4
Data 4 , 4 , 16