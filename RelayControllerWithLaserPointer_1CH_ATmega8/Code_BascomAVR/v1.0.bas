'Github Account: Github.com/AliRezaJoodi

$regfile = "m8def.dat"
$crystal = 1000000

Config Portb.2 = Input : Portb.2 = 1 : Sensor_on Alias Pinb.2
Config Portc.2 = Input : Portc.2 = 1 : Sensor_off Alias Pinc.2
Config Portd.1 = Output : Portd.1 = 0 : Relay Alias Portd.1

Do
   If Sensor_on = 1 And Sensor_off = 0 Then Set Relay
   If Sensor_on = 0 And Sensor_off = 1 Then Reset Relay
Loop

End