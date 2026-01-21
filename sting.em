
/*******************************分界符，以下为基础字符串函数**  *********************************/
function just_line_line_line_line_line_line_line_line0(){}

// string.em - C语言字符串函数实现
// 基于Source Insight宏语言实现
/*
使用说明：
保存文件：将以上代码保存为 string.em 文件，放在Source Insight的宏目录中。
加载宏：在Source Insight中通过 Options > Key Assignments 加载这个宏文件。
函数特点：
所有函数都使用中文注释说明功能
由于Source Insight宏语言的限制，这些函数都是"纯函数式"的，不修改输入参数
返回新的字符串结果
主要限制：
不能实现真正的 strtok（因为需要静态变量）
字符串不能包含真正的 '\0' 字符
所有修改操作都返回新字符串而不是修改原字符串
测试函数：
可以使用 test_string_functions() 宏来测试所有实现的函数
*/


// string.em - C语言字符串函数实现
// 基于Source Insight宏语言实现

// string.em - C语言字符串函数实现
// 基于Source Insight宏语言实现

function Char2Ascii(ch){ 

    
    ascii_num=AsciiFromChar(ch)

    if(ascii_num < 0 ){   
       //处理中文字符的acsii转换时，source insgiht的Ascii大于127时会溢出成负数，因此处理一下
       ascii_num=ascii_num+256
       return ascii_num
    }else{
        return ascii_num
    }
}


function Char2Ascii_CN(ch){ 
    
    
    ascii_num=AsciiFromChar(ch)


    if(ascii_num >0){
        return ascii_num
    }else if(ascii_num == 0){
        return 129 //0x81
    }else{  

        ascii_num=ascii_num+256
        //处理中文字符的acsii转换时，source insgiht的Ascii大于127时会溢出成负数，因此处理一下
        if(ascii_num >=0xE2 && ascii_num <= 0xEF){ //0xE2到0xEF为汉字utf-8开头,0xE2为数字226,0xEF为数字239
            //对于中文utf-8的中间字节的ascii处理,AsciiFromChar(ch)似乎会返回-17和0,特殊处理下
            //中文utf-8的首字节似乎是显示正常的负数
                  //对应0x81,数据扩展字符中的未定义字符
            //msg "中文开头字节编码@ascii_num@，字符:@ch@" 
            return ascii_num
        }else if(ascii_num == 0xEF){ //0xEF似乎是中间字节或标点符号开头
            
            msg "中文中间字节编码@ascii_num@，字符:@ch@"
            return 129 //0x81
        }else{

            return ascii_num
        }      

    }

}


// is_printable_char - 检查字符是否可打印
// 返回: TRUE(1)或FALSE(0)
function is_printable_char(ch)
{
    if (strlen(ch) == 0)
    {
        return 0
    }
    
    ascii = Char2Ascii(ch)
    
    if (ascii < 0)    {
        return 1
    }
    
    // 可打印字符范围：空格(32)到波浪号(126)
    // 可打印字符范围：如果大于127,也视为可打印字符,有可能有utf8中文
    if (ascii >= 32)
    {
       return 1
    }

    return 0

}


// is_visible_char - 判断某个位置是否是可见字符
// 可见字符包括：ASCII可见字符、中文字符
// 返回: 1-是可见字符，0-不是（即不可见字符）
function is_visible_char(ch)
{
    if (strlen(ch) == 0)
    {
        return 0
    }
    ascii = Char2Ascii(ch)
    
    if (ascii < 0)    {
        return 1
    }

    if (ascii < 33 || ascii == 127) //空格也作为不可见字符
    {
        return 0
    }
    
    
    return 1

}
/////////////////////////////////////////////////////////////////////////////
// 取小值函数
/////////////////////////////////////////////////////////////////////////////

function min(a,b){
    c=a-b
    if(c>0){
        return b
    }else{
        return a
    }
}

/////////////////////////////////////////////////////////////////////////////
// 取大值函数
/////////////////////////////////////////////////////////////////////////////

function max(a,b){
    c=a-b
    if(c<0){
        return b
    }else{
        return a
    }
}

/////////////////////////////////////////////////////////////////////////////
// 字符串比较函数
/////////////////////////////////////////////////////////////////////////////

// strcmp - 比较两个字符串
// 返回: 
//   0 - 字符串相等
//   <0 - s1 < s2
//   >0 - s1 > s2
function strcmp(s1, s2)
{
/**/
    len1 = strlen(s1)
    len2 = strlen(s2)
    
    // 计算最小长度
    if (len1 < len2)
    {
        min_len = len1
    }
    else
    {
        min_len = len2
    }
    
    i = 0
    while (i < min_len)
    {
        ch1 = s1[i]  // 注意：这里返回的是字符串，如"o"，而不是字符'o'
        ch2 = s2[i]
        ascii1 = Char2Ascii(ch1)
        ascii2 = Char2Ascii(ch2)
        
        if (ascii1 != ascii2)
        {
            return ascii1 - ascii2
        }
        i = i + 1
    }
    
    return len1 - len2
}

// strncmp - 比较两个字符串的前n个字符
// 返回: 
//   0 - 字符串前n个字符相等
//   <0 - s1 < s2 (在前n个字符内)
//   >0 - s1 > s2 (在前n个字符内)
function strncmp(s1, s2, n)
{
    len1 = strlen(s1)
    len2 = strlen(s2)
    
    // 确定实际比较的长度
    if (len1 < len2)
    {
        max_compare = len1
    }
    else
    {
        max_compare = len2
    }
    
    if (n < max_compare)
    {
        max_compare = n
    }
    
    i = 0
    while (i < max_compare)
    {
        ch1 = s1[i]
        ch2 = s2[i]
        ascii1 = Char2Ascii(ch1)
        ascii2 = Char2Ascii(ch2)
        
        if (ascii1 != ascii2)
        {
            return ascii1 - ascii2
        }
        i = i + 1
    }
    
    // 如果前max_compare个字符都相等，但n还没有到
    if (n > max_compare)
    {
        if (len1 < len2 && len1 < n)
        {
            return -1  // s1比s2短
        }
        else
        {
            if (len2 < len1 && len2 < n)
            {
                return 1   // s2比s1短
            }
        }
    }
    
    return 0
}

// stricmp - 不区分大小写的字符串比较（模拟strcasecmp）
// 返回: 
//   0 - 字符串相等（忽略大小写）
//   <0 - s1 < s2（忽略大小写）
//   >0 - s1 > s2（忽略大小写）
function stricmp(s1, s2)
{
    len1 = strlen(s1)
    len2 = strlen(s2)
    
    // 计算最小长度
    if (len1 < len2)
    {
        min_len = len1
    }
    else
    {
        min_len = len2
    }
    
    i = 0
    while (i < min_len)
    {
        ch1 = s1[i]
        ch2 = s2[i]
        
        // 转换为小写进行比较
        // 注意：tolower需要字符串参数
        ch1_lower = tolower(ch1)
        ch2_lower = tolower(ch2)
        
        ascii1 = Char2Ascii(ch1_lower)
        ascii2 = Char2Ascii(ch2_lower)
        
        if (ascii1 != ascii2)
        {
            return ascii1 - ascii2
        }
        i = i + 1
    }
    
    return len1 - len2
}

/////////////////////////////////////////////////////////////////////////////
// 字符串查找函数（修正版）
/////////////////////////////////////////////////////////////////////////////

// strchr - 查找字符在字符串中第一次出现的位置
// 返回: 字符位置的索引，未找到返回-1
function strchr(s, ch)
{
    len = strlen(s)
    i = 0
    while (i < len)
    {
        // 注意：s[i]返回的是字符串，ch也是字符串，需要转换为ASCII比较
        ch_from_str = s[i]
        ascii_from_str = Char2Ascii(ch_from_str)
        ascii_ch = Char2Ascii(ch)
        
        if (ascii_from_str == ascii_ch)
        {
            return i
        }
        i = i + 1
    }
    return -1
}

// strrchr - 查找字符在字符串中最后一次出现的位置
// 返回: 字符位置的索引，未找到返回-1
function strrchr(s, ch)
{
    len = strlen(s)
    i = len - 1
    ascii_ch = Char2Ascii(ch)
    
    while (i >= 0)
    {
        ch_from_str = s[i]
        ascii_from_str = Char2Ascii(ch_from_str)
        
        if (ascii_from_str == ascii_ch)
        {
            return i
        }
        i = i - 1
    }
    return -1
}


