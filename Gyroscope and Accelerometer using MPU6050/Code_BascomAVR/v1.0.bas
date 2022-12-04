'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M32def.dat"
$crystal = 4000000
$baud = 9600

Led_1 Alias Porta.0 : Config Led_1 = Output : Led_1 = 0

Enable Interrupts

Config Scl = Portc.0
Config Sda = Portc.1
'I2cinit

Const Mpu6050_i2c_address = &H68
Const Mpu6050_address = &H68
'Const Mpu6050_address = &HD0

Const Mpu6050_ra_xg_offs_tc = &H00                          '[7] PWR_MODE, [6:1] XG_OFFS_TC, [0] OTP_BNK_VLD
Const Mpu6050_ra_yg_offs_tc = &H01                          '[7] PWR_MODE, [6:1] YG_OFFS_TC, [0] OTP_BNK_VLD
Const Mpu6050_ra_zg_offs_tc = &H02                          '[7] PWR_MODE, [6:1] ZG_OFFS_TC, [0] OTP_BNK_VLD
Const Mpu6050_ra_x_fine_gain = &H03                         '[7:0] X_FINE_GAIN
Const Mpu6050_ra_y_fine_gain = &H04                         '[7:0] Y_FINE_GAIN
Const Mpu6050_ra_z_fine_gain = &H05                         '[7:0] Z_FINE_GAIN
Const Mpu6050_ra_xa_offs_h = &H06                           '[15:0] XA_OFFS
Const Mpu6050_ra_xa_offs_l_tc = &H07
Const Mpu6050_ra_ya_offs_h = &H08                           '[15:0] YA_OFFS
Const Mpu6050_ra_ya_offs_l_tc = &H09
Const Mpu6050_ra_za_offs_h = &H0A                           '[15:0] ZA_OFFS
Const Mpu6050_ra_za_offs_l_tc = &H0B
Const Mpu6050_ra_xg_offs_usrh = &H13                        '[15:0] XG_OFFS_USR
Const Mpu6050_ra_xg_offs_usrl = &H14
Const Mpu6050_ra_yg_offs_usrh = &H15                        '[15:0] YG_OFFS_USR
Const Mpu6050_ra_yg_offs_usrl = &H16
Const Mpu6050_ra_zg_offs_usrh = &H17                        '[15:0] ZG_OFFS_USR
Const Mpu6050_ra_zg_offs_usrl = &H18
Const Mpu6050_ra_smplrt_div = &H19
Const Mpu6050_ra_config = &H1A
Const Mpu6050_ra_gyro_config = &H1B
Const Mpu6050_ra_accel_config = &H1C
Const Mpu6050_ra_ff_thr = &H1D
Const Mpu6050_ra_ff_dur = &H1E
Const Mpu6050_ra_mot_thr = &H1F
Const Mpu6050_ra_mot_dur = &H20
Const Mpu6050_ra_zrmot_thr = &H21
Const Mpu6050_ra_zrmot_dur = &H22
Const Mpu6050_ra_fifo_en = &H23
Const Mpu6050_ra_i2c_mst_ctrl = &H24
Const Mpu6050_ra_i2c_slv0_addr = &H25
Const Mpu6050_ra_i2c_slv0_reg = &H26
Const Mpu6050_ra_i2c_slv0_ctrl = &H27
Const Mpu6050_ra_i2c_slv1_addr = &H28
Const Mpu6050_ra_i2c_slv1_reg = &H29
Const Mpu6050_ra_i2c_slv1_ctrl = &H2A
Const Mpu6050_ra_i2c_slv2_addr = &H2B
Const Mpu6050_ra_i2c_slv2_reg = &H2C
Const Mpu6050_ra_i2c_slv2_ctrl = &H2D
Const Mpu6050_ra_i2c_slv3_addr = &H2E
Const Mpu6050_ra_i2c_slv3_reg = &H2F
Const Mpu6050_ra_i2c_slv3_ctrl = &H30
Const Mpu6050_ra_i2c_slv4_addr = &H31
Const Mpu6050_ra_i2c_slv4_reg = &H32
Const Mpu6050_ra_i2c_slv4_do = &H33
Const Mpu6050_ra_i2c_slv4_ctrl = &H34
Const Mpu6050_ra_i2c_slv4_di = &H35
Const Mpu6050_ra_i2c_mst_status = &H36
Const Mpu6050_ra_int_pin_cfg = &H37
Const Mpu6050_ra_int_enable = &H38
Const Mpu6050_ra_dmp_int_status = &H39
Const Mpu6050_ra_int_status = &H3A
Const Mpu6050_ra_accel_xout_h = &H3B
Const Mpu6050_ra_accel_xout_l = &H3C
Const Mpu6050_ra_accel_yout_h = &H3D
Const Mpu6050_ra_accel_yout_l = &H3E
Const Mpu6050_ra_accel_zout_h = &H3F
Const Mpu6050_ra_accel_zout_l = &H40
Const Mpu6050_ra_temp_out_h = &H41
Const Mpu6050_ra_temp_out_l = &H42
Const Mpu6050_ra_gyro_xout_h = &H43
Const Mpu6050_ra_gyro_xout_l = &H44
Const Mpu6050_ra_gyro_yout_h = &H45
Const Mpu6050_ra_gyro_yout_l = &H46
Const Mpu6050_ra_gyro_zout_h = &H47
Const Mpu6050_ra_gyro_zout_l = &H48
Const Mpu6050_ra_ext_sens_data_00 = &H49
Const Mpu6050_ra_ext_sens_data_01 = &H4A
Const Mpu6050_ra_ext_sens_data_02 = &H4B
Const Mpu6050_ra_ext_sens_data_03 = &H4C
Const Mpu6050_ra_ext_sens_data_04 = &H4D
Const Mpu6050_ra_ext_sens_data_05 = &H4E
Const Mpu6050_ra_ext_sens_data_06 = &H4F
Const Mpu6050_ra_ext_sens_data_07 = &H50
Const Mpu6050_ra_ext_sens_data_08 = &H51
Const Mpu6050_ra_ext_sens_data_09 = &H52
Const Mpu6050_ra_ext_sens_data_10 = &H53
Const Mpu6050_ra_ext_sens_data_11 = &H54
Const Mpu6050_ra_ext_sens_data_12 = &H55
Const Mpu6050_ra_ext_sens_data_13 = &H56
Const Mpu6050_ra_ext_sens_data_14 = &H57
Const Mpu6050_ra_ext_sens_data_15 = &H58
Const Mpu6050_ra_ext_sens_data_16 = &H59
Const Mpu6050_ra_ext_sens_data_17 = &H5A
Const Mpu6050_ra_ext_sens_data_18 = &H5B
Const Mpu6050_ra_ext_sens_data_19 = &H5C
Const Mpu6050_ra_ext_sens_data_20 = &H5D
Const Mpu6050_ra_ext_sens_data_21 = &H5E
Const Mpu6050_ra_ext_sens_data_22 = &H5F
Const Mpu6050_ra_ext_sens_data_23 = &H60
Const Mpu6050_ra_mot_detect_status = &H61
Const Mpu6050_ra_i2c_slv0_do = &H63
Const Mpu6050_ra_i2c_slv1_do = &H64
Const Mpu6050_ra_i2c_slv2_do = &H65
Const Mpu6050_ra_i2c_slv3_do = &H66
Const Mpu6050_ra_i2c_mst_delay_ctrl = &H67
Const Mpu6050_ra_signal_path_reset = &H68
Const Mpu6050_ra_mot_detect_ctrl = &H69
Const Mpu6050_ra_user_ctrl = &H6A
Const Mpu6050_ra_pwr_mgmt_1 = &H6B
Const Mpu6050_ra_pwr_mgmt_2 = &H6C
Const Mpu6050_ra_bank_sel = &H6D
Const Mpu6050_ra_mem_start_addr = &H6E
Const Mpu6050_ra_mem_r_w = &H6F
Const Mpu6050_ra_dmp_cfg_1 = &H70
Const Mpu6050_ra_dmp_cfg_2 = &H71
Const Mpu6050_ra_fifo_counth = &H72
Const Mpu6050_ra_fifo_countl = &H73
Const Mpu6050_ra_fifo_r_w = &H74
Const Mpu6050_ra_who_am_i = &H75


