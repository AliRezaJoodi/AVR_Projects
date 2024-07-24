VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H80000000&
   Caption         =   "Humidity and Temperature Controller"
   ClientHeight    =   5280
   ClientLeft      =   2025
   ClientTop       =   3375
   ClientWidth     =   10260
   LinkTopic       =   "Form1"
   ScaleHeight     =   5280
   ScaleWidth      =   10260
   Begin VB.Frame Frame2 
      BackColor       =   &H80000000&
      Caption         =   "Humidity Monitoring"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1875
      Left            =   120
      TabIndex        =   18
      Top             =   1440
      Width           =   10095
      Begin VB.TextBox Change_Humidity_Max 
         BackColor       =   &H00E0E0E0&
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0/0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1065
            SubFormatType   =   1
         EndProperty
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   5520
         MaxLength       =   3
         TabIndex        =   20
         Top             =   1320
         Width           =   915
      End
      Begin VB.TextBox Change_Humidity_Min 
         BackColor       =   &H00E0E0E0&
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0/0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1065
            SubFormatType   =   1
         EndProperty
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   250
         MaxLength       =   4
         TabIndex        =   19
         Top             =   1320
         Width           =   915
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "Humidity ( %)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   5
         Left            =   2880
         TabIndex        =   30
         Top             =   360
         Width           =   1455
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "Setpoint ( MAX )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   3
         Left            =   5520
         TabIndex        =   29
         Top             =   360
         Width           =   1455
      End
      Begin VB.Label Display_Humidity 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "100"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   48
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1035
         Left            =   2160
         TabIndex        =   28
         Top             =   720
         Width           =   2760
      End
      Begin VB.Label Display_Humidity_Max 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "100"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   24
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00808080&
         Height          =   555
         Left            =   5520
         TabIndex        =   27
         Top             =   720
         Width           =   1350
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "Setpoint ( MIN )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   2
         Left            =   255
         TabIndex        =   26
         Top             =   360
         Width           =   1455
      End
      Begin VB.Label Display_Humidity_Min 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "100"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   24
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00808080&
         Height          =   555
         Left            =   255
         TabIndex        =   25
         Top             =   720
         Width           =   1350
      End
      Begin VB.Label Label2 
         BackColor       =   &H80000000&
         Caption         =   "(%)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Index           =   2
         Left            =   1200
         TabIndex        =   24
         Top             =   1320
         Width           =   375
      End
      Begin VB.Label Label2 
         BackColor       =   &H80000000&
         Caption         =   "(%)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   0
         Left            =   6480
         TabIndex        =   23
         Top             =   1320
         Width           =   375
      End
      Begin VB.Label Label4 
         Alignment       =   2  'Center
         BackColor       =   &H00C0C0FF&
         BackStyle       =   0  'Transparent
         Caption         =   "Dehumidifiers"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Left            =   7800
         TabIndex        =   22
         Top             =   1320
         Width           =   2055
      End
      Begin VB.Label Label3 
         Alignment       =   2  'Center
         BackColor       =   &H00C0C0FF&
         BackStyle       =   0  'Transparent
         Caption         =   "Humidifier"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Left            =   7800
         TabIndex        =   21
         Top             =   600
         Width           =   2055
      End
      Begin VB.Shape Status_Dehumidifiers 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   525
         Left            =   7800
         Shape           =   4  'Rounded Rectangle
         Top             =   1200
         Width           =   2010
      End
      Begin VB.Shape Status_Humidifier 
         BackColor       =   &H0000FF00&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   525
         Left            =   7800
         Shape           =   4  'Rounded Rectangle
         Top             =   480
         Width           =   2010
      End
   End
   Begin VB.Frame Frame4 
      BackColor       =   &H80000000&
      Caption         =   "Communication"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1275
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   10095
      Begin VB.CommandButton Command1 
         Caption         =   "Start"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   250
         TabIndex        =   13
         Top             =   720
         Width           =   4335
      End
      Begin VB.CommandButton Command2 
         Caption         =   "Stop"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   5400
         TabIndex        =   12
         Top             =   720
         Width           =   4575
      End
      Begin VB.ComboBox Combo1 
         BackColor       =   &H00E0E0E0&
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   11.25
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   8640
         TabIndex        =   4
         Text            =   "1"
         Top             =   240
         Width           =   1215
      End
      Begin VB.Label Label7 
         BackColor       =   &H80000000&
         Caption         =   "COM Port Number"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         TabIndex        =   5
         Top             =   360
         Width           =   1815
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H80000000&
      Caption         =   "Temp Monitoring"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1875
      Left            =   120
      TabIndex        =   0
      Top             =   3360
      Width           =   10095
      Begin VB.TextBox Change_Temp_Min 
         BackColor       =   &H00E0E0E0&
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0/0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1065
            SubFormatType   =   1
         EndProperty
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   250
         MaxLength       =   4
         TabIndex        =   15
         Top             =   1320
         Width           =   915
      End
      Begin VB.TextBox Change_Temp_Max 
         BackColor       =   &H00E0E0E0&
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0/0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1065
            SubFormatType   =   1
         EndProperty
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   5520
         MaxLength       =   3
         TabIndex        =   14
         Top             =   1320
         Width           =   915
      End
      Begin VB.Label Label5 
         Alignment       =   2  'Center
         BackColor       =   &H00C0C0FF&
         BackStyle       =   0  'Transparent
         Caption         =   "Heater"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Left            =   7800
         TabIndex        =   6
         Top             =   1320
         Width           =   2055
      End
      Begin VB.Label Label6 
         Alignment       =   2  'Center
         BackColor       =   &H00C0C0FF&
         BackStyle       =   0  'Transparent
         Caption         =   "Fan"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Left            =   7800
         TabIndex        =   7
         Top             =   600
         Width           =   2055
      End
      Begin VB.Shape Status_Fan 
         BackColor       =   &H0000FF00&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   525
         Left            =   7800
         Shape           =   4  'Rounded Rectangle
         Top             =   480
         Width           =   2010
      End
      Begin VB.Label Label2 
         BackColor       =   &H80000000&
         Caption         =   "('c)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   5
         Left            =   6480
         TabIndex        =   17
         Top             =   1320
         Width           =   375
      End
      Begin VB.Label Label2 
         BackColor       =   &H80000000&
         Caption         =   "('c)"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   1
         Left            =   1200
         TabIndex        =   16
         Top             =   1320
         Width           =   375
      End
      Begin VB.Label Display_Temp_Min 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "999.9"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   24
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00808080&
         Height          =   555
         Left            =   255
         TabIndex        =   11
         Top             =   720
         Width           =   1350
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "Setpoint ( MIN )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   4
         Left            =   255
         TabIndex        =   10
         Top             =   360
         Width           =   1455
      End
      Begin VB.Label Display_Temp_Max 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "999.9"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   24
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00808080&
         Height          =   555
         Left            =   5520
         TabIndex        =   9
         Top             =   720
         Width           =   1350
      End
      Begin VB.Label Display_Temp 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "999.9"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   48
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1035
         Left            =   2160
         TabIndex        =   8
         Top             =   720
         Width           =   2760
      End
      Begin VB.Shape Status_Heater 
         BackColor       =   &H000000FF&
         BackStyle       =   1  'Opaque
         FillColor       =   &H000000FF&
         Height          =   525
         Left            =   7800
         Shape           =   4  'Rounded Rectangle
         Top             =   1200
         Width           =   2010
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "Setpoint ( MAX )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   1
         Left            =   5520
         TabIndex        =   2
         Top             =   360
         Width           =   1455
      End
      Begin VB.Label Label1 
         Alignment       =   2  'Center
         BackColor       =   &H80000000&
         Caption         =   "Tempreture ( 'c )"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   330
         Index           =   0
         Left            =   2760
         TabIndex        =   1
         Top             =   360
         Width           =   1575
      End
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   0
      Top             =   0
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
      InputLen        =   1
      RThreshold      =   1
      SThreshold      =   1
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'GitHub Account: GitHub.com/AliRezaJoodi

