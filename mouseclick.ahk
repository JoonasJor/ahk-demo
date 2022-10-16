; <COMPILER: v1.1.33.09>
#NoEnv
SetWorkingDir %A_ScriptDir%
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1
CoordMode, mouse, Screen
SetTimer, RemoveToolTip, -10000
ToolTip, `nCtrl+1/2 Add point`nAlt+1/2 Clear points`n1/2 Click points`nF6 to exit`nF5 toggle display,0,0

guiCount:=1
width:=30
height:=30
display := True
hoverColor := "Red"
points1:= []
points2:= []
init_points(points1,"Red")
init_points(points2,"Green")
SetTimer, hover, 1

1::
click_points(points1)
return

2::
click_points(points2)
return

^1::
hoverColor := "Red"
add_point(points1, "Red")
return

^2::
hoverColor := "Blue"
add_point(points2, "Blue")
return

!1::
clear_points(points1)
return

!2::
clear_points(points2)
return

F5::
display := !display
if (!display) {
    hide_gui()
} else {
    display_gui()
}
return

hover:
if (display) {
    MouseGetPos, currx, curry
    overlay_rect(currx, curry, width, height, 3, hoverColor, False)
}
return

F6::ExitApp
return

init_points(ByRef points,color) {
    global width, height, guiCount, js
    tempPoints := []
    For index, p In points
    {
        num := overlay_rect(p.currx, p.curry, width, height, 3, color, True)
        tempPoints.push({"currx":p.currx,"curry":p.curry,"x1":p.x1,"y1":p.y1,"x2":p.x2,"y2":p.y2,"gui":p.num})
    }
    points := tempPoints
}

clear_points(ByRef points) {
    For index, p In points
    {
        num := p.gui
        Gui %num%: Destroy
    }
    points := []
}

add_point(ByRef points, color) {
    global width, height, guiCount, js
    MouseGetPos, currx, curry
    num := overlay_rect(currx, curry, width, height, 3, color)
    x1 := currx - width/2
    x2 := currx + width/2
    y1 := curry - height/2
    y2 := curry + height/2
    points.push({"currx":currx,"curry":curry,"x1":x1,"y1":y1,"x2":x2,"y2":y2,"gui":num})
    js.save()
}

click_points(ByRef points) {
    MouseGetPos, currx, curry
    For index, p In points
    {
        click_box(p.x1, p.y1, p.x2, p.y2)
        Sleep, 50
    }
    MouseMove currx, curry
}

overlay_rect(X:=0, Y:=0, W:=0, H:=0, T:=3, cc:="Red", incr:=True) {
    global guiCount
    X -= W/2
    Y -= H/2
    w2:=W-T
    h2:=H-T
    txt := abs(mod(guiCount,99)+1)
    Gui %txt%: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
    Gui %txt%: Color, %cc%
    Gui %txt%: Show, w%W% h%H% x%X% y%Y% NA
    WinSet, Transparent, 150
    WinSet, Region, 0-0 %W%-0 %W%-%H% 0-%H% 0-0 %T%-%T% %w2%-%T% %w2%-%h2% %T%-%h2% %T%-%T%
    if (incr) {
        guiCount += 1
    }
    return txt
}

hide_gui() {
    loop, 99 {
        Gui %A_Index%: Hide
    }
}

display_gui() {
    loop, 99 {
        Gui %A_Index%: +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x08000000 +E0x80020
        Gui %A_Index%: Show
    }
}
click_box(x1, y1, x2, y2) {
    ToolTip
    x += target_random(x1,(x1+x2)/2,x2)
    y += target_random(y1,(y1+y2)/2,y2)
    MouseMove(x, y)
    Click
}

MouseMove(x,y,Speed:=2) {
    MouseGetPos, x0, y0
    xd := x-x0, yd := y-y0
    z := Sqrt(xd*xd+yd*yd)//Speed
    xd := xd/z, yd := yd/z
    Loop,% z {
        MouseMove, x0+=xd, y0+=yd, 1
        MouseGetPos, xx, yy
        xdd := x-xx, ydd := y-yy
        if (Sqrt(xdd*xdd+ydd*ydd) < 5) {
            sleep, 1
        }
    }
    Sleep, rand_range(20,30)
}

rand_range(min, max) {
    return (min+max)/2
}

target_random(min, target, max){
    Return, target
}

RemoveToolTip:
ToolTip
return