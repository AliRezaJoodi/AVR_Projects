'Github Account: Github.com/AliRezaJoodi

$regfile = "m32def.dat"
'$crystal = 8000000
$crystal = 11059200

Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up , Prescale = 8
'Config Timer1 = Pwm , Pwm = 8 , Compare_a_pwm = Clear_down , Compare_b_pwm = Clear_down , Prescale = 8
'Config Timer1 = Pwm , Pwm = 8 , Compare_a_pwm = Clear_up , Compare_b_pwm = Clear_down , Prescale = 1
Pwm1a = 0 : Pwm1b = 0

Config Portc.7 = Output : Portc.7 = 0 : Led6 Alias Portc.7
Config Portc.6 = Output : Portc.6 = 0 : Led5 Alias Portc.6
Config Portc.5 = Output : Portc.5 = 0 : Led4 Alias Portc.5
Config Portc.3 = Output : Portc.3 = 0 : Led3 Alias Portc.3
Config Portc.2 = Output : Portc.2 = 0 : Led2 Alias Portc.2
Config Portc.1 = Output : Portc.1 = 0 : Led1 Alias Portc.1
Config Portc.0 = Output : Portc.0 = 0 : Led0 Alias Portc.0
Config Portc.4 = Output : Portc.4 = 0 : Led7 Alias Portc.4

Config Portd.4 = Output : Portd.4 = 0 : En_left Alias Portd.4
Config Portd.2 = Output : Portd.2 = 0 : In1_left Alias Portd.2
Config Portd.7 = Output : Portd.7 = 0 : In2_left Alias Portd.7

Config Portd.5 = Output : Portd.5 = 0 : En_right Alias Portd.5
Config Portd.3 = Output : Portd.3 = 0 : In1_right Alias Portd.3
Config Portd.6 = Output : Portd.6 = 0 : In2_right Alias Portd.6



Config Porta = Input

Config Portb.3 = Input : Portb.3 = 1 : Key Alias Pinb.3
Config Debounce = 30

Const Pwm_right_min = 255
Const Pwm_right_normal = 255
Const Pwm_right_max = 255

Const Pwm_left_min = 255
Const Pwm_left_normal = 255
Const Pwm_left_max = 250

Dim Sensor As Byte
Dim Z As Byte
Dim I As Byte
Dim K As Byte
Dim Status_key As Boolean : Status_key = 0
Dim Status_test As Boolean : Status_test = 0

'Gosub Test_led
'Gosub Test_motor_left
'Gosub Test_motor_right
Gosub Test_sensor

Set Led7 : Waitms 500 : Reset Led7

Do
   If Key = 0 And Status_key = 0 Then
      Waitms 30
      If Key = 0 And Status_key = 0 Then
         Status_key = 1
         Toggle Status_test
         Pwm1a = 0 : Reset In1_right : Reset In2_right
         Pwm1b = 0 : Reset In1_left : Reset In2_left
         Waitms 300
      End If
   End If
   If Key = 1 Then Status_key = 0

   Gosub Read_sensor
   'Gosub Inverter
   Gosub Standardization
   Gosub Led_driver
   If Z <> Sensor And Status_test = 0 Then
      Gosub Run
      Z = Sensor
   End If
Loop

End

'**********************************************
Test_sensor:
   Do
      'Sensor.6 = Pina.0 : Led0 = Sensor.6
      'Sensor.5 = Pina.1 : Led1 = Sensor.5
      'Sensor.4 = Pina.2 : Led2 = Sensor.4
      Gosub Read_sensor
      Gosub Standardization
      Gosub Led_driver
   Loop
Return

'**********************************************
Test_led:
   Do
      Reset Led0 : Reset Led1 : Reset Led2 : Reset Led3 : Reset Led4 : Reset Led5 : Reset Led6 : Reset Led7 : Waitms 500
      Set Led0 : Reset Led1 : Reset Led2 : Reset Led3 : Reset Led4 : Reset Led5 : Reset Led6 : Reset Led7 : Waitms 500
      Reset Led0 : Set Led1 : Reset Led2 : Reset Led3 : Reset Led4 : Reset Led5 : Reset Led6 : Reset Led7 : Waitms 500
      Reset Led0 : Reset Led1 : Set Led2 : Reset Led3 : Reset Led4 : Reset Led5 : Reset Led6 : Reset Led7 : Waitms 500
      Reset Led0 : Reset Led1 : Reset Led2 : Set Led3 : Reset Led4 : Reset Led5 : Reset Led6 : Reset Led7 : Waitms 500
      Reset Led0 : Reset Led1 : Reset Led2 : Reset Led3 : Set Led4 : Reset Led5 : Reset Led6 : Reset Led7 : Waitms 500
      Reset Led0 : Reset Led1 : Reset Led2 : Reset Led3 : Reset Led4 : Set Led5 : Reset Led6 : Reset Led7 : Waitms 500
      Reset Led0 : Reset Led1 : Reset Led2 : Reset Led3 : Reset Led4 : Reset Led5 : Set Led6 : Reset Led7 : Waitms 500
      Reset Led0 : Reset Led1 : Reset Led2 : Reset Led3 : Reset Led4 : Reset Led5 : Reset Led6 : Set Led7 : Waitms 500
   Loop

