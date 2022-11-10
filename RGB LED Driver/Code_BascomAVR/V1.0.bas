'Github Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Enable Interrupts

Config Timer0 = Timer , Prescale = 256
On Ovf0 Pwm_create
Enable Timer0
Stop Timer0

Config Porta.0 = Output : Chanal_r Alias Porta.0
Config Porta.1 = Output : Chanal_g Alias Porta.1
Config Porta.2 = Output : Chanal_b Alias Porta.2

Dim Value_r As Byte : Value_r = 0
Dim Value_g As Byte : Value_g = 0
Dim Value_b As Byte : Value_b = 0
Dim I As Byte

Start Timer0

Do
   Gosub Color_1 : Waitms 500
   Gosub Color_red : Waitms 500
   Gosub Color_green : Waitms 500
   Gosub Color_blue : Waitms 500
Loop

End

'***********************************************
Pwm_create:
   Timer0 = 254
   Incr I
   If I >= 10 Then
      I = 0
      Set Chanal_r : Set Chanal_g : Set Chanal_b
   End If
   If I = Value_r Then Reset Chanal_r
   If I = Value_g Then Reset Chanal_g
   If I = Value_b Then Reset Chanal_b
Return

'***********************************************
Color_1:
   Value_r = 1
   Value_g = 1
   Value_b = 1
Return

'***********************************************
Color_red:
   Value_r = 10
   Value_g = 0
   Value_b = 0
Return

'***********************************************
Color_green:
   Value_r = 0
   Value_g = 10
   Value_b = 0
Return

'***********************************************
Color_blue:
   Value_r = 0
   Value_g = 0
   Value_b = 10
Return
