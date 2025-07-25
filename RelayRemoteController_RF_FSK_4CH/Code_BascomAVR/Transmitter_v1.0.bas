'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m8def.dat"
$crystal = 11059200
$baud = 9600

Config Portd.5 = Input : Portd.5 = 0 : K4 Alias Pind.5
Config Portd.6 = Input : Portd.6 = 0 : K3 Alias Pind.6
Config Portd.7 = Input : Portd.7 = 0 : K2 Alias Pind.7
Config Portb.0 = Input : Portb.0 = 0 : K1 Alias Pinb.0

Config Portb.2 = Output : Portb.2 = 0 : Led Alias Portb.2
Config Portb.1 = Output : Portb.1 = 0 : Sowitch Alias Portb.1

Config Portc.0 = Input
Config Portc.2 = Input
Config Portd.3 = Input
Config Portd.4 = Input

Dim Address As String * 3 : Address = "123"

Dim Status As Byte : Status = &B00001111
Dim Status_string As String * 1 : Status_string = "0"

Dim I As Byte

Do
   Set Led
   Incr I
   Status.0 = K1
   Status.1 = K2
   Status.2 = K3
   Status.3 = K4
   Status = Status And &B00001111
   Status_string = Str(status)
   Print Address ; Status_string : Waitms 20
   If I > 40 Then
      'Do
         Set Sowitch
      'Loop
   End If
Loop

End
