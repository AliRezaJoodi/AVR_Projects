'GitHub Account: GitHub.com/AliRezaJoodi

$crystal = 8000000
$regfile = "M8def.dat"

Dim T As Byte : T = 25

Main:

Enable Interrupts
Config Clock = Soft , Gosub = Sectic

Config Portd = Output
Config Pinb.0 = Output
Config Pinb.1 = Output
Config Pinb.2 = Output
Config Pinb.3 = Output
Config Pinb.4 = Output
Config Pinb.5 = Output
Config Pinc.0 = Output

Config Pinc.1 = Input

Config Debounce = 30
Ddrc.4 = 0 : Portc.4 = 1
Ddrc.5 = 0 : Portc.5 = 1


Segment Lr1 Alias Portb.1
Segment Sw1 Alias Portb.2
Segment Lr2 Alias Portb.3
Segment Sw2 Alias Portb.4

A Alias Portb.0
B Alias Portb.5
C Alias Portc.0


Dim I As Integer : I = T
Dim Gam As Bit : Gam = 0
Dim J As Byte

Set A : Reset B : Reset C
Toggle Gam

Do
   Debounce Pinc.5 , 0 , Up , Sub
   Debounce Pinc.4 , 0 , Downe , Sub

   If Gam = 0 Then Gosub Show_i_on_the_sw
   If Gam = 1 Then Gosub Show_i_on_the_lr
Loop

End

'************************************
Show_i_on_the_sw:
   Select Case I
      Case 0 To T :
      Portd = I Mod 10
      Reset Segment Sw1                                     'Segment Sw1 is on
      Set Segment Lr1                                       'Segment Lr1 is off
      Waitms 1
      Set Segment Sw1                                       'Segment Sw1 is off
      Portd = I \ 10
      Reset Segment Sw2                                     'Segment Sw2 is on
      Set Segment Lr2                                       'Segment Lr2 is off
      Waitms 1
      Set Segment Sw2                                       'Segment Sw2 is off
   End Select
Return

'************************************
Show_i_on_the_lr:
   Select Case I
      Case 0 To T :
      Portd = I Mod 10
      Reset Segment Lr1                                     'Segment Lr1 is on
      Set Segment Sw1                                       'Segment Sw1 is off
      Waitms 1
      Set Segment Lr1                                       'Segment Lr1 is off
      Portd = I \ 10
      Reset Segment Lr2                                     'Segment Lr2 is on
      Set Segment Sw2                                       'Segment Sw2 is off
      Waitms 1
      Set Segment Lr2                                       'Segment Lr2 is off
   End Select
Return

'************************************
Section_abc:
   Select Case I
       Case -1:
            Reset A : Set B : Reset C
       Case -2 :
            Reset A : Set B : Reset C
       Case -3 :
            Reset A : Set B : Reset C
       Case -4 :
            Reset A : Set B : Reset C
       Case -5 :
            Reset A : Set B : Reset C
       Case -6:
            If Gam = 1 Then
               Reset A : Reset B : Set C
            Else
               Set A : Reset B : Reset C
            End If
            Toggle Gam
            I = T
   End Select
Return

'************************************
Show_t:
   For J = 0 To 50
       Portd = T Mod 10
       Reset Segment Lr1                                    'Segment Lr1 is on
       Reset Segment Sw1                                    'Segment Sw1 is on
       Waitms 1
       Set Segment Lr1                                      'Segment Lr1 is off
       Set Segment Sw1                                      'Segment Sw1 is off
       Portd = T \ 10
       Reset Segment Lr2                                    'Segment Lr2 is on
       Reset Segment Sw2                                    'Segment Sw2 is on
       Waitms 1
       Set Segment Lr2                                      'Segment Lr2 is off
       Set Segment Sw2                                      'Segment Sw2 is off
   Next J
   Start Timer2
   Goto Main
Return

'****************************
Sectic:
   Decr I
   Gosub Section_abc
Return

'****************************
Up:
   Stop Timer2
   Incr T
   If T = 100 Then T = 5
   I = T
   Goto Show_t
Return

'****************************
Downe:
   Stop Timer2
   Decr T
   If T = 4 Then T = 99
   I = T
   Goto Show_t
Return