// strstr - 查找子串在字符串中第一次出现的位置
// 返回: 子串开始位置的索引，未找到返回-1
function strstr(main_str, sub_str)
{
    main_str_len = strlen(main_str)
    sub_str_len = strlen(sub_str)
    ln=1
    first_matchln=0 //第一次匹配所在的行
    last_matchln=0 //最后一次匹配所在的行
    first_matchindex=-1 //第一次匹配所在的位置
    last_matchindex=-1 //最后一次匹配所在位置
    match=0 //是否匹配成功
    
     // 如果sub_str_len为空字符串，返回-1
    // 如果sub_str_len比main_str_len长，不可能找到
    if (sub_str_len == 0 || sub_str_len > main_str_len)
    {
        return -1
    }
    
    i = 0
    max_i = main_str_len - sub_str_len
    
    while (i <= max_i)
    {       
        ch1 = main_str[i]
        ch2 = sub_str[0]
        ascii1 = Char2Ascii(ch1)
        ascii2 = Char2Ascii(ch2)
        
        if(ascii1 == 10){
            ln=ln+1 //下一行开始,行数增加
        }
        

        if (ascii1 == ascii2){//第1个字符匹配成功
            j = 0
            while (j < sub_str_len)
            {
                // 比较字符的ASCII值
                ch1 = main_str[i + j]
                ch2 = sub_str[j]
                ascii1 = Char2Ascii(ch1)
                ascii2 = Char2Ascii(ch2)
                if (ascii1 != ascii2)
                {
                    break
                }
                j = j + 1
            }
            
            if(j == sub_str_len){ //j遍历完了说明匹配成功
            
                match=1
                if(first_matchln == 0){
                    first_matchln=ln //记录第1次匹配的行
                }
                if(first_matchindex == -1){
                    first_matchindex=i //记录第1次匹配的行
                }
                last_matchln=ln //最后一次匹配的行,每次更新
                last_matchindex=i //最后一次匹配的索引,每次更新

                break //如果想要遍历完整个字符串,得到最后匹配的行,不要break
            }
       }
       i=i+1
       
    }
    //返回第1个匹配成功的索引
    if(match == 1){
        return first_matchindex
    }else{
        return -1
    }
    
}

// strpbrk - 查找字符串中第一个匹配指定字符集中任意字符的位置
// 返回: 字符位置的索引，未找到返回-1
function strpbrk(s, accept)
{
    s_len = strlen(s)
    accept_len = strlen(accept)
    
    // 计算accept中每个字符的ASCII值
    // 由于Source Insight不支持数组，我们用字符串存储ASCII值
    ascii_list = ""
    k = 0
    while (k < accept_len)
    {
        ascii_val = Char2Ascii(accept[k])
        ascii_list = cat(ascii_list, CharFromAscii(ascii_val))
        k = k + 1
    }
    
    i = 0
    while (i < s_len)
    {
        ch = s[i]
        ascii_ch = Char2Ascii(ch)
        
        // 在ascii_list中查找
        j = 0
        while (j < accept_len)
        {
            ascii_accept = Char2Ascii(ascii_list[j])
            if (ascii_ch == ascii_accept)
            {
                return i
            }
            j = j + 1
        }
        
        i = i + 1
    }
    
    return -1
}

/////////////////////////////////////////////////////////////////////////////
// 字符串操作函数
/////////////////////////////////////////////////////////////////////////////

// strcpy - 字符串拷贝（模拟，返回新字符串）
// 注意: Source Insight宏不能修改参数，所以返回新字符串
function strcpy(dest, src)
{
    return src  // 直接返回源字符串
}

// strncpy - 字符串拷贝n个字符（模拟，返回新字符串）
function strncpy(dest, src, n)
{
    src_len = strlen(src)
    
    if (n <= 0)
    {
        return ""
    }
    
    if (src_len >= n)
    {
        // 截取前n个字符
        return strmid(src, 0, n)
    }
    else
    {
        // src长度小于n，需要填充空字符（这里用空字符串表示）
        result = src
        // 由于Source Insight的字符串不能包含'\0'，我们用空字符串数组操作来模拟
        i = src_len
        while (i < n)
        {
            result = cat(result, "")
            i = i + 1
        }
        return result
    }
}

// strcat - 字符串连接（模拟，返回新字符串）
function strcat(dest, src)
{
    return cat(dest, src)  // 使用基础宏的cat函数
}

// strncat - 字符串连接n个字符（模拟，返回新字符串）
function strncat(dest, src, n)
{
    src_len = strlen(src)
    
    if (n <= 0)
    {
        return dest
    }
    
    if (src_len >= n)
    {
        // 取前n个字符
        src_part = strmid(src, 0, n)
    }
    else
    {
        // src长度小于n，取全部
        src_part = src
    }
    
    return cat(dest, src_part)
}

/////////////////////////////////////////////////////////////////////////////
// 字符串分析函数
/////////////////////////////////////////////////////////////////////////////

// strspn - 计算字符串开头连续包含指定字符集中字符的个数
// 返回: 匹配的字符数
function strspn(s, accept)
{
    s_len = strlen(s)
    accept_len = strlen(accept)
    
    // 预先计算accept中所有字符的ASCII值
    accept_ascii = ""
    k = 0
    while (k < accept_len)
    {
        ascii_val = Char2Ascii(accept[k])
        accept_ascii = cat(accept_ascii, CharFromAscii(ascii_val))
        k = k + 1
    }
    
    count = 0
    i = 0
    
    while (i < s_len)
    {
        ch = s[i]
        ascii_ch = Char2Ascii(ch)
        found = 0
        
        j = 0
        while (j < accept_len)
        {
            ascii_accept = Char2Ascii(accept_ascii[j])
            if (ascii_ch == ascii_accept)
            {
                found = 1
                break
            }
            j = j + 1
        }
        
        if (!found)
        {
            break
        }
        
        count = count + 1
        i = i + 1
    }
    
    return count
}

// strcspn - 计算字符串开头连续不包含指定字符集中字符的个数
// 返回: 不匹配的字符数
function strcspn(s, reject)
{
    s_len = strlen(s)
    reject_len = strlen(reject)
    
    // 预先计算reject中所有字符的ASCII值
    reject_ascii = ""
    k = 0
    while (k < reject_len)
    {
        ascii_val = Char2Ascii(reject[k])
        reject_ascii = cat(reject_ascii, CharFromAscii(ascii_val))
        k = k + 1
    }
    
    count = 0
    i = 0
    
    while (i < s_len)
    {
        ch = s[i]
        ascii_ch = Char2Ascii(ch)
        found = 0
        
        j = 0
        while (j < reject_len)
        {
            ascii_reject = Char2Ascii(reject_ascii[j])
            if (ascii_ch == ascii_reject)
            {
                found = 1
                break
            }
            j = j + 1
        }
        
        if (found)
        {
            break
        }
        
        count = count + 1
        i = i + 1
    }
    
    return count
}

// strtok - 字符串分割（简化版，单次调用）
// 注意: 由于Source Insight没有静态变量，这是一个简化实现
// 返回: 第一个分割出的令牌，或空字符串
function strtok(s, delim)
{
    s_len = strlen(s)
    if (s_len == 0)
    {
        return ""
    }
    
    // 跳过开头的分隔符
    start = strspn(s, delim)
    
    if (start >= s_len)
    {
        return ""  // 整个字符串都是分隔符
    }
    
    // 找到下一个分隔符的位置
    remaining = strmid(s, start, s_len)
    next_delim = strcspn(remaining, delim)
    end = start + next_delim
    
    // 返回令牌
    return strmid(s, start, end)
}

/////////////////////////////////////////////////////////////////////////////
// 字符串转换和测试函数
/////////////////////////////////////////////////////////////////////////////

// isalpha - 检查字符是否为字母
// 返回: TRUE(1)或FALSE(0)
function isalpha(ch)
{
    if (strlen(ch) == 0)
    {
        return 0
    }
    
    // 检查是否为大写或小写字母
    if (isupper(ch))
    {
        return 1
    }
    if (islower(ch))
    {
        return 1
    }
    
    return 0
}

// isdigit - 检查字符是否为数字
// 返回: TRUE(1)或FALSE(0)
function isdigit(ch)
{
    if (strlen(ch) == 0)
    {
        return 0
    }
    
    ascii = Char2Ascii(ch)
    
    if (ascii >= 48)
    {
        if (ascii <= 57)
        {
            return 1  // '0'到'9'
        }
    }
    return 0
}

// isalnum - 检查字符是否为字母或数字
// 返回: TRUE(1)或FALSE(0)
function isalnum(ch)
{
    if (isalpha(ch))
    {
        return 1
    }
    return isdigit(ch)
}

// isspace - 检查字符是否为空白字符
// 返回: TRUE(1)或FALSE(0)
function isspace(ch)
{
    if (strlen(ch) == 0)
    {
        return 0
    }

    ascii = Char2Ascii(ch)
    
    if (ascii == 32)
    {
        return 1  // 空格
    }
    
    if (ascii == 9)  // 制表符 \t
    {
        return 1
    }
    
    if (ascii == 10)  // 换行 \n
    {
        return 1
    }
    
    if (ascii == 13)  // 回车 \r
    {
        return 1
    }
    
    if (ascii == 11)  // 垂直制表符
    {
        return 1
    }
    
    if (ascii == 12)  // 换页
    {
        return 1
    }
    
    return 0
}


