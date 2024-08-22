'GitHub Account: GitHub.com/AliRezaJoodi

$regfile = "M8def.dat"
$crystal = 1000000

Config Pind.3 = Output: ALARM Alias Portd.3 :ALARM=0

Config Pinb.1 = Input :Portb.1 = 1
Config Pinb.2 = Input  :Portb.2 = 1

Dim status As Byte
status=0

Do
   If Pinb.1 = 0 Then
      waitms 30
      If Pinb.1 = 0 Then  status=1
   end if

   If Pinb.2 = 1 Then
      waitms 30
      If Pinb.2 = 1 Then  status=1
   end if

   ALARM=status
Loop

End

