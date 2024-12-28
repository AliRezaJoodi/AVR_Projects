'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200


Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Cursor Off
Cls

Enable Interrupts

Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Disconnect , Compare B Pwm = Clear Down , Prescale = 1
'Start Timer1
Pwm1b = 0


Config Portc.0 = Output : In3 Alias Portc.0 : Reset In3
Config Portc.1 = Output : In4 Alias Portc.1 : Reset In4

Config Debounce = 30
Config Portb.4 = Input : Portb.4 = 1 : Up_key Alias Pinb.4
Config Portb.2 = Input : Portb.2 = 1 : Down_key Alias Pinb.2
Config Portb.3 = Input : Portb.3 = 1 : Left_key Alias Pinb.3
Config Portb.0 = Input : Portb.0 = 1 : Right_key Alias Pinb.0
Config Portb.1 = Input : Portb.1 = 1 : Stop_key Alias Pinb.1

Config Porta.3 = Input
Config Portd.2 = Input
Config Portd.3 = Input


'Dim P As Word
Dim Pwm_motor As Byte                                       ': Pwm_motor = 20

Dim K As Word

Gosub Start_sub

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

'********************************************
Start_sub:
   Cls
   Reset In3 : Reset In4
   Readeeprom Pwm_motor , &H00
   Pwm1b = Pwm_motor
   Locate 1 , 1 : Lcd "Stop Motor"
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
Return

'********************************************
Up_motor:
 'Incr Pwm_motor
 Pwm_motor = Pwm_motor + 5
 If Pwm_motor = 4 Then Pwm_motor = 0
 Pwm1b = Pwm_motor
 Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
 Writeeeprom Pwm_motor , &H00
Return

'********************************************
Down_motor:
 'Decr Pwm_motor
 Pwm_motor = Pwm_motor - 5
 If Pwm_motor = 251 Then Pwm_motor = 255
 Pwm1b = Pwm_motor
 Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
 Writeeeprom Pwm_motor , &H00
Return

'********************************************
Stop_motor:
   Reset In3 : Reset In4
   Locate 1 , 1 : Lcd "Stop Motor   "
Return

'********************************************
Left_motor:
   Set In3 : Reset In4
   Locate 1 , 1 : Lcd "Rotate Left  "
Return

'********************************************
Right_motor:
   Reset In3 : Set In4
   Locate 1 , 1 : Lcd "Rotate Right "
Return