Return

'**********************************************
Test_motor_left:
   Pwm1a = 0 : Reset In1_right : Reset In2_right
   Do
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Set Led0 : Reset Led1 : Reset Led2 : Set Led3 : Reset Led4 : Reset Led5 : Reset Led6 : Reset Led7
      Wait 2

      Pwm1b = Pwm_left_max : Reset In1_left : Set In2_left
      Set Led0 : Reset Led1 : Reset Led2 : Reset Led3 : Reset Led4 : Reset Led5 : Reset Led6 : Set Led7
      Wait 2

   Loop
Return

'**********************************************
Test_motor_right:
   Pwm1b = 0 : Reset In1_left : Reset In2_left
   Do
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
      Reset Led0 : Reset Led1 : Reset Led2 : Set Led3 : Reset Led4 : Reset Led5 : Set Led6 : Reset Led7
      Wait 2

      Pwm1a = Pwm_right_max : Reset In1_right : Set In2_right
      Reset Led0 : Reset Led1 : Reset Led2 : Reset Led3 : Reset Led4 : Reset Led5 : Set Led6 : Set Led7
      Wait 2
   Loop
Return

'**********************************************
Stop_driver:
   Pwm1b = Pwm_left_max : Reset In1_left : Set In2_left
   Pwm1a = Pwm_right_max : Reset In1_right : Set In2_right
   Waitms 2
   Pwm1b = 0 : Reset In1_left : Reset In2_left
   Pwm1a = 0 : Reset In1_right : Reset In2_right
Return

'**********************************************
Run:
   If Sensor = &B10001000 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   Elseif Sensor = &B10010100 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   Elseif Sensor = &B10100010 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   Elseif Sensor = &B11000001 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right

   Elseif Sensor = &B00000100 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = Pwm_right_min : Set In1_right : Reset In2_right
   Elseif Sensor = &B10001100 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = 0 : Reset In1_right : Reset In2_right
   Elseif Sensor = &B00000010 Then
      Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = 0 : Reset In1_right : Reset In2_right
   Elseif Sensor = &B00000001 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = 0 : Reset In1_right : Reset In2_right
   Elseif Sensor = &B10000100 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = Pwm_right_min : Set In1_right : Reset In2_right
   Elseif Sensor = &B10000001 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = 0 : Reset In1_right : Reset In2_right
   Elseif Sensor = &B10000110 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = 0 : Reset In1_right : Reset In2_right

   Elseif Sensor = &B00010000 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_min : Set In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   Elseif Sensor = &B10011000 Then
      'Gosub Stop_driver
      Pwm1b = 0 : Reset In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   Elseif Sensor = &B00100000 Then
      'Gosub Stop_driver
      Pwm1b = 0 : Reset In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   Elseif Sensor = &B01000000 Then
      'Gosub Stop_driver
      Pwm1b = 0 : Reset In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   Elseif Sensor = &B10010000 Then
      'Gosub Stop_driver
      Pwm1b = Pwm_left_max : Set In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   Elseif Sensor = &B11000000 Then
      'Gosub Stop_driver
      Pwm1b = 0 : Reset In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   Elseif Sensor = &B10110000 Then
      'Gosub Stop_driver
      Pwm1b = 0 : Reset In1_left : Reset In2_left
      Pwm1a = Pwm_right_max : Set In1_right : Reset In2_right
   End If
   'Waitms 20
Return

'**********************************************
Read_sensor:
   Sensor.6 = Pina.0
   Sensor.5 = Pina.1
   Sensor.4 = Pina.2
   Sensor.3 = Pina.4
   Sensor.2 = Pina.5
   Sensor.1 = Pina.6
   Sensor.0 = Pina.7
   Sensor.7 = Pina.3
Return

'**********************************************
Standardization:
   K = 0
   For I = 0 To 7
      If Sensor.i = 1 Then Incr K
   Next I
   If K > 4 Then Gosub Inverter
Return

'**********************************************
Inverter:
   Toggle Sensor.0
   Toggle Sensor.1
   Toggle Sensor.2
   Toggle Sensor.3
   Toggle Sensor.4
   Toggle Sensor.5
   Toggle Sensor.6
   Toggle Sensor.7
Return

'**********************************************
Led_driver:
   Led0 = Sensor.0
   Led1 = Sensor.1
   Led2 = Sensor.2
   Led3 = Sensor.3
   Led4 = Sensor.4
   Led5 = Sensor.5
   Led6 = Sensor.6
   Led7 = Sensor.7
Return