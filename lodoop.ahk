#singleinstance force
DetectHiddenWindows, On
VarSetCapacity(output2 ,8)

output2=

havekey=0
;-------------------------Instructions-------------------------
;
;Alt X = Unlock Screen
;Alt R = Reset Password
;
;Use right click menu to set other options
;
;------------------------Requirements-----------------------
;
;Only tested on Windows XP
;
;Reasonably current version of Autohotkey
;
;---------------------------------------------------------------------



lockstate=0

;Creates Black Password on first run

blank=1


;checks idle time every minutes
SetTimer, Timer, 60000

;Timer Starts off disabled

IfNotExist, %homeDrive%\lock
    IniWrite, 0, %homeDrive%\lock, autoactivate, Status

IfNotExist, %homeDrive%\lock
    IniWrite, 900000, %homeDrive%\lock, autoactivate, milliSeconds

;Creates Menu's

Menu, Tray, Icon , %SystemRoot%\system32\SHELL32.dll, 48
Menu, Tray, NoStandard
Menu, TimerOptions, add, 3 Hours, Hours
Menu, TimerOptions, add, 2 Hours, Hours

Minutes=60

Loop,12
{
  Menu, TimerOptions, add, %Minutes% mins, Minutes
  Minutes-=5
}


;Checks/Enables/Disables menu items based on status of timer

IniRead, ms, %homeDrive%\lock, autoactivate, milliSeconds

SetFormat, Float, 0.0
mins:=ms/60000

If mins > 3
    Menu, TimerOptions,Check, %mins% mins

If mins = 3
    Menu, TimerOptions,Check, 3 Hours

If mins = 2
    Menu, TimerOptions,Check, 2 Hours

Menu, Tray, add, Lock
Menu, Tray, Default, Lock

Menu, TimerOptions, add, Disable
Menu, Tray, add, Auto-Activate, :TimerOptions


IniRead, autoStatus, %homeDrive%\lock, autoactivate, Status, 0

If autoStatus=1
    SetTimer, Timer, on

If autoStatus=0
{
  SetTimer, Timer, off
  Menu, TimerOptions, Disable, 3 Hours
  Menu, TimerOptions, Disable, 2 Hours
  Minutes=60
  Loop,12
  {
    Menu, TimerOptions, Disable, %Minutes% mins
    Minutes-=5
  }
  Menu, TimerOptions,Rename, Disable, Enable
}

Menu, Tray, add, Exit

;Enables All Blocked Keys

Hotkey, Left, Off
Hotkey, Right, Off
Hotkey, up, Off
Hotkey, down, Off

Hotkey, Tab, Off
Hotkey, !Tab, Off
Hotkey, !F4, Off
Hotkey, LWin, Off
Hotkey, RWin, Off
Hotkey, AppsKey, Off
Hotkey, ^Escape, Off

Hotkey, NumpadUp, Off
Hotkey, NumpadDown, Off
Hotkey, NumpadLeft, Off
Hotkey, NumpadRight, Off



Return



;-------------------------------------------------------------------

;Disables/Enables Menu items and Timer

Disable:

 If A_ThisMenuItem=Disable
 {
   IniWrite, 0, %homeDrive%\lock, autoactivate, Status
   SetTimer, Timer, off
   Menu, TimerOptions,Rename, Disable, Enable
   Menu, TimerOptions, Disable, 3 Hours
   Menu, TimerOptions, Disable, 2 Hours
   Minutes=60
   Loop,12
   {
     Menu, TimerOptions, Disable, %Minutes% mins
     Minutes-=5
   }
 }

 If A_ThisMenuItem=Enable
 {
   IniWrite, 1, %homeDrive%\lock, autoactivate, Status
   SetTimer, Timer, on
   Menu, TimerOptions,Rename, Enable, Disable

   Menu, TimerOptions, Enable, 3 Hours
   Menu, TimerOptions, Enable, 2 Hours
   Minutes=60
   Loop,12
   {
     Menu, TimerOptions, Enable, %Minutes% mins
     Minutes-=5
   }
 }

Auto-Activate:
Return


