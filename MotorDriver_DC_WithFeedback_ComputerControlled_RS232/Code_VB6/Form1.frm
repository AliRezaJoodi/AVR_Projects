VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00E0E0E0&
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "DC Motor Contoroler"
   ClientHeight    =   2940
   ClientLeft      =   1080
   ClientTop       =   1515
   ClientWidth     =   9495
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2940
   ScaleWidth      =   9495
   Begin VB.Frame Frame2 
      BackColor       =   &H00E0E0E0&
      Caption         =   "Settings"
      ClipControls    =   0   'False
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000D&
      Height          =   2175
      Index           =   1
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   4815
      Begin VB.TextBox Seting_RPM_Display 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   405
         Left            =   3720
         MaxLength       =   5
         TabIndex        =   11
         Text            =   "0"
         Top             =   1200
         Width           =   975
      End
      Begin VB.ComboBox Combo1 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Left            =   3720
         TabIndex        =   10
         Text            =   "1"
         Top             =   480
         Width           =   975
      End
      Begin VB.Label Label2 
         BackColor       =   &H00E0E0E0&
         Caption         =   $"Form1.frx":0000
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00000000&
         Height          =   375
         Index           =   1
         Left            =   120
         TabIndex        =   9
         Top             =   1200
         Width           =   3200
      End
      Begin VB.Label Label7 
         BackColor       =   &H00E0E0E0&
         Caption         =   "COM PORT"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00000000&
         Height          =   255
         Index           =   1
         Left            =   120
         TabIndex        =   8
         Top             =   480
         Width           =   1215
      End
   End
   Begin VB.CommandButton Command_STOP 
      BackColor       =   &H00FFC0C0&
      Caption         =   "STOP"
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
      Left            =   5160
      MaskColor       =   &H00FFC0C0&
      TabIndex        =   6
      Top             =   2400
      Width           =   4215
   End
   Begin VB.CommandButton Command_START 
      BackColor       =   &H00E0E0E0&
      Caption         =   "START"
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
      Left            =   120
      MaskColor       =   &H00000000&
      TabIndex        =   2
      Top             =   2400
      Width           =   4815
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00E0E0E0&
      Caption         =   "Monitoring"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   178
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000D&
      Height          =   2175
      Index           =   0
      Left            =   5160
      TabIndex        =   0
      Top             =   120
      Width           =   4200
      Begin VB.TextBox RPM_Display 
         Appearance      =   0  'Flat
         BackColor       =   &H00E0E0E0&
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1065
            SubFormatType   =   1
         EndProperty
         DragMode        =   1  'Automatic
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   24
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   2280
         MaxLength       =   5
         TabIndex        =   5
         Top             =   480
         Width           =   1575
      End
      Begin VB.TextBox PWM_Display 
         Appearance      =   0  'Flat
         BackColor       =   &H00E0E0E0&
         BeginProperty DataFormat 
            Type            =   1
            Format          =   "0"
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1065
            SubFormatType   =   1
         EndProperty
         DragMode        =   1  'Automatic
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   24
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   2280
         MaxLength       =   5
         TabIndex        =   3
         Top             =   1320
         Width           =   1575
      End
      Begin VB.Label Label3 
         BackColor       =   &H00E0E0E0&
         Caption         =   "PWM"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         Left            =   120
         TabIndex        =   4
         Top             =   1440
         Width           =   780
      End
      Begin VB.Label Label1 
         BackColor       =   &H00E0E0E0&
         Caption         =   "RMP"
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
         Index           =   0
         Left            =   120
         TabIndex        =   1
         Top             =   600
         Width           =   735
      End
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   0
      Top             =   -240
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

Dim START As Boolean
Dim CPN As Byte
Dim buffer As Variant
Dim rpm_set As Integer
Dim z As Integer
Dim flag As Boolean
Dim counter As Byte
Dim Serial_data(3) As Byte
Dim rpm As Integer
Dim Msb_rpm As Byte
Dim Lsb_rpm As Byte
Dim PWM As Integer
Dim lsb_PWM As Integer
Dim msb_PWM  As Integer

Private Sub Command_START_Click()
    CPN = Val(Combo1.Text): MSComm1.CommPort = CPN
    MSComm1.PortOpen = True
    rpm_set = Val(Seting_RPM_Display.Text)
    Command_START.Enabled = False
    Command_STOP.Enabled = True
    Seting_RPM_Display.Enabled = False
    Combo1.Enabled = False
End Sub

Private Sub Command_STOP_Click()
    Call STOP_MOTOR
    Command_STOP.Enabled = False
    Command_START.Enabled = True
    MSComm1.PortOpen = False
    Seting_RPM_Display.Enabled = True
    Combo1.Enabled = True
End Sub

Private Sub Form_Load()
MSComm1.Settings = "9600,N,8,1"
MSComm1.RThreshold = 1
MSComm1.SThreshold = 1
MSComm1.InputLen = 1
    Combo1.Clear
    For CPN = 1 To 254
        Combo1.AddItem Str(CPN)
    Next CPN
    Combo1.Text = Combo1.List(0)
    's = False
    Command_STOP.Enabled = False
    'START = False
    'Seting_RPM_Display.Text = START
End Sub

Private Sub MSComm1_OnComm()
Select Case MSComm1.CommEvent
        Case comEvReceive
            'START = True
            buffer = MSComm1.Input
            buffer = Asc(buffer)
            Debug.Print buffer
            If flag = False Then
                If buffer = &HAA Then
                    Cs_rpm = &HAA
                    flag = True
                    counter = 1
                End If
            Else
            Serial_data(counter) = buffer
            If counter = 2 Then
                Lsb_rpm = Serial_data(1)
                Msb_rpm = Serial_data(2)
                rpm = (Msb_rpm * 256) + Lsb_rpm
                RPM_Display.Text = rpm
                Call Calculated_PWM
                PWM_Display.Text = PWM
                Call Sending_PWM(PWM)
                counter = 0
                flag = False
            End If
            counter = counter + 1
            End If
    End Select
End Sub

Private Sub Sending_PWM(ByVal PWM As Integer)
    MSComm1.Output = Chr$(&HAA)
    lsb_PWM = CInt(PWM Mod 256)
    MSComm1.Output = Chr$(lsb_PWM)
    msb_PWM = CInt(PWM / 256)
    MSComm1.Output = Chr$(msb_PWM)
End Sub

Private Sub Calculated_PWM()
    'If START = False Then PWM = 18
    z = rpm_set - rpm
    z = z \ 120
    PWM = PWM + z
    If PWM > 255 Then
        PWM = 255
    End If
    If PWM < 0 Then
        PWM = 0
    End If
End Sub

Private Sub STOP_MOTOR()
    flag = False
    PWM = 0: Call Sending_PWM(PWM): PWM_Display.Text = PWM
    rpm = 0: RPM_Display.Text = rpm
End Sub

