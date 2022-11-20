$regfile = "m32def.dat"
$crystal = 1000000

Activate Alias 1
Deactivate Alias 0
A1 Alias Portc.0 : Config A1 = Output : A1 = Deactivate
A2 Alias Portc.1 : Config A2 = Output : A2 = Deactivate
B2 Alias Portc.2 : Config B2 = Output : B2 = Deactivate
B1 Alias Portc.3 : Config B1 = Output : B1 = Deactivate

Dim Index As Byte : Index = 7
Dim Number_steps As Integer

Declare Sub Driver_cw_full(byval Number As Integer , Byval Lag As Integer)
Declare Sub Driver_cw_half(byval Number As Integer , Byval Lag As Integer)
Declare Sub Driver_ccw_full(byval Number As Integer , Byval Lag As Integer)
Declare Sub Driver_ccw_half(byval Number As Integer , Byval Lag As Integer)
Declare Sub Driver_port(byval Data_step As Byte)

Waitms 500

Do
   'Number_steps = 4 : Call Driver_cw_full(number_steps , 500) : Wait 2
   'Number_steps = 8 : Call Driver_cw_half(number_steps , 500) : Wait 2
   'Number_steps = 4 : Call Driver_ccw_full(number_steps , 500) : Wait 2
   Number_steps = 8 : Call Driver_ccw_half(number_steps , 500) : Wait 2
Loop

End

'***************************************************
Sub Driver_ccw_half(byval Number As Integer , Byval Lag As Integer)
   Local Count As Byte : Count = 0
   Local Data_step As Byte : Count = 0
   Do
      Data_step = Lookup(index , Table2)
      Call Driver_port(data_step) : Incr Count
      Waitms Lag
      Index = Index - 1 : If Index > 7 Then Index = 7
   Loop Until Count >= Number
   Count = 0
End Sub

'***************************************************
Sub Driver_cw_half(byval Number As Integer , Byval Lag As Integer)
   Local Count As Byte : Count = 0
   Local Data_step As Byte : Count = 0
   Do
      Data_step = Lookup(index , Table2)
      Call Driver_port(data_step) : Incr Count
      Waitms Lag
      Index = Index + 1 : If Index > 7 Then Index = 0
   Loop Until Count >= Number
   Count = 0
End Sub

'***************************************************
Sub Driver_ccw_full(byval Number As Integer , Byval Lag As Integer)
   Local Count As Byte : Count = 0
   Local Data_step As Byte : Count = 0
   Do
      Data_step = Lookup(index , Table1)
      Call Driver_port(data_step) : Incr Count
      Waitms Lag
      Index = Index - 1 : If Index > 3 Then Index = 3
   Loop Until Count >= Number
   Count = 0
End Sub

'***************************************************
Sub Driver_cw_full(byval Number As Integer , Byval Lag As Integer)
   Local Count As Byte : Count = 0
   Local Data_step As Byte : Count = 0
   Do
      Data_step = Lookup(index , Table1)
      Call Driver_port(data_step) : Incr Count
      Waitms Lag
      Index = Index + 1 : If Index > 3 Then Index = 0
   Loop Until Count >= Number
   Count = 0
End Sub

'***************************************************
Sub Driver_port(byval Data_step As Byte)
   A1 = Data_step.0
   A2 = Data_step.1
   B2 = Data_step.2
   B1 = Data_step.3
End Sub

'***************************************************
Table1:
Data &B1000
Data &B0100
Data &B0010
Data &B0001

'***************************************************
Table2:
Data &B00000001
Data &B00000011
Data &B00000010
Data &B00000110
Data &B00000100
Data &B00001100
Data &B00001000
Data &B00001001