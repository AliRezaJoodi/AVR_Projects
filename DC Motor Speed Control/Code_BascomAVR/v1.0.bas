'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcdpin = Pin , Rs = Porta.0 , E = Porta.2 , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts

Config Portd.5 = Output : Portd.5 = 0 : Ena Alias Portd.5
Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Up , Compare B Pwm = Disconnect , Prescale = 64
Pwm1a = 0

Config Portd.2 = Output : Portd.2 = 0 : Motor_port1 Alias Portd.2
Config Portd.3 = Output : Portd.3 = 0 : Motor_port2 Alias Portd.3

Config Debounce = 30
Config Portb.0 = Input : Portb.0 = 1 : Key_front Alias Pinb.0
Config Portb.1 = Input : Portb.1 = 1 : Key_stop Alias Pinb.1
Config Portb.2 = Input : Portb.2 = 1 : Key_back Alias Pinb.2
Config Portb.3 = Input : Portb.3 = 1 : Key_up Alias Pinb.3
Config Portb.4 = Input : Portb.4 = 1 : Key_down Alias Pinb.4

Dim Pwm_value As Byte : Pwm_value = 250
Dim Direction As String * 5 : Direction = "Stop"

Gosub Direction_stop
Gosub Lcd_driver

Do
   Debounce Key_front , 0 , Direction_front , Sub
   Debounce Key_stop , 0 , Direction_stop , Sub
   Debounce Key_back , 0 , Direction_back , Sub
   Debounce Key_up , 0 , Speed_incr , Sub
   Debounce Key_down , 0 , Speed_decr , Sub

   Gosub Lcd_driver
   Pwm1a = Pwm_value
Loop

End

'**************************
Direction_front:
   Direction = "Front"
   Motor_port1 = 0 : Motor_port2 = 1
Return

'**************************
Direction_back:
   Direction = "Back"
   Motor_port1 = 1 : Motor_port2 = 0
Return

'**************************
Direction_stop:
   Direction = "Stop"
   Motor_port1 = 0 : Motor_port2 = 0
Return

'**************************
Lcd_driver:
   Locate 1 , 1 : Lcd "Direct: " ; Direction ; "  "
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_value ; "  "
Return

'**************************
Speed_incr:
   Pwm_value = Pwm_value + 10
Return

'**************************
Speed_decr:
   Pwm_value = Pwm_value - 10
Return
