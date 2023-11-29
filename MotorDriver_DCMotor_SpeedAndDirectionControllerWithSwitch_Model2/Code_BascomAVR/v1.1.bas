'GitHub Account: GitHub.com/AliRezaJoodi

'....................................................................
$regfile = "m16def.dat"
$crystal = 11059200


'..............................................................................
Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Cursor Off
Cls

Enable Interrupts
'........................................................................ ...................................
Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Down , Compare B Pwm = Disconnect , Prescale = 64
'Start Timer1
Pwm1a = 0

Config Debounce = 30
Config Portb.4 = Input : Portb.4 = 1 : Up_key Alias Pinb.4
Config Portb.2 = Input : Portb.2 = 1 : Down_key Alias Pinb.2
Config Portb.3 = Input : Portb.3 = 1 : Left_key Alias Pinb.3
Config Portb.0 = Input : Portb.0 = 1 : Right_key Alias Pinb.0
Config Portb.1 = Input : Portb.1 = 1 : Stop_key Alias Pinb.1

Config Portc.0 = Output : Portc.0 = 0 : Relay Alias Portc.0

Config Porta.3 = Input
Config Portd.2 = Input
Config Portd.3 = Input

Config Portc.6 = Input
Config Portc.7 = Input

'Dim P As Word
Dim Pwm_motor As Byte                                       ': Pwm_motor = 20
Dim Pwm_motor_eeprom As Eram Byte

Dim K As Word
Dim Motor_status As Bit : Motor_status = 0

Dim Pass_1_eeprom As Eram String * 1
Dim Pass_1 As String * 1
Dim Pass_status As Bit : Pass_status = 1
Gosub Create_password_1
Gosub Check_password_1
Gosub Check_password_2



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
'///////////////////////////////////////////    End Program

'********************************************      Start_sub
Start_sub:
   Cls
   'Reset In3 : Reset In4
   'Readeeprom Pwm_motor , &H00
   Pwm_motor = Pwm_motor_eeprom
   Pwm1a = 0
   Locate 1 , 1 : Lcd "Stop Motor"
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
Return

'********************************************
Up_motor:
 'Incr Pwm_motor
 Pwm_motor = Pwm_motor + 5
 If Pwm_motor = 4 Then Pwm_motor = 0
 If Motor_status = 1 Then
   Pwm1a = Pwm_motor
 End If
 Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
 'Writeeeprom Pwm_motor , &H00
 Pwm_motor_eeprom = Pwm_motor
Return

'********************************************
Down_motor:
 'Decr Pwm_motor
 Pwm_motor = Pwm_motor - 5
 If Pwm_motor = 251 Then Pwm_motor = 255
 If Motor_status = 1 Then
   Pwm1a = Pwm_motor
 End If
 Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
 'Writeeeprom Pwm_motor , &H00
 Pwm_motor_eeprom = Pwm_motor
Return

'********************************************
Stop_motor:
   Motor_status = 0
   Pwm1a = 0
   Locate 1 , 1 : Lcd "Stop Motor   "
   'Locate 2 , 1 : Lcd "PWM= " ; 0 ; "    "
Return

'********************************************
Left_motor:
   Set Relay
   Motor_status = 1
   Pwm1a = Pwm_motor
   Locate 1 , 1 : Lcd "Rotate Left  "
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
Return

'********************************************
Right_motor:
   Reset Relay
   Motor_status = 1
   Pwm1a = Pwm_motor
   Locate 1 , 1 : Lcd "Rotate Right "
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
Return

'*************************************************
Create_password_1:
   Pass_1 = "_"
   Pass_1_eeprom = Pass_1 : Waitms 10

Return

'*************************************************
Check_password_2:
   Pass_1 = Pass_1_eeprom : Waitms 10
   If Pass_1 <> "_" Or Pass_status = 1 Then
      'Do
            Cls
            Locate 1 , 1 : Lcd "This is Copy"
            Locate 2 , 1 : Lcd "09112204314"
            End
      'Loop
   End If

'*************************************************
Check_password_1:
   Config Portc.6 = Output : Portc.6 = 0
   Config Portc.7 = Input : Portc.7 = 1
   If Pinc.7 = 0 Then
      Waitms 30
      If Pinc.7 = 0 Then Pass_status = 0
   End If
   'Bitwait Pinc.7 , Reset : Waitms 100
Return