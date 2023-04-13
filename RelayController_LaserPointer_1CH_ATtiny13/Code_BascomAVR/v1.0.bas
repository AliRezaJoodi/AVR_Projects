'Github Account: Github.com/AliRezaJoodi

$regfile = "ATtiny13A.DAT"
$crystal = 4800000

$hwstack = 6
$swstack = 12
$framesize = 28

Config Portb.4 = Output : Portb.4 = 0 : Relay Alias Portb.4
Config Portb.1 = Input : Portb.1 = 1 : Sensor_off Alias Pinb.1
Config Portb.2 = Input : Portb.2 = 1 : Sensor_on Alias Pinb.2

Do
   If Sensor_on = 1 And Sensor_off = 0 Then Set Relay
   If Sensor_on = 0 And Sensor_off = 1 Then Reset Relay
Loop

End