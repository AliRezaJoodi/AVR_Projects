'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 10000000

$baud = 9600
Print "Test UART"

Config Portb.4 = Input

Enable Interrupts

Led1 Alias Porta.0 : Config Led1 = Output : Led1 = 0
Led2 Alias Porta.1 : Config Led2 = Output : Led2 = 0
Led3 Alias Porta.2 : Config Led3 = Output : Led3 = 0
Led4 Alias Porta.3 : Config Led4 = Output : Led4 = 0

Config Portc.0 = Input : Portc.3 = 1 : Key1 Alias Pinc.0
Config Portd.7 = Input : Portd.7 = 1 : Key2 Alias Pind.7
Config Portc.3 = Input : Portc.3 = 1 : Key3 Alias Pinc.3

Dim Togbit As Byte : Togbit = 0                             ' make it 0 or 32 to set the toggle bit
Dim Address As Byte : Address = 0
Dim Command As Byte

Enable Interrupts
Config Rc5 = Pind.2

Set Led4 : Waitms 200 : Reset Led4

Do
   Getrc5(address , Command)
   If Address < 255 And Command < 255 Then
      Set Led1
      Address = Address And &B00011111
      Command = Command And &B00111111
      Print "Address=" ; Address
      Print "Command=" ; Command
      Print
      If Command = 1 Then Toggle Led2
      Waitms 100 : Reset Led1
   End If

   Debounce Key1 , 1 , Sender_rc5 , Sub
Loop

End

'***********************************************
Sender_rc5:
   Togbit = 0 : Address = 0 : Command = 12                  ' power on off
   Rc5send Togbit , Address , Command
   'or use the extended RC5 send code. You can not use both
   'make sure that the MS bit is set to 1, so you need to send
   '&B10000000 this is the minimal requirement
   '&B11000000 this is the normal RC5 mode
   '&B10100000 here the toggle bit is set
   'Rc5sendext &B11000000 , Address , Command

   Set Led2 : Waitms 200 : Reset Led2
Return

'***********************************************
Sender_rc6:
   Togbit = 0 : Address = 0 : Command = 12
   Rc6send Togbit , Address , Command
Return

'***********************************************
Sender_sony:
   Sonysend &H4D1
   'Sonysend &H1D1
Return
'(
'***********************************************
Test_Led2:
   Do
      Set Led1 : Waitms 80
      Reset Led1 : Waitms 1300
   Loop
Return
')

'(
'***********************************************
Test_led:
   Do
      Set Led1 : Reset Led2 : Reset Led3 : Reset Led4 : Waitms 500
      Reset Led1 : Set Led2 : Reset Led3 : Reset Led4 : Waitms 500
      Reset Led1 : Reset Led2 : Set Led3 : Reset Led4 : Waitms 500
      Reset Led1 : Reset Led2 : Reset Led3 : Set Led4 : Waitms 500
   Loop
Return
')

'(
'***********************************************
Test_key:
   Led1 = Key_1
   'Led2 = Key_2
   'Led3 = Key_3
Return
')

'(
'***********************************************
Test_uart:
   Dim I As Byte
   Do
      Incr I : Print I : Waitms 500
   Loop
Return
')