// strrev - 反转字符串
// 返回: 反转后的字符串
function strrev(s)
{
    len = strlen(s)
    if (len <= 1)
    {
        return s
    }
    
    result = ""
    i = len - 1
    while (i >= 0)
    {
        result = cat(result, s[i])
        i = i - 1
    }
    
    return result
}

// strtrim - 去除字符串两端的空白字符
// 返回: 去除空白后的字符串
function strtrim(s)
{
    str=s
    len = strlen(s)
    //msg "接收字符串为@str@,str长度为@len@"
    if (len == 0)
    {
        return s
    }
    
    // 找到第一个非空白字符
    first_i = -1
    last_i = 0
    i=0
    while (i < len)
    {
        ch = str[i]
        if (is_visible_char(ch))
        {
            if(first_i==-1){
                first_i=i
            }
            last_i=i
        }
        i = i + 1
    }
    
    // 如果整个字符串都是空白
    if (first_i == -1)
    {
        return ""
    }
    
    //msg "第一个可见字符索引为@first_i@,最后一个可见字符索引为@last_i@"
    // 提取子串
    str=strmid(str, first_i, last_i + 1)
    //msg "处理后字符串为@str@,str长度为@len@"
    return str
}

// trim_left - 去除字符串左边的空白字符（包括空格）
// 返回: 去除左边空白后的字符串
function trim_left(s)
{
    len = strlen(s)
    
    if (len == 0)
    {
        return s
    }
    
    // 找到第一个非空白字符的位置
    first_visible = find_visible_char_atbegin(s)
    
    if (first_visible == -1)
    {
        return ""  // 全部是空白字符
    }
    
    return strmid(s, first_visible, len)
}

// trim_right - 去除字符串右边的空白字符（包括空格）
// 返回: 去除右边空白后的字符串
function trim_right(s)
{
    len = strlen(s)
    
    if (len == 0)
    {
        return s
    }
    
    // 找到最后一个非空白字符的位置
    i = len - 1
    while (i >= 0)
    {
        ch = s[i]
        
        // 检查是否是可见字符（空格或控制字符）
        if (is_visible_char(ch)){
            //msg "第@i@个字符可见"
            break
        }
        //msg "第@i@个字符不可见"
        i = i - 1
    }
    
    if (i < 0)
    {
        return ""  // 全部是空白字符
    }
    
    return strmid(s, 0, i + 1)
}


/***************************************************分界符，以上为C语言string库实现******************************************************/
function just_line_line_line_line_line_line_line_line1(){}





// unescape_string - 将转义序列转换回控制字符（简化版）
// 注意：这个函数不能处理所有转义序列，是简化实现
function unescape_string(s)
{
    len = strlen(s)
    result = ""
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        ascii = Char2Ascii(ch)
        
        // 检查是否是反斜杠
        if (ascii == 92 && i + 1 < len)  // 反斜杠
        {
            next_ch = s[i + 1]
            next_ascii = Char2Ascii(next_ch)
            
            if (next_ascii == 116)  // t -> \t
            {
                result = cat(result, CharFromAscii(9))  // 制表符
                i = i + 2
            }
            else if (next_ascii == 110)  // n -> \n
            {
                result = cat(result, CharFromAscii(10))  // 换行
                i = i + 2
            }
            else if (next_ascii == 114)  // r -> \r
            {
                result = cat(result, CharFromAscii(13))  // 回车
                i = i + 2
            }
            else if (next_ascii == 92)  // \\ -> \
            {
                result = cat(result, CharFromAscii(92))  // 反斜杠
                i = i + 2
            }
            else if (next_ascii == 34)  // \" -> "
            {
                result = cat(result, CharFromAscii(34))  // 双引号
                i = i + 2
            }
            else if (next_ascii == 39)  // \' -> '
            {
                result = cat(result, CharFromAscii(39))  // 单引号
                i = i + 2
            }
            else if (next_ascii == 120 && i + 3 < len)  // \xXX
            {
                // 尝试解析十六进制
                hex1 = s[i + 2]
                hex2 = s[i + 3]
                ascii1 = Char2Ascii(hex1)
                ascii2 = Char2Ascii(hex2)
                
                value = 0
                
                // 第一个十六进制数字
                if (ascii1 >= 48 && ascii1 <= 57)  // 0-9
                {
                    value = (ascii1 - 48) * 16
                }
                else if (ascii1 >= 97 && ascii1 <= 102)  // a-f
                {
                    value = (ascii1 - 87) * 16
                }
                else if (ascii1 >= 65 && ascii1 <= 70)  // A-F
                {
                    value = (ascii1 - 55) * 16
                }
                
                // 第二个十六进制数字
                if (ascii2 >= 48 && ascii2 <= 57)  // 0-9
                {
                    value = value + (ascii2 - 48)
                }
                else if (ascii2 >= 97 && ascii2 <= 102)  // a-f
                {
                    value = value + (ascii2 - 87)
                }
                else if (ascii2 >= 65 && ascii2 <= 70)  // A-F
                {
                    value = value + (ascii2 - 55)
                }
                
                result = cat(result, CharFromAscii(value))
                i = i + 4
            }
            else  // 未知转义，保持原样
            {
                result = cat(result, ch)
                i = i + 1
            }
        }
        else  // 普通字符
        {
            result = cat(result, ch)
            i = i + 1
        }
    }
    
    return result
}


/////////////////////////////////////////////////////////////////////////////
// 新增函数：行操作和扩展功能
/////////////////////////////////////////////////////////////////////////////

// get_line_count - 获取字符串中的行数，以\n为行结束标志
// 末尾行不以\n结尾也算一行
// 返回: 行数
function get_line_count(s)
{
    len = strlen(s)
    if (len == 0)
    {
        return 1  // 空字符串也算一行
    }
    
    line_count = 1  // 至少有一行
    i = 0
    while (i < len)
    {
        ch = s[i]
        ascii = Char2Ascii(ch)
        
        if (ascii == 10)  // 换行符
        {
            line_count = line_count + 1
        }
        i = i + 1
    }
    
    return line_count
}

// find_visible_char_atbegin - 查找第一可见字符的索引（正向）
// 返回: 索引位置，未找到返回-1
function find_visible_char_atbegin(s)
{
    len = strlen(s)
    first_index=-1
    last_index=-1
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        if (is_visible_char(ch))
        {
            if(first_index==-1){
                first_index=i
            }
            last_index=i
            break
        }
        i = i + 1
    }
    
    return first_index
}

// find_unvisible_char_atend(s) - 查找最后一个可见字符的后一个位置的索引
// 返回: 索引位置，未找到返回-1
function find_unvisible_char_atend(s)
{
    len = strlen(s)
    first_index=-1
    last_index=-1
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        if (is_visible_char(ch))
        {
            if(first_index==-1){
                first_index=i
            }
            last_index=i+1 //最后一个可见字符位置+1
        }
        i = i + 1
    }
    
    return last_index

}
// find_printable_char_atbegin - 查找第一个打印字符的位置（含空格）


// 返回: 索引位置，未找到返回-1




function find_printable_char_atbegin(s)
{
    len = strlen(s)
    first_index=-1
    last_index=-1
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        if (is_printable_char(ch))
        {
            if(first_index==-1){
                first_index=i
            }
            last_index=i
            break
        }
        i = i + 1
    }
    
    return first_index
}

// find_unprintable_char_atend(s) - 查找最后一个打印字符的后一个位置的索引
// 返回: 索引位置，未找到返回-1
function find_unprintable_char_atend(s)
{
    len = strlen(s)
    first_index=-1
    last_index=-1
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        if (is_printable_char(ch))
        {
            if(first_index==-1){
                first_index=i
            }
            last_index=i+1 //最后一个可见字符位置+1
        }
        i = i + 1
    }
    
    return last_index

}

