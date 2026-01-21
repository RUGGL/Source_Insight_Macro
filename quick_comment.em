

//将选择的行添加斜杠星注释,每个 /* 注释 在代码段前后独立成一行
macro quick_Comment()
{
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    hbuf=GetCurrentBuf()
    firstln=sel.lnFirst
    lastln=sel.lnLast
    clean=1 //是否清除每行末尾空格,建议加注释时清除，取消注释时不清除，防止影响缩进
    
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
        
//        //msg "开始索引为@first_char@,结束索引为@last_char@"

        if(sel.ichFirst == sel.ichLim){
        //单行,没有选择框
            first_char=find_first_visible_char(firstlnstr) //第一个可见字符的索引位置
            last_char=find_last_visible_char(firstlnstr)+1 //最后一个可见字符的索引位置
            if(first_char==-1 || last_char==0){ //本行没有可见字符
                mode=00
                //单行,没有选择框,没有可见字符
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

            }else{
//情况0.1  单行,有选择框,不为空
                mode=03

            }
            
       }
    }else{
//情况1.0
       //选择了多行
       mode=10
        
//       firstlnstr_right=strmid(firstlnstr,first_char,strlen(firstlnstr))
//       lastlnstr_left=strmid(lastlnstr,0,last_char)    
       
//        if(strlen(strtrim(firstlnstr_right))==0){//第一行选择范围内为空
//            //第一行选择为空
//            //删除第一行末尾空格
//            lnstr = GetBufLine(hbuf,firstln)
//            lnstr = trim_right(lnstr)
//            PutBufLine(hbuf,firstln,lnstr)
            
//            //第1行为空，自动修改选择框到下一行
//            sel.lnFirst=sel.lnFirst+1
//            firstln=firstln+1
//            firstlnstr=GetBufLine(hbuf,sel.lnFirst)
//            sel.ichFirst=0
//            //sel.ichFirst=find_first_visible_char(firstlnstr)
//            //sel.ichLim=find_last_visible_char(lastlnstr)+1
//            SetWndSel(hwnd,sel)
//        }
        //更多处理留给下文
        
    } 

    if(mode==00){
    //单行，未选择代码模式，为空
    //思路：只涉及注释插入，当前位置到行尾纳入注释范围，插入注释符号，并检查开头缩进
        //msg "mode=@mode@,单行,没有选择框,没有可见字符"
        first_char=sel.ichFirst
        last_char=firstlnstrlen
        firstlnstr_left=strmid(firstlnstr,0,first_char)
        firstlnstr_right=strmid(firstlnstr,first_char,last_char)
        
        firstlnst_right=cat("/*",firstlnstr_right) 
        firstlnst_right=cat(firstlnst_right,"*/") //直接开头末尾加入注释
        firstlnstr=cat(firstlnstr_left,firstlnst_right)
        
        
        sel.ichLim=strlen(firstlnstr)   
        
        
        //检查缩进
        indentnum_beforeln=getindent_preln(firstln)
        indentnum_afterln=getindent_nextln(firstln)
        indentnum_currentln=getindentln(firstln)
        maxspacenum=max(indentnum_beforeln,indentnum_afterln)
        num=maxspacenum-min(first_char,indentnum_currentln) //开头需补充的空格数
        //msg "上行缩进值为@indentnum_beforeln@，下行缩进值为@indentnum_afterln@，本行缩进值为@indentnum_currentln@"
        //msg "当前光标索引为@first_char@，需补充空格数为@num@"
        if(num>0){
            space=makespaceindent(num)
            firstlnstr=cat(space,firstlnstr) //补充空格缩进
            
            //msg "生成的空格为@space@"
            sel.ichFirst=sel.ichFirst+num
            sel.ichLim=sel.ichLim+num
        }
        PutBufLine(hbuf,firstln,firstlnstr) //替换原行
        SetWndSel(hwnd,sel)
    }
    

    
    if(mode==02){
    //单行，有选择框，内容为空
         //msg "mode=@mode@,单行,有选择框,有可见字符"
         firstlnstr_middle=cat("/*",firstlnstr_middle)
         firstlnstr_middle=cat(firstlnstr_middle,"*/")
         
         firstlnstr=cat(firstlnstr_left,firstlnstr_middle)
         firstlnstr=cat(firstlnstr,firstlnstr_right)
         PutBufLine(hbuf,firstln,firstlnstr) //替换原行
         sel.ichLim=sel.ichLim+4   //最后一个空格字符的下一索引位置
         SetWndSel(hwnd,sel)

    
    }
    
    if(mode==01){
    //单行，未选择代码模式，非空
    //本模式的处理方式是在当前位置之后部分处理插入注释
    //msg "mode=@mode@,单行,没有选择框,有可见字符"
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
             indentnum_beforeln=getindent_preln(firstln)
             indentnum_afterln=getindent_nextln(firstln)
             indentnum_currentln=getindentln(firstln)
             maxspacenum=max(indentnum_beforeln,indentnum_afterln)
             num=maxspacenum-min(first_char,indentnum_currentln) //开头需补充的空格数
             if(num>0){
                 firstlnstr=cat(makespaceindent(num),firstlnstr) //补充空格缩进
                 sel.ichFirst=sel.ichFirst+num
                 sel.ichLim=sel.ichLim+num
             }
             PutBufLine(hbuf,sel.lnFirst,firstlnstr) //替换原行
             SetWndSel(hwnd,sel)
             clean=0
        
        
             
         }else{
             //如果没有注释,加注释
             
        
             firstlnstr_right=cat("/*",firstlnstr_right) 
             firstlnstr_right=cat(firstlnstr_right,"*/") //直接开头末尾加入注释
             
             firstlnstr=cat(firstlnstr_left,firstlnstr_right)
        
             sel.ichFirst=first_char
             sel.ichLim=last_char+4
        
        
//             //检查缩进
//             indentnum_beforeln=getindent_preln(firstln)
//             indentnum_afterln=getindent_nextln(firstln)
//             indentnum_currentln=getindentln(firstln)
//             maxspacenum=max(indentnum_beforeln,indentnum_afterln)
//             num=maxspacenum-min(first_char,indentnum_currentln) //开头需补充的空格数
//             if(num>0){
//                 firstlnstr=cat(makespaceindent(num),firstlnstr) //补充空格缩进
//                 sel.ichFirst=sel.ichFirst+num
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
        //msg "mode=@mode@,单行,没有选择框,有可见字符,整行处理模式"

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
            
            
            
            sel.ichFirst=first_char
            sel.ichLim=last_char-4
            
            //检查缩进
            indentnum_beforeln=getindent_preln(firstln)
            indentnum_afterln=getindent_nextln(firstln)
            indentnum_currentln=getindentln(firstln)
            maxspacenum=max(indentnum_beforeln,indentnum_afterln)
            num=maxspacenum-min(first_char,indentnum_currentln) //开头需补充的空格数
            if(num>0){
                space=makespaceindent(num)
                firstlnstr=cat(space,firstlnstr) //补充空格缩进

                sel.ichFirst=sel.ichFirst+num
                sel.ichLim=sel.ichLim+num
            }
            PutBufLine(hbuf,sel.lnFirst,firstlnstr) //替换原行
            SetWndSel(hwnd,sel)
            clean=0

            
        }else{
            //如果没有注释,加注释
            

            firstlnstr_middle=cat("/*",firstlnstr_middle) 
            firstlnstr_middle=cat(firstlnstr_middle,"*/") //直接开头末尾加入注释
            
            firstlnstr=cat(firstlnstr_left,firstlnstr_middle)
            firstlnstr=cat(firstlnstr,firstlnstr_right)


            sel.ichFirst=first_char
            sel.ichLim=last_char+4


            //检查缩进
            indentnum_beforeln=getindent_preln(firstln)
            indentnum_afterln=getindent_nextln(firstln)
            indentnum_currentln=getindentln(firstln)
            maxspacenum=max(indentnum_beforeln,indentnum_afterln)
            num=maxspacenum-min(first_char,indentnum_currentln) //开头需补充的空格数
            if(num>0){
                space=makespaceindent(num)
                firstlnstr=cat(space,firstlnstr) //补充空格缩进

                sel.ichFirst=sel.ichFirst+num
                sel.ichLim=sel.ichLim+num
            }
            PutBufLine(hbuf,sel.lnFirst,firstlnstr) //替换原行
            SetWndSel(hwnd,sel)
       }

    }
    
    if(mode==03){
        //单行，有选择框，不为空
        
        //msg "mode=@mode@,单行，有选择框，不为空"
        firstlnstr_middle=strmid(firstlnstr,first_char,last_char)

        last_char=first_char+find_last_visible_char(firstlnstr_middle)+1 //最后一个可见字符的索引位置
        first_char=first_char+find_first_visible_char(firstlnstr_middle) //第一个可见字符的索引位置


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
            clean=0
        }else{
            //如果没有注释,加注释

            //注意顺序,先插入后一个字符,否则第二次插入的字符索引位置会变化
//            //msg "单行选择代码模式,增加注释,firstlnstr_left为@firstlnstr_left@"
//            //msg "单行选择代码模式,增加注释,firstlnstr_middle为@firstlnstr_middle@"
//            //msg "单行选择代码模式,增加注释,firstlnstr_right为@firstlnstr_right@"

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
        //先尝试找到当前选择框内是否有注释
        //msg "mode=@mode@,多行模式，有选择框，不为空"
        isnoted=0
        if(isincludenote()){
        //内部发现有注释
        //msg "多行模式,内部发现有注释"
            beginln=getln_visiblechar_searchdown(sel.lnFirst,sel.ichFirst) //内部从开头向下
            beginich=getich_visiblechar_searchdown(sel.lnFirst,sel.ichFirst)
            endln=getln_visiblechar_searchup(sel.lnLast,sel.ichLim)  //内部从尾部向上
            endich=getich_visiblechar_searchup(sel.lnLast,sel.ichLim) 
            //内部注释时,不更新选择框
//            sel.lnFirst=beginln
//            sel.lnLast=endln
//            sel.ichFirst=beginich
//            sel.ichLim=endich+1
//            SetWndSel(hwnd,sel)
            //msg "beginich为@beginich@"
            firstln=beginln
            lastln=endln
            
            firstlnstr = GetBufLine(hbuf, beginln)
            firstlnstrlen=strlen(firstlnstr)
            lastlnstr = GetBufLine(hbuf, endln)
            lastlnstrlen=strlen(lastlnstr)
            first_char=beginich
            last_char=endich+1
            isnoted=1
            

        }else if(iswrappedbynote()){
        //外部发现注释符号
        //msg "多行模式,外部发现注释符号"
            beginln=getln_visiblechar_searchup(sel.lnFirst,sel.ichFirst) //外部从开头向上
            beginich=getich_visiblechar_searchup(sel.lnFirst,sel.ichFirst)
            endln=getln_visiblechar_searchdown(sel.lnLast,sel.ichLim)  //外部从尾部向下
            endich=getich_visiblechar_searchdown(sel.lnLast,sel.ichLim) 
            //更新选择框
            sel.lnFirst=beginln
            sel.lnLast=endln
            sel.ichFirst=beginich-1
            //msg "beginich为@beginich@"
            sel.ichLim=endich+2
            SetWndSel(hwnd,sel)
            
            firstln=sel.lnFirst
            lastln=sel.lnLast
            
            firstlnstr = GetBufLine(hbuf, sel.lnFirst)
            firstlnstrlen=strlen(firstlnstr)
            lastlnstr = GetBufLine(hbuf, sel.lnLast)
            lastlnstrlen=strlen(lastlnstr)
            first_char=min(sel.ichFirst,firstlnstrlen)
            last_char=min(sel.ichLim,lastlnstrlen)
            isnoted=1
        }else{
            //内外都没有发现注释符号
            isnoted=0
            //向外扩展空白区域
            beginln=getln_visiblechar_searchup(sel.lnFirst,0) //外部从开头向上扩展空白行
            endln=getln_visiblechar_searchdown(sel.lnLast,lastlnstrlen)  //外部从向下扩展空白
            if(beginln+1<sel.lnFirst){
                sel.lnFirst=beginln+1
                firstln=sel.lnFirst
            }
            if(endln-1>sel.lnLast){
                sel.lnLast=endln-1
                lastln=sel.lnFirst
            }
            sel.ichFirst=0
            first_char=0
            lastlnstr = GetBufLine(hbuf, sel.lnLast)
            lastlnstrlen=strlen(lastlnstr)
            sel.ichLim=lastlnstrlen+1
            last_char=lastlnstrlen
            SetWndSel(hwnd,sel)
            

        }
        
        firstlnstr = GetBufLine(hbuf, firstln) //被选择的代码块的第一行内容 或 注释符所在行
        firstlnstr_left=strmid(firstlnstr,0,first_char)
        firstlnstr_right=strmid(firstlnstr,first_char,strlen(firstlnstr))

        lastlnstr = GetBufLine(hbuf, lastln) //被选择的代码块的最后一行内容           或 注释符所在行
        lastlnstr_left=strmid(lastlnstr,0,last_char)
        lastlnstr_right=strmid(lastlnstr,last_char,strlen(lastlnstr))

//        firstlnstr_right_begin=strtrim(firstlnstr_right)
//        firstlnstr_right_begin=str_get(firstlnstr_right_begin,0,2)
//        lastlnstr_left_end=strtrim(lastlnstr_left)
//        lastlnstr_left_end=str_get(lastlnstr_left_end,0-2,2)
        
        if(isnoted){

            //如果已有注释,取消注释
            //所选第一行开头的前两个非空字符时"/*" 且 最后一行后两个非空字符是 "*/"
            //firstlnstr_right=replace_once_from_begin(firstlnstr_right,"/*","") //替换/*为空
            firstlnstr_right=strmid(firstlnstr_right,2,strlen(firstlnstr_right))
            firstlnstr=cat(firstlnstr_left,firstlnstr_right) //重组第一行字符串
            
            //lastlnstr_left=replace_once_from_end(lastlnstr_left,"*/","") //替换*/为空
            leftlen=strlen(lastlnstr_left)
            lastlnstr_left=strmid(lastlnstr_left,0,leftlen-2)
            lastlnstr=cat(lastlnstr_left,lastlnstr_right) //重组最后一行字符串            
            //msg "多行模式,取消注释,firstlnstr为@firstlnstr@" //不是选择框,因为注释符可能不跟选择框在一行
            PutBufLine(hbuf,firstln,firstlnstr)
            //msg "多行模式,取消注释,lastlnstr为@lastlnstr@"
            PutBufLine(hbuf,lastln,lastlnstr)

            
//            sel=GetWndSel(hwnd)
//            if(lastln==sel.lnLast){
//                sel.ichLim=sel.ichLim-2
//                SetWndSel(hwnd,sel)
//            }
            
            
            clean=0
        }else{
            //如果没有注释,加注释,
            //代码前后新建两行插入注释符号
            
            //检查缩进
            indentnum_beforeln=getindent_preln(firstln)
            indentnum_afterln=getindent_nextln(firstln)
            //indentnum_currentln=getindentln(firstln)
            maxspacenum=max(indentnum_beforeln,indentnum_afterln)
            num=max(0,maxspacenum-2) //开头需补充的空格数
            notebegin=cat(makespaceindent(num),"/*")
            noteend=cat(makespaceindent(num),"*/")

            //插入哪一行,相当于占据哪行位置,之前内容后移一行
            if(is_visible_str(lastlnstr)){
                
                InsBufLine (hbuf,sel.lnLast+1,noteend)
                sel.lnLast=sel.lnLast+1
            }else{
                PutBufLine (hbuf,sel.lnLast,noteend)
            }

            if(is_visible_str(firstlnstr)){
                InsBufLine (hbuf,sel.lnFirst,notebegin)
                sel.lnLast=sel.lnLast+1
                //sel.lnFirst=sel.lnFirst+1
                
            }else{
                PutBufLine (hbuf,sel.lnFirst,notebegin)
            }
            
            sel.ichLim=strlen(noteend)
            sel.ichFirst=0
            SetWndSel(hwnd,sel)

//           if(0){
//           //选择框同行添加注释符号的方式
//            firstlnstr_right=cat("/*",firstlnstr_right)
//            firstlnstr=cat(firstlnstr_left,firstlnstr_right) //重组第一行字符串
            
//            lastlnstr_left=cat(lastlnstr_left,"*/")
//            lastlnstr=cat(lastlnstr_left,lastlnstr_right) //重组最后一行字符串

//            //msg "多行模式,增加注释,firstlnstr为@firstlnstr@"
//            PutBufLine(hbuf,sel.lnFirst,firstlnstr)
//            //msg "多行模式,增加注释,lastlnstr为@lastlnstr@"
//            PutBufLine(hbuf,sel.lnLast,lastlnstr)
            
//            sel.ichFirst=sel.ichFirst
//            sel.ichLim=sel.ichLim+2
//            SetWndSel(hwnd,sel)
//            }

        }
    }

    //清除选择范围内,每行末尾的空格
    
