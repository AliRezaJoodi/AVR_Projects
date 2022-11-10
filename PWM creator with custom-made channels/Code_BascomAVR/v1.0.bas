'Github Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Timer0 = Timer , Prescale = 1
On Ovf0 Pwm_creator
Enable Timer0
Enable Interrupts

Config Portb.0 = Output : Ch1 Alias Portb.0
Config Portb.1 = Output : Ch2 Alias Portb.1
Config Portb.2 = Output : Ch3 Alias Portb.2
Config Portb.3 = Output : Ch4 Alias Portb.3

Dim Value1 As Byte : Value1 = 25
Dim Value2 As Byte : Value2 = 50
Dim Value3 As Byte : Value3 = 75
Dim Value4 As Byte : Value4 = 99

Dim I As Byte : I = 0

Do
Loop

End

Pwm_creator:
   Timer0 = 56                                              
   Incr I : If I > 99 Then I = 0
   If I = 0 Then
      Set Ch1 : Set Ch2 : Set Ch3 : Set Ch4
   End If
   If I = Value1 Then Reset CH1
   If I = Value2 Then Reset Ch2
   If I = Value3 Then Reset CH3
   If I = Value4 Then Reset Ch4
Return