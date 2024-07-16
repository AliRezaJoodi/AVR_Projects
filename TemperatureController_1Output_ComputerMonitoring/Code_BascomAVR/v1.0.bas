'Github Account: Github.com/AliRezaJoodi

$regfile = "m32def.dat"
$crystal = 11059200

'Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.5 , Rs = Portc.6
Config Lcdpin = Pin , Db4 = Portc.3 , Db5 = Portc.2 , Db6 = Portc.1 , Db7 = Portc.0 , E = Portc.4 , Rs = Portc.6
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts

$baud = 9600
Enable Urxc                                                 'enable uart data revive interrupt
On Urxc Receive_setpoint                                    'jump to this label when reciving data from serial port

Config Adc = Single , Prescaler = Auto                      ', Reference = Internal
Start Adc

Config Timer0 = Timer , Prescale = 1024
Enable Timer0
On Timer0 32ms                                              'initial timer0 for 32ms overflow

Config Portd.6 = Output : Relay Alias Portd.6 : Reset Relay

Dim A As Byte
Dim W As Word
Dim Tmp As Word
Dim Temp_average As Word
Dim Final_temp As Byte
Dim Setpoint As Byte
Dim Relay_out As Byte
Dim Cs_temp As Word
Dim Count As Byte
Dim Serial_data(2) As Byte
Dim Uart As Byte
Dim Flag As Bit
Dim Cs As Byte

Dim Set_temp_max As Byte
Dim Set_temp_min As Byte

Deflcdchar 0 , 28 , 20 , 28 , 32 , 32 , 32 , 32 , 32

'Setpoint = 15 : Gosub Save_eeprom
Gosub Load_eeprom

Do
Loop

End

'***********************************************
Show_temp:
   Cls
   Locate 1 , 1
   Lcd "Temp: " ; Final_temp ; Chr(0) ; "C   "
   Locate 2 , 1
   Lcd "Setpoint: " ; Setpoint ; "   "
Return

'***********************************************
32ms:
   Incr Count                                               'counter for sampling tempreture
   W = Getadc(0)                                            'reading temp
   Cs_temp = W + Cs_temp                                    'adding samples
   If Count >= 30 Then                                      'when 1s expire and collect 30 samples
      Stop Timer0
      Temp_average = Cs_temp / 30                           'mean of 30 samples
      'Temp_average = Temp_average - 558                     'decrement offset
      Final_temp = Temp_average / 2                         'calculate total vaule
      'Final_temp = 27
      Gosub Send_data
      Count = 0 : Cs_temp = 0
      Gosub Show_temp
      Gosub Termostat
      Start Timer0
   End If
Return

'***********************************************
Send_data:
   Udr = &HEB : Waitms 5                                    'send first byte of frame
   Udr = Final_temp : Waitms 5                              'send temprature
   Udr = Setpoint : Waitms 5                                'send setpoint value
   Udr = Relay_out : Waitms 5                               'send satuse of relay
   Cs_temp = &HEB + Final_temp
   Cs_temp = Cs_temp + Setpoint
   Cs_temp = Cs_temp + Relay_out                            'calculate check sum                             '
   Udr = Cs_temp : Waitms 5                                 'send check sum of previous 4 byte
   Cs_temp = 0
Return

'***********************************************
Receive_setpoint:
   Uart = Udr                                               'reading uart data register (udr)
   If Flag = 0 Then
      If Uart = &HAA Then                                   'finding the first byte of frame
         Cs = &HAA
         Flag = 1
         Count = 1
      End If
   Else
      Serial_data(count) = Uart
      If Count = 2 Then                                     'counting 2 byte after detecting first byte
         If Cs = Serial_data(2) Then                        'compare calculated cs with reciving cs
            Setpoint = Serial_data(1)                       'the cs is good   byte 2 if setpoint
            Gosub Save_eeprom
         End If
         Count = 0                                          'reset serial data counter
         Flag = 0
      End If
      Incr Count
      Cs = Cs + Uart                                        'cs(check sum) calculation
   End If
Return

'***********************************************
Termostat:
   Set_temp_max = Setpoint
   Set_temp_min = Setpoint - 1
   If Final_temp > Set_temp_max Then
      Relay_out = 0 : Reset Relay
   Elseif Final_temp <= Set_temp_min Then
      Relay_out = 1 : Set Relay
   End If
Return

'***********************************************
Load_eeprom:
   Readeeprom Setpoint , &H0000                             'read saved setpoint from eeprom
Return

'***********************************************
Save_eeprom:
   Writeeeprom Setpoint , &H0000
   Waitms 10
Return