Hours:
Minutes:

 Menu, TimerOptions, UnCheck, 3 Hours
 Menu, TimerOptions, UnCheck, 2 Hours
 Minutes=60
 Loop,12
 {
    Menu, TimerOptions, UnCheck, %Minutes% mins
    Minutes-=5
 }

 Menu, TimerOptions,ToggleCheck, %A_ThisMenuItem%
 StringLeft, mins,A_ThisMenuItem, 2

 ;Calculates milliseconds to wait based on timer option chosen

 If mins=2
   milliSeconds=7200000
 If mins=3
   milliSeconds=10800000
 milliSeconds:=mins*60000
 IniWrite, %milliSeconds%, %homeDrive%\lock, autoactivate, milliSeconds
 Return


Timer:

 ;If more than X minutes has passed then lock the screen

 IniRead, milliSeconds, %homeDrive%\lock, autoactivate, milliSeconds
 If A_TimeIdlePhysical > %milliSeconds%
 {
   SetTimer, Timer, off
   Gosub, Lock
 }
Return


Lock:

 lockstate=1


  ;Blocks all hotkeys which could be used to unlock the screen

 Hotkey, Left, On
 Hotkey, Right, On
 Hotkey, up, On
 Hotkey, down, On

 Hotkey, Tab, On
 Hotkey, !Tab, On
 Hotkey, !F4, On
 Hotkey, LWin, On
 Hotkey, RWin, On
 Hotkey, AppsKey, On
 Hotkey, ^Escape, On

 Hotkey, NumpadUp, On
 Hotkey, NumpadDown, On
 Hotkey, NumpadLeft, On
 Hotkey, NumpadRight, On

 WinHide, ahk_class Shell_TrayWnd
WinHide,  ahk_class Button


 WinGetPos, , , Width, Height, ahk_class Progman
gui 9: -caption +alwaysontop
gui 9:color,black
gui 9:show,x0 y0 h%a_screenheight% w%a_screenwidth%,Lock SCREEN
if blank!=1
{
WinSet, Transparent, 100, Lock SCREEN
}
 

 ;------------------------------------------------------------------

 ;Begins Locking of Screen

beginning:


 ;SetTimer, killrun, 100


gui 5:destroy
cat=ap|b|c|ca|co|d|dr|f|fl|h|ss|tp
let=a|q|z|e|v|c|s|p|r|t|o|b
my=fl|d|ap
StringSplit, checker, cat , |

loop,parse,cat,|
{
%a_loopfield%=0
}

 lockstate=1

 SetTimer, InputOnTop, 500
SetTimer, CloseTaskmgr, 1000

gui, -caption


time=%checker0%

loop %time%
{


StringSplit, check, cat , |
StringSplit, letter, let , |
Random, ran , 1, %time%
Random, ran2 , 1, %time%

%a_index%:=check%ran%

l%a_index%:=letter%ran2%

cat=

let=

num:=%a_index%

numl:= l%a_index%


loop %check0%
{
element := check%A_Index%
elementl := letter%A_Index%
if element!=%num%
{
cat=%cat%%element%|
}
if elementl!=%numl%
{
let=%let%%elementl%|
}

}
time--
}
;msgbox 3
Random, ran , 1, 2
gui,add,picture,x0 y0 h115 w160,dat\%1%%ran%
Random, ran , 1, 2
gui,add,picture,x160 y0 h115 w160,dat\%2%%ran%
Random, ran , 1, 2
gui,add,picture,x320 y0 h115 w160,dat\%3%%ran%
Random, ran , 1, 2
gui,add,picture,x480 y0 h115 w160,dat\%4%%ran%
Random, ran , 1, 2
gui,add,picture,x0 y115 h115 w160,dat\%5%%ran%
Random, ran , 1, 2
gui,add,picture,x160 y115 h115 w160,dat\%6%%ran%
Random, ran , 1, 2
gui,add,picture,x320 y115 h115 w160,dat\%7%%ran%
Random, ran , 1, 2
gui,add,picture,x480 y115 h115 w160,dat\%8%%ran%
Random, ran , 1, 2
gui,add,picture,x0 y230 h115 w160,dat\%9%%ran%
Random, ran , 1, 2
gui,add,picture,x160 y230 h115 w160,dat\%10%%ran%
Random, ran , 1, 2
gui,add,picture,x320 y230 h115 w160,dat\%11%%ran%
Random, ran , 1, 2
gui,add,picture,x480 y230 h115 w160,dat\%12%%ran%
gui, font, s12
;msgbox 1

