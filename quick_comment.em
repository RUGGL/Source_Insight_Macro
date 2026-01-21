

//将选择的行添加斜杠星注释,每个 /* 注释 在代码段前后独立成一行
macro quick_Comment()
{
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    hbuf=GetCurrentBuf()
    firstln=sel.lnFirst
    lastln=sel.lnLast

    
    firstlnstr = GetBufLine(hbuf, sel.lnFirst)
    firstlnstrlen=strlen(firstlnstr)
    lastlnstr = GetBufLine(hbuf, sel.lnLast)
    lastlnstrlen=strlen(lastlnstr)
    first_char=min(sel.ichFirst,firstlnstrlen)
    last_char=min(sel.ichLim,lastlnstrlen)
    
//    msg "开始行为@firstln@,行内字符长度为@firstlnstrlen@"
//    msg "结束行为@lastln@,行内字符长度为@lastlnstrlen@"
//    msg "开始索引为@first_char@,结束索引为@last_char@"

    if(sel.lnFirst == sel.lnLast){//光标范围为一行
        
//        msg "开始索引为@first_char@,结束索引为@last_char@"

        if(sel.ichFirst == sel.ichLim){
        //单行，没有选择框
            first_char=find_visible_char_atbegin(firstlnstr) //第一个可见字符的索引位置
            last_char=find_unvisible_char_atend(firstlnstr) //最后一个可见字符的索引位置
            if(first_char==-1 || last_char==-1){ //本行没有可见字符
                mode=00
                //单行，没有选择框,没有可见字符
                //处理思路,从当前位置插入注释符号

            }else{
//情况0.0 单行,没有选择框,有可见字符
                        mode=01 //01模式为处理当前光标位置之后的代码

            }
            
            
        }else{
        //单行,有选择框
            firstlnstr_left=strmid(firstlnstr,0,first_char)
            firstlnstr_middle=strmid(firstlnstr,first_char,last_char)
            firstlnstr_right=strmid(firstlnstr,last_char,strlen(firstlnstr))
            if(strlen(strtrim(firstlnstr_middle)) == 0){//所选择范围为空,没有代码
                mode=02
//情况 单行,有选择框,内容为空
                firstlnstr_middle=cat("/*",firstlnstr_middle)
                firstlnstr_middle=cat(firstlnstr_middle,"*/")
                firstlnstr=cat(firstlnstr_left,firstlnstr_middle)
                firstlnstr=cat(firstlnstr,firstlnstr_right)
                PutBufLine(hbuf,firstln,firstlnstr) //替换原行
                sel.ichLim=sel.ichLim+4   //最后一个空格字符的下一索引位置
                SetWndSel(hwnd,sel)
                stop
            }else{
//情况0.1  单行,有选择框,不为空
                mode=03

            }
            
       }
    }else{
//情况1.0
       //选择了多行
       mode=10
        
       firstlnstr_right=strmid(firstlnstr,first_char,strlen(firstlnstr))
       lastlnstr_left=strmid(lastlnstr,0,last_char)    
       
        if(strlen(strtrim(firstlnstr_right))==0){//第一行选择范围内为空
            //第一行选择为空
            //删除第一行末尾空格
            lnstr = GetBufLine(hbuf,firstln)
            lnstr = trim_right(lnstr)
            PutBufLine(hbuf,firstln,lnstr)
            
            //第1行为空，自动修改选择框到下一行
            sel.lnFirst=sel.lnFirst+1
            firstln=firstln+1
            firstlnstr=GetBufLine(hbuf,sel.lnFirst)
            sel.ichFirst=0
            //sel.ichFirst=find_visible_char_atbegin(firstlnstr)
            //sel.ichLim=find_unvisible_char_atend(lastlnstr)
            SetWndSel(hwnd,sel)
        }
        //更多处理留给下文
        
    } 

    if(mode==00){
    //单行，未选择代码模式，为空
    //思路：只涉及注释插入，当前位置到行尾纳入注释范围，插入注释符号，并检查开头缩进
        first_char=sel.ichFirst
        last_char=firstlnstrlen
        firstlnstr_left=strmid(firstlnstr,0,first_char)
        firstlnstr_right=strmid(firstlnstr,first_char,last_char)
        
        firstlnst_right=cat("/*",firstlnstr_right) 
        firstlnst_right=cat(firstlnst_right,"*/") //直接开头末尾加入注释
        firstlnstr=cat(firstlnstr_left,firstlnst_right)
        PutBufLine(hbuf,firstln,firstlnstr) //替换原行
        
        sel.ichLim=strlen(firstlnstr)   
        
        
        //检查缩进
        indentnum_beforeln=getindentbeforeln(firstln)
        indentnum_afterln=getindentafterln(firstln)
        indentnum_currentln=getindentln(firstln)
        maxspacenum=max(indentnum_beforeln,indentnum_afterln)
        num=maxspacenum-indentnum_currentln //上下行的缩进最大值
        if(num>0){
            firstlnstr=cat(makespaceindent(num),firstlnst) //补充空格缩进
            sel.First=sel.First+num
            sel.ichLim=sel.ichLim+num
        }
        SetWndSel(hwnd,sel)
        stop
    
    }
    
    if(mode==01){
    //单行，未选择代码模式，非空
    //本模式的处理方式是在当前位置之后部分处理插入注释
         first_char=sel.ichFirst
         last_char=firstlnstrlen

         firstlnstr_left=strmid(firstlnstr,0,first_char)
         firstlnstr_right=strmid(firstlnstr,first_char,last_char)
         
         firstlnstr_right_begin=str_get(firstlnstr_right,0,2)
         firstlnstr_right_end=str_get(firstlnstr_right,0-2,2)
         if(!strcmp(firstlnstr_right_begin,"/*") && !strcmp(firstlnstr_right_end,"*/")){
        
             //如果已有注释,则取消注释
             //所选第一行开头的前两个非空字符时"/*" 且 最后一行后两个非空字符是 "*/"
             firstlnstr_right=replace_once_from_begin(firstlnstr_right,"/*","") //开头替换/*为空格
             firstlnstr_right=replace_once_from_end(firstlnstr_right,"*/","") //结尾替换*/为空格
        
             firstlnstr=cat(firstlnstr_left,firstlnstr_right) //重组第一行字符串
             //msg "单行未选择代码模式,取消注释,firstlnstr为@firstlnstr@"
             
             
             sel.ichFirst=first_char
             sel.ichLim=last_char-4
             
             //检查缩进
             indentnum_beforeln=getindentbeforeln(firstln)
             indentnum_afterln=getindentafterln(firstln)
             indentnum_currentln=getindentln(firstln)
             maxspacenum=max(indentnum_beforeln,indentnum_afterln)
             num=maxspacenum-indentnum_currentln //上下行的缩进最大值
             if(num>0){
                 firstlnstr=cat(makespaceindent(num),firstlnst) //补充空格缩进
                 sel.First=sel.First+num
                 sel.ichLim=sel.ichLim+num
             }
             PutBufLine(hbuf,sel.lnFirst,firstlnstr) //替换原行
             SetWndSel(hwnd,sel)
             stop
        
        
             
         }else{
             //如果没有注释,加注释
             //msg "第一个可见字符索引为@fisrt_visiblecharindex@,最后一个可见字符索引为@last_visiblecharindex@"
        
             firstlnstr_right=cat("/*",firstlnstr_right) 
             firstlnstr_right=cat(firstlnstr_right,"*/") //直接开头末尾加入注释
             
             firstlnstr=cat(firstlnstr_left,firstlnstr_right)
        
             sel.ichFirst=first_char
             sel.ichLim=last_char+4
        
        
//             //检查缩进
//             indentnum_beforeln=getindentbeforeln(firstln)
//             indentnum_afterln=getindentafterln(firstln)
//             indentnum_currentln=getindentln(firstln)
//             maxspacenum=max(indentnum_beforeln,indentnum_afterln)
//             num=maxspacenum-indentnum_currentln //上下行的缩进最大值
//             if(num>0){
//                 firstlnstr=cat(makespaceindent(num),firstlnst) //补充空格缩进
//                 sel.First=sel.First+num
//                 sel.ichLim=sel.ichLim+num
//             }
             PutBufLine(hbuf,sel.lnFirst,firstlnstr) //替换原行
             SetWndSel(hwnd,sel)
             stop
        }

    
    }

    if(mode==04){
        //单行，未选择代码模式，非空
        //本模式的处理方式是将整行进行注释、取消注释

        firstlnstr_left=strmid(firstlnstr,0,first_char)
        firstlnstr_middle=strmid(firstlnstr,first_char,last_char)
        firstlnstr_right=strmid(firstlnstr,last_char,firstlnstrlen)
        
        firstlnstr_middle_begin=str_get(firstlnstr_middle,0,2)
        firstlnstr_middle_end=str_get(firstlnstr_middle,0-2,2)
        if(!strcmp(firstlnstr_middle_begin,"/*") && !strcmp(firstlnstr_middle_end,"*/")){

            //如果已有注释,则取消注释
            //所选第一行开头的前两个非空字符时"/*" 且 最后一行后两个非空字符是 "*/"
            firstlnstr_middle=replace_once_from_begin(firstlnstr_middle,"/*","") //开头替换/*为空格
            firstlnstr_middle=replace_once_from_end(firstlnstr_middle,"*/","") //结尾替换*/为空格

            firstlnstr=cat(firstlnstr_left,firstlnstr_middle) //重组第一行字符串
            firstlnstr=cat(firstlnstr,firstlnstr_right)    //重组最后一行字符串
            //msg "单行未选择代码模式,取消注释,firstlnstr为@firstlnstr@"
            
            
            sel.ichFirst=first_char
            sel.ichLim=last_char-4
            
            //检查缩进
            indentnum_beforeln=getindentbeforeln(firstln)
            indentnum_afterln=getindentafterln(firstln)
            indentnum_currentln=getindentln(firstln)
            maxspacenum=max(indentnum_beforeln,indentnum_afterln)
            num=maxspacenum-indentnum_currentln //上下行的缩进最大值
            if(num>0){
                firstlnstr=cat(makespaceindent(num),firstlnst) //补充空格缩进
                sel.First=sel.First+num
                sel.ichLim=sel.ichLim+num
            }
            PutBufLine(hbuf,sel.lnFirst,firstlnstr) //替换原行
            SetWndSel(hwnd,sel)
            stop


            
        }else{
            //如果没有注释,加注释
            //msg "第一个可见字符索引为@fisrt_visiblecharindex@,最后一个可见字符索引为@last_visiblecharindex@"

            firstlnstr_middle=cat("/*",firstlnstr_middle) 
            firstlnstr_middle=cat(firstlnstr_middle,"*/") //直接开头末尾加入注释
            
            firstlnstr=cat(firstlnstr_left,firstlnstr_middle)
            firstlnstr=cat(firstlnstr,firstlnstr_right)


            sel.ichFirst=first_char
            sel.ichLim=last_char+4


            //检查缩进
            indentnum_beforeln=getindentbeforeln(firstln)
            indentnum_afterln=getindentafterln(firstln)
            indentnum_currentln=getindentln(firstln)
            maxspacenum=max(indentnum_beforeln,indentnum_afterln)
            num=maxspacenum-indentnum_currentln //上下行的缩进最大值
            if(num>0){
                firstlnstr=cat(makespaceindent(num),firstlnst) //补充空格缩进
                sel.First=sel.First+num
                sel.ichLim=sel.ichLim+num
            }
            PutBufLine(hbuf,sel.lnFirst,firstlnstr) //替换原行
            SetWndSel(hwnd,sel)
            stop
       }

    }
    
    if(mode==03){
        //单行，有选择框，不为空

        firstlnstr_middle=strmid(firstlnstr,first_char,last_char)

        last_char=first_char+find_unvisible_char_atend(firstlnstr_middle) //最后一个可见字符的索引位置
        first_char=first_char+find_visible_char_atbegin(firstlnstr_middle) //第一个可见字符的索引位置


        firstlnstr_left=strmid(firstlnstr,0,first_char)
        firstlnstr_middle=strmid(firstlnstr,first_char,last_char)
        firstlnstr_right=strmid(firstlnstr,last_char,firstlnstrlen)
        
        firstlnstr_middle_begin=str_get(firstlnstr_middle,0,2)
        firstlnstr_middle_end=str_get(firstlnstr_middle,0-2,2)

        //msg "单行选择代码,开始索引为@first_char@,结束索引为@last_char@"
        if(!strcmp(firstlnstr_middle_begin,"/*") && !strcmp(firstlnstr_middle_end,"*/")){
            //如果已有注释,则取消注释
            //所选第一行开头的前两个非空字符时"/*" 且 最后一行后两个非空字符是 "*/"
            firstlnstr_middle=replace_once_from_begin(firstlnstr_middle,"/*","") //开头替换/*为空
            firstlnstr_middle=replace_once_from_end(firstlnstr_middle,"*/","") //结尾替换*/为空

            firstlnstr=cat(firstlnstr_left,firstlnstr_middle) //重组第一行字符串
            firstlnstr=cat(firstlnstr,firstlnstr_right)    //重组最后一行字符串
            //msg "单行选择代码模式,取消注释,firstlnstr为@firstlnstr@"
            PutBufLine(hbuf,sel.lnFirst,firstlnstr) //替换选择行
            sel.ichFirst=first_char
            sel.ichLim=last_char-4
            SetWndSel(hwnd,sel)   

        }else{
            //如果没有注释,加注释

            //注意顺序,先插入后一个字符,否则第二次插入的字符索引位置会变化
//            msg "单行选择代码模式,增加注释,firstlnstr_left为@firstlnstr_left@"
//            msg "单行选择代码模式,增加注释,firstlnstr_middle为@firstlnstr_middle@"
//            msg "单行选择代码模式,增加注释,firstlnstr_right为@firstlnstr_right@"

            firstlnstr_middle=cat("/*",firstlnstr_middle) 
            firstlnstr_middle=cat(firstlnstr_middle,"*/") //直接开头末尾加入注释
            
            firstlnstr=cat(firstlnstr_left,firstlnstr_middle) //重组第一行字符串
            firstlnstr=cat(firstlnstr,firstlnstr_right)    //重组最后一行字符串
            //msg "单行选择代码模式,增加注释,firstlnstr为@firstlnstr@"
            PutBufLine(hbuf,sel.lnFirst,firstlnstr) //替换选择行
            sel.ichFirst=first_char
            sel.ichLim=last_char+4
            SetWndSel(hwnd,sel)

        }
    }
    
    if(mode == 10){
         //多行模式
        hbuf=GetCurrentBuf()

        firstlnstr = GetBufLine(hbuf, sel.lnFirst) //被选择的代码块的第一行内容
        firstlnstr_left=strmid(firstlnstr,0,sel.ichFirst)
        firstlnstr_right=strmid(firstlnstr,sel.ichFirst,strlen(firstlnstr))

        lastlnstr = GetBufLine(hbuf, sel.lnLast) //被选择的代码块的最后一行内容
        lastlnstr_left=strmid(lastlnstr,0,last_char)
        lastlnstr_right=strmid(lastlnstr,last_char,strlen(lastlnstr))

        firstlnstr_right_begin=strtrim(firstlnstr_right)
        firstlnstr_right_begin=str_get(firstlnstr_right_begin,0,2)
        lastlnstr_left_end=strtrim(lastlnstr_left)
        lastlnstr_left_end=str_get(lastlnstr_left_end,0-2,2)
        if(!strcmp(firstlnstr_right_begin,"/*") && !strcmp(lastlnstr_left_end,"*/")){

            //如果已有注释,取消注释
            //所选第一行开头的前两个非空字符时"/*" 且 最后一行后两个非空字符是 "*/"
            firstlnstr_right=replace_once_from_begin(firstlnstr_right,"/*","") //替换/*为空
            firstlnstr=cat(firstlnstr_left,firstlnstr_right) //重组第一行字符串
            
            lastlnstr_left=replace_once_from_end(lastlnstr_left,"*/","") //替换*/为空
            lastlnstr=cat(lastlnstr_left,lastlnstr_right) //重组最后一行字符串
            
            //msg "多行模式,取消注释,firstlnstr为@firstlnstr@"
            PutBufLine(hbuf,sel.lnFirst,firstlnstr)
            //msg "多行模式,取消注释,lastlnstr为@lastlnstr@"
            PutBufLine(hbuf,sel.lnLast,lastlnstr)
            sel.ichFirst=sel.ichFirst
            sel.ichLim=sel.ichLim-2
            SetWndSel(hwnd,sel)
        }else{
            //如果没有注释,加注释
            fisrt_visiblecharindex=find_visible_char_atbegin(firstlnstr_right) //第一个可见字符的索引位置
            last_visiblecharindex=find_unvisible_char_atend(lastlnstr_left) //最后一个可见字符的索引位置加1
          
            lastlnstr_left=str_insert(lastlnstr_left,last_visiblecharindex+1,"*/") //结尾插入*/
            lastlnstr=cat(lastlnstr_left,lastlnstr_right) //重组最后一行字符串

            firstlnstr_right=str_insert(firstlnstr_right,fisrt_visiblecharindex,"/*") //开头插入/*
            firstlnstr=cat(firstlnstr_left,firstlnstr_right) //重组第一行字符串
            
            //msg "多行模式,增加注释,firstlnstr为@firstlnstr@"
            PutBufLine(hbuf,sel.lnFirst,firstlnstr)
            //msg "多行模式,增加注释,lastlnstr为@lastlnstr@"
            PutBufLine(hbuf,sel.lnLast,lastlnstr)
            sel.ichFirst=sel.ichFirst
            sel.ichLim=sel.ichLim+2
            SetWndSel(hwnd,sel)

        }
    }

    //清除选择范围内,每行末尾的空格
    ln=firstln
    while (ln<=lastln)
    {
        lnstr = GetBufLine(hbuf,ln)
        lnstr = trim_right(lnstr)
        PutBufLine(hbuf,ln,lnstr)
        ln=ln+1
    }


}



