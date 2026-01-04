// 下载后保存为quickswitchhs.em,UTF-8格式
// 一键切换头文件与源文件
/***********************************************************************************
 * 文 件 名   : quickswitchhs.em
 * 负 责 人   : RUGGL
 * 创建日期   : 2026年1月3日
 * 文件描述   : source insight中一键切换项目中对应头文件和源文件
 * 版权说明   : Copyright (c) 2026-2026
 * 其    他   : 不限制目录结构,只要是项目中的同名文件
 * 修改日志   : 


20260104_0207 发现因为Source Insight源代码设置的不同，项目内文件会以相对路径、绝对路径两种模式显示文件名
20260104_0213 进行相对路径绝对路径的判断，并对相对路径模式下的文件名进行补全成绝对路径；相对路径可以运行，但是绝对路径出错
20260104_0222 相对绝对路径的判断，独立成函数，判断正常运行
20260104_0229 注释掉过程调试信息弹窗，运行正常
20260104_0238 进行一些边边角角的修改
***********************************************************************************/




macro QuickSwitchHS()
{
    version="20260104_0238"
    // Msg("调试输出:当前版本号 @version@")
    //获取当前打开buffer的句柄
    CurrentBuf = GetCurrentBuf()
    if (CurrentBuf == hNil)
        stop

   
    curOpenFileName = GetBufName(CurrentBuf) //无论项目设置的源代码根目录在哪里,这个宏返回的都是当前buffer文件的绝对路径
    
    if (curOpenFileName == "")
        stop 
        
    
    // 头文件类型后缀名列表
    hExtList = NewBuf("hExtList") 
    ClearBuf(hExtList) 
//    index_hpp_begin = 0 // 头文件开始索引,h;hh;hpp;hxx;h++;inc;inl
    AppendBufLine(hExtList, "h") 
    AppendBufLine(hExtList, "hpp") 

//    //后边这些后缀名不常用,因此默认不加入匹配列表,匹配次数是文件名*后缀,后缀越多 匹配越慢
//    //根据个人项目需要可取消注释相应的后缀
//    AppendBufLine(hExtList, "hh") 
//    AppendBufLine(hExtList, "hxx") 
//    AppendBufLine(hExtList, "h++") 
//    AppendBufLine(hExtList, "inc") 
//    AppendBufLine(hExtList, "inl") 
//    index_hpp_end = GetBufLineCount(hExtList) // 头文件结束索引 
      
    // 源文件类型后缀名列表 
    cExtList = NewBuf("cExtList") 
    ClearBuf(cExtList) 
//    index_cpp_begin = 0 // 源文件开始索引 
    AppendBufLine(cExtList, "c") 
    AppendBufLine(cExtList, "cpp") 
//    AppendBufLine(cExtList, "cc") 
//    AppendBufLine(cExtList, "cx") 
//    AppendBufLine(cExtList, "cxx") 
//    AppendBufLine(cExtList, "c++") 
//    AppendBufLine(cExtList, "m") 
//    AppendBufLine(cExtList, "mm") 
//    index_cpp_end = GetBufLineCount(cExtList) // 源文件结束索引 
  
    // --- 1. 提取当前文件的 basename 和 ext ---
    // 1.1 获取不包含路径的文件名
    fname = curOpenFileName
    i = strlen(curOpenFileName) - 1
    while (i >= 0)
    {
        ch = curOpenFileName[i]
        if (ch == "\\" || ch == "/")
        {
            fname = strmid(curOpenFileName, i + 1, strlen(curOpenFileName))
            break
        }
        i = i - 1
    }

    // 1.2 分离 basename 和扩展名 ext
    basename = fname
    ext = ""
    namelen = strlen(fname)
    i = namelen - 1
    while (i >= 0)
    {
        if (fname[i] == ".")
        {
            basename = strmid(fname, 0, i)
            ext = strmid(fname, i + 1, namelen)
            break
        }
        i = i - 1
    }
    // Msg("当前打开的文件为:文件路径:@curOpenFileName@,文件名:@basename@,文件拓展名:@ext@ ")
    if (ext == "") //basename == "" || 
    {
        // Msg("当前文件无扩展名: @fname@")
        CloseBuf(hExtList) // 关闭缓冲区 
        CloseBuf(cExtList)
        stop
    }

    // --- 2. 判断当前文件类型 ---
    ext = tolower(ext)
    isHeader = 0
    isSource = 0

    // 2.1 检查是否为头文件
    if (IsExtInList(ext,hExtList))
    {
        isHeader = 1
        
    }
    // 2.2 检查是否为源文件
    else if (IsExtInList(ext,cExtList))
    {
        isSource = 1
        
    }

    // --- 3. 确定要查找的目标扩展名列表 ---
      if (isHeader == 1)
    {
        // 当前是头文件 -> 目标为源文件
        // Msg("后缀名为:@ext@, 当前是头文件 -> 目标为源文件,正在查找对应的源文件...")
        targetExtList=cExtList
        
    }
    else if (isSource == 1)
    {
        // 当前是源文件 -> 目标为头文件
        // Msg("后缀名为:@ext@, 当前是源文件 -> 目标为头文件,正在查找对应的头文件...")
        targetExtList=hExtList
    }
    else
    {
        // Msg("当前不是C/C++头文件或源文件: .@ext@")
        
        CloseBuf(hExtList) // 关闭缓冲区 
        CloseBuf(cExtList)
        stop
    }

    // --- 4. 在项目范围搜索对应的匹配文件 ---
    foundFile = ""
    
    // Msg("在项目范围搜索...")
    foundFile = SearchInProject(basename, targetExtList)


    // --- 5. 处理查找结果 ---
    if (foundFile !="")
    {
        // 5.1 打开或切换到目标文件
        OpenOrSwitch(foundFile)
    }
    else
    {
        // Msg("未找到匹配文件")
    }
    CloseBuf(hExtList) // 关闭缓冲区 
    CloseBuf(cExtList)
    stop
}