gui,add,text,x140 y95 center w20,%l1%

gui,add,text,x300 y95 center w20,%l2%

gui,add,text,x460 y95 center w20,%l3%

gui,add,text,x620 y95 center w20,%l4%


gui,add,text,x140 y210 center w20,%l5%

gui,add,text,x300 y210 center w20,%l6%

gui,add,text,x460 y210 center w20,%l7%

gui,add,text,x620 y210 center w20,%l8%


gui,add,text,x140 y325 center w20,%l9%

gui,add,text,x300 y325 center w20,%l10%

gui,add,text,x460 y325 center w20,%l11%

gui,add,text,x620 y325 center w20,%l12%
gui,color,white

xx:=(640/2)-25
xx2:=(640/2)-100

gui +alwaysontop
gui,add,edit,x%xx% -number limit3 password vcode w50 center
gui,add,button,x%xx2% w200 default gcodecheck,Unlock
gui,+lastfound

gui,show,xcenter ycenter w640,lodoop - Login

gui,+lastfound


WinGetPos ,xx ,yy, ww,hh

gui 2: -caption 
gui 2: color,  blue 
bx:=xx-20
by:=yy-20
bw:=ww+40
bh:=hh+40
gui 2:+lastfound
gui 2: show, x%bx% y%by% w%bw% h%bh%,lobackground
gui 2:+lastfound
winactivate
gui,+lastfound
winactivate
ControlFocus , edit1





return

codecheck:
gui,submit
gui 2: +lastfound
winhide
num=0
loop,parse,code
{

loop 12
{
ar:=l%a_index%
if ar=%a_loopfield%
{
cat:=%a_index%

loop,parse,my,|
{
if cat=%a_loopfield%
{
%cat%++
}
}
}
}

}


StringSplit, my, my , |

num1:=%my1%
num2:=%my2%
num3:=%my3%
if num1=1 
{
if num2=1
{
if num3=1
{

   gui 9:destroy
     WinShow, ahk_class Shell_TrayWnd
     WinShow, ahk_class ahk_class Button

     Reload
}
else
{
gosub incor
}
}
else
{
gosub incor

}
}
else
{
gosub incor

}




return
incor:
gui 55: +alwaysontop
gui 55: add,text,,Incorrect code
gui 55: add,button,gokk,ok
gui 55: show,xcenter ycenter, gui 55: add,text,,Incorrect
return

okk:
gui,destroy
gui 2:destroy
gui 55:destroy
gosub beginning
return
killrun:
 SetTimer, killrun, off
 Process, Wait, rundll32.exe, 4
 Process, Close, rundll32.exe
 SetTimer, killrun, on

return

CloseTaskmgr:
 SetTimer, CloseTaskmgr, off
 Process, Wait, taskmgr.exe, 4
 Process, Close, taskmgr.exe
 SetTimer, CloseTaskmgr, on
return

DisableOK:
 Control, Disable, , OK, Error (%Timeout%)
Return

InputOnTop:
 WinSet, AlwaysOnTop, On, lodoop - Login
gui,+lastfound
ControlFocus , edit1,lodoop - Login
 SetTimer, InputOnTop, on
Return



InputOnTop2:
 WinSet, AlwaysOnTop, On, open
 SetTimer, InputOnTop2, Off
Return

MsgBoxTimeout:
 oldTimeout=%Timeout%
 Timeout-=1
 WinSetTitle, Error (%oldTimeout%), , Error (%Timeout%)
 If Timeout = 0
   SetTimer, MsgBoxTimeout, off
Return


