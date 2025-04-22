'GitHub Account: GitHub.com/AliRezaJoodi

$crystal = 8000000
$regfile = "attiny2313.dat"

$baud = 9600
'Config Serialin = Buffered , Size = 20
'Config Serialout = Buffered , Size = 20
Enable Interrupts

Dim Value As String * 6
Dim Dis As String * 1
Dim Testin As Integer
Dim Wa As Byte : Wa = 20
Dim Stap As Integer
Dim A As Byte : A = 144
Dim I As Byte

Config Portb = Output
Config Portd = Input

Print "*************AVR Projects******************"
Print "Serial Port Stepper Motor Driver           "
Print "To run the motor give input Rxxxxx or Lxxxx"
Print "where xxxxx is a number from 1 to 32000    "
Print "serial port settings:9600-8-N-1           "
Print "*******************************************"

Do
   Input "Give input: " , Value
   Print "Running..."

   Dis = Left(value , 1)
   Value = Mid(value , 2 , 5)
   Stap = Val(value)

   If Dis = "L" Then
      For I = 1 To Stap
         Gosub Ccw
      Next I
   End If

   If Dis = "R" Then
      For I = 1 To Stap
         Gosub Cw
      Next I
   End If

Loop
End

'*************************************************
Ccw:
   Rotate A , Right
   If A = 24 Then A = 144
   If A = 72 Then A = 192
   Portb = A
   'Print A
   Waitms 20
Return

'**************************************************
Cw:
   Rotate A , Left
   If A = 129 Then A = 144
   If A = 33 Then A = 48
   Portb = A
   'Print A
   Waitms 20
Return



'Portb = 144
'Portb = 192
'Portb = 096
'Portb = 048