// 在项目范围内查找
Function SearchInProject(basename, targetExtList)
{
    // Msg("开始匹配文件名:@Basename@")
    foundFile = ""
    CurrentProj = GetCurrentProj()
    
    if (CurrentProj == hNil){ //不确定是用stop还是return返回值
        // Msg("获取当前项目失败")
        return foundFile
    }else{
        ProjName = GetProjName (CurrentProj)
        ifileMax = GetProjFileCount (CurrentProj)

        ProjSourceDir=GetProjDir (CurrentProj)  //项目设置的源代码路径,不是项目保存的路径
        // Msg("获取当前项目名称为:@ProjName@,项目源代码路径为:@ProjSourceDir@,句柄为@CurrentProj@,包含@ifileMax@个文件")
        
    }
    
   
    i = 0
    projFile = GetProjFileName (CurrentProj, i)
    IsRelative=IsRelativePath(projFile) //判断是否为相对路径
    
    while (i < ifileMax)
    {
        projFile = GetProjFileName (CurrentProj, i)
        
        if(IsRelative){
        
            // Msg("宏返回当前测试文件路径为相对路径,需手动构造绝对路径,构造前路径:@projFile@")
            projFile=cat(ProjSourceDir,cat("\\",projFile))
            
            // Msg("构造绝对路径后,测试文件路径:@projFile@")
            
        }else{
            // Msg("宏返回当前测试文件为绝对路径:@projFile@")
        }

        
        // 提取文件名
        projFileName = ExtractFileName(projFile)
        
        // 分离文件名和扩展名
        projBasename = projFileName
        projExt = ""
        namelen = strlen(projFileName)
        j = namelen - 1
        while (j >= 0)
        {
            if (projFileName[j] == ".")
            {
                projBasename = strmid(projFileName, 0, j)
                projExt = strmid(projFileName, j + 1, namelen)
                break
            }
            j = j - 1
        }
        
        // Msg("文件名拆分完成,开始匹配:文件路径:@projFile@,文件名:@projBasename@,文件拓展名:@projExt@ ")
        // 检查是否匹配
        if (projBasename == basename && (projExt != ""))
        {
            // Msg("文件名匹配成功,开始匹配后缀:文件路径:@projFile@,文件名:@projBasename@,文件拓展名:@projExt@ ")
            projExtLower = tolower(projExt)
            if (IsExtInList(projExtLower, targetExtList))
            {

                foundFile = projFile
                // Msg("文件名、后缀匹配成功!:文件路径:@projFile@,文件名:@projBasename@,文件拓展名:@projExt@ ")
                //return foundFile
                break
            }
            // Msg("后缀匹配失败!:文件路径:@projFile@,文件名:@projBasename@,文件拓展名:@projExt@ ")
        }
        i = i + 1
    }
    // Msg("返回信息:文件路径:@foundFile@,文件名:@projBasename@,文件拓展名:@projExt@ ")
    return foundFile
}