//    if(clean==1){
//        ln=firstln
//        while (ln<=lastln)
//        {
//            lnstr = GetBufLine(hbuf,ln)
//            lnstr = trim_right(lnstr)
//            PutBufLine(hbuf,ln,lnstr)
//            ln=ln+1
//        }
//    }



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

//判断选择框内是是否包含注释符号
function isincludenote(){
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    //向上查找时,不包含当前索引字符
    //向下查找时,包含当前索引字符
    //先内部向下搜索
    beginln=getln_visiblechar_searchdown(sel.lnFirst,sel.ichFirst) //内部从开头向下
    beginich=getich_visiblechar_searchdown(sel.lnFirst,sel.ichFirst)
    endln=getln_visiblechar_searchup(sel.lnLast,sel.ichLim+1)  //内部从尾部向上
    endich=getich_visiblechar_searchup(sel.lnLast,sel.ichLim+1) 
    //msg "内部注释:beginln为@beginln@,beginich为@beginich@,endln为@endln@,endich为@endich@"
    if(beginln<0 || beginich<0 || endln<0 || endich<1 || beginln>endln){
        //找不到可见字符,内部为空
        return 0
    }
    beginnote=getlncontent(beginln,beginich,2)
    endnote=getlncontent(endln,endich-1,2)
    if( beginnote == "/*" && endnote == "*/")
    {
        return 1
    }

    return 0
}
//选择的代码范围是否被注释符号包裹
function iswrappedbynote(){
    hwnd=GetCurrentWnd()
    sel=GetWndSel(hwnd)
    
    //向上查找时,不包含当前索引字符
    //向下查找时,包含当前索引字符
    beginln=getln_visiblechar_searchup(sel.lnFirst,sel.ichFirst) //外部从开头向上
    beginich=getich_visiblechar_searchup(sel.lnFirst,sel.ichFirst)
    endln=getln_visiblechar_searchdown(sel.lnLast,sel.ichLim+1)  //外部从尾部向下
    endich=getich_visiblechar_searchdown(sel.lnLast,sel.ichLim+1) 
    //msg "外部注释:beginln为@beginln@,beginich为@beginich@,endln为@endln@,endich为@endich@"
    
    if(beginln<0 || beginich<1 || endln<0 || endich<0){
        //找不到可见字符,内部为空
        return 0
    }
    beginnote=getlncontent(beginln,beginich-1,2)
    endnote=getlncontent(endln,endich,2)
    if( beginnote == "/*" && endnote == "*/")
    {
        return 1
    }
    return 0
}


