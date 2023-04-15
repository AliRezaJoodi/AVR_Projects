'Github Account: Github.com/AliRezaJoodi

$regfile = "m32def.dat"
'$crystal = 11059200
$crystal = 8000000

Config Lcdpin = Pin , Rs = Pina.0 , E = Pina.2 , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7
Config Lcd = 16 * 2
'Config Pina.1 = Input
Cursor Off
Cls

Config Portd.4 = Output : Portd.4 = 0 : Rst Alias Portd.4
Config Portd.5 = Output : Portd.5 = 0 : Clk Alias Portd.5
Config Portb.0 = Input : Portb.0 = 1 : Data_pin Alias Pinb.0
Config Portd.2 = Input : Portd.2 = 1 : Telcard_key Alias Pind.2

Config Portd.6 = Output : Portd.6 = 0 : Buzzer Alias Portd.6
Config Portd.1 = Output : Portd.1 = 0 : Led Alias Portd.1 : Reset Led
Config Portd.3 = Input : Portd.3 = 1 : Key Alias Pind.3


Config Debounce = 30

Dim D(65) As Byte
Dim X(5) As Byte
Dim P(5) As Integer
Dim I As Byte
Dim J As Byte
Dim N As Byte
Dim Credit As Integer

Dim K1 As Byte

Sound Buzzer , 400 , 250
Gosub Start_sub

Do
   Debounce Key , 0 , Read_telcard , Sub
   If Telcard_key = 1 Then
      Set Led
   Else
      Reset Led
   End If
Loop

End


'***********************************************
Start_sub:
   Cls
   'Locate 1 , 1 : Lcd "TelCard Reader"
   Locate 1 , 1 : Lcd "Press Key"
Return

'***********************************************
Read_telcard:
   Set Buzzer : Reset Led
   Gosub Erase_variable
   Gosub Read_mode
   Gosub Read_data
   Gosub Credit_calculator
   Gosub Show_credit
   Waitms 50 : Reset Buzzer : Set Led
Return

'***********************************************
Read_mode:
   Set Rst
      Set Clk
         Waitus 5
      Reset Clk
   Reset Rst
Return

'***********************************************
Read_data:
   For J = 1 To 64
      For I = 1 To 8
         Set Clk : Waitus 5
         Shift D(j) , Left
         If Data_pin = 1 Then
            D(j) = D(j) Or &B00000001
         End If
         Reset Clk : Waitus 5
      Next I
   Next J
Return

'***********************************************
Credit_calculator:
   N = 4
   For J = 10 To 13
      If D(j).0 = 1 Then Incr X(n)
      If D(j).1 = 1 Then Incr X(n)
      If D(j).2 = 1 Then Incr X(n)
      If D(j).3 = 1 Then Incr X(n)
      If D(j).4 = 1 Then Incr X(n)
      If D(j).5 = 1 Then Incr X(n)
      If D(j).6 = 1 Then Incr X(n)
      If D(j).7 = 1 Then Incr X(n)
      Decr N
   Next J
   P(1) = X(1) * 1
   P(2) = X(2) * 8
   P(3) = X(3) * 64
   P(4) = X(4) * 512
   Credit = P(1) : Credit = Credit + P(2) : Credit = Credit + P(3) : Credit = Credit + P(4)
   Credit = Credit * 50
Return

'***********************************************
Erase_variable:
   For I = 1 To 64
      D(i) = 0
   Next I
   For I = 1 To 4
      X(i) = 0 : P(i) = 0
   Next I
   Credit = 0
Return

'***********************************************
Show_credit:
   If Credit >= 0 Then
      Cls : Lcd Credit ; " Rial"
   Else
      'Cls : Lcd "    " ; " Rial"
      Cls : Lcd "Error"
   End If
Return