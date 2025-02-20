VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Transmit text with wireless communication"
   ClientHeight    =   5400
   ClientLeft      =   3195
   ClientTop       =   3945
   ClientWidth     =   9480
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
   ScaleHeight     =   5400
   ScaleWidth      =   9480
   Begin VB.Frame Frame1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Servo Motor D"
      Height          =   1815
      Index           =   3
      Left            =   4800
      TabIndex        =   30
      Top             =   3480
      Width           =   4575
      Begin VB.HScrollBar HScroll 
         Height          =   375
         Index           =   3
         Left            =   120
         Max             =   145
         Min             =   40
         TabIndex        =   37
         Top             =   840
         Value           =   90
         Width           =   4215
      End
      Begin VB.TextBox Servo_min 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   345
         Index           =   3
         Left            =   240
         MaxLength       =   3
         TabIndex        =   36
         Text            =   "40"
         Top             =   360
         Width           =   615
      End
      Begin VB.TextBox Servo_max 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   405
         Index           =   3
         Left            =   3720
         TabIndex        =   35
         Text            =   "145"
         Top             =   360
         Width           =   615
      End
      Begin VB.CommandButton Command_min 
         Caption         =   "Min"
         Height          =   375
         Index           =   3
         Left            =   120
         TabIndex        =   34
         Top             =   1320
         Width           =   855
      End
      Begin VB.CommandButton Command_Middle 
         Caption         =   "Middle"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   3
         Left            =   1800
         TabIndex        =   33
         Top             =   1320
         Width           =   855
      End
      Begin VB.CommandButton Command_Max 
         Caption         =   "Max"
         Height          =   375
         Index           =   3
         Left            =   3480
         TabIndex        =   32
         Top             =   1320
         Width           =   855
      End
      Begin VB.TextBox Servo_Middle 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   405
         Index           =   3
         Left            =   1880
         TabIndex        =   31
         Text            =   "90"
         Top             =   360
         Width           =   615
      End
      Begin VB.Label Label_buffer 
         BackColor       =   &H00C0C0C0&
         Caption         =   " Buffer"
         Height          =   375
         Index           =   3
         Left            =   2760
         TabIndex        =   38
         Top             =   360
         Width           =   615
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Servo Motor C"
      Height          =   1815
      Index           =   2
      Left            =   4800
      TabIndex        =   21
      Top             =   1560
      Width           =   4575
      Begin VB.HScrollBar HScroll 
         Height          =   375
         Index           =   2
         Left            =   120
         Max             =   145
         Min             =   40
         TabIndex        =   28
         Top             =   840
         Value           =   90
         Width           =   4215
      End
      Begin VB.TextBox Servo_min 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   345
         Index           =   2
         Left            =   240
         MaxLength       =   3
         TabIndex        =   27
         Text            =   "40"
         Top             =   360
         Width           =   615
      End
      Begin VB.TextBox Servo_max 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   405
         Index           =   2
         Left            =   3720
         TabIndex        =   26
         Text            =   "145"
         Top             =   360
         Width           =   615
      End
      Begin VB.CommandButton Command_min 
         Caption         =   "Min"
         Height          =   375
         Index           =   2
         Left            =   120
         TabIndex        =   25
         Top             =   1320
         Width           =   855
      End
      Begin VB.CommandButton Command_Middle 
         Caption         =   "Middle"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   2
         Left            =   1800
         TabIndex        =   24
         Top             =   1320
         Width           =   855
      End
      Begin VB.CommandButton Command_Max 
         Caption         =   "Max"
         Height          =   375
         Index           =   2
         Left            =   3480
         TabIndex        =   23
         Top             =   1320
         Width           =   855
      End
      Begin VB.TextBox Servo_Middle 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   405
         Index           =   2
         Left            =   1880
         TabIndex        =   22
         Text            =   "90"
         Top             =   360
         Width           =   615
      End
      Begin VB.Label Label_buffer 
         BackColor       =   &H00C0C0C0&
         Caption         =   " Buffer"
         Height          =   375
         Index           =   2
         Left            =   2760
         TabIndex        =   29
         Top             =   360
         Width           =   615
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Servo Motor B"
      Height          =   1815
      Index           =   1
      Left            =   120
      TabIndex        =   12
      Top             =   3480
      Width           =   4575
      Begin VB.HScrollBar HScroll 
         Height          =   375
         Index           =   1
         Left            =   120
         Max             =   140
         Min             =   40
         TabIndex        =   19
         Top             =   840
         Value           =   90
         Width           =   4215
      End
      Begin VB.TextBox Servo_min 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   345
         Index           =   1
         Left            =   240
         MaxLength       =   3
         TabIndex        =   18
         Text            =   "40"
         Top             =   360
         Width           =   615
      End
      Begin VB.TextBox Servo_max 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         ForeColor       =   &H00404040&
         Height          =   405
         Index           =   1
         Left            =   3720
         TabIndex        =   17
         Text            =   "145"
         Top             =   360
         Width           =   615
      End
      Begin VB.CommandButton Command_min 
         Caption         =   "Min"
         Height          =   375
         Index           =   1
         Left            =   120
         TabIndex        =   16
         Top             =   1320
         Width           =   855
      End
      Begin VB.CommandButton Command_Middle 
         Caption         =   "Middle"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   1
         Left            =   1800
         TabIndex        =   15
         Top             =   1320
         Width           =   855
      End
      Begin VB.CommandButton Command_Max 
         Caption         =   "Max"
         Height          =   375
         Index           =   1
         Left            =   3480
         MaskColor       =   &H00C0E0FF&
         TabIndex        =   14
         Top             =   1320
         Width           =   855
      End
      Begin VB.TextBox Servo_Middle 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   405
         Index           =   1
         Left            =   1880
         TabIndex        =   13
         Text            =   "90"
         Top             =   360
         Width           =   615
      End
      Begin VB.Label Label_buffer 
         BackColor       =   &H00C0C0C0&
         Caption         =   " Buffer"
         Height          =   375
         Index           =   1
         Left            =   2760
         TabIndex        =   20
         Top             =   360
         Width           =   615
      End
   End
   Begin VB.Frame Frame2 
      BackColor       =   &H00E0E0E0&
      Caption         =   "Communication"
      Height          =   1335
      Left            =   120
      TabIndex        =   8
      Top             =   120
      Width           =   9255
      Begin VB.CommandButton Command_Stop 
         Caption         =   "STOP"
         Height          =   375
         Left            =   5400
         TabIndex        =   40
         Top             =   840
         Width           =   3735
      End
      Begin VB.CommandButton Command_Start 
         Caption         =   "START"
         Height          =   405
         Left            =   120
         TabIndex        =   39
         Top             =   840
         Width           =   3735
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
         Left            =   7920
         TabIndex        =   10
         Text            =   "1"
         Top             =   240
         Width           =   1215
      End
      Begin MSCommLib.MSComm MSComm1 
         Left            =   3240
         Top             =   240
         _ExtentX        =   794
         _ExtentY        =   794
         _Version        =   393216
         DTREnable       =   -1  'True
         InputLen        =   1024
      End
      Begin VB.Label LABLE_CPN 
         BackColor       =   &H00E0E0E0&
         Caption         =   "COM Port Number"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   315
         Left            =   120
         TabIndex        =   9
         Top             =   360
         Width           =   2055
      End
   End
   Begin VB.Frame Frame1 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Servo Motor A"
      Height          =   1815
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   1560
      Width           =   4575
      Begin VB.TextBox Servo_Middle 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   405
         Index           =   0
         Left            =   1880
         TabIndex        =   7
         Text            =   "90"
         Top             =   360
         Width           =   615
      End
      Begin VB.CommandButton Command_Max 
         Appearance      =   0  'Flat
         Caption         =   "Max"
         Height          =   375
         Index           =   0
         Left            =   3480
         TabIndex        =   6
         Top             =   1320
         Width           =   855
      End
      Begin VB.CommandButton Command_Middle 
         Caption         =   "Middle"
         BeginProperty Font 
            Name            =   "Times New Roman"
            Size            =   9.75
            Charset         =   178
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Index           =   0
         Left            =   1800
         TabIndex        =   5
         Top             =   1320
         Width           =   855
      End
      Begin VB.CommandButton Command_min 
         Caption         =   "Min"
         Height          =   375
         Index           =   0
         Left            =   120
         TabIndex        =   4
         Top             =   1320
         Width           =   855
      End
      Begin VB.TextBox Servo_max 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   405
         Index           =   0
         Left            =   3720
         TabIndex        =   3
         Text            =   "145"
         Top             =   360
         Width           =   615
      End
      Begin VB.TextBox Servo_min 
         Alignment       =   2  'Center
         BackColor       =   &H00E0E0E0&
         Height          =   345
         Index           =   0
         Left            =   240
         MaxLength       =   3
         TabIndex        =   2
         Text            =   "40"
         Top             =   360
         Width           =   615
      End
      Begin VB.HScrollBar HScroll 
         Height          =   375
         Index           =   0
         Left            =   120
         Max             =   140
         Min             =   44
         TabIndex        =   1
         Top             =   840
         Value           =   90
         Width           =   4215
      End
      Begin VB.Label Label_buffer 
         BackColor       =   &H00C0C0C0&
         Caption         =   " Buffer"
         Height          =   375
         Index           =   0
         Left            =   2760
         TabIndex        =   11
         Top             =   360
         Width           =   615
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
Dim Controler_Buffer As String
Dim i As Byte
Dim servo1_Normaly As Byte
Dim e As Byte

