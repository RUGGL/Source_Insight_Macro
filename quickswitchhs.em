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
20260104_1059 修改路径判断的位置,只有匹配成功之后才判断,避免每次匹配都判断
20260104_1411 根据常用的头文件\源文件保存位置,先构造简单的路径进行枚举匹配,避免每次都遍历整个项目文件
***********************************************************************************/




macro QuickSwitchHS()
{
    version="20260104_1059"
    // Msg("调试输出:当前版本号 @version@")
    //获取当前打开buffer的句柄
    CurrentBuf = GetCurrentBuf()   
    if (CurrentBuf == hNil)
        stop
    curOpenFileName = GetBufName(CurrentBuf) //获取当前窗口的文件名
    //无论项目设置的源代码根目录在哪里,这个宏返回的都是当前buffer文件的绝对路径
    if (curOpenFileName == "")
        stop 

    CurrentProj = GetCurrentProj()      //根据官方文档,句柄不能作为全局变量
    if (CurrentProj == hNil){
        // Msg("获取当前项目失败")
        stop
    }else{
        ProjName = GetProjName (CurrentProj)
        ifileMax = GetProjFileCount (CurrentProj)
        ProjSourceDir=GetProjDir (CurrentProj)  //获取项目设置的源代码路径,不是项目保存的路径

    }

    
    // Msg("获取当前项目名称为:@ProjName@,项目源代码路径为:@ProjSourceDir@,句柄为@CurrentProj@,包含@ifileMax@个文件")
    
    
    // 头文件类型后缀名列表
    MatchList = NewBuf("MatchList") 
    ClearBuf(MatchList) 
    hExt_Index_Begin = 0 // 头文件后缀开始索引,h;hh;hpp;hxx;h++;inc;inl
    AppendBufLine(MatchList, "h") 
    AppendBufLine(MatchList, "hpp") 

//    //后边这些后缀名不常用,因此默认不加入匹配列表,匹配次数是文件名*后缀,后缀越多 匹配越慢
//    //根据个人项目需要可取消注释相应的后缀
//    AppendBufLine(MatchList, "hh") 
//    AppendBufLine(MatchList, "hxx") 
//    AppendBufLine(MatchList, "h++") 
//    AppendBufLine(MatchList, "inc") 
//    AppendBufLine(MatchList, "inl") 
    hExt_Index_End = GetBufLineCount(MatchList)  //头文件后缀结束索引


    // 源文件类型后缀名列表 
    //MatchList = NewBuf("MatchList") 
    //ClearBuf(MatchList) 
    cExt_Index_Begin = GetBufLineCount(MatchList) // 源文件后缀开始索引 
    AppendBufLine(MatchList, "c") 
    AppendBufLine(MatchList, "cpp") 
//    AppendBufLine(MatchList, "cc") 
//    AppendBufLine(MatchList, "cx") 
//    AppendBufLine(MatchList, "cxx") 
//    AppendBufLine(MatchList, "c++") 
//    AppendBufLine(MatchList, "m") 
//    AppendBufLine(MatchList, "mm") 
    cExt_Index_End = GetBufLineCount(MatchList) // 源文件后缀结束索引 



    //以下为头文件最可能存在的路径,简单搜索时用到
    hDir_Index_Begin = GetBufLineCount(MatchList)  //头文件可能路径的开始索引
    //举例,对于"D:\Project_SPI\Core\stm32f4xx_it.c"
    AppendBufLine(MatchList, "\\")  //"当前同级路径下,对应D:\Project_SPI\Core\*"
    AppendBufLine(MatchList, "\\Include\\")  //"当前同级路径下文件夹include,对应D:\Project_SPI\Core\Include\"
    AppendBufLine(MatchList, "\\include\\")  //"对应D:\Project_SPI\Core\include\"
    AppendBufLine(MatchList, "\\Inc\\")      //"对应D:\Project_SPI\Core\Inc\"
    AppendBufLine(MatchList, "\\inc\\")      //"对应D:\Project_SPI\Core\inc\"
    AppendBufLine(MatchList, "\\INCLUDE\\")  //
    AppendBufLine(MatchList, "\\INC\\")  //
    hDir_Index_End = GetBufLineCount(MatchList) //头文件可能路径的结束索引 



    //以下为源文件最可能存在的路径,简单搜索时用到(简单粗暴地对较大可能性的小范围遍历,避免遍历整个项目所有文件)
    cDir_Index_Begin = GetBufLineCount(MatchList)  //源文件可能路径的开始索引
    //举例,对于"D:\Project_SPI\Core\stm32f4xx_it.c"
    AppendBufLine(MatchList, "\\")  //当前同级路径下,对应D:\Project_SPI\Core\*
    AppendBufLine(MatchList, "\\Source\\")  //"当前同级路径下文件夹include,对应D:\Project_SPI\Core\Source\"
    AppendBufLine(MatchList, "\\source\\")  //"对应D:\Project_SPI\Core\source\"
    AppendBufLine(MatchList, "\\Src\\")      //"对应D:\Project_SPI\Core\Src\"
    AppendBufLine(MatchList, "\\src\\")      //"对应D:\Project_SPI\Core\Src\"
    AppendBufLine(MatchList, "\\SOURCE\\")      //
    AppendBufLine(MatchList, "\\SRC\\")      //  
    cDir_Index_End = GetBufLineCount(MatchList) // 源文件可能路径的结束索引 


    

    // --- 1. 提取当前文件的 basename 和 ext ---
    // 1.1 获取不包含路径的文件名
    fname = curOpenFileName
    i = strlen(curOpenFileName) - 1
    while (i >= 0)
    {
        ch = curOpenFileName[i]
        if (ch == "\\" || ch == "/")
        {
            fdir = strmid(curOpenFileName, 0, i) //得到形如:"D:\project\stm32\src" 的文件父目录,末尾不带反斜杠
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
        CloseBuf(MatchList) // 关闭缓冲区 
        CloseBuf(MatchList)
        stop
    }

    // --- 2. 判断当前文件类型 ---
    ext = tolower(ext)
    isHeader = 0
    isSource = 0

    // 2.1 检查是否为头文件
    if (IsExtInList(ext,MatchList,hExt_Index_Begin,hExt_Index_End)) //判断当前文件后缀跟头文件后缀区域是否有匹配
    {
        isHeader = 1
        
    }
    // 2.2 检查是否为源文件
    else if (IsExtInList(ext,MatchList,cExt_Index_Begin,cExt_Index_End)) //判断当前文件后缀跟源文件后缀区域是否有匹配
    {
        isSource = 1
        
    }

    // --- 3. 确定要查找的目标扩展名列表 ---

    global Ext_Index_Begin
    global Ext_Index_End
    global ChildDir_Index_Begin
    global ChildDir_Index_End
    
    if (isHeader == 1)
    {
        // 当前是头文件 -> 目标为源文件
        // Msg("后缀名为:@ext@, 当前是头文件 -> 目标为源文件,正在查找对应的源文件...")
        targetMatchList = MatchList
        Ext_Index_Begin =cExt_Index_Begin    //当前是头文件,要查找源文件的后缀名
        Ext_Index_End =cExt_Index_End
        ChildDir_Index_Begin =cDir_Index_Begin //当前是头文件,要查找源文件的子目录
        ChildDir_Index_End =cDir_Index_End  
    }
    else if (isSource == 1)
    {
        // 当前是源文件 -> 目标为头文件
        // Msg("后缀名为:@ext@, 当前是源文件 -> 目标为头文件,正在查找对应的头文件...")
        targetMatchList = MatchList
        Ext_Index_Begin =hExt_Index_Begin //当前是源文件,要查找头文件的缀名
        Ext_Index_End =hExt_Index_End
        ChildDir_Index_Begin =hDir_Index_Begin //当前是源文件,要查找头文件的子目录
        ChildDir_Index_End =hDir_Index_End      
    }
    else
    {
        // Msg("当前不是C/C++头文件或源文件: .@ext@")
        
        CloseBuf(MatchList) // 关闭缓冲区 
        stop
    }

    // --- 4. 在项目范围搜索对应的匹配文件 ---
    foundFile = ""
    
    
    // Msg("根据枚举列表,进行简单搜索...")
    //fdir始终时绝对路径,
    //相当于尝试寻找 fdir/basename.Ext 文件
    if (SimpleSearchAround(fdir,basename,targetMatchList) ){
        // Msg("简单搜索成功,找到文件为:@foundFile@")
        
        CloseBuf(MatchList) // 关闭缓冲区 
        stop
        
    }else{

        // Msg("简单搜索无结果,在项目范围搜索...")
        foundFile = SearchInProject(basename, targetMatchList) //简单匹配搜索不到对应文件,再进行项目遍历搜索
    }
    
    // --- 5. 处理查找结果 ---
    if (foundFile !="")
    {
        // 5.1 判断是否为相对路径
        IsRelative=IsRelativePath(foundFile) //判断是否为相对路径
        
         if(IsRelative){
        
            // Msg("宏返回当前测试文件路径为相对路径,需手动构造绝对路径,构造前路径:@foundFile@")
            foundFile=cat(ProjSourceDir,cat("\\",foundFile))
            
            // Msg("构造绝对路径后,测试文件路径:@foundFile@")
            
        }else{
            // Msg("宏返回当前测试文件为绝对路径:@foundFile@")
        }

        //5.2 打开或切换到目标文件
        //以绝对路径尝试打开匹配到的文件
        OpenOrSwitch(foundFile)
    }
    else
    {
        // Msg("未找到匹配文件")
    }

    // --- 6. 关闭打开的后缀名列表buffer ---

    CloseBuf(MatchList) // 关闭缓冲区 
    stop
}


// 在项目范围内查找
Function SearchInProject(basename, targetMatchList)
{
    // Msg("开始匹配文件名:@Basename@")
    foundFile = ""
    CurrentProj = GetCurrentProj()      //根据官方文档,句柄不能作为全局变量
    if (CurrentProj == hNil){
        // Msg("获取当前项目失败")
        stop
    }else{
        ProjName = GetProjName (CurrentProj)
        ifileMax = GetProjFileCount (CurrentProj)
        ProjSourceDir=GetProjDir (CurrentProj)  //获取项目设置的源代码路径,不是项目保存的路径

    }

    
    i = 0
    projFile = GetProjFileName (CurrentProj, i)
    while (i < ifileMax)
    {
        projFile = GetProjFileName (CurrentProj, i)
        
        // Msg("当前宏返回的测试文件路径为:@projFile@")

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
            if (IsExtInList(projExtLower, targetMatchList,Ext_index_Begin,Ext_index_End))
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
Function ExtractFileName(fullPath)
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

// 获取父目录路径
Function GetParentDirectory(dirPath)
{
    if (dirPath == "") return ""
    
    //dirPath = NormalizePath(dirPath)
    len = strlen(dirPath)
    
    // 查找最后一个路径分隔符
    i = len - 1
    while (i >= 0)
    {
        if (dirPath[i] == "\\")
        {
            return strmid(dirPath, 0, i)  //得到形如:"D:\project\stm32\src" 的文件父目录,末尾不带反斜杠
        }
        i = i - 1
    }
    
    return ""
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
Function IsExtInList(ext,targetMatchList,Ext_index_Begin,Ext_index_End)
{
    isMatch = 0 // 当前bufer中是否能找到ext后缀名的匹配; 
    //curOpenFileExt =ext  // 当前打开文件的扩展名
    index = Ext_index_Begin 

    // Msg("进入后缀匹配函数,当前匹配的后缀列表区域为:@Ext_index_Begin@ -- @Ext_index_End@(不含末尾索引本身)")
    while(index < Ext_index_End) 
    { 
        bufferExt = GetBufLine(targetMatchList, index)
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

        // Msg("现bufer中有该文件,正在切换切换窗口:@filepath@")
        SetCurrentBuf(hbuf)
        
        // Msg("已切换到文件:@filepath@")
    }
    else
    {
        // 打开新文件
        // Msg("现bufer中无该文件,尝试打开该文件:@filepath@")
        
        hbuf = OpenBuf(filepath)
        if (hbuf != hNil){
            SetCurrentBuf(hbuf) 
            // Msg("已打开文件")
            
        }else{
            // Msg("打开文件失败:@filepath@")
            return 0
        }

    }
    return 1 //找到相应文件,可以打开或切换
}


Function SimpleSearchAround(fDir,filename,targetMatchList){

    rootDir=fDir 
    layer=0     //当前向上遍历所在层数
    maxlayer=2  //最大向上遍历层数,建议为两层
    while(layer<=maxlayer){   //每次循环,根目录向上跳一级


        ExtIndex=Ext_Index_Begin
        while(ExtIndex<Ext_Index_End){  //每次循环,取出一个可能的后缀

            ChildDirIndex = ChildDir_Index_Begin
            while (ChildDirIndex < ChildDir_Index_End){  //每次循环,取出一个可能的子目录
                childDir = GetBufLine(targetMatchList, ChildDirIndex)
                ParentDir=cat(rootDir,childDir)


                Ext = GetBufLine(targetMatchList, ExtIndex)  //后缀名列表不带点,需要加上"."
                
                targetFilePath=cat(cat(ParentDir,filename),cat("\.",Ext))
                
                // Msg("当前构造的测试文件路径:@targetFilePath@")
                
                if(OpenOrSwitch(targetFilePath)){
                    // Msg("当前测试文件路径匹配成功:@targetFilePath@")
                    return 1  //路径匹配成功
                }



                   

                ChildDirIndex=ChildDirIndex+1
            }
            
            ExtIndex=ExtIndex+1
        }


        layer=layer+1
        rootDir=GetParentDirectory(rootDir) //当前目录没找到,再往上找1层
        if(rootDir == ""){ //不存在更上一级目录了,直接返回
            return 0
        }
    }

    return 0  //所有层目录都没有,返回0

}



