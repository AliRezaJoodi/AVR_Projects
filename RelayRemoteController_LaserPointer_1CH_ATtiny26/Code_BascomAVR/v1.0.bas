'Github Account: Github.com/AliRezaJoodi

$regfile = "Attiny26.dat"
$crystal = 8000000
'$tiny
'$noramclear

Config Portb.3 = Output : Portb.3 = 0 : Relay Alias Portb.3
Config Porta.2 = Input : Porta.2 = 1 : Sensor_off Alias Pina.2
Config Porta.7 = Input : Porta.7 = 1 : Sensor_on Alias Pina.7

Do
   If Sensor_on = 1 And Sensor_off = 0 Then Set Relay
   If Sensor_on = 0 And Sensor_off = 1 Then Reset Relay
Loop

End