Private Sub Command_Start_Click()
    Command_Start.Enabled = False
    Combo1.Enabled = False
    Call enable
    Command_Stop.Enabled = True
    CPN = Val(Combo1.Text)
    MSComm1.CommPort = CPN
    MSComm1.PortOpen = True: e = 1
End Sub

Private Sub Command_Stop_Click()
    MSComm1.PortOpen = False: e = 0
    Command_Stop.Enabled = False
    Combo1.Enabled = True
    Command_Start.Enabled = True
    Call Disable
End Sub

Private Sub Form_Load()
    Command_Stop.Enabled = False
    Call Disable
    Combo1.Clear
    For CPN = 1 To 16
        Combo1.AddItem Str(CPN)
    Next CPN
    Combo1.Text = Combo1.List(0)
    For i = 0 To 3 Step 1
        Label_buffer(i).Caption = ""
        HScroll(i).Min = Val(Servo_min(i).Text)
        HScroll(i).Max = Val(Servo_max(i).Text)
        HScroll(i).Value = Val(Servo_min(i).Text)
    Next i
    'LABLE_CPN.Caption = ""
End Sub

Private Sub Command_min_Click(Index As Integer)
    HScroll(Index).Value = Val(Servo_min(Index).Text)
End Sub

Private Sub Command_Middle_Click(Index As Integer)
    HScroll(Index).Value = Val(Servo_Middle(Index).Text)
