'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8def.dat"
$crystal = 8000000

$baud = 9600 : Print "Start"

Enable Interrupts

Config Portb.2 = Output : Portb.2 = 0 : Led_rc5 Alias Portb.2

Config Rc5 = Pind.2
'Config Pinc.2 = Input : Portc.2 = 1

Config Watchdog = 2048
Start Watchdog

Dim Command As Byte
Dim Address As Byte

Set Led_rc5 : Waitms 200 : Reset Led_rc5

Do
   Reset Watchdog
   Getrc5(address , Command)
   If Address < 255 And Command < 255 Then
      Address = Address And &B00011111
      Command = Command And &B00111111
      Gosub S1
      Set Led_rc5 : Waitms 200 : Reset Led_rc5
      Waitms 400
   End If
Loop

End

'***************************************
S1:
   Udr = 127 : Waitms 5
   Udr = Address : Waitms 5
   Udr = Command : Waitms 5
   'Udr = 13 : Waitms 5
Return

'***************************************
S2:
   Print "Address=" ; Address
   Print "Command=" ; Command
   Print
Return