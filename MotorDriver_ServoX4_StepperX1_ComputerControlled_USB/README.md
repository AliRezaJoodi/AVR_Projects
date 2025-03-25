## 4-Channel Servo Motor Controller and Stepper Motor Driver, Computer Controlled, USB Interface
	   
MCU:			ATmega32A    
Computer Interfacing:	UART to USB Converter with FT232BL    
Computer Software:	MATLAB   
Servo Motor:		4x  
Stepper Motor:		1x Unipolar Stepper Motor
Isolated:		TLP521  

Note: Included schematic and PCB layout with Proteus  
Note: It's a prototype and should get better

### Command Format
Each command is made of a letter (device selector) and a number (control value).   
`XNNN`
- `X` = A, B, C, D and E
- `NNN` = number between 0 and 255

Examples:
- `A124` = Select servo 1, pulse value 124
- `B200` = Select servo 2, pulse value 200
- `C0` = Select servo 3, pulse value 0
- `D255` = Select servo 4, pulse value 255
- `E8` = Select stepper motor, output is 1000

Note: The number is converted to 4-bit binary and sent to 4 stepper motor pins:  
Example:
- `E8` = 1000
- `E3` = 0011

### Folder and Files Description
It has included:
- `Code_BascomAVR` (Code with Basic Language)
- `Code_Matlab` (Software with Matlab)
- `Hardware` (Included hardware laye)
- `Pictures` (Photos Samples Made)

### Picture: v1.0
![](Pictures/v1.0.jpg)

### Picture: v1.0 with Box
![](Pictures/v1.0_Box.jpg)

### Schematic: v1.0, Main
![](Hardware/v1.0.png)

### Schematic: v1.0, Driver
![](Hardware/v1.0_Driver.png)

My GitHub Account: [GitHub.com/AliRezaJoodi](https://github.com/AliRezaJoodi)  
**Note**: [You can go here to download a single folder or file from GitHub.com](https://minhaskamal.github.io/DownGit/#/home)