Dim buf As Variant
Dim data(15) As Variant
Dim data_dorost(3)  As Variant
Dim counter As Variant
Dim cs As Variant
Dim sending As Boolean
Dim CPN As Byte
Dim GAS As Single
Dim Z1 As Byte
Dim z2 As Single
Dim s1 As String
Dim Status_Relays As Byte

Dim Humidity_Min As Single
Dim Humidity_Min_LSB As Single
Dim Humidity_Min_MSB As Single
Dim Humidity As Single
Dim Humidity_LSB As Single
Dim Humidity_MSB As Single
Dim Humidity_Max As Single
Dim Humidity_Max_LSB As Single
Dim Humidity_Max_MSB As Single

Dim Temp_Min As Single
Dim Temp_Min_LSB As Byte
Dim Temp_Min_MSB As Byte
Dim Temp As Single
Dim Temp_LSB As Byte
Dim Temp_MSB As Byte
Dim Temp_Max As Single
Dim Temp_Max_LSB As Byte
Dim Temp_Max_MSB As Byte
Private Sub Command1_Click()
    CPN = Val(Combo1.Text)
    MSComm1.CommPort = CPN
    
    Change_Humidity_Min.Enabled = True
    Change_Humidity_Max.Enabled = True
    Change_Temp_Min.Enabled = True
    Change_Temp_Max.Enabled = True
    
    MSComm1.PortOpen = True
    Command1.Enabled = False
    Command2.Enabled = True
    Combo1.Enabled = False
