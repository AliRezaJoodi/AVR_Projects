'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Porta = Output
Config Portc = Output

Config Portb.1 = Output : Reset Portb.1 : Led_1 Alias Portb.1
Config Portb.0 = Output : Reset Portb.0 : Led_2 Alias Portb.0
Config Portd.6 = Output : Reset Portd.6 : Led_3 Alias Portd.6
Config Portd.5 = Output : Reset Portd.5 : Led_4 Alias Portd.5

Dim I As Word
Dim End_i As Word : End_i = 125
Dim T As Word : T = 150

Gosub Stepper_motor_1
Gosub Stepper_motor_3
Gosub Stepper_motor_2
Gosub Stepper_motor_4

Do
loop

End


'****************************************
Stepper_motor_1:
   I = 0
   Set Led_1
   Do
      Porta = &B00000001 : Waitms T
      Porta = &B00000100 : Waitms T
      Porta = &B00000010 : Waitms T
      Porta = &B00001000 : Waitms T
      Incr I
   Loop Until I >= End_i
   Reset Led_1 : Porta = &B00000000
Return

'****************************************
Stepper_motor_2:
   I = 0
   Set Led_2
   Do
      Porta = &B10000000 : Waitms T
      Porta = &B00100000 : Waitms T
      Porta = &B01000000 : Waitms T
      Porta = &B00010000 : Waitms T
      Incr I
   Loop Until I >= End_i
   Reset Led_2 : Porta = &B00000000
Return

'****************************************
Stepper_motor_3:
   I = 0
   Set Led_3
   Do
      Portc = &B10000000 : Waitms T
      Portc = &B00100000 : Waitms T
      Portc = &B01000000 : Waitms T
      Portc = &B00010000 : Waitms T
      Incr I
   Loop Until I >= End_i
   Reset Led_3 : Portc = &B00000000
Return

'****************************************
Stepper_motor_4:
   I = 0
   Set Led_4
   Do
      Portc = &B00000001 : Waitms T
      Portc = &B00000100 : Waitms T
      Portc = &B00000010 : Waitms T
      Portc = &B00001000 : Waitms T
      Incr I
   Loop Until I >= End_i
   Reset Led_4 : Portc = &B00000000
Return