'Github Account: Github.com/AliRezaJoodi

$regfile = "Attiny2313.dat"
$crystal = 8000000

Config Portd.5 = Output : Portd.5 = 0 : Relay Alias Portd.5
Config Portb.6 = Input : Portb.6 = 1 : Sensor_off Alias Pinb.6
Config Portd.6 = Input : Portd.6 = 1 : Sensor_on Alias Pind.6

Do
   If Sensor_on = 1 And Sensor_off = 0 Then Set Relay
   If Sensor_on = 0 And Sensor_off = 1 Then Reset Relay
Loop

End