'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8def.dat"
$crystal = 8000000
$baud = 9600

Enable Interrupts
Config Scl = Portd.4
Config Sda = Portd.3
'Const Comps10_i2c_address = &HC0

Config Portc.3 = Output : Portc.3 = 0 : Led Alias Portc.3

Dim Compass As Word
Dim Compass_msb As Byte
Dim Compass_lsb As Byte
Dim Compass_1 As Single

Dim Pitch_angle As Byte
Dim Roll_angle As Byte

Dim Magnetometer_x_msb As Byte
Dim Magnetometer_x_lsb As Byte
Dim Magnetometer_x As Word

Dim Magnetometer_y_msb As Byte
Dim Magnetometer_y_lsb As Byte
Dim Magnetometer_y As Word

Dim Magnetometer_z_msb As Byte
Dim Magnetometer_z_lsb As Byte
Dim Magnetometer_z As Word

Dim Accelerometer_x_msb As Byte
Dim Accelerometer_x_lsb As Byte
Dim Accelerometer_x As Word

Dim Accelerometer_y_msb As Byte
Dim Accelerometer_y_lsb As Byte
Dim Accelerometer_y As Word

Dim Accelerometer_z_msb As Byte
Dim Accelerometer_z_lsb As Byte
Dim Accelerometer_z As Word

Reset Led : Waitms 300 : Set Led

Do
   Reset Led
   Gosub Get_compass : Gosub Display_compass
   Gosub Get_pitch_angle : Gosub Display_pitch_angle
   Gosub Get_roll_angle : Gosub Display_roll_angle
   Gosub Get_magnetometer : Gosub Display_magnetometer
   Gosub Get_accelerometer : Gosub Display_accelerometer
   Print
   Set Led
   Waitms 1000
Loop

End

'******************************************************
Display_compass:
   'Print "Compass: " ; Compass
   Compass_1 = Compass : Compass_1 = Compass_1 / 10
   Print "Compass: " ; Fusing(compass_1 , "#.#") ; " Degrees"
Return

'******************************************************
Display_pitch_angle:
   Print "Pitch angle: " ; Pitch_angle
Return

'******************************************************
Display_roll_angle:
   Print "Roll angle: " ; Roll_angle
Return

'******************************************************
Display_magnetometer:
      Print "Magnetometer x,y,z: " ; Magnetometer_x ; " , " ; Magnetometer_y ; " , " ; Magnetometer_z
Return

'******************************************************
Display_accelerometer:
      Print "Accelerometer x,y,z: " ; Accelerometer_x ; " , " ; Accelerometer_y ; " , " ; Accelerometer_z
Return

'******************************************************
Get_compass:
   I2cstart
   I2cwbyte &HC0
   I2cwbyte 2
   I2cstop

   I2cstart
   I2cwbyte &HC1
   I2crbyte Compass_msb , Ack
   I2crbyte Compass_lsb , Nack
   I2cstop
   Compass = Makeint(compass_lsb , Compass_msb)
Return

'******************************************************
Get_pitch_angle:
   I2cstart
   I2cwbyte &HC0
   I2cwbyte 4
   I2cstop

   I2cstart
   I2cwbyte &HC1
   I2crbyte Pitch_angle , Nack
   I2cstop
Return

'******************************************************
Get_roll_angle:
   I2cstart
   I2cwbyte &HC0
   I2cwbyte 5
   I2cstop

   I2cstart
   I2cwbyte &HC1
   I2crbyte Roll_angle , Nack
   I2cstop
Return

'******************************************************
Get_magnetometer:
   I2cstart
   I2cwbyte &HC0
   I2cwbyte 10
   I2cstop

   I2cstart
   I2cwbyte &HC1
   I2crbyte Magnetometer_x_msb , Ack
   I2crbyte Magnetometer_x_lsb , Ack
   I2crbyte Magnetometer_y_msb , Ack
   I2crbyte Magnetometer_y_lsb , Ack
   I2crbyte Magnetometer_z_msb , Ack
   I2crbyte Magnetometer_z_lsb , Nack
   I2cstop
   Magnetometer_x = Makeint(magnetometer_x_lsb , Magnetometer_x_msb)
   Magnetometer_y = Makeint(magnetometer_y_lsb , Magnetometer_y_msb)
   Magnetometer_z = Makeint(magnetometer_z_lsb , Magnetometer_z_msb)
Return

'******************************************************
Get_accelerometer:
   I2cstart
   I2cwbyte &HC0
   I2cwbyte 16
   I2cstop

   I2cstart
   I2cwbyte &HC1
   I2crbyte Accelerometer_x_msb , Ack
   I2crbyte Accelerometer_x_lsb , Ack
   I2crbyte Accelerometer_y_msb , Ack
   I2crbyte Accelerometer_y_lsb , Ack
   I2crbyte Accelerometer_z_msb , Ack
   I2crbyte Accelerometer_z_lsb , Nack
   I2cstop
   Accelerometer_x = Makeint(accelerometer_x_lsb , Accelerometer_x_msb)
   Accelerometer_y = Makeint(accelerometer_y_lsb , Accelerometer_y_msb)
   Accelerometer_z = Makeint(accelerometer_z_lsb , Accelerometer_z_msb)
Return

'******************************************************
T0:
   Do
      Print "ok" : Waitms 800
   Loop
Return