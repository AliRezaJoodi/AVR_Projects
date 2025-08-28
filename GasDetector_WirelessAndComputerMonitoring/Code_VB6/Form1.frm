VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "Gas Detector"
   ClientHeight    =   3360
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9900
   LinkTopic       =   "Form1"
   ScaleHeight     =   3360
   ScaleWidth      =   9900
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame4 
      Caption         =   "Status Relay"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   15
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1815
      Left            =   6360
      TabIndex        =   7
      Top             =   1440
      Width           =   3045
      Begin VB.Shape Relay 
         BackColor       =   &H80000000&
         BackStyle       =   1  'Opaque
         Height          =   735
         Left            =   1080
         Shape           =   3  'Circle
         Top             =   720
         Width           =   735
      End
   End
   Begin VB.Frame Frame3 
      Caption         =   "Setpoint"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   15
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1815
      Left            =   3240
      TabIndex        =   6
      Top             =   1440
      Width           =   2975
      Begin VB.Label Label2 
         Caption         =   "0"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   60
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1095
         Left            =   360
         TabIndex        =   8
         Top             =   480
         Width           =   2175
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "Gas"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   15
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1815
      Left            =   120
      TabIndex        =   4
      Top             =   1440
      Width           =   2975
      Begin VB.Label Label1 
         Caption         =   "0"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   60
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1215
         Left            =   480
         TabIndex        =   5
         Top             =   480
         Width           =   2175
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00E0E0E0&
      Caption         =   "COM Port Setting"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   15
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   1335
      Left            =   120
      TabIndex        =   0
      Top             =   0
      Width           =   9255
      Begin MSCommLib.MSComm MSComm1 
         Left            =   6480
         Top             =   240
         _ExtentX        =   1005
         _ExtentY        =   1005
         _Version        =   393216
         DTREnable       =   -1  'True
      End
      Begin VB.ComboBox Combo1 
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   345
         Left            =   8280
         TabIndex        =   3
         Text            =   "1"
         Top             =   360
         Width           =   855
      End
      Begin VB.CommandButton Command_Open 
         BackColor       =   &H8000000B&
         Caption         =   "Open"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   120
         TabIndex        =   2
         Top             =   840
         Width           =   4335
      End
      Begin VB.CommandButton Command_Close 
         Caption         =   "Close"
         BeginProperty Font 
            Name            =   "Arial"
            Size            =   12
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   4800
         TabIndex        =   1
         Top             =   840
         Width           =   4335
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'GitHub Account: GitHub.com/AliRezaJoodi
Dim CPN As Byte
Dim buf As Variant
Dim data(4) As Byte
Dim counter As Byte

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
    Frame2.Enabled = False
    Frame3.Enabled = False
    Frame4.Enabled = False
    Command_Close.Enabled = False
    Label1.Enabled = False
    Label2.Enabled = False
    Relay.BackColor = RGB(192, 192, 192)
End Sub

Private Sub Command_Open_Click()
    CPN = Val(Combo1.Text): MSComm1.CommPort = CPN
    MSComm1.PortOpen = True
    Command_Close.Enabled = True
    Command_Open.Enabled = False
    Combo1.Enabled = False
    Frame2.Enabled = True
    Frame3.Enabled = True
    Frame4.Enabled = True
    Label1.Enabled = True
    Label2.Enabled = True
End Sub

Private Sub Command_Close_Click()
    MSComm1.PortOpen = False
    Command_Close.Enabled = False
    Command_Open.Enabled = True
    Combo1.Enabled = True
    Frame2.Enabled = False
    Frame3.Enabled = False
    Frame4.Enabled = False
    Label1.Caption = "0"
    Label2.Caption = "0"
    Label1.Enabled = False
    Label2.Enabled = False
    Relay.BackColor = RGB(192, 192, 192)
End Sub

Private Sub MSComm1_OnComm()
    Select Case MSComm1.CommEvent
        Case comEvReceive
            buf = MSComm1.Input
            buf = Asc(buf)
            Debug.Print buf
            If buf = 123 And counter = 0 Then
                counter = 1
                data(counter) = buf
                Exit Sub
            End If
            If counter <> 0 Then
                counter = counter + 1
                data(counter) = buf
                If counter = 4 Then
                    Label1.Caption = Str(data(2))
                    Label2.Caption = Str(data(3))
                    If data(4) = 0 Then Relay.BackColor = RGB(192, 192, 192) Else Relay.BackColor = RGB(255, 0, 0)
                    counter = 0
                End If
            End If
    End Select
End Sub