// find_strln_frombegin - 查找包含指定字符串的行号（正向）
// 返回: 行号（从1开始），未找到返回-1
function find_strln_frombegin(main_str, sub_str)
{
    main_str_len = strlen(main_str)
    sub_str_len = strlen(sub_str)
    ln=1
    first_matchln=0 //第一次匹配所在的行
    last_matchln=0 //最后一次匹配所在的行
    first_matchindex=-1 //第一次匹配所在的位置
    last_matchindex=-1 //最后一次匹配所在位置
    match=0 //是否匹配成功
    //msg "主字符串长度:@main_str_len@,子字符串长度:@sub_str_len@"
     // 如果sub_str_len为空字符串，返回-1
    // 如果sub_str_len比main_str_len长，不可能找到
    if (sub_str_len == 0 || sub_str_len > main_str_len)
    {
        //msg "sub_str_len比main_str_len长，不可能找到"
        return -1
    }
    
    i = 0
    max_i = main_str_len - sub_str_len
    while (i <= max_i)
    {       
        ch1 = main_str[i]
        ch2 = sub_str[0]
        ascii1 = Char2Ascii(ch1)
        ascii2 = Char2Ascii(ch2)
        
        if(ascii1 == 10){
            ln=ln+1 //下一行开始,行数增加
        }

        if (ascii1 == ascii2){//第1个字符匹配成功
            j = 0
            while (j < sub_str_len)
            {
                // 比较字符的ASCII值
                ch1 = main_str[i + j]
                ch2 = sub_str[j]
                ascii1 = Char2Ascii(ch1)
                ascii2 = Char2Ascii(ch2)
                if (ascii1 != ascii2)
                {
                    break
                }
                j = j + 1
            }
            
            if(j == sub_str_len){ //j遍历完了说明匹配成功
            
                match=1
                if(first_matchln == 0){
                    first_matchln=ln //记录第1次匹配的行
                }
                if(first_matchindex == -1){
                    first_matchindex=i //记录第1次匹配的行
                }
                last_matchln=ln //最后一次匹配的行,每次更新
                last_matchindex=i //最后一次匹配的索引,每次更新
                
                break //如果想要遍历完整个字符串,得到最后匹配的行,不要break                
            }
       }
       i=i+1
       
    }
    //返回第一个匹配成功的行号
    if(match == 1){
        return first_matchln
    }else{
        return -1
    }
    
}


// find_strln_fromend - 查找包含指定字符串的行号（反向，简化版）
// 返回: 行号（从1开始），未找到返回0
function find_strln_fromend(main_str, sub_str)
{
    main_str_len = strlen(main_str)
    sub_str_len = strlen(sub_str)
    ln=1
    first_matchln=0 //第一次匹配所在的行
    last_matchln=0 //最后一次匹配所在的行
    first_matchindex=-1 //第一次匹配所在的位置
    last_matchindex=-1 //最后一次匹配所在位置
    match=0 //是否匹配成功
    
     // 如果sub_str_len为空字符串，返回-1
    // 如果sub_str_len比main_str_len长，不可能找到
    if (sub_str_len == 0 || sub_str_len > main_str_len)
    {
        return -1
    }
    
    i = 0
    max_i = main_str_len - sub_str_len
    
    while (i <= max_i)
    {       
        ch1 = main_str[i]
        ch2 = sub_str[0]
        ascii1 = Char2Ascii(ch1)
        ascii2 = Char2Ascii(ch2)
        
        if(ascii1 == 10){
            ln=ln+1 //下一行开始,行数增加
        }
        

        if (ascii1 == ascii2){//第1个字符匹配成功
            j = 0
            while (j < sub_str_len)
            {
                // 比较字符的ASCII值
                ch1 = main_str[i + j]
                ch2 = sub_str[j]
                ascii1 = Char2Ascii(ch1)
                ascii2 = Char2Ascii(ch2)
                if (ascii1 != ascii2)
                {
                    break
                }
                j = j + 1
            }
            
            if(j == sub_str_len){ //j遍历完了说明匹配成功
            
                match=1
                if(first_matchln == 0){
                    first_matchln=ln //记录第1次匹配的行
                }
                if(first_matchindex == -1){
                    first_matchindex=i //记录第1次匹配的行
                }

                last_matchln=ln //最后一次匹配的行,每次更新
                last_matchindex=i //最后一次匹配的索引,每次更新
                
                //break //如果想要遍历完整个字符串,得到最后匹配的行,不要break                
            }
       }
       i=i+1
       
    }
    //返回最后一个匹配成功的行号
    if(match == 1){
        return last_matchln
    }else{
        return -1
    }
    
}


// get_line_content - 获取指定行内容
// 返回: 整行字符，从上一行换行符(不含)开始到本行换行符(不包含)或结束
function get_line_content(s, line_num)
{

    len = strlen(s)
    total_lines = get_line_count(s)
    str = ""
    //msg "行数有@total_lines@行,字符串长度为@len@"
    if (len == 0 )
    {
        return ""
    }
    if (line_num <0)//为负数时,默认从末尾倒数第n行
    {
        line_num=total_lines+1+line_num
    }
    
    if (line_num == 0)//为0时,获取第1行
    {
        line_num=1
    }
    
    if (line_num > total_lines)//为行数太大时,获取最后1行
    {
       line_num = total_lines
    }    

    //msg "获取第@line_num@行"
    
//情况1:字符串只有1行,只可能获取一行
    if (total_lines == 1)
    {
        //直接返回原字符串
        str=s
        return str 
    }
    

//情况2:字符串有多行,要返回第1行
    if (line_num == 1)
    {
        i = 0
        while (i < len)
        {
            ch = s[i]
            ascii = Char2Ascii(ch)
            if (ascii == 10)  // 找到第1个换行符位置
            {
                break;
            }
            i=i+1
        }
        
        //直接返回字符串,不含第一行末尾换行符
        str =strmid(s,0,i)
        //msg "获取第1行@str@"
        return str
    }else{

//情况3:字符串有多行,要返回第n行
        first_index=0
        second_index=0
        num=0 //遍历到的换行符数量
        i=0
        while (i < len)
        {
            ch = s[i]
            ascii = Char2Ascii(ch)
            
            if (ascii == 10)  // 换行符
            {
                num=num+1

                //找到第n-1个换行符时标记前一半结束位置
                if(num==line_num-1){
                    first_index=i
                    //msg "first_index为@first_index@"
                }
                
                //找到第n个换行符时标记后一半开始位置(当要删除最后一行时,不存在)
                if(num==line_num){
                    second_index=i
                    //msg "second_index为@second_index@"
                    break
                }
            }
            

            i=i+1
        }

        
       
        if(num == line_num){
            //能找到第n个换行符,说明获取的中间行

            str=strmid(s,first_index+1,second_index)
            //msg "获取中间行,字符串为@str@"
            return str
        }else{
            //找不到第n个换行符,说明获取的最后一行
            //只截取第一段字符
            if(first_index+1 >len){
                //最后一行时空行,无内容
                str=""
                //msg "最后一行空行,获取最后一行,字符串为@str@"
                return str 
            }else{
                str=strmid(s,first_index+1,len)
                //msg "最后一行非空,字符串为@str@"
                return str
            }
        }
        

    }

}


// str_insert_line - 在指定行插入字符串,自动生成新行
// 返回: 插入后的新字符串
function str_insert_line(s, line_num, str_insert)
{

    
    len = strlen(s)
    total_lines = get_line_count(s)
    str = ""

    if (len == 0 )
    {
        return ""
    }
    if (line_num <0)//为负数时,默认从末尾倒数第n行
    {
        line_num=total_lines+1+line_num+1
    }
    
    if (line_num == 0)//为负数时,获取第1行
    {
        line_num=1
    }
    
    if (line_num > total_lines+1)//插入时,可选行数比总行数大1
    {
       line_num = total_lines+1
    }  

    

//情况1:插入第1行
    if (line_num == 1)
    {
        //为插入字符串末尾添加一个换行符
        str=cat(str_insert,CharFromAscii(10))
        str=cat(str,s)
        return str
    }else if(line_num == total_lines+1){
//情况2:要插入末尾

        //在字符串开头插入换行符
        str=cat(CharFromAscii(10),str_insert)
        str=cat(s,str)
        return str
    }else{
//情况3:要插入第n行

        //为插入字符串开头添加一个换行符
        str=cat(CharFromAscii(10),str_insert)
      
        first_index=0
        second_index=0
        num=0 //遍历到的换行符数量
        i=0
        while (i < len)
        {
            ch = s[i]
            ascii = Char2Ascii(ch)
            
            if (ascii == 10)  // 换行符
            {
                num=num+1

                //找到第n-1个换行符时标记前一半结束位置
                if(num==line_num-1){
                    first_index=i
                    //msg "first_index为@first_index@"
                    break
                }
                
                //找到第n个换行符时标记后一半开始位置(当要找最后一行时,不存在)
                if(num==line_num){
                    second_index=i
                    //msg "second_index为@second_index@"
                    
                }
            }                

            i=i+1
        }

        
        // 方法：构建新字符串，放入新插入的行

            first_str=strmid(s,0,first_index)
            second_str=strmid(s,first_index,len)
            str=cat(first_str,str)
            str=cat(str,second_str)
            return str

        

    }

}