Dim Gyroscope_x As Word
Dim Gyroscope_y As Word
Dim Gyroscope_z As Word
Dim Gyroscope_x_msb As Byte
Dim Gyroscope_x_lsb As Byte
Dim Gyroscope_y_msb As Byte
Dim Gyroscope_y_lsb As Byte
Dim Gyroscope_z_msb As Byte
Dim Gyroscope_z_lsb As Byte

Dim Accelerometer_x As Word
Dim Accelerometer_y As Word
Dim Accelerometer_z As Word
Dim Accelerometer_x_msb As Byte
Dim Accelerometer_x_lsb As Byte
Dim Accelerometer_y_msb As Byte
Dim Accelerometer_y_lsb As Byte
Dim Accelerometer_z_msb As Byte
Dim Accelerometer_z_lsb As Byte

Dim Temperature As Word
Dim Temperature_msb As Byte
Dim Temperature_lsb As Byte

Set Led_1 : Waitms 200 : Reset Led_1

Do
   Gosub Mpu6050_config : Gosub Mpu6050_verify
   Gosub Mpu6050_gyroscope
   Gosub Mpu6050_accelerometer
   Gosub Display_uart
   Reset Led_1 : Waitms 900 : Set Led_1
Loop

End

'******************************************************
Display_lcd:

Return

'******************************************************
Display_uart:
   Print "Temperature: " ; Temperature
   Print "Gyroscope x,y,z: " ; Gyroscope_x ; " , " ; Gyroscope_y ; " , " ; Gyroscope_z
   Print "Accelerometer x,y,z: " ; Accelerometer_x ; " , " ; Accelerometer_y ; " , " ; Accelerometer_z
   Print
Return

'******************************************************
Mpu6050_config:
   I2cstart
   I2cwbyte Mpu6050_address
   I2cwbyte Mpu6050_ra_pwr_mgmt_1
   I2cwbyte &B00000011
   I2cstop

   I2cstart
   I2cwbyte Mpu6050_i2c_address
   I2cwbyte 26
   I2cwbyte &B00000011
   I2cstop

   I2cstart
   I2cwbyte Mpu6050_i2c_address
   I2cwbyte 25
   I2cwbyte 4
   I2cstop

   I2cstart
   I2cwbyte Mpu6050_i2c_address
   I2cwbyte 27
   I2cwbyte &B00011000
   I2cstop

   I2cstart
   I2cwbyte Mpu6050_i2c_address
   I2cwbyte 28
   I2cwbyte &B00000000
   I2cstop

Return

'******************************************************
Mpu6050_verify:
   I2cstart
   I2cwbyte Mpu6050_address
   I2cwbyte Mpu6050_ra_who_am_i
   I2cstop
   I2cstart
   I2cwbyte Mpu6050_address
   I2crbyte Gyroscope_x_msb , Nack
   I2cstop
   Print "MPU6050 Address: " ; Gyroscope_x_msb
Return

'******************************************************
Mpu6050_gyroscope:
   I2cstart
   I2cwbyte Mpu6050_i2c_address
   I2cwbyte 67
   I2cstop
   I2cstart
   I2cwbyte Mpu6050_i2c_address
   I2crbyte Gyroscope_x_msb , Ack
   I2crbyte Gyroscope_x_lsb , Ack
   I2crbyte Gyroscope_y_msb , Ack
   I2crbyte Gyroscope_y_lsb , Ack
   I2crbyte Gyroscope_z_msb , Ack
   I2crbyte Gyroscope_z_lsb , Nack
   I2cstop
   Gyroscope_x = Makeint(gyroscope_x_lsb , Gyroscope_x_msb)
   Gyroscope_y = Makeint(gyroscope_y_lsb , Gyroscope_y_msb)
   Gyroscope_z = Makeint(gyroscope_z_lsb , Gyroscope_z_msb)
Return


'******************************************************
Mpu6050_accelerometer:
   I2cstart
   I2cwbyte Mpu6050_i2c_address
   I2cwbyte 59
   I2cstop
   I2cstart
   I2cwbyte Mpu6050_i2c_address
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
Mpu6050_temperature:
   Temperature = Makeint(temperature_lsb , Temperature_msb)
Return