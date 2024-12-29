'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200
'$crystal = 8000000

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
Dim Pwm_motor As Word : Pwm_motor = 0
Dim Rps As Word : Rps = 0
Dim Rpm As Word : Rpm = 0

Dim Serial_data(3) As Byte
Dim A As Byte
Dim Uart As Byte
Dim Flag As Bit
Dim Count As Byte
Dim Msb_pwm_motor As Byte
Dim Lsb_pwm_motor As Byte
Dim Cs_pwm As Byte
'Dim Ao As Word
Dim Msb_rpm As Byte
Dim Lsb_rpm As Byte
Dim Cs_rpm As Byte

Dim T As Byte : T = 10
Gosub Start_lcd

Start Timer2
Start Counter0

Do
   ''Input Pwm_motor
   'Pwm1a = Pwm_motor
   'Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "     "
Loop

End

'*****************************************************
Resive_2:
Uart = Udr
If Flag = 0 Then
   If Uart = &HAA Then
      'Cs_pwm = &HAA
      Flag = 1
      Count = 1
   End If
Else
   Serial_data(count) = Uart

   If Count = 2 Then
      'If Cs_pwm = Serial_data(3) Then
         Lsb_pwm_motor = Serial_data(1)
         Msb_pwm_motor = Serial_data(2)
         Pwm_motor = Makeint(lsb_pwm_motor , Msb_pwm_motor)
            'Pwm_motor = Pwm_motor * 2
            'Pwm_motor = Pwm_motor / 3
            Pwm1a = Pwm_motor
            Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "     "
            'Locate 1 , 1 : Lcd "RPM= " ; Rpm ; "     "

      'End If
   Count = 0
   Flag = 0
   End If
Incr Count
'Cs_pwm = Cs_pwm + Uart
End If
Return

'*************************************************** 
Resive_1:
            Pwm_motor = Udr
            Pwm1a = Pwm_motor
            Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "     "
            Locate 1 , 1 : Lcd "RPM= " ; Rpm ; "     "
Return

'***************************************************
Resive_3:
Uart = Udr
   'Cls
   Lcd Uart
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
      Stop Counter0
      Stop Timer2
      'Disable Urxc
      'Disable Interrupts
      Rps = Counter0
      Rpm = Rps * 120
      'Rpm = 5000
      Lsb_rpm = Low(rpm)
      Msb_rpm = High(rpm)
      'If Lsb_rpm = 0 And Msb_rpm = 0 Then Lsb_rpm = 1
      I = 0 : Timer2 = 0 : Counter0 = 0
      Locate 1 , 1 : Lcd "RPM= " ; Rpm ; "     "
      Udr = &HAA : Waitms T
      Udr = Lsb_rpm : Waitms T
      Udr = Msb_rpm                                         ': Waitms T
      'Cs_rpm = &HAA + Lsb_rpm : Cs_rpm = Cs_rpm + Msb_rpm : Cs_rpm = Cs_rpm And &HFF
      'If Lsb_rpm = 0 And Msb_rpm = 0 Then Cs_rpm = &HAA
      'Udr = Cs_rpm : Waitms T
      'Locate 1 , 1 : Lcd "RPM= " ; Rpm ; "     "
      'Locate 2 , 1 : Lcd "Pwm= " ; Pwm_motor ; "     "

      'Enable Interrupts
      'Enable Urxc
      'WAITMS 300
      Start Timer2
      Start Counter0
   End If
Return