// str_delete_line - 删除指定行,行号从1开始
// 返回: 删除后的新字符串
function str_delete_line(s, line_num)
{
    len = strlen(s)
    total_lines = get_line_count(s)
    str = ""

    if (len == 0 )
    {
        return ""
    }
    
    if (line_num <0)//为负数时,默认从末尾倒数第n行
    {
        line_num=total_lines+1+line_num
    }
    
    if (line_num == 0)//为0时,删除第1行
    {
        line_num=1
    }
    
    if (line_num > total_lines)//为行数太大时,删除最后1行
    {
       line_num = total_lines
    } 

    
//情况1:字符串只有1行,只可能删除一行
    if (total_lines == 1)
    {
        //直接返回空字符串
        return "" 
    }
    

//情况2:字符串有多行,要删掉第1行
    if (line_num == 1)
    {
        i = 0
        while (i < len)
        {
            ch = s[i]
            ascii = Char2Ascii(ch)
            if (ascii == 10)  // 找到第1个换行符位置
            {
                break;
            }
            i=i+1
        }
        
        //直接返回字符串,不含第一行末尾换行符
        str =strmid(s, i+1,len)
        return str
    }else{

//情况3:字符串有多行,要删掉第n行
        first_index=0
        second_index=0
        num=0 //遍历到的换行符数量
        i=0
        while (i < len)
        {
            ch = s[i]
            ascii = Char2Ascii(ch)
            
            if (ascii == 10)  // 换行符
            {
                num=num+1

                //找到第n-1个换行符时标记前一半结束位置
                if(num==line_num-1){
                    first_index=i
                    //msg "first_index为@first_index@"
                    
                }
                
                //找到第n个换行符时标记后一半开始位置(当要找最后一行时,不存在)
                if(num==line_num){
                    second_index=i
                    //msg "second_index为@second_index@"
                    break
                }
            } 

            i=i+1
        }

        
        // 方法：构建新字符串，跳过要删除的行
        if(num == line_num){
            //能找到第n个换行符,说明删除的中间行
            //前后两段字符串连接一起
            first_str=strmid(s,0,first_index)
            second_str=strmid(s,second_index,len)
            str=cat(first_str,second_str)
            return str
        }else{
            //找不到第n个换行符,说明删除的最后一行
            //只截取第一段字符
            str=strmid(s,0,first_index)
            return str
        }
        

    }

}
    

// str_replace_line - 替换指定行内容
// 新字符串可以是多行字符串，中间可以包含换行符
// 返回: 替换后的新字符串
function str_replace_line(s, line_num, new_content)
{
    len = strlen(s)
    total_lines = get_line_count(s)
    str = ""

    if (len == 0 )
    {
        return ""
    }
    
    if (line_num <0)//为负数时,默认从末尾倒数第n行
    {
        line_num=total_lines+1+line_num
    }
    
    if (line_num == 0)//为0时,第1行
    {
        line_num=1
    }
    
    if (line_num > total_lines)//为行数太大时,最后1行
    {
       line_num = total_lines
    } 

    
    // 先删除原行，再插入新内容
    temp = str_delete_line(s, line_num)
    return str_insert_line(temp, line_num, new_content)
}


// strstr_fromend - 从后往前查找字符串在字符串中第一次出现的位置
// 实际上是查找子串最后一次出现的位置
// 返回: 索引位置，未找到返回-1
function strstr_fromend(main_str, sub_str)
{
    main_str_len = strlen(main_str)
    sub_str_len = strlen(sub_str)
    ln=1
    first_matchln=0 //第一次匹配所在的行
    last_matchln=0 //最后一次匹配所在的行
    first_matchindex=-1 //第一次匹配所在的位置
    last_matchindex=-1 //最后一次匹配所在位置
    match=0 //是否匹配成功
    
     // 如果sub_str_len为空字符串，返回-1
    // 如果sub_str_len比main_str_len长，不可能找到
    if (sub_str_len == 0 || sub_str_len > main_str_len)
    {
        return -1
    }
    
    i = 0
    max_i = main_str_len - sub_str_len
    
    while (i <= max_i)
    {       
        ch1 = main_str[i]
        ch2 = sub_str[0]
        ascii1 = Char2Ascii(ch1)
        ascii2 = Char2Ascii(ch2)
        
        if(ascii1 == 10){
            ln=ln+1 //下一行开始,行数增加
        }
        

        if (ascii1 == ascii2){//第1个字符匹配成功
            j = 0
            while (j < sub_str_len)
            {
                // 比较字符的ASCII值
                ch1 = main_str[i + j]
                ch2 = sub_str[j]
                ascii1 = Char2Ascii(ch1)
                ascii2 = Char2Ascii(ch2)
                if (ascii1 != ascii2)
                {
                    break
                }
                j = j + 1
            }
            
            if(j == sub_str_len){ //j遍历完了说明匹配成功
            
                match=1
                if(first_matchln ==0){
                    first_matchln=ln //记录第1次匹配的行
                }
                if(first_matchindex == -1){
                    first_matchindex=i //记录第1次匹配的行
                }
                last_matchln=ln //最后一次匹配的行,每次更新
                last_matchindex=i //最后一次匹配的索引,每次更新
                
                //break //如果想要遍历完整个字符串,得到最后匹配的行,不要break                
            }
       }
       i=i+1
       
    }
    //返回最后一个匹配成功的索引号
    if(match == 1){
        return last_matchindex
    }else{
        return -1
    }
    
}


// str_insert - 在字符串指定位置插入字符串（正向位置）
// 返回: 插入后的新字符串
function str_insert(s, position, str_insert)
{
   
    len = strlen(s)
    //位置负数处理,从倒数第position个字符处开始节区length个字符
    if(position<0){
        position=len+1+position
    }
    //位置越界处理,变为最后length个字符
    if (position > len)
    {
        position=len
    }
    
    if (position == 0)
    {
        return cat(str_insert, s)
    }
    
    if (position == len)
    {
        return cat(s, str_insert)
    }
    
    before = strmid(s, 0, position)
    after = strmid(s, position, len)
    str=cat(before, str_insert)
    str=cat(str,after)
    return str
}


// str_delete - 在字符串指定位置删除指定长度字符（正向位置）
// 返回: 删除后的新字符串
function str_delete(s, position, length)
{
    len = strlen(s)
    //长度为不是正数就报错无法处理
    if (length <= 0 || length>len)
    {
        return ""
    }

    //位置负数处理,从倒数第position个字符处开始节区length个字符
    if(position<0){
        position=len+position
    }
    //位置越界处理,变为最后length个字符
    if (position + length > len)
    {
        position=len-length
    }
    
    before = strmid(s, 0, position)
    str=before
    
    if(position + length < len){
        after = strmid(s, position + length, len)
        str=cat(before, after)
    }
    
    return str
}



// str_replace - 在字符串指定位置替换字符串（正向位置）
// 返回: 替换后的新字符串
function str_replace(s, position, length, new_str)
{
    len = strlen(s)
    //长度为不是正数就报错无法处理
    if (length <= 0 || length>len)
    {
        return ""
    }

    //位置负数处理,从倒数第position个字符处开始节区length个字符
    if(position<0){
        position=len+position
    }
    //位置越界处理,变为最后length个字符
    if (position + length > len)
    {
        position=len-length
    }
    
    // 先删除，再插入
    temp = str_delete(s, position, length)
    return str_insert(temp, position, new_str)
}



// str_get - 获取指定长度的字符串（正向）
// 返回: 从指定位置开始的指定长度子串,position可以为负数(负数表示从末尾开始数),length必须为正数
function str_get(s, position, length)
{
    len = strlen(s)
    //长度为不是正数就报错无法处理
    if (length <= 0 || length>len)
    {
        return ""
    }
    

    //位置负数处理,从倒数第position个字符处开始节区length个字符
    if(position<0){
        position=len+position
        
    }
    //位置越界处理,变为最后length个字符
    if (position + length > len)
    {
        position=len-length
    }
    
    return strmid(s, position, position + length)
}



// replace_once_from_begin - 单次替换，用A字符串替换原字符串中的首次匹配到的B字符串（正向）
// 返回: 替换后的新字符串
function replace_once_from_begin(s, old_str, new_str)
{
    pos = strstr(s, old_str)
    //msg "原字符串位置为@pos@"
    if (pos == -1)
    {
        //msg "未找到，返回原字符串"
        return s  // 未找到，返回原字符串
    }
    
    return str_replace(s, pos, strlen(old_str), new_str)
}

// replace_once_from_end - 单次替换，用A字符串替换原字符串中的首次匹配到的B字符串（反向）
// 从末尾开始查找第一次匹配
// 返回: 替换后的新字符串
function replace_once_from_end(s, old_str, new_str)
{
    pos = strstr_fromend(s, old_str)
    if (pos == -1)
    {
        return s  // 未找到，返回原字符串
    }
    
    return str_replace(s, pos, strlen(old_str), new_str)
}

