
Config Lcdpin = Pin , Db4 = Pina.4 , Db5 = Pina.5 , Db6 = Pina.6 , Db7 = Pina.7 , E = Pina.2 , Rs = Pina.0
Config Lcd = 16 * 2
Cursor Off
Cls

Config Kbd = Portb , Debounce = 50 , Delay = 150

Config Pind.6 = Input : Portd.6 = 1 : Key Alias Pind.6
Config Portd.5 = Output : Portd.5 = 0 : Buzzer Alias Pind.5
Config Portc.3 = Output : Portc.3 = 0 : Relay Alias Portc.3