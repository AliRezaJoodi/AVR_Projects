VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H00E0E0E0&
   Caption         =   "Wireless Communication"
   ClientHeight    =   1800
   ClientLeft      =   2445
   ClientTop       =   2985
   ClientWidth     =   8865
   LinkTopic       =   "Form1"
   NegotiateMenus  =   0   'False
   ScaleHeight     =   1800
   ScaleWidth      =   8865
   Begin MSCommLib.MSComm MSComm1 
      Left            =   3840
      Top             =   0
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00E0E0E0&
      Caption         =   "Communication"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   14.25
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1635
      Index           =   1
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   4335
      Begin VB.ComboBox Combo1 
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   14.25
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   435
         Left            =   2880
         TabIndex        =   4
         Text            =   "1"
         Top             =   480
         Width           =   1215
      End
      Begin VB.CommandButton Command_Start 
         Caption         =   "Connect"
         Height          =   375
         Left            =   240
         TabIndex        =   3
         Top             =   1080
         Width           =   1815
      End
      Begin VB.CommandButton Command_Stop 
         Caption         =   "Disconnect"
         Height          =   375
         Left            =   2400
         TabIndex        =   2
         Top             =   1080
         Width           =   1815
      End
      Begin VB.Label Label1 
         BackColor       =   &H00E0E0E0&
         Caption         =   "COM Port Number:"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   15.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   360
         Index           =   0
         Left            =   120
         TabIndex        =   5
         Top             =   495
         Width           =   2655
      End
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00E0E0E0&
      Caption         =   "Monitoring"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   14.25
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1635
      Index           =   0
      Left            =   4560
      TabIndex        =   0
      Top             =   120
      Width           =   4215
      Begin VB.TextBox Text2 
         BackColor       =   &H00FFFFFF&
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   11.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   405
         Left            =   120
         MaxLength       =   16
         TabIndex        =   7
         Top             =   1080
         Width           =   3975
      End
      Begin VB.TextBox Text1 
         BackColor       =   &H00FFFFFF&
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   11.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   405
         Left            =   120
         MaxLength       =   16
         TabIndex        =   6
         Top             =   600
         Width           =   3975
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
Dim status As Boolean

Private Sub Form_Load()
MSComm1.Settings = "9600,N,8,1"
MSComm1.RThreshold = 1
MSComm1.SThreshold = 1
MSComm1.InputLen = 1
    Combo1.Clear
    For CPN = 1 To 16
        Combo1.AddItem Str(CPN)
    Next CPN
    Combo1.text = Combo1.List(0)
    Command_Stop.Enabled = False
    Text1.text = ""
    Text2.text = ""
End Sub

Private Sub Command_Start_Click()
    CPN = Val(Combo1.text)
    MSComm1.CommPort = CPN
    MSComm1.PortOpen = True
    Command_Start.Enabled = False
    Command_Stop.Enabled = True
    Combo1.Enabled = False
End Sub

Private Sub Command_Stop_Click()
    MSComm1.PortOpen = False
    Command_Start.Enabled = True
    Command_Stop.Enabled = False
    Combo1.Enabled = True
    Text1.text = ""
    Text2.text = ""
End Sub

Private Sub MSComm1_OnComm()
    buf = MSComm1.Input
    buf = Asc(buf)
    Select Case buf
        Case 12:
            Text2.text = ""
            Text1.text = ""
            status = False
        Case 13:
            If status = False Then
                status = True
            'Else
                'status = False
            End If
        Case 8:
        Case 33 To 126:
            If status = False Then
                Text1.text = Text1.text + Chr(buf)
            Else
                Text2.text = Text2.text + Chr(buf)
            End If
    End Select
End Sub



