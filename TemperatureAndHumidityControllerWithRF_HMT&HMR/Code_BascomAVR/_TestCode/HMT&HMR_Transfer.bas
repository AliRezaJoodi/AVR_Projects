'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
$baud = 9600

Config Porta.3 = Input : Porta.3 = 1 : K4 Alias Pina.3
Config Porta.2 = Input : Porta.2 = 1 : K3 Alias Pina.2
Config Porta.1 = Input : Porta.1 = 1 : K2 Alias Pina.1
Config Porta.0 = Input : Porta.0 = 1 : K1 Alias Pina.0

Config Portd.6 = Output : Portd.6 = 0 : Led Alias Portd.6
'Config Portb.1 = Output : Portb.1 = 0 : Sowitch Alias Portb.1

'Config Portc.0 = Input
'Config Portc.2 = Input
'Config Portd.3 = Input
'Config Portd.4 = Input

Dim Address As String * 3 : Address = "123"

Dim Status As Byte : Status = &B00001111
Dim Status_string As String * 1 : Status_string = "0"

Dim I As Byte

Do
   Incr I
   Status.0 = K1
   Status.1 = K2
   Status.2 = K3
   Status.3 = K4
   Status = Status And &B00001111
   Status_string = Str(status)
   Set Led
   Print Address ; Status_string
   Reset Led
   Waitms 100
   'If I > 40 Then
      'Do
         'Set Sowitch
      'Loop
   'End If
Loop

End