End Sub

Private Sub Command_Max_Click(Index As Integer)
    HScroll(Index).Value = Val(Servo_max(Index).Text)
End Sub

Private Sub HScroll_Change(Index As Integer)
    'CPN = Val(Combo1.Text): MSComm1.CommPort = CPN
    'MSComm1.PortOpen = True
    K = Val(HScroll(Index).Value)
    Label_buffer(Index).Caption = K
    Controler_Buffer = Label_buffer(Index).Caption
    Label_buffer(Index).Caption = ""
    If e = 1 Then
        Select Case Index
            Case 0: MSComm1.Output = "A" + Controler_Buffer + Chr(13)
            Case 1: MSComm1.Output = "B" + Controler_Buffer + Chr(13)
            Case 2: MSComm1.Output = "C" + Controler_Buffer + Chr(13)
            Case 3: MSComm1.Output = "D" + Controler_Buffer + Chr(13)
        End Select
    End If
    'MSComm1.PortOpen = False
    End Sub
    
Private Sub Servo_min_Change(Index As Integer)
    HScroll(Index).Min = Val(Servo_min(Index).Text)
    HScroll(Index).Max = Val(Servo_max(Index).Text)
    servo1_Normaly = Val(Servo_Middle(Index).Text)
End Sub

Private Sub Servo_max_Change(Index As Integer)
    HScroll(Index).Min = Val(Servo_min(Index).Text)
    HScroll(Index).Max = Val(Servo_max(Index).Text)
    servo1_Normaly = Val(Servo_Middle(Index).Text)
End Sub

Private Sub Servo_Middle_Change(Index As Integer)
    HScroll(Index).Min = Val(Servo_min(Index).Text)
    HScroll(Index).Max = Val(Servo_max(Index).Text)
    servo1_Normaly = Val(Servo_Middle(Index).Text)
End Sub

Private Sub Disable()
    For i = 0 To 3
        HScroll(i).Enabled = False
        Command_min(i).Enabled = False
        Command_Middle(i).Enabled = False
        Command_Max(i).Enabled = False
        Servo_min(i).Enabled = False
        Servo_Middle(i).Enabled = False
        Servo_max(i).Enabled = False
        Frame1(i).Enabled = False
    Next i
End Sub

Private Sub enable()
    For i = 0 To 3
        HScroll(i).Enabled = True
        Command_min(i).Enabled = True
        Command_Middle(i).Enabled = True
        Command_Max(i).Enabled = True
        Servo_min(i).Enabled = True
        Servo_Middle(i).Enabled = True
        Servo_max(i).Enabled = True
        Frame1(i).Enabled = True
    Next i
End Sub
