'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m8DEF.dat"
$crystal = 8000000

Config Portb.0 = Output : Portb.0 = 0 : Device_1 Alias Portb.0
Config Portd.7 = Output : Portd.7 = 0 : Device_2 Alias Portd.7
Config Portd.6 = Output : Portd.6 = 0 : Device_3 Alias Portd.6
Config Portd.5 = Output : Portd.5 = 0 : Device_4 Alias Portd.5
Config Portd.3 = Output : Portd.3 = 0 : Device_5 Alias Portd.3
Config Portd.2 = Output : Portd.2 = 0 : Device_6 Alias Portd.2
Config Portd.1 = Output : Portd.1 = 0 : Device_7 Alias Portd.1
Config Portd.0 = Output : Portd.0 = 0 : Device_8 Alias Portd.0
Config Portb.1 = Output : Portb.1 = 0 : Device_9 Alias Portb.1
Config Portb.2 = Output : Portb.2 = 0 : Device_10 Alias Portb.2
Config Portb.3 = Output : Portb.3 = 0 : Device_11 Alias Portb.3
Config Portb.4 = Output : Portb.4 = 0 : Device_12 Alias Portb.4
Config Portb.5 = Output : Portb.5 = 0 : Device_13 Alias Portb.5
Config Portc.0 = Output : Portc.0 = 0 : Device_14 Alias Portc.0
Config Portc.1 = Output : Portc.1 = 0 : Device_15 Alias Portc.1
Config Portc.2 = Output : Portc.2 = 0 : Device_16 Alias Portc.2

Dim Dat As Integer
Dim I As Byte
Dim Refresh As Word : Refresh = 0

Declare Sub Blinker_1(byval N As Byte , Byval T As Word)
Declare Sub Blinker_2(byval N As Byte , Byval T As Word)
Declare Sub Blinker_3(byval N As Byte , Byval T As Word)
Declare Sub Blinker_4(byval N As Byte , Byval T As Word)

Do
   Call Blinker_1(8 , 500)
   Call Blinker_2(1 , 500)
   Call Blinker_3(1 , 300)
   Call Blinker_4(1 , 300)
Loop

End

'**************************************************
Sub Blinker_1(n As Byte , T As Word)
   Refresh = 0
   Do
      For I = 0 To 1
         Dat = Lookup(i , Data_1)
         Device_1 = Dat.0 : Device_2 = Dat.1 : Device_3 = Dat.2 : Device_4 = Dat.3 : Device_5 = Dat.4 : Device_6 = Dat.5 : Device_7 = Dat.6 : Device_8 = Dat.7
         Device_9 = Dat.8 : Device_10 = Dat.9 : Device_11 = Dat.10 : Device_12 = Dat.11 : Device_13 = Dat.12 : Device_14 = Dat.13 : Device_15 = Dat.14 : Device_16 = Dat.15
         Waitms T
      Next I
     Incr Refresh
   Loop Until Refresh = N
End Sub
Data_1:
Data &B0101010101010101%
Data &B1010101010101010%


'**************************************************
Sub Blinker_2(n As Byte , T As Word)
   Refresh = 0
   Do
      For I = 0 To 14
         Dat = Lookup(i , Data_2)
         Device_1 = Dat.0 : Device_2 = Dat.1 : Device_3 = Dat.2 : Device_4 = Dat.3 : Device_5 = Dat.4 : Device_6 = Dat.5 : Device_7 = Dat.6 : Device_8 = Dat.7
         Device_9 = Dat.8 : Device_10 = Dat.9 : Device_11 = Dat.10 : Device_12 = Dat.11 : Device_13 = Dat.12 : Device_14 = Dat.13 : Device_15 = Dat.14 : Device_16 = Dat.15
         Waitms T
      Next I
     Incr Refresh
   Loop Until Refresh = N
End Sub
Data_2:
Data &B1000000000000001%
Data &B0100000000000010%
Data &B0010000000000100%
Data &B0001000000001000%
Data &B0000100000010000%
Data &B0000010000100000%
Data &B0000001001000000%
Data &B0000000110000000%
Data &B0000001001000000%
Data &B0000010000100000%
Data &B0000100000010000%
Data &B0001000000001000%
Data &B0010000000000100%
Data &B0100000000000010%
Data &B1000000000000001%


'**************************************************
Sub Blinker_3(n As Byte , T As Word)
   Refresh = 0
   Do
      For I = 0 To 14
         Dat = Lookup(i , Data_3)
         Device_1 = Dat.0 : Device_2 = Dat.1 : Device_3 = Dat.2 : Device_4 = Dat.3 : Device_5 = Dat.4 : Device_6 = Dat.5 : Device_7 = Dat.6 : Device_8 = Dat.7
         Device_9 = Dat.8 : Device_10 = Dat.9 : Device_11 = Dat.10 : Device_12 = Dat.11 : Device_13 = Dat.12 : Device_14 = Dat.13 : Device_15 = Dat.14 : Device_16 = Dat.15
         Waitms T
      Next I
     Incr Refresh
   Loop Until Refresh = N
End Sub
Data_3:
Data &B0011111111111111%
Data &B1100111111111111%
Data &B1111001111111111%
Data &B1111110011111111%
Data &B1111111100111111%
Data &B1111111111001111%
Data &B1111111111110011%
Data &B1111111111111100%
Data &B1111111111110011%
Data &B1111111111001111%
Data &B1111111100111111%
Data &B1111110011111111%
Data &B1111001111111111%
Data &B1100111111111111%
Data &B0011111111111111%

'**************************************************
Sub Blinker_4(n As Byte , T As Word)
   Refresh = 0
   Do
      For I = 0 To 15
         Dat = Lookup(i , Data_4)
         Device_1 = Dat.0 : Device_2 = Dat.1 : Device_3 = Dat.2 : Device_4 = Dat.3 : Device_5 = Dat.4 : Device_6 = Dat.5 : Device_7 = Dat.6 : Device_8 = Dat.7
         Device_9 = Dat.8 : Device_10 = Dat.9 : Device_11 = Dat.10 : Device_12 = Dat.11 : Device_13 = Dat.12 : Device_14 = Dat.13 : Device_15 = Dat.14 : Device_16 = Dat.15
         Waitms T
      Next I
     Incr Refresh
   Loop Until Refresh = N
End Sub
Data_4:
Data &B1000000000000000%
Data &B0100000000000000%
Data &B0010000000000000%
Data &B0001000000000000%
Data &B0000100000000000%
Data &B0000010000000000%
Data &B0000001000000000%
Data &B0000000100000000%
Data &B0000000010000000%
Data &B0000000001000000%
Data &B0000000000100000%
Data &B0000000000010000%
Data &B0000000000001000%
Data &B0000000000000100%
Data &B0000000000000010%
Data &B0000000000000001%