End Sub

Private Sub Command2_Click()
    MSComm1.PortOpen = False
    Command1.Enabled = True
    Command2.Enabled = False
    Combo1.Enabled = True

    Change_Humidity_Min.Enabled = False
    Change_Humidity_Max.Enabled = False
    Change_Temp_Min.Enabled = False
    Change_Temp_Max.Enabled = False
    
    Display_Temp = ""
    Display_Temp_Setpoint = ""
    Display_Gas = ""
    Display_Gas_Setpoint = ""
    
    Status_Humidifier.BackColor = RGB(192, 192, 192)
    Status_Dehumidifiers.BackColor = RGB(192, 192, 192)
    Status_Fan.BackColor = RGB(192, 192, 192)
    Status_Heater.BackColor = RGB(192, 192, 192)
    
    Display_Humidity_Min.Caption = 0
    Display_Humidity.Caption = 0
    Display_Humidity_Max.Caption = 0
    Display_Temp_Min.Caption = 0
    Display_Temp.Caption = 0
    Display_Temp_Max.Caption = 0
    
End Sub

Private Sub Form_Load()
MSComm1.Settings = "9600,N,8,1"
MSComm1.RThreshold = 1
MSComm1.SThreshold = 1
MSComm1.InputLen = 1
    Combo1.Clear
    For CPN = 1 To 16
        Combo1.AddItem Str(CPN)
    Next CPN
    Combo1.Text = Combo1.List(0)
    'Combo1.Text = 16
    's = False
    Display_Temp = " 0"
    Display_Temp_Setpoint = " 0"
    Display_Gas = " 0"
    Display_Gas_Setpoint = " 0"
    
    Status_Humidifier.BackColor = RGB(192, 192, 192)
    Status_Dehumidifiers.BackColor = RGB(192, 192, 192)
    Status_Fan.BackColor = RGB(192, 192, 192)
    Status_Heater.BackColor = RGB(192, 192, 192)
    
    Display_Humidity_Min.Caption = 0
    Display_Humidity.Caption = 0
    Display_Humidity_Max.Caption = 0
    Display_Temp_Min.Caption = 0
    Display_Temp.Caption = 0
    Display_Temp_Max.Caption = 0
    
    Change_Humidity_Min.Enabled = False
    Change_Humidity_Max.Enabled = False
    Change_Temp_Min.Enabled = False
    Change_Temp_Max.Enabled = False
    
    Command2.Enabled = False
End Sub

Private Sub MSComm1_OnComm()