Bin2Hex(ByRef @hex, ByRef @bin, _byteNb=0)
{
   local intFormat, dataSize, dataAddress, granted, x

   ; Save original integer format
   intFormat = %A_FormatInteger%
   ; For converting bytes to hex
   SetFormat Integer, Hex

   ; Get size of data
   dataSize := VarSetCapacity(@bin)
   If (_byteNb < 1 or _byteNb > dataSize)
   {
      _byteNb := dataSize
   }
   dataAddress := &@bin
   ; Make enough room (faster)
   granted := VarSetCapacity(@hex, _byteNb * 2)
   if (granted < _byteNb * 2)
   {
      ; Cannot allocate enough memory
      ErrorLevel = Mem=%granted%
      Return -1
   }
   Loop %_byteNb%
   {
      ; Get byte in hexa
      x := *dataAddress + 0x100
      StringRight x, x, 2   ; 2 hex digits
      StringUpper x, x
      @hex = %@hex%%x%
      dataAddress++   ; Next byte
   }
   ; Restore original integer format
   SetFormat Integer, %intFormat%

   Return _byteNb
}



Left::
right::
up::
down::

Tab::
!Tab::
!F4::
LWin::
RWin::
Appskey::
^Escape::

NumpadUp::
NumpadDown::
NumpadLeft::
NumpadRight::

Return
Exit:
 WinShow, ahk_class Shell_TrayWnd
WinShow, ahk_class ahk_class Button
 ExitApp

!x::
exitapp
return

fadein(gui_trans,winname) 
{
   transL := 0
   Loop, 20
   {
      transL += GUI_TRANS//20
      WinSet, Transparent, %transL%, %WinName%
      Sleep, 10
      GuiActive=0;
   }
}
fadeout(gui_trans,winname) 
{
   transL := gui_trans
   Loop, 20
   {
      transL -= GUI_TRANS//20
      WinSet, Transparent, %transL%, %WinName%
      Sleep, 10
      GuiActive=0;
   }
}


Bin2Hex2(addr,len) {
   Static fun
   If (fun = "") {
      h=8B4C2404578B7C241085FF7E30568B7424108A168AC2C0E804463C0976040437EB02043080E20F88018AC2413C0976040437EB0204308801414F75D65EC601005FC3
      VarSetCapacity(fun,StrLen(h)//2)
      Loop % StrLen(h)//2
         NumPut("0x" . SubStr(h,2*A_Index-1,2), fun, A_Index-1, "Char")
   }
   VarSetCapacity(hex,2*len+1)
   dllcall(&fun, "uint",&hex, "uint",addr, "uint",len, "cdecl")
   VarSetCapacity(hex,-1) ; update StrLen
   Return hex
}

;___RC4 Encryption by Rajat_____________________________________

RC4(RC4Data,RC4Pass)
  {
    global RC4Result
    ATrim = %A_AutoTrim%
    AutoTrim, Off
    BLines = %A_BatchLines%
    SetBatchLines, -1
    StringLen, RC4PassLen, RC4Pass
    Loop, 256
      {
        a := A_Index - 1
        Transform, ModVal, Mod, %a%, %RC4PassLen%
        ModVal ++
        StringMid, C, RC4Pass, %ModVal%, 1
        Transform, AscVar, Asc, %C%
        Key%a% = %AscVar%
        sBox%a% = %a%
      }
    b = 0
    Loop, 256
      {
        a := A_Index - 1
        TempVar := b + sBox%a% + Key%a%
        Transform, b, Mod, %TempVar%, 256
        T := sBox%a%
        sBox%a% := sBox%b%
        sBox%b% = %T%
      }
    StringLen, DataLen, RC4Data
    RC4Result =
    i = 0
    j = 0
    Loop, %DataLen%
      {
        TmpVar := i + 1
        Transform, i, Mod, %TmpVar%, 256
        TmpVar := sBox%i% + j
        Transform, j, Mod, %TmpVar%, 256
        TmpVar := sBox%i% + sBox%j%
        Transform, TmpVar2, Mod, %TmpVar%, 256
        k := sBox%TmpVar2%
        StringMid, TmpVar, RC4Data, %A_Index%, 1
        Transform, AscVar, Asc, %TmpVar%
        Transform, C, BitXOr, %AscVar%, %k%
        IfEqual, C, 0
            C = %k%
        Transform, ChrVar, Chr, %C%
        RC4Result = %RC4Result%%ChrVar%
      }
    AutoTrim, %ATrim%
    SetBatchLines, %BLines%
    Return RC4Result
  }
;___RC4 Encryption by Rajat_____________________________________ 