// replace_all - 全部替换，用A字符串替换原字符串中的所有匹配到的B字符串
// 返回: 替换后的新字符串
function replace_all(s, old_str, new_str)
{
    result = s
    old_len = strlen(old_str)
    
    if (old_len == 0)
    {
        return result  // 空字符串不替换
    }
    
    // 循环替换直到没有匹配
    max_iterations = 100  // 防止无限循环
    iteration = 0
    
    while (iteration < max_iterations)
    {
        iteration = iteration + 1
        
        pos = strstr(result, old_str)
        if (pos == -1)
        {
            break
        }
        
        result = str_replace(result, pos, old_len, new_str)
    }
    
    return result
}


/***************************************分界符，以上为字符位置查找函数实现*****  *********************************/
function just_line_line_line_line_line_line_line_line2(){}

/////////////////////////////////////////////////////////////////////////////
// 基础编码判断函数（返回字节数量）
/////////////////////////////////////////////////////////////////////////////

// is_CN_utf8 - 判断从指定位置开始是否是UTF-8编码的中文字符
// 返回: 0-不是UTF-8中文，3或4-是UTF-8中文（返回字节数量）


function is_CN_utf8(s, position)
{
    len = strlen(s)
    if (position < 0 || position >= len)
    {
        return 0
    }
    
    // 获取第一个字节
    ch1 = s[position]
    byte1 = Char2Ascii_CN(ch1)

    //msg "第1个字节@ch1@编码为:@byte1@"

    // 检查是否是3字节UTF-8中文字符 (0xE4-0xE9是常用中文范围)
//    if (byte1 >= 0xE4 && byte1 <= 0xE9)
//    {
//        // 确保有足够的后续字节
//        //msg "有足够的后续字节"
//        if (position + 2 < len)
//        {
//            // 检查第二、三个字节是否在有效范围 (0x80-0xBF)

//            byte2 = Char2Ascii_CN(ch2)
//            //msg "第2个字节@ch2@编码为:@byte2@"

//            ch3 = s[position + 2]
//            byte3 = Char2Ascii_CN(ch3)
//            //msg "第3个字节@ch3@编码为:@byte3@"

//            if (byte2 >= 0x80 && byte2 <= 0xBF)
//            {

//                if(byte3 >= 0x80 && byte3 <= 0xBF) {
                
//                    return 3  // 是3字节UTF-8中文
//                }

//            }
//        }
//    }
    
    // 检查其他可能的UTF-8中文范围 (3字节)
    if (byte1 >= 0xE0 && byte1 <= 0xEF)
    {
        if (position + 2 < len) //长度够就按三字节返回
        {
//            ch2 = s[position + 1]
//            byte2 = Char2Ascii_CN(ch2)
//            ch3 = s[position + 2]
//            byte3 = Char2Ascii_CN(ch3)
            
//            if (byte2 >= 0x80 && byte2 <= 0xBF && byte3 >= 0x80 && byte3 <= 0xBF)
//            {
//                // 进一步检查是否是中文常用Unicode范围
//                // Unicode中文范围: 0x4E00-0x9FFF
//                // 对应的UTF-8: 
//                // 0x4E00-0x4FFF: 0xE4 0xB8 0x80 - 0xE4 0xBF 0xBF
//                // 0x5000-0x9FFF: 0xE5 0x80 0x80 - 0xE9 0xBF 0xBF
//                if ((byte1 == 0xE4 && byte2 >= 0xB8) || 
//                    (byte1 >= 0xE5 && byte1 <= 0xE9))
//                {
//                    return 3
//                }
                
//                // 其他3字节UTF-8字符也可能是中文
//                if (byte1 == 0xE3 || byte1 == 0xE2 || byte1 == 0xE1 || byte1 == 0xE0)
//                {
//                    // 这些可能是其他CJK字符
                    return 3
//                }
//            }
        }
    }
    
    // 检查4字节UTF-8字符 (扩展中文范围)，注释掉，不考虑
//    if (byte1 >= 0xF0 && byte1 <= 0xF4)
//    {
//        if (position + 3 < len)
//        {
//            valid = 1
//            i = 1
//            while (i <= 3)
//            {
//                ch = s[position + i]
//                byte = Char2Ascii_CN(ch)
//                if (byte < 0x80 || byte > 0xBF)
//                {
//                    valid = 0
//                    break
//                }
//                i = i + 1
//            }
            
//            if (valid == 1)
//            {
//                // 检查是否是CJK扩展A区或B区
//                // CJK扩展A区: 0x3400-0x4DBF -> UTF-8: 0xF0 0xA4 0x80 0x80 - 0xF0 0xA4 0xB6 0xBF
//                // CJK扩展B区: 0x20000-0x2A6DF -> UTF-8: 0xF0 0xA0 0x80 0x80 - 0xF0 0xAA 0x9B 0x9F
//                if (byte1 == 0xF0)
//                {
//                    ch2 = s[position + 1]
//                    byte2 = Char2Ascii_CN(ch2)
//                    if ((byte2 >= 0xA4 && byte2 <= 0xA4) ||  // 扩展A区
//                        (byte2 >= 0xA0 && byte2 <= 0xAA))    // 扩展B区等
//                    {
//                        return 4
//                    }
//                }
//                return 4  // 其他4字节UTF-8
//            }
//        }
//    }
    
    return 0
}



// is_CN_char - 判断从指定位置开始是否是中文字符（自动检测编码）
// 先尝试UTF-8，再尝试GBK
// 返回: 0-不是中文字符，>0-是中文字符（返回字节数量）
function is_CN_char(s, position)
{
    // 先检查UTF-8
    utf8_result = is_CN_utf8(s, position)
    if (utf8_result > 0)
    {
        //msg "@s@是中文utf8，字节数为@utf8_result@"
        return utf8_result
    }
 
    return 0
}

/////////////////////////////////////////////////////////////////////////////
// UTF-8相关辅助函数
/////////////////////////////////////////////////////////////////////////////

// get_utf8_char_length - 获取UTF-8字符的字节长度
// 返回: UTF-8字符的字节数 (1-4)，如果不是有效的UTF-8返回0
function get_utf8_char_length(s, position)
{
    len = strlen(s)
    
    if (position < 0 || position >= len)
    {
        return 0
    }
    
    // 获取第一个字节
    ch1 = s[position]
    byte1 = Char2Ascii(ch1)
    
    // ASCII字符 (0-127)
    if (byte1 < 0x80)
    {
        return 1
    }
    
    // 2字节UTF-8 (110xxxxx)
    if (byte1 >= 0xC0 && byte1 <= 0xDF)
    {
        if (position + 1 >= len)
        {
            return 0
        }
        
        ch2 = s[position + 1]
        byte2 = Char2Ascii(ch2)
        if (byte2 >= 0x80 && byte2 <= 0xBF)
        {
            return 2
        }
    }
    
    // 3字节UTF-8 (1110xxxx) - 包含大部分中文
    if (byte1 >= 0xE0 && byte1 <= 0xEF)
    {
        if (position + 2 >= len)
        {
            return 0
        }
        
        ch2 = s[position + 1]
        byte2 = Char2Ascii(ch2)
        ch3 = s[position + 2]
        byte3 = Char2Ascii(ch3)
        
        if (byte2 >= 0x80 && byte2 <= 0xBF && byte3 >= 0x80 && byte3 <= 0xBF)
        {
            return 3
        }
    }
    
    // 4字节UTF-8 (11110xxx)
    if (byte1 >= 0xF0 && byte1 <= 0xF7)
    {
        if (position + 3 >= len)
        {
            return 0
        }
        
        valid = 1
        i = 1
        while (i <= 3)
        {
            ch = s[position + i]
            byte = Char2Ascii(ch)
            if (byte < 0x80 || byte > 0xBF)
            {
                valid = 0
                break
            }
            i = i + 1
        }
        
        if (valid == 1)
        {
            return 4
        }
    }
    
    return 0
}

/////////////////////////////////////////////////////////////////////////////
// 修改其他函数使用新的判断函数
/////////////////////////////////////////////////////////////////////////////

// count_CN_utf8_chars - 统计字符串中的UTF-8中文字符数量
// 返回: 中文字符数量
function count_CN_utf8_chars(s)
{
    len = strlen(s)
    count = 0
    i = 0
    
    while (i < len)
    {
        cn_len = is_CN_utf8(s, i)
        if (cn_len > 0)
        {
            count = count + 1
            i = i + cn_len
        }
        else
        {
            // 不是中文字符，检查下一个字符
            utf8_len = get_utf8_char_length(s, i)
            if (utf8_len > 0)
            {
                i = i + utf8_len
            }
            else
            {
                i = i + 1  // 无效字节，跳过1个
            }
        }
    }
    
    return count
}


// count_CN_chars - 统计字符串中的中文字符数量（自动检测编码）
// 返回: 中文字符数量
count_CN_chars(" 世界 ")

