'GitHub Account: GitHub.com/AliRezaJoodi

$crystal = 1000000
$regfile = "M8def.dat"

Config Portb = Output
Config Pind.0 = Output
Config Pind.1 = Output

S1 Alias Portd.1
S2 Alias Portd.0

Portb = 255
Set S1 : Set S2                                             'Display1 is OFF : Display2 is OFF

Enable Interrupts

Config Adc = Single , Prescaler = Auto
Start Adc

Dim A As Integer : A = 0
Dim S As Integer : S = 0
Dim Temp As Integer : Temp = 0
Dim Z As Byte : Z = 0
Dim T As Integer : T = 0
Dim I As Integer : I = 0

Declare Sub Show(byval Temp As Integer)

Do
   For Z = 1 To 40
      A = Getadc(0)
      A = A / 2
      S = S + A
      Call Show(temp)
   Next Z
   Temp = S / 40
   S = 0
Loop

End


'*******************************************
Sub Show(temp As Integer)
Do
   Incr I
   T = Temp Mod 10
   Portb = Lookup(t , Annode_display)
   Select Case I
      Case 1:
         Reset S1 : Set S2                                  'Display1 is ON   :  Display2 is OFF
         Waitms 1
      Case 2:
         Set S1 : Reset S2                                  'Display1 is OFF   :  Display2 is ON
         Waitms 1
   End Select
   Set S1 : Set S2                                          'Display1 is OFF : Display2 is OFF
   Temp = Temp \ 10
   If Temp = 0 Then
      I = 0
      Exit Sub
   End If
Loop
End Sub


'*******************************************
Annode_display:
Data 192 , 249 , 164 , 176 , 153 , 146 , 130 , 248 , 128 , 144 , 191 , 127 , 199
'      0      1    2     3     4     5     6     7     8     9     -    dp    L