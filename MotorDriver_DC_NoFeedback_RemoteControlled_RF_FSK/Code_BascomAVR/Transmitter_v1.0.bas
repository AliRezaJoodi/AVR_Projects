'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000
$baud = 9600
'Config Debounce = 30

'Config Portb.2 = Input : Portb.2 = 1 : Key_down Alias Pinb.2
'Config Portb.1 = Input : Portb.1 = 1 : Key_stop Alias Pinb.1

Config Porta.4 = Input : Porta.4 = 0 : Key_up Alias Pina.4
Config Porta.2 = Input : Porta.2 = 0 : Key_left Alias Pina.2
Config Porta.0 = Input : Porta.0 = 0 : Key_right Alias Pina.0
Config Porta.1 = Input : Porta.1 = 0 : Key_downe Alias Pina.1
Config Porta.3 = Input : Porta.3 = 0 : Key_stop Alias Pina.3

Config PortD.2 = Output : PortD.2 = 0 : Led Alias PortD.2

Dim Status_key_right As Bit : Status_key_right = 0

Dim Address As String * 3 : Address = "123"
Dim Status As Byte : Status = 0
Dim Status_string As String * 1 : Status_string = "0"


Do

   If Key_right = 1 Then
      Waitms 30
      If Key_right = 1 Then
         Set Led
         Status = 1 : Status_string = Str(status)
         Print Address ; Status_string : Waitms 20
         Reset Led
      End If
   End If

   If Key_left = 1 Then
      Waitms 30
      If Key_left = 1 Then
         Set Led
         Status = 2 : Status_string = Str(status)
         Print Address ; Status_string : Waitms 20
         Reset Led
      End If
   End If

   If Key_up = 1 Then
      Waitms 30
      If Key_up = 1 Then
         Set Led
         Status = 3 : Status_string = Str(status)
         Print Address ; Status_string : Waitms 20
         Reset Led
      End If
   End If

   If Key_downe = 1 Then
      Waitms 30
      If Key_downe = 1 Then
         Set Led
         Status = 4 : Status_string = Str(status)
         Print Address ; Status_string : Waitms 20
         Reset Led
      End If
   End If

   If Key_stop = 1 Then
      Waitms 30
      If Key_stop = 1 Then
         Set Led
         Status = 5 : Status_string = Str(status)
         Print Address ; Status_string : Waitms 20
         Reset Led
      End If
   End If

Loop

End