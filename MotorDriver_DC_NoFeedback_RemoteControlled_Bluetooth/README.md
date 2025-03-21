## DC Motor Driver, No Feedback, Remote Controlled, Bluetooth Interface, Optically Isolated
Note: This is just a prototype and needs improvement. 

### Pictures
v1.0
![](Pictures/v1.0.jpg)

### Features
MCU: ATmega32A  
Driver: Mosfet for Speed Controller  
Driver: Relay for Direction Controller  
Bluetooth module: HC-05  
Isolated: TLP521

### Command Format 
Commands can be sent from any device with Bluetooth, like a computer or smartphone. 
- Anti-Clockwise: "L"  
- Clockwise: "R"  
- Stop: "S"  
- Increase Speed: "U"  
- Decrease Speed: "D"  

### Folders and Files
This project includes:
- `Code_BascomAVR` _ Microcontroller Programming with Basic Language in BASCOM-AVR
- `Hardware` _ Included schematic and PCB layout with Proteus
- `Pictures` _ Sample Photos of Projects

### Schematic
v1.0, DC Motor Driver
![](Hardware/v1.0_Driver.png)

v1.0, Main
![](Hardware/v1.0.png)

### More Information
My GitHub Account: [GitHub.com/AliRezaJoodi](https://github.com/AliRezaJoodi)  
**Note**: [You can go here to download a single folder or file from GitHub.com](https://minhaskamal.github.io/DownGit/#/home)