Select Case MSComm1.CommEvent
        Case comEvReceive
            buf = MSComm1.Input
            buf = Asc(buf)
            Debug.Print buf
            If buf = &HEB And counter = 0 Then
                counter = 1
                data(counter) = buf
                'cs = buf
                Exit Sub
            End If
            
            If counter <> 0 Then
                    counter = counter + 1
                    data(counter) = buf
                     If counter = 14 Then
                            
                            Humidity_Min_MSB = data(2)
                            Humidity_Min_LSB = data(3)
                            Humidity_Min = ((Humidity_Min_MSB * 256) + Humidity_Min_LSB) / 10
                            Display_Humidity_Min.Caption = Humidity_Min

                            Humidity_MSB = data(4)
                            Humidity_LSB = data(5)
                            Humidity = ((Humidity_MSB * 256) + Humidity_LSB) / 10
                            Display_Humidity.Caption = Humidity
                            
                            Humidity_Max_MSB = data(6)
                            Humidity_Max_LSB = data(7)
                            Humidity_Max = ((Humidity_Max_MSB * 256) + Humidity_Max_LSB) / 10
                            Display_Humidity_Max.Caption = Humidity_Max
                            
                            Temp_Min_MSB = data(8)
                            Temp_Min_LSB = data(9)
                            Temp_Min = ((Temp_Min_MSB * 256) + Temp_Min_LSB) / 10
                            Display_Temp_Min.Caption = Temp_Min
                            
                            Temp_MSB = data(10)
                            Temp_LSB = data(11)
                            Temp = ((Temp_MSB * 256) + Temp_LSB) / 10
                            Display_Temp.Caption = Temp
                            
                            Temp_Max_MSB = data(12)
                            Temp_Max_LSB = data(13)
                            Temp_Max = ((Temp_Max_MSB * 256) + Temp_Max_LSB) / 10
                            Display_Temp_Max.Caption = Temp_Max
                            
                            'Display_Temp_Setpoint.Caption = data(3)
                            
                            'GAS = data(4) '/ 10
                            'Display_Gas_Setpoint.Caption = GAS

                            Status_Relays = Val(data(14))
                            If (Status_Relays And 1) = 1 Then Status_Humidifier.BackColor = RGB(0, 255, 0) Else Status_Humidifier.BackColor = RGB(192, 192, 192)
                            If (Status_Relays And 2) = 2 Then Status_Dehumidifiers.BackColor = RGB(255, 0, 0) Else Status_Dehumidifiers.BackColor = RGB(192, 192, 192)
                            If (Status_Relays And 4) = 4 Then Status_Fan.BackColor = RGB(0, 255, 0) Else Status_Fan.BackColor = RGB(192, 192, 192)
                            If (Status_Relays And 8) = 8 Then Status_Heater.BackColor = RGB(255, 0, 0) Else Status_Heater.BackColor = RGB(192, 192, 192)
                    
                    counter = 0
                    
                  If sending = True Then
                        sending = False
                        F_BYTE = &HAA
                        cs = F_BYTE
                        MSComm1.Output = Chr$(F_BYTE)
                        If Change_Temp_setpoint.Text = "" Then Change_Temp_setpoint.Text = "255"
                        MSComm1.Output = Chr$(Change_Temp_setpoint.Text)
                        
                        If Change_Gas_Setpoint.Text = "" Then Change_Gas_Setpoint.Text = "255"
                        z2 = Val(Change_Gas_Setpoint.Text)
                        z2 = z2 '* 10
                        s1 = Str(z2)
                        Z1 = Val(s1)
                        MSComm1.Output = Chr$(Z1)
                        
                        'MSComm1.Output = Chr$(setpoint_change.Text)
                        'Label4.Caption = Chr$(Change_Gas_Setpoint.Text)
                        
                        cs = F_BYTE + Change_Temp_setpoint.Text
                        'cs = cs + Change_Gas_Setpoint.Text
                        cs = cs And 255
                        'MSComm1.Output = Chr$(cs)
                        Change_Temp_setpoint.Text = ""
                        Change_Gas_Setpoint.Text = ""
                 End If
                 
                     End If
                    'cs = cs + buf
            End If
End Select

End Sub
Private Sub Change_Temp_setpoint_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then sending = True
End Sub
Private Sub Change_Gas_Setpoint_KeyPress(KeyAscii As Integer)
    If KeyAscii = 13 Then sending = True
End Sub

