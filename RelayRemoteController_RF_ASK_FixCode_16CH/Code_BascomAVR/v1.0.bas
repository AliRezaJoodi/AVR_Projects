'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8def.dat"
$crystal = 8000000

Enable Interrupts
Enable Int0
'Config Int0 = Rising
On Int0 Reding

Config Portc = Input

Config Portb = Output
Portb = 0

Config Pind.0 = Output
Config Pind.1 = Output
Config Pind.3 = Output
Config Pind.4 = Output
Config Pind.5 = Output
Config Pind.6 = Output
Config Pind.7 = Output

Rl_1 Alias Portd.0
Rl_2 Alias Portd.1
Rl_3 Alias Portd.3
Rl_4 Alias Portd.4
Rl_5 Alias Portb.6
Rl_6 Alias Portb.7
Rl_7 Alias Portd.5
Rl_8 Alias Portd.6
Rl_9 Alias Portd.7
Rl_10 Alias Portb.0
Rl_11 Alias Portb.5
Rl_12 Alias Portb.4
Rl_13 Alias Portb.3
Rl_14 Alias Portb.1
Rl_15 Alias Portb.2

Dim A As Byte

Do
Loop

End

'**********************************
Reding:
A = Pinc
A = A And &H3F
A = Lookup(a , Convert)
Select Case A
   Case 1 : Toggle Rl_1
   Case 2 : Toggle Rl_2
   Case 3 : Toggle Rl_3
   Case 4 : Toggle Rl_4
   Case 5 : Toggle Rl_5
   Case 6 : Toggle Rl_6
   Case 7 : Toggle Rl_7
   Case 8 : Toggle Rl_8
   Case 9 : Toggle Rl_9
   Case 10 : Toggle Rl_10
   Case 11 : Toggle Rl_11
   Case 12 : Toggle Rl_12
   Case 13 : Toggle Rl_13
   Case 14 : Toggle Rl_14
   Case 15 : Toggle Rl_15
   Case 16:
      Set Rl_1
      Set Rl_2
      Set Rl_3
      Set Rl_4
      Set Rl_5
      Set Rl_6
      Set Rl_7
      Set Rl_8
      Set Rl_9
      Set Rl_10
      Set Rl_11
      Set Rl_12
      Set Rl_13
      Set Rl_14
      Set Rl_15
   Case 18:
      Reset Rl_1
      Reset Rl_2
      Reset Rl_3
      Reset Rl_4
      Reset Rl_5
      Reset Rl_6
      Reset Rl_7
      Reset Rl_8
      Reset Rl_9
      Reset Rl_10
      Reset Rl_11
      Reset Rl_12
      Reset Rl_13
      Reset Rl_14
      Reset Rl_15
End Select
Waitms 200
Return

'***********************************************************
Convert:
Data 0 , 6 , 5 , 0 , 1 , 11 , 10 , 0 , 4 , 0
Data 0 , 0 , 9 , 0 , 0 , 0 , 3 , 18 , 17 , 0
Data 8 , 0 , 0 , 0 , 16 , 0 , 0 , 0 , 0 , 0
Data 0 , 0 , 2 , 15 , 14 , 0 , 7 , 0 , 0 , 0
Data 13 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 12 , 0
