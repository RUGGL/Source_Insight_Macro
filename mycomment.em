

//将选择的行添加斜杠星注释,每个 /* 注释 在代码段前后独立成一行
macro slash_asterisk_MultiLineComment()
{
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
            szIfStart = GetBufLine(hbuf, LnFirst-1) //被选择的第一行的上一行的内容
    }
    szIfEnd = GetBufLine(hbuf, lnLast+1) //被选择的代码块的最后一行的下一行内容


    szCodeStart = GetBufLine(hbuf, LnFirst) //被选择的代码块的第一行内容
    szCodeEnd = GetBufLine(hbuf, lnLast)//被选择的代码块的最后一行内容

    start_space_count = 0 //第一行代码的前面的空白个数  只计算Tab个数,忽略空格
    end_space_count = 0  //最后一行的代码的前面的空白个数
    insert_space_count = 0

    index = 0

    while(index<strlen(szCodeStart))
    {
        if(AsciiFromChar(szCodeStart[index])== 9) //9是Tab字符的ASCII
        {
            start_space_count = start_space_count +4
        }
        if(AsciiFromChar(szCodeStart[index])== 32) //32是空格字符的ASCII
        {
            start_space_count = start_space_count +1
        }
        index = index + 1 
    }

    index = 0
    while(index<strlen(szCodeEnd))
    {
        if(AsciiFromChar(szCodeEnd[index])== 9)
        {
            end_space_count=end_space_count+1
        }
        index = index + 1 
    }

    if(start_space_count<end_space_count)
    {
        insert_space_count = start_space_count -1
    }
    else
    {
        insert_space_count = end_space_count -1
    }

    str_start_insert=""
    str_end_insert=""
    index=0

    while(index<insert_space_count)
    {
        str_start_insert=str_start_insert#" "  //这里添加的 字符
        str_end_insert=str_end_insert#" "
        index = index + 1 
    }
    str_start_insert=str_start_insert#"/*"    //在注释开始符号和结束符号前都添加 字符,比代码行前面的空白少一个
    str_end_insert=str_end_insert#"*/"    

    if (_slash_asterisk_TrimString(szIfStart) == "/*" && _slash_asterisk_TrimString(szIfEnd) =="*/") {
            DelBufLine(hbuf, lnLast+1)
            DelBufLine(hbuf, lnFirst-1)
            sel.lnFirst = sel.lnFirst - 1
            sel.lnLast = sel.lnLast - 1
    } else {
            InsBufLine(hbuf, lnFirst, str_start_insert)
            InsBufLine(hbuf, lnLast+2, str_end_insert)
            sel.lnFirst = sel.lnFirst + 1
            sel.lnLast = sel.lnLast + 1
    }

    SetWndSel( hwnd, sel )
}



//对选择的代码添加 或取消#if 0  #endif 包围
macro slash_asterisk_AddMacroComment()
{
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
            szIfStart = GetBufLine(hbuf, LnFirst-1) //被选择的第一行的上一行的内容
    }
    szIfEnd = GetBufLine(hbuf, lnLast+1) //被选择的代码块的最后一行的下一行内容


    szCodeStart = GetBufLine(hbuf, LnFirst) //被选择的代码块的第一行内容
    szCodeEnd = GetBufLine(hbuf, lnLast)//被选择的代码块的最后一行内容

    start_space_count = 0 //第一行代码的前面的空白个数  只计算Tab个数,忽略空格
    end_space_count = 0  //最后一行的代码的前面的空白个数
    insert_space_count = 0 //我们要插入的#if 0 字符串前面应该插入多少个Tab

    index = 0

    while(index<strlen(szCodeStart))
    {
        if(AsciiFromChar(szCodeStart[index])== 9) //9是Tab字符的ASCII
        {
            start_space_count = start_space_count +4
        }
        if(AsciiFromChar(szCodeStart[index])== 32) //32是空格字符的ASCII
        {
            start_space_count = start_space_count +1
        }
        index = index + 1 
    }

    index = 0
    while(index<strlen(szCodeEnd))
    {
        if(AsciiFromChar(szCodeStart[index])== 9) //9是Tab字符的ASCII
        {
            start_space_count = start_space_count +4
        }
        if(AsciiFromChar(szCodeStart[index])== 32) //32是空格字符的ASCII
        {
            start_space_count = start_space_count +1
        }
        index = index + 1 
    }

    //代码块的第一行和最后一行前面的Tab个数,取比较小的那个值
    if(start_space_count<end_space_count)
    {
        insert_space_count = start_space_count -1
    }
    else
    {
        insert_space_count = end_space_count -1
    }

    str_start_insert=""
    str_end_insert=""
    index=0

    while(index<insert_space_count)
    {
        str_start_insert=str_start_insert#" "  //这里添加的 字符
        str_end_insert=str_end_insert#" "  //这里添加的也是 字符
        index = index + 1 
    }
    str_start_insert=str_start_insert#"#if 0"    //在#if 0 开始符号和结束符号前都添加 字符,比代码行前面的空白少一个
    str_end_insert=str_end_insert#"#endif"    

    if (_slash_asterisk_TrimString(szIfStart) == "#if 0" && _slash_asterisk_TrimString(szIfEnd) =="#endif") {
            DelBufLine(hbuf, lnLast+1)
            DelBufLine(hbuf, lnFirst-1)
            sel.lnFirst = sel.lnFirst - 1
            sel.lnLast = sel.lnLast - 1
    } 
    else 
    {
            InsBufLine(hbuf, lnFirst, str_start_insert)
            InsBufLine(hbuf, lnLast+2, str_end_insert)
            sel.lnFirst = sel.lnFirst + 1
            sel.lnLast = sel.lnLast + 1
    }
    SetWndSel( hwnd, sel )
}


