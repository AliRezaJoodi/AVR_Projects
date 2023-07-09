'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m16def.dat"
$crystal = 8000000

Activate_led Alias 1
Deactivate_led Alias 0
Led0 Alias Portc.5 : Config Led0 = Output : Led0 = Deactivate_led
Led1 Alias Portc.4 : Config Led1 = Output : Led1 = Deactivate_led
Led2 Alias Portc.3 : Config Led2 = Output : Led2 = Deactivate_led
Led3 Alias Portc.2 : Config Led3 = Output : Led3 = Deactivate_led
Led4 Alias Portc.0 : Config Led4 = Output : Led4 = Deactivate_led
Led5 Alias Portd.7 : Config Led5 = Output : Led5 = Deactivate_led
Led6 Alias Portb.2 : Config Led6 = Output : Led6 = Deactivate_led
Led7 Alias Portd.3 : Config Led7 = Output : Led7 = Deactivate_led

Dim Value As Byte

Do
   Incr Value
   Gosub Set_leds
   Waitms 1000
Loop

End

Set_leds:
   Led0 = Value.0
   Led1 = Value.1
   Led2 = Value.2
   Led3 = Value.3
   Led4 = Value.4
   Led5 = Value.5
   Led6 = Value.6
   Led7 = Value.7
Return