//获取行内指定位置开始指定长度的字符串
function getlncontent(ln,ich,num){
    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)
    if(ln<0 || ln>=maxline){
        return ""
    }
    lnstr = GetBufLine(hbuf, ln)
    len=strlen(lnstr)
    endich=ich+num
    if(ich <0 || num <0 || endich > len){
        return ""
    }
    //msg "获取行内指定位置字符串,行@ln@,索引@ich@,数量@num@"
    str=strmid(lnstr,ich,endich)
    return str
}

//生成空格,最小为0个字符
function makespaceindent(n){

    if(n<0){
        return ""
    }
    if(n>120){ //太长空格不处理，防止溢出
        return ""
    }
    str=""
    
    i=0
    while(i<n){
        str=cat(CharFromAscii(32),str)
        i=i+1
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

    lnstr = GetBufLine(hbuf,ln)
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

//source insight返回的行号,是从0开始索引的
//获取当前行上一行的开头缩进,找到返回数量n，找不到返回-1
function getindent_preln(ln){
    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)
    
    if(ln<0 || ln>=maxline){
        return -1
    }
    if(ln==0){
        return -1
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
function getindent_nextln(ln){

    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)
    if(ln<0 || ln>=maxline){
        return -1
    }
    if(ln==maxline-1){
        return -1
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
    if(num>=0){
     return num //第1个可见字符索引号即空格数量
    }else{
     return -1
    }


}

//从当前位置向上找到最早一个可见字符所在的行,找到返回行，找不到返回0，(当前位置的字符不计算在内)
//向上查找时,不包含当前索引字符
function getln_visiblechar_searchup(fromln,fromindex){
    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)

    
    //msg "当前查找起始行编号为@fromln@,索引为@fromindex@,最大行号为@maxline@"
    if(fromln<0 || fromln>=maxline){
        return -1
    }

    ln=fromln
    lnstr = GetBufLine(hbuf,ln)
    
    index=fromindex
    len=strlen(lnstr)
    if(index>len){
        index=len
    }

    
    lnstr=strmid(lnstr,0,index)
    //msg "向上搜索,当前搜索行内容为@lnstr@"
    //先搜索所在行
    try=find_last_visible_char(lnstr)
    if(try>=0){
        return ln
    }



    //向上搜索其他行
    ln=ln-1
    while(ln>=0){
        lnstr = GetBufLine(hbuf,ln)
        len=strlen(lnstr)
        //msg "向上搜索,当前搜索行内容为@lnstr@"
        try=find_last_visible_char(lnstr)
        if(try>=0){
            return ln
        }

        ln=ln-1
    }
    //找不到可见字符,返回-1
    return -1
}

//从当前位置向上找到最早一个可见字符所在的索引,找到返回行，找不到返回-1，(当前位置的字符不计算在内)
//向上查找时,不包含当前索引字符
function getich_visiblechar_searchup(fromln,fromindex){
    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)
    //msg "当前查找起始行编号为@fromln@,索引为@fromindex@,最大行号为@maxline@"
    if(fromln<0 || fromln>=maxline){
        return -1
    }

    ln=fromln
    lnstr = GetBufLine(hbuf,ln)
    
    index=fromindex
    len=strlen(lnstr)
    if(index>len){
        index=len
    }

    
    lnstr=strmid(lnstr,0,index)
    //先搜索所在行
    try=find_last_visible_char(lnstr)
    if(try>=0){
        return try
    }


    //向上搜索其他行
    ln=ln-1
    while(ln>=0){
        lnstr = GetBufLine(hbuf,ln)
        len=strlen(lnstr)
        
        try=find_last_visible_char(lnstr)
        if(try>=0){
            return try
        }

        ln=ln-1
    }
    
    //找不到可见字符,返回-1
    return -1

}


//从当前位置向下找到最早一个可见字符所在的行,找到返回行，找不到返回0，(当前位置的字符计算在内)
//向下查找时,包含当前索引字符
function getln_visiblechar_searchdown(fromln,fromindex){
    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)
    //msg "当前查找起始行编号为@fromln@,索引为@fromindex@,最大行号为@maxline@"
    if(fromln<0 || fromln>=maxline){
        return -1
    }
    
    ln=fromln
    lnstr = GetBufLine(hbuf,ln)
    
    index=fromindex
    len=strlen(lnstr)
    if(index>len){
        index=len
    }
    
    lnstr=strmid(lnstr,index,len)
    //msg "向下搜索,当前搜索行内容为@lnstr@"
    //先搜索所在行
    try=find_first_visible_char(lnstr)
    if(try>=0){
        return ln
    }


    //向下搜索其他行
    ln=ln+1
    while(ln<maxline){
        lnstr = GetBufLine(hbuf,ln)
        len=strlen(lnstr)
        //msg "向下搜索,当前搜索行内容为@lnstr@"
        try=find_first_visible_char(lnstr)
        if(try>=0){
            return ln
        }

        ln=ln+1
    }
    //找不到可见字符,返回0
    return -1
}

//从当前位置向下找到最早一个可见字符所在的行,找到返回行，找不到返回0，(当前位置的字符计算在内)
//向下查找时,包含当前索引字符
function getich_visiblechar_searchdown(fromln,fromindex){
    hbuf=GetCurrentBuf()
    maxline=GetBufLineCount(hbuf)
    //msg "当前查找起始行编号为@fromln@,索引为@fromindex@,最大行号为@maxline@"
    if(fromln<0 || fromln>=maxline){
        return -1
    }
    
    ln=fromln
    lnstr = GetBufLine(hbuf,ln)
    
    index=fromindex
    len=strlen(lnstr)
    if(index>len){
        index=len
    }
    
    lnstr=strmid(lnstr,index,len)
    //先搜索所在行
    try=find_first_visible_char(lnstr)
    if(try>=0){
        return fromindex+try
    }


    //向下搜索其他行
    ln=ln+1
    while(ln<maxline){
        lnstr = GetBufLine(hbuf,ln)
        
        len=strlen(lnstr)
        
        try=find_first_visible_char(lnstr)
        if(try>=0){
            return try
        }

        ln=ln+1
    }
    //找不到可见字符,返回0
    return -1
}

