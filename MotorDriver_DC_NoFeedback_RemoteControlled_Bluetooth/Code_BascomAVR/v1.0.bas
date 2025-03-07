'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200

Config Lcd = 16 * 2
Config Lcdpin = Pin , Db4 = Porta.4 , Db5 = Porta.5 , Db6 = Porta.6 , Db7 = Porta.7 , E = Porta.2 , Rs = Porta.0
Cursor Off
Cls

Enable Interrupts

Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Down , Compare B Pwm = Disconnect , Prescale = 64
'Start Timer1
Pwm1a = 0

$baud = 9600
On Urxc Uart_receiver
Enable Urxc

Config Portd.4 = Output : Portd.4 = 1 : Hc05_reset Alias Portd.4
Config Portd.6 = Output : Portd.6 = 0 : Hc05_key Alias Portd.6

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
Dim State_direction As Byte : State_direction = 0
Dim T As Byte : T = 5

Dim J As Byte : J = 0
Dim D(3) As Byte

Dim T2 As Word : T2 = 500

Dim Buffer_uart As Byte
Dim S As String * 1

If Stop_key = 0 Then
   Waitms 30
   If Stop_key = 0 Then
      Gosub Preparation : Print "AT+RMAAD" ; Chr(13) ; Chr(10) : Waitms T2
      Gosub Preparation : Print "AT+PSWD=1234" ; Chr(13) ; Chr(10) : Waitms T2
      Gosub Preparation : Print "AT+NAME=HC-05" ; Chr(13) ; Chr(10) : Waitms T2
      Gosub Preparation : Print "AT+RESET" ; Chr(13) ; Chr(10) : Waitms T2
   End If
End If

Gosub Start_sub

Do
   'Debounce Up_key , 0 , Up_motor , Sub
   'Debounce Down_key , 0 , Down_motor , Sub
   Debounce Left_key , 0 , Anti_clockwise , Sub
   Debounce Right_key , 0 , Clockwise , Sub
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


'***********************************************
Preparation:
   Reset Hc05_reset : Waitms 10 : Set Hc05_reset : Waitms 1000
   Set Hc05_key : Waitms 10 : Reset Hc05_key : Waitms 100
Return

'***********************************************
Send_data:
   Udr = &HF1 : Waitms T
   Udr = State_direction : Waitms T
   Udr = Pwm_motor : Waitms T
Return

'***********************************************
Uart_receiver:
   Buffer_uart = Udr

   If Buffer_uart = &HF2 Then
      Disable Urxc
      Waitms 200 : Gosub Send_data
      Enable Urxc
      Goto E1
   End If

   If Buffer_uart = &HF1 And J = 0 Then
      J = 1
      D(j) = Buffer_uart
      Goto E1
   End If
   If J <> 0 Then
      J = J + 1
      D(j) = Buffer_uart
      If J = 3 Then
         Disable Urxc
         'Cls : Lcd "OK"
         If D(2) = 0 Or D(2) = 1 Or D(2) = 2 Then State_direction = D(2)
         Pwm_motor = D(3) : Pwm_motor_eeprom = Pwm_motor : Waitms 10
         'Cls : Lcd Pwm_motor : Wait 1
         J = 0
         If State_direction = 0 Then Gosub Stop_motor
         If State_direction = 1 Then Gosub Anti_clockwise
         If State_direction = 2 Then Gosub Clockwise
         If D(2) = 3 Then
            Locate 2 , 1 : Lcd Space(16)
            Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor          '; "   "
            If State_direction <> 0 Then Pwm1a = Pwm_motor
         End If
         Enable Urxc
      End If
   End If

   If J = 0 Then
      S = Chr(buffer_uart)
      Select Case S
         Case "L" :
            Disable Urxc : Gosub Anti_clockwise : Enable Urxc
         Case "R" :
            Disable Urxc : Gosub Clockwise : Enable Urxc
         Case "S" :
            Disable Urxc : Gosub Stop_motor : Enable Urxc
         Case "U" :
            Disable Urxc : Gosub Up_motor : Enable Urxc
         Case "D" :
            Disable Urxc : Gosub Down_motor : Enable Urxc
      End Select
   End If

E1:
Return

'********************************************
Start_sub:
   Cls
   'Reset In3 : Reset In4
   'Readeeprom Pwm_motor , &H00
   Pwm_motor = Pwm_motor_eeprom
   Pwm1a = 0
   Locate 1 , 1 : Lcd "Stop Motor"
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
   Gosub Send_data
Return

'********************************************
Up_motor:
 'Incr Pwm_motor
 Pwm_motor = Pwm_motor + 5
 If Pwm_motor = 4 Then Pwm_motor = 0
 If State_direction <> 0 Then
   Pwm1a = Pwm_motor
 End If
 Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
    Udr = &HF1 : Waitms T
   Udr = State_direction : Waitms T
   Udr = Pwm_motor : Waitms T
 'Writeeeprom Pwm_motor , &H00
 Pwm_motor_eeprom = Pwm_motor
Return

'********************************************
Down_motor:
 'Decr Pwm_motor
 Pwm_motor = Pwm_motor - 5
 If Pwm_motor = 251 Then Pwm_motor = 255
 If State_direction <> 0 Then
   Pwm1a = Pwm_motor
 End If
 Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
 'Writeeeprom Pwm_motor , &H00
 Gosub Send_data
 Pwm_motor_eeprom = Pwm_motor
Return

'********************************************
Stop_motor:
   State_direction = 0
   Pwm1a = 0
   Locate 1 , 1 : Lcd Space(16)
   Locate 1 , 1 : Lcd "Stop Motor"
   Gosub Send_data
   'Locate 2 , 1 : Lcd "PWM= " ; 0 ; "    "
Return

'********************************************
Anti_clockwise:
   Set Relay
   State_direction = 1
   Pwm1a = Pwm_motor
   Locate 1 , 1 : Lcd Space(16)
   Locate 1 , 1 : Lcd "Anti Clockwise"
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
   Gosub Send_data
Return

'********************************************
Clockwise:
   Reset Relay
   State_direction = 2
   Pwm1a = Pwm_motor
   Locate 1 , 1 : Lcd Space(16)
   Locate 1 , 1 : Lcd "Clockwise"
   Locate 2 , 1 : Lcd "PWM= " ; Pwm_motor ; "   "
   Gosub Send_data
Return