function count_CN_chars(s)
{
    len = strlen(s)
    count = 0
    i = 0
    msg "当前字符串为@s@,长度为@len@"

    while (i < len)
    {
        ch = s[i]
        byte1 = Char2Ascii_CN(ch)
        cn_len = is_CN_char(s, i)

        if (cn_len > 0)
        {
            msg "位置@i@开始的字符串是中文,长度@cn_len@,第一个ascii编码为@byte1@,字符为@ch@"
            count = count + 1
            i = i + cn_len
        }
        else
        {
                // 扩展ASCII，按单字节处理
            i = i + 1
        }
    }
    
    return count
}

// find_first_CN_utf8 - 查找第一个UTF-8中文字符的位置
// 返回: 位置索引，未找到返回-1
function find_first_CN_utf8(s)
{
    len = strlen(s)
    i = 0
    
    while (i < len)
    {
        cn_len = is_CN_utf8(s, i)
        if (cn_len > 0)
        {
            return i
        }
        
        // 移动到下一个字符开始位置
        utf8_len = get_utf8_char_length(s, i)
        if (utf8_len > 0)
        {
            i = i + utf8_len
        }
        else
        {
            i = i + 1
        }
    }
    
    return -1
}


// find_first_CN_char - 查找第一个中文字符的位置（自动检测编码）
// 返回: 位置索引，未找到返回-1
function find_first_CN_char(s)
{
    // 先尝试查找UTF-8中文
    pos = find_first_CN_utf8(s)
    if (pos != -1)
    {
        return pos
    }
    
}

// get_CN_char - 获取从指定位置开始的中文字符
// 返回: 中文字符字符串，如果不是中文字符返回空字符串
function get_CN_char(s, position)
{
    len = strlen(s)
    
    if (position < 0 || position >= len)
    {
        return ""
    }
    
    // 获取字符长度
    cn_len = is_CN_char(s, position)
    
    if (cn_len > 0 && position + cn_len <= len)
    {
        return strmid(s, position, position + cn_len)
    }
    
    return ""
}


/*******************************分界符，以上为中英文可见字符位置查找函数实现**  *********************************/
function just_line_line_line_line_line_line_line_line3(){}

/////////////////////////////////////////////////////////////////////////////
// 其他相关工具函数
/////////////////////////////////////////////////////////////////////////////





/////////////////////////////////////////////////////////////////////////////
// 相关的工具函数
/////////////////////////////////////////////////////////////////////////////

// trim_trailing_invisible - 去除末尾的连续不可见字符
// 返回: 去除末尾不可见字符后的字符串
function trim_trailing_invisible(s)
{
    len = strlen(s)
    
    if (len == 0)
    {
        return s
    }
    
    // 找到末尾连续不可见字符的开始位置
    invisible_start = find_unvisible_char_atend(s)
    
    if (invisible_start == -1)
    {
        return s  // 没有末尾不可见字符
    }
    
    if (invisible_start == 0)
    {
        return ""  // 整个字符串都是不可见字符
    }
    
    // 截取从开头到不可见字符开始位置之前的部分
    return strmid(s, 0, invisible_start)
}



// get_trailing_invisible - 获取末尾的连续不可见字符
// 返回: 末尾连续不可见字符的字符串
function get_trailing_invisible(s)
{
    len = strlen(s)
    
    if (len == 0)
    {
        return ""
    }
    
    invisible_start = find_unvisible_char_atend(s)
    
    if (invisible_start == -1)
    {
        return ""  // 没有末尾不可见字符
    }
    
    if (invisible_start >= len)
    {
        return ""
    }
    
    return strmid(s, invisible_start, len)
}

// has_trailing_invisible - 判断是否有末尾连续不可见字符
// 返回: 1-有，0-没有
function has_trailing_invisible(s)
{
    invisible_start = find_unvisible_char_atend(s)
    if (invisible_start != -1 && invisible_start < strlen(s))
    {
        return 1
    }
    return 0
}
/***************************************分界符，以下为测试函数*****  *********************************/
function just_line_line_line_line_line_line_line_line4(){}

/////////////////////////////////////////////////////////////////////////////
// 测试函数
/////////////////////////////////////////////////////////////////////////////

// test_trailing_invisible_functions - 测试末尾不可见字符函数
function test_trailing_invisible_functions()
{
    msg "=== 测试末尾不可见字符函数 ==="
    
    // 测试用例1：末尾有空格
    test1 = "Hello World   "
    msg "测试字符串1: \"" # test1 # "\""
    msg "字符串长度: " # strlen(test1)
    
    invisible_start1 = find_unvisible_char_atend(test1)
    msg "末尾连续不可见字符开始位置: " # invisible_start1 # " (期望: 11，'d'后面第一个空格)"
    
    if (invisible_start1 != -1)
    {
        trailing = get_trailing_invisible(test1)
        msg "末尾不可见字符: \"" # trailing # "\""
        msg "末尾不可见字符长度: " # strlen(trailing)
        
        trimmed = trim_trailing_invisible(test1)
        msg "去除后: \"" # trimmed # "\""
        msg "去除后长度: " # strlen(trimmed)
    }
    
    // 测试用例2：末尾有空格和换行符
    test2 = "Test String  \n\t  "
    msg "测试字符串2: 显示控制字符"
    
    // 显示字符详情
    i = 0
    while (i < strlen(test2) && i < 20)
    {
        ch = test2[i]
        ascii = Char2Ascii(ch)
        if (ascii == 32)
        {
            msg "位置 " # i # ": 空格"
        }
        else if (ascii == 9)
        {
            msg "位置 " # i # ": 制表符(\\t)"
        }
        else if (ascii == 10)
        {
            msg "位置 " # i # ": 换行符(\\n)"
        }
        else if (ascii >= 33 && ascii <= 126)
        {
            msg "位置 " # i # ": '" # ch # "'"
        }
        i = i + 1
    }
    
    invisible_start2 = find_unvisible_char_atend(test2)
    msg "末尾连续不可见字符开始位置: " # invisible_start2
    
    if (invisible_start2 != -1)
    {
        trailing2 = get_trailing_invisible(test2)
        msg "末尾不可见字符长度: " # strlen(trailing2)
        
        trimmed2 = trim_trailing_invisible(test2)
        msg "去除后: \"" # trimmed2 # "\""
    }
    
    // 测试用例3：没有末尾不可见字符
    test3 = "No trailing spaces"
    msg "测试字符串3: \"" # test3 # "\""
    
    invisible_start3 = find_unvisible_char_atend(test3)
    msg "末尾连续不可见字符开始位置: " # invisible_start3 # " (期望: -1，没有)"
    
    has_trailing = has_trailing_invisible(test3)
    msg "是否有末尾不可见字符: " # has_trailing # " (期望: 0)"
    
    // 测试用例4：全是不可见字符
    test4 = "   \t\n  "
    msg "测试字符串4: 全是不可见字符"
    
    invisible_start4 = find_unvisible_char_atend(test4)
    msg "末尾连续不可见字符开始位置: " # invisible_start4 # " (期望: 0，整个字符串都是)"
    
    if (invisible_start4 == 0)
    {
        trimmed4 = trim_trailing_invisible(test4)
        msg "去除后长度: " # strlen(trimmed4) # " (期望: 0)"
    }
    
    // 测试用例5：中英混合，末尾有空格
    test5 = "Hello 世界！  "
    msg "测试字符串5: \"" # test5 # "\""
    
    invisible_start5 = find_unvisible_char_atend(test5)
    msg "末尾连续不可见字符开始位置: " # invisible_start5
    
    if (invisible_start5 != -1)
    {
        ch = test5[invisible_start5]
        ascii = Char2Ascii(ch)
        msg "开始位置字符ASCII: " # ascii # " (期望: 32，空格)"
        
        trimmed5 = trim_trailing_invisible(test5)
        msg "去除后: \"" # trimmed5 # "\""
    }
    
    // 测试扩展版本
    msg "--- 测试扩展版本 ---"
    test6 = "Text with commas,,,  "
    msg "测试字符串6: \"" # test6 # "\""
    
    // 默认情况：逗号是可见的
    invisible_start6a = find_unvisible_char_atend(test6)
    msg "默认 - 末尾连续不可见字符开始位置: " # invisible_start6a
    
    
    msg "=== 末尾不可见字符测试结束 ==="
}

