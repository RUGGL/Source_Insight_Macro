/************************ 以下为20260103增加的if 0注释插件  *************************/

macro MacroComment_If0()//Alt+1
{    //add #if 0 #endif
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    lnFirst=GetWndSelLnFirst(hwnd)
    lnLast=GetWndSelLnLast(hwnd)
    hbuf=GetCurrentBuf()

    if (LnFirst == 0)
    {
        szIfStart = ""
    }
    else
    {
        szIfStart = GetBufLine(hbuf, LnFirst-1)
    }

    szIfEnd = GetBufLine(hbuf, lnLast+1)

    if (szIfStart == "#if 0" && szIfEnd =="#endif")
    {
        DelBufLine(hbuf, lnLast+1)
        DelBufLine(hbuf, lnFirst-1)
        sel.lnFirst = sel.lnFirst – 1
        sel.lnLast = sel.lnLast – 1
    }
    else
    {
        InsBufLine(hbuf, lnFirst, "#if 0")
        InsBufLine(hbuf, lnLast+2, "#endif")
        sel.lnFirst = sel.lnFirst + 1
        sel.lnLast = sel.lnLast + 1
    }
    SetWndSel( hwnd, sel )
}

