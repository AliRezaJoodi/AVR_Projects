'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 8000000

Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Cursor Off
Cls

Config Watchdog = 256

Enable Interrupts

Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear_Up , Compare B Pwm = Disconnect , Prescale = 64
'Start Timer1
Pwm1a = 0

Enable Interrupts
Config Int0 = Rising
On Int0 T4
Enable Int0

Config Portb = Input
Config Portd.2 = Input


Config Portc.0 = Output : Portc.0 = 0 : Relay Alias Portc.0
Config Portb.4 = Output : Portb.4 = 0 : Led Alias Portb.4

'Config Porta.3 = Input

'Config Portc.6 = Input
'Config Portc.7 = Input

Dim Pwm_motor As Byte
Dim Pwm_motor_eeprom As Eram Byte

Dim I As Word
Dim Status As Byte : Status = 0
Dim B As Byte

Start Watchdog

'Gosub Eeprom_Default
Gosub Eeprom_load : Reset Watchdog
Gosub Display_lcd : Reset Watchdog
Gosub Driver : Reset Watchdog

Do
   Reset Watchdog
Loop

End


'********************************************
T4:
   Do
      Set Led
      Gosub Get_Commands

      Select Case B
         Case 8:
            Gosub Left_motor
            Gosub Display_lcd
            Gosub Driver
         Case 1:
            Gosub Right_motor
            Gosub Display_lcd
            Gosub Driver
         Case 4:
            Gosub Stop_motor
            Gosub Display_lcd
            Gosub Driver
         Case 2:
            Incr I
            If I = 11000 Then
               Gosub Up_motor
               Gosub Eeprom_save
               Gosub Display_lcd
               Gosub Driver
               I = 0
            End If
         Case 3:
            Incr I
            If I = 11000 Then
               Gosub Down_motor
               Gosub Eeprom_save
               Gosub Display_lcd
               Gosub Driver
               I = 0
            End If
      End Select
      Reset Watchdog
   Loop Until Pind.2 = 0
   B = 0 : Reset Led
Return

'********************************************
Get_Commands:
   B.0 = Pinb.0
   B.1 = Pinb.1
   B.2 = Pinb.2
   B.3 = Pinb.3
   B = B And &B00001111
Return

'********************************************
Display_lcd:
   If Status = 0 Then
      Locate 1 , 1 : Lcd "Stop Motor   "
   Elseif Status = 1 Then
      Locate 1 , 1 : Lcd "Rotate Left  "
   Elseif Status = 2 Then
      Locate 1 , 1 : Lcd "Rotate Right "
   End If
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "        "
Return

'********************************************
Up_motor:
   Pwm_motor = Pwm_motor + 5
   If Pwm_motor = 4 Then Pwm_motor = 255
Return

'********************************************
Down_motor:
   Pwm_motor = Pwm_motor - 5
   If Pwm_motor = 251 Then Pwm_motor = 0
Return

'********************************************
Stop_motor:
   Status = 0
Return

'********************************************
Left_motor:
   Status = 1
Return

'********************************************
Right_motor:
   Status = 2
Return

'********************************************
Driver:
   If Status = 0 Then
      Pwm1a = 0
   Elseif Status = 1 Then
      Set Relay : Waitms 10 : Pwm1a = Pwm_motor
   Elseif Status = 2 Then
      Reset Relay : Waitms 10 : Pwm1a = Pwm_motor
   End If
Return

'********************************************
Eeprom_save:
   Pwm_motor_eeprom = Pwm_motor
   waitms 10
Return

'********************************************
Eeprom_load:
   Pwm_motor = Pwm_motor_eeprom
Return

'********************************************
Eeprom_Default:
   Pwm_motor=125
   Pwm_motor_eeprom = Pwm_motor
   waitms 10
Return