Function IsRelativePath(projFile)
{
    len = strlen(projFile)

    i = 0
    while (i < len)
    {
        if (projFile[i] == "\:") //有":"代表是绝对路径，返回0
        {
            return 0
        }
        i = i + 1
    }

    return 1 //相对路径，返回0
}


// 从完整路径中提取文件名
Macro ExtractFileName(fullPath)
{
    //fullPath = NormalizePath(fullPath)
    len = strlen(fullPath)
    
    i = len - 1
    while (i >= 0)
    {
        if (fullPath[i] == "\\")
        {
            return strmid(fullPath, i + 1, len)
        }
        i = i - 1
    }
    
    return fullPath
}


//  实际项目内的文件都是反斜杠，不需要再进行标准化了
//// 标准化路径（统一使用反斜杠）
//Macro NormalizePath(path)
//{
//    result =""
//    len = strlen(path)
//    
//    i = 0
//    while (i < len)
//    {
//        ch = path[i]
//        if (ch == "/")
//        {
//            result = cat(result, "\\")
//        }
//        else
//        {
//            result = cat(result, ch)
//        }
//        i = i + 1
//    }
//    
//    return result
//}


// 辅助函数:检查扩展名是否在给定的后缀名列表中
// 遍历List,判断是否当前打开文件后缀名是否与其中某行匹配
Function IsExtInList(ext,targetExtList)
{
    isMatch = 0 // 当前bufer中是否能找到ext后缀名的匹配; 
    //curOpenFileExt =ext  // 当前打开文件的扩展名
    index = 0 
    index_end=GetBufLineCount(targetExtList)
    // Msg("进入后缀匹配函数,当前后缀列表数量为:@index_end@")
    while(index < index_end) 
    { 
        bufferExt = GetBufLine(targetExtList, index)
        // Msg("尝试匹配后缀:@bufferExt@")
        if(bufferExt == ext) // 匹配成功 
        {
            // Msg("匹配成功:@bufferExt@")
            isMatch = 1 //匹配成功返回1
            //return isMatch
            break
        } 
        // Msg("@bufferExt@匹配失败,下一个后缀")
        index = index + 1 
    }// while(index < index_cpp_end) 
    return isMatch //匹配失败返回0
}

// 辅助函数:打开文件或切换到已打开的文件窗口
Function OpenOrSwitch(filepath)
{
    hbuf = GetBufHandle(filepath)
    
    if (hbuf != hNil)
    {
        // 文件已打开,切换到其窗口

        // Msg("文件已打开,正在切换:@filepath@")
        SetCurrentBuf(hbuf)
        
        // Msg("已切换到文件:@filepath@")
    }
    else
    {
        // 打开新文件
        // Msg("文件未打开,正在打开:@filepath@")
        
        hbuf = OpenBuf(filepath)
        if (hbuf != hNil){
            SetCurrentBuf(hbuf) 
            // Msg("已打开文件")
        }else{
            // Msg("打开文件失败:@filepath@")
            
        }

    }
}