//对选择的代码添加 或取消#if 0  #endif 包围
macro quick_AddMacroComment()
{
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    firstln=GetWndSelLnFirst(hwnd)
    lastln=GetWndSelLnLast(hwnd)
    hbuf=GetCurrentBuf()

    if (LnFirst == 0) 
    {
            szIfStart = ""
    } 
    else 
    {
            szIfStart = GetBufLine(hbuf, sel.lnFirst-1) //被选择的第一行的上一行的内容
    }
    szIfEnd = GetBufLine(hbuf, sel.lnLast+1) //被选择的代码块的最后一行的下一行内容


    szCodeStart = GetBufLine(hbuf, sel.lnFirst) //被选择的代码块的第一行内容
    szCodeEnd = GetBufLine(hbuf, sel.lnLast)//被选择的代码块的最后一行内容

    start_space_count = 0 //第一行代码的前面的空白个数  只计算Tab个数,忽略空格
    end_space_count = 0  //最后一行的代码的前面的空白个数
    insert_space_count = 0 //我们要插入的#if 0 字符串前面应该插入多少个Tab

    index = 0

    while(index<strlen(szCodeStart))
    {
        if(Char2Ascii(szCodeStart[index])== 9) //9是Tab字符的ASCII
        {
            start_space_count = start_space_count +4
        }
        if(Char2Ascii(szCodeStart[index])== 32) //32是空格字符的ASCII
        {
            start_space_count = start_space_count +1
        }
        index = index + 1 
    }

    index = 0
    while(index<strlen(szCodeEnd))
    {
        if(Char2Ascii(szCodeStart[index])== 9) //9是Tab字符的ASCII
        {
            start_space_count = start_space_count +4
        }
        if(Char2Ascii(szCodeStart[index])== 32) //32是空格字符的ASCII
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

    if (!strcmp(str_get(strtrim(szIfStart),0,5),"#if 0") && !strcmp(str_get(strtrim(szIfEnd),0-6,6),"#endif")) {
            DelBufLine(hbuf, lnLast+1)
            DelBufLine(hbuf, lnFirst-1)
            sel.lnFirst = sel.lnFirst - 1
            sel.lnLast = sel.lnLast - 1
    } 
    else 
    {
            InsBufLine(hbuf, sel.lnFirst, str_start_insert)
            InsBufLine(hbuf,sel.lnLast+2, str_end_insert)
            sel.lnFirst = sel.lnFirst + 1
            sel.lnLast = sel.lnLast + 1
    }
    SetWndSel( hwnd, sel )
}

//生成空格
function makespaceindent(n){
    i=0
    str=""
    while(i<n){
        str=cat(str," ")
    }
    return str
}

//获取当前行的开头缩进,找到返回数量n，找不到返回0
function getindentln(ln){
    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)
    
    if(ln<1 || ln>maxline){
        return 0
    }

    beforeln=ln-1
    lnstr = GetBufLine(hbuf,beforeln)
    len=strlen(lnstr)
    i=0
    while(i<len){
        ch=lnstr[i]
        if(is_visible_char(ch)){
            break
       }
       i=i+1
   }
   
    num=i
    if(num>0){
        return num //第1个可见字符索引号即空格数量
    }else{
        return 0
    }
}


//获取当前行上一行的开头缩进,找到返回数量n，找不到返回0
function getindentbeforeln(ln){
    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)
    
    if(ln<1 || ln>maxline){
        return 0
    }
    if(ln==1){
        return 0
    }
    beforeln=ln-1
    lnstr = GetBufLine(hbuf,beforeln)
    len=strlen(lnstr)
    i=0
    while(i<len){
     ch=lnstr[i]
     if(is_visible_char(ch)){
         break
    }
    i=i+1
    }

    num=i
    if(num>0){
     return num //第1个可见字符索引号即空格数量
    }else{
     return 0
    }

}

//获取当前行下一行的开头缩进,找到返回数量n，找不到返回0
function getindentafterln(ln){

    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)
    if(ln<1 || ln>maxline){
        return 0
    }
    if(ln==maxline-1){
        return 0
    }
    
    afterln=ln+1
    lnstr = GetBufLine(hbuf,afterln)
    len=strlen(lnstr)
    i=0
    while(i<len){
     ch=lnstr[i]
     if(is_visible_char(ch)){
         break
    }
    i=i+1
    }

    num=i
    if(num>0){
     return num //第1个可见字符索引号即空格数量
    }else{
     return 0
    }


}