// quick_test_trailing - 快速测试末尾不可见字符
function quick_test_trailing()
{
    msg "快速测试末尾不可见字符函数:"
    
    test_str = "Hello World   \t"
    msg "测试字符串: 显示控制字符"
    
    // 显示字符串
    i = 0
    while (i < strlen(test_str))
    {
        ch = test_str[i]
        ascii = Char2Ascii(ch)
        if (ascii == 32)
        {
            msg "位置 " # i # ": 空格"
        }
        else if (ascii == 9)
        {
            msg "位置 " # i # ": 制表符"
        }
        else if (ascii == 10)
        {
            msg "位置 " # i # ": 换行符"
        }
        else if (ascii >= 33 && ascii <= 126)
        {
            msg "位置 " # i # ": '" # ch # "'"
        }
        i = i + 1
    }
    
    invisible_start = find_unvisible_char_atend(test_str)
    msg "末尾连续不可见字符开始位置: " # invisible_start
    
    if (invisible_start != -1)
    {
        trailing = get_trailing_invisible(test_str)
        msg "末尾不可见字符长度: " # strlen(trailing)
        
        trimmed = trim_trailing_invisible(test_str)
        msg "去除后: \"" # trimmed # "\""
        msg "去除后长度: " # strlen(trimmed)
    }
    
    // 测试第一个可见字符
    first_visible = find_visible_char_atbegin(test_str)
    msg "第一个可见字符位置（跳过空格）: " # first_visible
    
    if (first_visible != -1)
    {
        ch = test_str[first_visible]
        msg "第一个可见字符: '" # ch # "'"
    }
}


// quick_test_CN - 快速测试中文判断
function quick_test_CN()
{
    msg "快速测试中文判断:"
    
    test_str = "Hello 世界！测试123"
    
    msg "测试字符串: \"" # test_str # "\""
    msg "总字节数: " # strlen(test_str)
    msg "中文字符数: " # count_CN_chars(test_str)
    
    // 查找第一个中文
    first_cn = find_first_CN_char(test_str)
    msg "第一个中文位置: " # first_cn
    
    if (first_cn != -1)
    {
        cn_char = get_CN_char(test_str, first_cn)
        cn_len = is_CN_char(test_str, first_cn)
        msg "第一个中文: '" # cn_char # "' (长度: " # cn_len # ")"
    }
    
    // 测试各个位置
    msg "位置判断测试:"
    pos = 6
    cn_len = is_CN_char(test_str, pos)
    if (cn_len > 0)
    {
        cn_char = strmid(test_str, pos, pos + cn_len)
        msg "位置 " # pos # ": 中文 '" # cn_char # "'"
    }
    else
    {
        msg "位置 " # pos # ": 不是中文"
    }
}


/////////////////////////////////////////////////////////////////////////////
// ASCII判断函数（保持不变，但更新调用方式）
/////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////////////////////////
// 测试函数
/////////////////////////////////////////////////////////////////////////////

// test_CN_functions - 测试中文判断函数
function test_CN_functions()
{
    msg "=== 测试中文判断函数 ==="
    
    // 测试字符串（UTF-8编码）
    test_str = "Hello 世界！这是一个测试。Test 测试"
    msg "测试字符串: \"" # test_str # "\""
    msg "字符串长度(字节): " # strlen(test_str)
    
    // 显示字符串的字节信息
    msg "--- 字节分析 ---"
    i = 0
    while (i < strlen(test_str) && i < 30)
    {
        ch = test_str[i]
        ascii = Char2Ascii(ch)
        
        // 检查是否是中文
        cn_len = is_CN_char(test_str, i)
        if (cn_len > 0)
        {
            cn_char = strmid(test_str, i, i + cn_len)
            msg "位置 " # i # ": 中文字符 '" # cn_char # "' (长度: " # cn_len # ", ASCII: " # ascii # ")"
            i = i + cn_len - 1
        }
        else if (ascii >= 32 && ascii <= 126)
        {
            msg "位置 " # i # ": ASCII字符 '" # ch # "' (ASCII: " # ascii # ")"
        }
        else if (ascii < 32 || ascii == 127)
        {
            if (ascii == 32)
            {
                msg "位置 " # i # ": 空格"
            }
            else if (ascii == 9)
            {
                msg "位置 " # i # ": 制表符"
            }
            else if (ascii == 10)
            {
                msg "位置 " # i # ": 换行符"
            }
            else
            {
                msg "位置 " # i # ": 控制字符 (ASCII: " # ascii # ")"
            }
        }
        else
        {
            msg "位置 " # i # ": 扩展字符 (ASCII: " # ascii # ")"
        }
        
        i = i + 1
    }
    
    // 测试统计函数
    msg "--- 统计测试 ---"
    utf8_count = count_CN_utf8_chars(test_str)

    total_count = count_CN_chars(test_str)
    
    msg "UTF-8中文字符数: " # utf8_count

    msg "总中文字符数: " # total_count
    
    // 测试查找函数
    msg "--- 查找测试 ---"
    first_utf8 = find_first_CN_utf8(test_str)

    first_cn = find_first_CN_char(test_str)
    
    msg "第一个UTF-8中文位置: " # first_utf8

    msg "第一个中文位置: " # first_cn
    
    if (first_cn != -1)
    {
        cn_char = get_CN_char(test_str, first_cn)
        msg "第一个中文字符: '" # cn_char # "'"
        
        // 检查该字符的长度
        cn_len = is_CN_char(test_str, first_cn)
        msg "字符长度: " # cn_len
    }
    
    // 测试具体位置判断
    msg "--- 具体位置判断 ---"
    
    // 测试位置6（应该是"世"字）
    pos = 6
    cn_len1 = is_CN_utf8(test_str, pos)

    cn_len3 = is_CN_char(test_str, pos)
    
    msg "位置 " # pos # " 判断结果:"
    msg "  is_CN_utf8: " # cn_len1 # " (期望: 3)"

    msg "  is_CN_char: " # cn_len3 # " (期望: 3)"
    
    if (cn_len1 > 0)
    {
        cn_char = strmid(test_str, pos, pos + cn_len1)
        msg "  字符: '" # cn_char # "'"
    }
    
    // 测试纯中文字符串
    msg "--- 纯中文测试 ---"
    chinese_only = "中华人民共和国"
    msg "纯中文字符串: \"" # chinese_only # "\""
    msg "字节数: " # strlen(chinese_only)
    msg "中文字符数: " # count_CN_chars(chinese_only)
    
    // 测试混合字符串中的中文判断
    msg "--- 混合字符串遍历 ---"
    mixed = "A测试B中文C"
    msg "混合字符串: \"" # mixed # "\""
    
    i = 0
    while (i < strlen(mixed))
    {
        cn_len = is_CN_char(mixed, i)
        if (cn_len > 0)
        {
            cn_char = strmid(mixed, i, i + cn_len)
            msg "位置 " # i # ": 中文字符 '" # cn_char # "' (长度: " # cn_len # ")"
            i = i + cn_len
        }
        else
        {
            ch = mixed[i]
            ascii = Char2Ascii(ch)
            if (ascii >= 32 && ascii <= 126)
            {
                msg "位置 " # i # ": ASCII字符 '" # ch # "'"
            }
            i = i + 1
        }
    }
    
    msg "=== 中文判断测试结束 ==="
}

// test_encoding_detection - 测试编码检测
function test_encoding_detection()
{
    msg "=== 测试编码检测 ==="
    
    // 测试不同情况
    test1 = "Hello World"
    test2 = "你好世界"
    test3 = "Hello 世界！"
    test4 = "Test测试Mixed混合"
    
    msg "测试用例1 - 纯ASCII:"
    msg "字符串: \"" # test1 # "\""
    msg "中文字符数: " # count_CN_chars(test1) # " (期望: 0)"
    
    msg "测试用例2 - 纯中文:"
    msg "字符串: \"" # test2 # "\""
    msg "字节数: " # strlen(test2)
    msg "中文字符数: " # count_CN_chars(test2)
    msg "UTF-8中文数: " # count_CN_utf8_chars(test2)
    
    msg "测试用例3 - 中英混合:"
    msg "字符串: \"" # test3 # "\""
    msg "中文字符数: " # count_CN_chars(test3)
    first_cn = find_first_CN_char(test3)
    msg "第一个中文位置: " # first_cn
    if (first_cn != -1)
    {
        cn_char = get_CN_char(test3, first_cn)
        msg "第一个中文字符: '" # cn_char # "'"
    }
    
    msg "测试用例4 - 复杂混合:"
    msg "字符串: \"" # test4 # "\""
    msg "中文字符数: " # count_CN_chars(test4)
    
    // 遍历显示所有字符
    msg "字符分析:"
    i = 0
    while (i < strlen(test4))
    {
        cn_len = is_CN_char(test4, i)
        if (cn_len > 0)
        {
            cn_char = strmid(test4, i, i + cn_len)
            msg "位置 " # i # ": 中文 '" # cn_char # "' (长度: " # cn_len # ")"
            i = i + cn_len
        }
        else
        {
            ch = test4[i]
            ascii = Char2Ascii(ch)
            if (ascii >= 32 && ascii <= 126)
            {
                msg "位置 " # i # ": ASCII '" # ch # "'"
            }
            else
            {
                msg "位置 " # i # ": 其他 (ASCII: " # ascii # ")"
            }
            i = i + 1
        }
    }
    
    msg "=== 编码检测测试结束 ==="
}

