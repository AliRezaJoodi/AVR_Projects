'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000


Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Cursor Off
Cls
Gosub Test_lcd

Enable Interrupts

Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Down , Compare B Pwm = Disconnect , Prescale = 64
Start Timer1
Pwm1a = 20


Config Portd.4 = Output : In3 Alias Portd.4 : Reset In3
Config Portd.6 = Output : In4 Alias Portd.6 : Reset In4

Config Debounce = 30
Config Pinc.0 = Input : Portc.0 = 1 : Up_key Alias Pinc.0
Config Pinc.1 = Input : Portc.1 = 1 : Down_key Alias Pinc.1
Config Pinc.2 = Input : Portc.2 = 1 : Left_key Alias Pinc.2
Config Pinc.3 = Input : Portc.3 = 1 : Right_key Alias Pinc.3
Config Pinc.4 = Input : Portc.4 = 1 : Stop_key Alias Pinc.4

Dim P As Word
Dim Pwm_motor As Word : Pwm_motor = 20

Dim K As Word

Gosub Stop_motor

Do
   'Debounce Up_key , 0 , Up_motor , Sub
   'Debounce Down_key , 0 , Down_motor , Sub
   Debounce Left_key , 0 , Left_motor , Sub
   Debounce Right_key , 0 , Right_motor , Sub
   Debounce Stop_key , 0 , Stop_motor , Sub
   If Up_key = 0 Then
      Incr K
      If K = 16000 Then
         Gosub Up_motor
         K = 0
      End If
   End If

      If Down_key = 0 Then
      Incr K
      If K = 16000 Then
         Gosub Down_motor
         K = 0
      End If
   End If

Loop

End


Test_lcd:
   Cls
   Locate 1 , 1 : Lcd "Stop Engine"
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
Return

Lcd_drive:

Return

Up_motor:
 'Incr Pwm_motor
 Pwm_motor = Pwm_motor + 5
 Pwm1a = Pwm_motor
 Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
Return

Down_motor:
 'Decr Pwm_motor
 Pwm_motor=Pwm_motor-5
 Pwm1a = Pwm_motor
 Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
Return

Stop_motor:
   Reset In3 : Reset In4
   Locate 1 , 1 : Lcd "Stop Engine"
Return

Left_motor:
   Set In3 : Reset In4
   Locate 1 , 1 : Lcd "Rotate Left  "
Return

Right_motor:
   Reset In3 : Set In4
   Locate 1 , 1 : Lcd "Rotate Right "
Return