//将选择的行添加斜杠星注释,每个 /* 注释 在代码段同行  
macro slash_asterisk_SingleLineComment()
{
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
            szIfStart = GetBufLine(hbuf, LnFirst) //被选择的第一行的上一行的内容
    }
    szIfEnd = GetBufLine(hbuf, lnLast) //被选择的代码块的最后一行的下一行内容


    szCodeStart = GetBufLine(hbuf, LnFirst) //被选择的代码块的第一行内容
    szCodeEnd = GetBufLine(hbuf, lnLast)//被选择的代码块的最后一行内容

    start_space_count = 0 //第一行代码的前面的空白个数  只计算Tab个数,忽略空格
    end_space_count = 0  //最后一行的代码的前面的空白个数
    insert_space_count = 0

    index = 0

    while(index<strlen(szCodeStart))
    {
        if(AsciiFromChar(szCodeStart[index])== 9) //9是Tab字符的ASCII
        {
            start_space_count = start_space_count +4
        }
        if(AsciiFromChar(szCodeStart[index])== 32) //32是空格字符的ASCII
        {
            start_space_count = start_space_count +1
        }
        index = index + 1 
    }

    index = 0
    while(index<strlen(szCodeEnd))
    {
        if(AsciiFromChar(szCodeEnd[index])== 9)
        {
            end_space_count=end_space_count+1
        }
        index = index + 1 
    }

    if(start_space_count<end_space_count)
    {
        insert_space_count = start_space_count -1
    }
    else
    {
        insert_space_count = end_space_count -1
    }

    str_start_insert=""
    str_end_insert=""
    index=0

    while(index<insert_space_count)
    {
        str_start_insert=str_start_insert#" "  //这里添加的 字符
        str_end_insert=str_end_insert#" "
        index = index + 1 
    }
    str_start_insert=str_start_insert#"/*"    //在注释开始符号和结束符号前都添加 字符,比代码行前面的空白少一个
    str_end_insert=str_end_insert#"*/"    
    start_string=_slash_asterisk_TrimString(szCodeStart)
    end_sting=_slash_asterisk_TrimString(szCodeEnd)
    if ( == "/*" &&  =="*/") {
            DelBufLine(hbuf, lnLast+1) //从后往前删除行
            DelBufLine(hbuf, lnFirst-1) 
            sel.lnFirst = sel.lnFirst - 1
            sel.lnLast = sel.lnLast - 1
    } else {
            InsBufLine(hbuf, lnFirst, str_start_insert)
            InsBufLine(hbuf, lnLast+2, str_end_insert)
            sel.lnFirst = sel.lnFirst + 1
            sel.lnLast = sel.lnLast + 1
    }

    SetWndSel( hwnd, sel )
}



//去掉左边空格,Tab等
macro _slash_asterisk_TrimLeft(szLine)
{
    nLen = strlen(szLine)
    if(nLen == 0)
    {
        return szLine
    }
    nIdx = 0
    while( nIdx < nLen )
    {
        if( ( szLine[nIdx] != " ") && (szLine[nIdx] != "\t") )
        {
            break
        }
        nIdx = nIdx + 1
    }
    return strmid(szLine,nIdx,nLen)
}


//去掉字符串右边的空格
macro _slash_asterisk_TrimRight(szLine)
{
    nLen = strlen(szLine)
    if(nLen == 0)
    {
        return szLine
    }
    nIdx = nLen
    while( nIdx > 0 )
    {
        nIdx = nIdx - 1
        if( ( szLine[nIdx] != " ") && (szLine[nIdx] != "\t") )
        {
            break
        }
    }
    return strmid(szLine,0,nIdx+1)
}

//去掉字符串两边空格
macro _slash_asterisk_TrimString(szLine)
{
    szLine = TrimLeft(szLine)
    szLIne = TrimRight(szLine)
    return szLine
}


