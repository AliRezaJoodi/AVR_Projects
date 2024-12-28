'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200

Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Cursor Off
Cls

Enable Interrupts

$baud = 9600
Enable Urxc                                                 'enable uart data revive interrupt
On Urxc Resive_2
'Do
   'Print "ok" : Waitms 400
'Loop


Config Timer1 = Pwm , Pwm = 10 , Compare A Pwm = Clear Down , Compare B Pwm = Disconnect , Prescale = 64
Pwm1a = 0

Config Timer2 = Timer , Prescale = 32
Enable Ovf2
On Ovf2 One_sec
Stop Timer2
Timer2 = 0

Config Pinb.0 = Input : Portb.0 = 1
Config Timer0 = Counter , Edge = Falling
Stop Counter0
Counter0 = 0

Dim I As Word : I = 0
Dim I2 As Word : I2 = 0
Dim Pwm_motor As Word : Pwm_motor = 0
Dim Rps As Word : Rps = 0
Dim Rpm As Word : Rpm = 0

Dim K As Byte
Dim Uart As Byte
Dim S As String * 16 : S = ""
Gosub Start_lcd

Start Timer2
Start Counter0

Do
   'Input Pwm_motor
   'I2 = 0
   'Pwm_motor = 1000
   'Pwm1a = Pwm_motor
   'Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "     "
Loop

End


'***********************
Resive_2:
   Uart = Udr
   Select Case Uart
      Case 48 To 57:
         S = S + Chr(uart)
      Case 13:
         Disable Urxc
         Pwm_motor = Val(s)
         'Cls : Lcd Pwm_motor
         Pwm1a = Pwm_motor
         Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "   "
         S = "" : Uart = 0
         Enable Urxc
         I2 = 0
   End Select
   'If Pwm_motor <> 13 Then
      'Lcd Pwm_motor ; " "
      'Pwm1a = Pwm_motor
      'Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "     "
   'Else
      'Cls
   'End If
Return

'***********************
Resive_2_:
   Pwm_motor = Udr
   If Pwm_motor <> 13 Then
      Pwm1a = Pwm_motor
      Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "     "
   End If
Return

'***************************************************
Start_lcd:
   Cls
   Locate 1 , 1 : Lcd "DC Motor"
   Locate 2 , 1 : Lcd "With RS232"
   Waitms 1000
   Cls
Return

'***************************************************
One_sec:
   Incr I

   If I > 675 Then
      Disable Urxc
      Incr I2
      If I2 > 11 Then
         Pwm_motor = 0 : Pwm1a = Pwm_motor
         Locate 1 , 1 : Lcd "RPM= " ; Rpm ; "      "
         Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "       "
         I2 = 0
      End If
      Stop Counter0
      Stop Timer2
      Rps = Counter0
      Rpm = Rps * 120
      Print Rpm

      Locate 1 , 1 : Lcd "RPM= " ; Rpm ; "      "
      Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "     "
      I = 0 : Timer2 = 0 : Counter0 = 0

      Start Timer2
      Start Counter0
      Enable Urxc
   End If
   'If I2 > 10 Then
      'Pwm_motor = 0 : Pwm1a = Pwm_motor
      'Locate 1 , 1 : Lcd "RPM= " ; Rpm ; "      "
      'Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "       "
      'I2 = 0
   'End If
Return

