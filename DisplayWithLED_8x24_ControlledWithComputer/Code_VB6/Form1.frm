VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   BackColor       =   &H80000013&
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Form1"
   ClientHeight    =   2310
   ClientLeft      =   3195
   ClientTop       =   3825
   ClientWidth     =   8850
   BeginProperty Font 
      Name            =   "Times New Roman"
      Size            =   12
      Charset         =   178
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2310
   ScaleWidth      =   8850
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton Command2 
      Caption         =   "Command2"
      Height          =   615
      Left            =   7080
      TabIndex        =   5
      Top             =   120
      Width           =   1095
   End
   Begin VB.TextBox Text2 
      Height          =   405
      Left            =   480
      MaxLength       =   94
      TabIndex        =   4
      Text            =   "HELLO"
      Top             =   1320
      Width           =   8295
   End
   Begin VB.TextBox Text1 
      Height          =   405
      Left            =   480
      MaxLength       =   3
      TabIndex        =   3
      Top             =   720
      Width           =   735
   End
   Begin VB.CommandButton Command1 
      BackColor       =   &H80000013&
      Caption         =   "send"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   178
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   372
      Index           =   0
      Left            =   5280
      TabIndex        =   0
      Top             =   720
      Width           =   1092
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   8160
      Top             =   1800
      _ExtentX        =   794
      _ExtentY        =   794
      _Version        =   393216
      DTREnable       =   -1  'True
      InputLen        =   1024
   End
   Begin VB.Label label 
      BackColor       =   &H80000013&
      Caption         =   "Commport 3"
      Height          =   255
      Left            =   5400
      TabIndex        =   2
      Top             =   1920
      Width           =   1335
   End
   Begin VB.Line Line4 
      X1              =   4200
      X2              =   6720
      Y1              =   240
      Y2              =   240
   End
   Begin VB.Line Line2 
      X1              =   6720
      X2              =   6720
      Y1              =   240
      Y2              =   840
   End
   Begin VB.Line Line1 
      X1              =   240
      X2              =   2985
      Y1              =   2040
      Y2              =   2040
   End
   Begin VB.Line Line10 
      X1              =   240
      X2              =   240
      Y1              =   1440
      Y2              =   2040
   End
   Begin VB.Label Label2 
      BackColor       =   &H80000013&
      Caption         =   "Input Text"
      BeginProperty Font 
         Name            =   "Times New Roman"
         Size            =   12
         Charset         =   178
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Index           =   0
      Left            =   360
      TabIndex        =   1
      Top             =   120
      Width           =   1095
   End
   Begin VB.Line Line3 
      X1              =   7080
      X2              =   8280
      Y1              =   5280
      Y2              =   5760
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private Sub Command1_Click(Index As Integer)
    MSComm1.PortOpen = True
    MSComm1.Output = Text1.Text + Chr(13) + Text2.Text + Chr(13)
    MSComm1.PortOpen = False
End Sub

Private Sub Command2_Click()
   MSComm1.PortOpen = True
    MSComm1.Output = Chr(13)
    MSComm1.PortOpen = False
End Sub

Private Sub Form_Load()
    MSComm1.Settings = "9600,N,8,1"
    MSComm1.RThreshold = 1
    MSComm1.SThreshold = 1
    MSComm1.InputLen = 1
End Sub

