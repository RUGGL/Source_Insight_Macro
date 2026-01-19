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
        ascii1 = AsciiFromChar(ch1)
        ascii2 = AsciiFromChar(ch2)
        
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
        ascii1 = AsciiFromChar(ch1)
        ascii2 = AsciiFromChar(ch2)
        
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
        
        ascii1 = AsciiFromChar(ch1_lower)
        ascii2 = AsciiFromChar(ch2_lower)
        
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
        ascii_from_str = AsciiFromChar(ch_from_str)
        ascii_ch = AsciiFromChar(ch)
        
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
    ascii_ch = AsciiFromChar(ch)
    
    while (i >= 0)
    {
        ch_from_str = s[i]
        ascii_from_str = AsciiFromChar(ch_from_str)
        
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
        ascii1 = AsciiFromChar(ch1)
        ascii2 = AsciiFromChar(ch2)
        
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
                ascii1 = AsciiFromChar(ch1)
                ascii2 = AsciiFromChar(ch2)
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
        ascii_val = AsciiFromChar(accept[k])
        ascii_list = cat(ascii_list, CharFromAscii(ascii_val))
        k = k + 1
    }
    
    i = 0
    while (i < s_len)
    {
        ch = s[i]
        ascii_ch = AsciiFromChar(ch)
        
        // 在ascii_list中查找
        j = 0
        while (j < accept_len)
        {
            ascii_accept = AsciiFromChar(ascii_list[j])
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
        ascii_val = AsciiFromChar(accept[k])
        accept_ascii = cat(accept_ascii, CharFromAscii(ascii_val))
        k = k + 1
    }
    
    count = 0
    i = 0
    
    while (i < s_len)
    {
        ch = s[i]
        ascii_ch = AsciiFromChar(ch)
        found = 0
        
        j = 0
        while (j < accept_len)
        {
            ascii_accept = AsciiFromChar(accept_ascii[j])
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
        ascii_val = AsciiFromChar(reject[k])
        reject_ascii = cat(reject_ascii, CharFromAscii(ascii_val))
        k = k + 1
    }
    
    count = 0
    i = 0
    
    while (i < s_len)
    {
        ch = s[i]
        ascii_ch = AsciiFromChar(ch)
        found = 0
        
        j = 0
        while (j < reject_len)
        {
            ascii_reject = AsciiFromChar(reject_ascii[j])
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
    
    ascii = AsciiFromChar(ch)
    
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
    
    ascii = AsciiFromChar(ch)
    
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
    len = strlen(s)
    
    if (len == 0)
    {
        return s
    }
    
    // 找到第一个非空白字符
    start = 0
    while (start < len)
    {
        ch = s[start]
        if (!isspace(ch))
        {
            break
        }
        start = start + 1
    }
    
    // 如果整个字符串都是空白
    if (start >= len)
    {
        return ""
    }
    
    // 找到最后一个非空白字符
    end = len - 1
    while (end >= 0)
    {
        ch = s[end]
        if (!isspace(ch))
        {
            break
        }
        end = end - 1
    }
    
    // 提取子串
    return strmid(s, start, end + 1)
}

////////////////////////////////////////////////////////////////////////////
// 特殊字符处理函数（修正版）
/////////////////////////////////////////////////////////////////////////////

// contains_special_chars - 检查字符串是否包含控制字符
// 返回: TRUE(1)或FALSE(0)
function contains_special_chars(s)
{
    len = strlen(s)
    i = 0
    while (i < len)
    {
        ch = s[i]
        ascii = AsciiFromChar(ch)
        
        // 检查是否是控制字符（ASCII < 32）或删除字符（127）
        if (ascii < 32 || ascii == 127)
        {
            return 1
        }
        i = i + 1
    }
    return 0
}

// is_printable_char - 检查字符是否可打印
// 返回: TRUE(1)或FALSE(0)
function is_printable_char(ch)
{
    if (strlen(ch) == 0)
    {
        return 0
    }
    
    ascii = AsciiFromChar(ch)
    
    // 可打印字符范围：空格(32)到波浪号(126)
    // 可打印字符范围：如果大于127,也视为可打印字符,有可能有utf8中文
    if (ascii >= 32)
    {
       return 1
    }

    return 0
}

// is_visible_char - 检查字符是否可见
// 返回: TRUE(1)或FALSE(0)
function is_visible_char(ch)
{
    if (strlen(ch) == 0)
    {
        return 0
    }
    ascii = AsciiFromChar(ch)
    
    if (ascii < 33) //空格也作为不可见字符
    {
        return 0
    }
    
    // delete字符不可见
    if (ascii == 127)
    {
        return 0
    }
    
    return 1

}


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
        ascii = AsciiFromChar(ch)
        
        // 检查是否是反斜杠
        if (ascii == 92 && i + 1 < len)  // 反斜杠
        {
            next_ch = s[i + 1]
            next_ascii = AsciiFromChar(next_ch)
            
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
                ascii1 = AsciiFromChar(hex1)
                ascii2 = AsciiFromChar(hex2)
                
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
        ascii = AsciiFromChar(ch)
        
        if (ascii == 10)  // 换行符
        {
            line_count = line_count + 1
        }
        i = i + 1
    }
    
    return line_count
}

// find_first_visible_char - 查找第一可见字符的索引（正向）
// 返回: 索引位置，未找到返回-1
function find_first_visible_char(s)
{
    len = strlen(s)
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        if (is_visible_char(ch))
        {
            return i
        }
        i = i + 1
    }
    
    return -1
}

// find_last_visible_char - 查找最后一个可见字符的索引（反向）
// 返回: 索引位置，未找到返回-1
function find_last_visible_char(s)
{
    len = strlen(s)
    i = len - 1
    
    while (i >= 0)
    {
        ch = s[i]
        if (is_visible_char(ch))
        {
            return i
        }
        i = i - 1
    }
    
    return -1
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
        ascii1 = AsciiFromChar(ch1)
        ascii2 = AsciiFromChar(ch2)
        
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
                ascii1 = AsciiFromChar(ch1)
                ascii2 = AsciiFromChar(ch2)
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
        ascii1 = AsciiFromChar(ch1)
        ascii2 = AsciiFromChar(ch2)
        
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
                ascii1 = AsciiFromChar(ch1)
                ascii2 = AsciiFromChar(ch2)
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
            ascii = AsciiFromChar(ch)
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
            ascii = AsciiFromChar(ch)
            
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
            ascii = AsciiFromChar(ch)
            
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
            ascii = AsciiFromChar(ch)
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
            ascii = AsciiFromChar(ch)
            
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
        ascii1 = AsciiFromChar(ch1)
        ascii2 = AsciiFromChar(ch2)
        
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
                ascii1 = AsciiFromChar(ch1)
                ascii2 = AsciiFromChar(ch2)
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


//以下为测试部分

/////////////////////////////////////////////////////////////////////////////
// 工具函数：创建包含换行符的测试字符串
/////////////////////////////////////////////////////////////////////////////

// create_multilines_test_string - 创建包含换行符的测试字符串
// 使用CharFromAscii(10)创建换行符，避免转义问题
function create_multilines_test_string()
{
    //使用实际的换行符（ASCII 10）而不是"\n"
    newline = CharFromAscii(10)
    
    str = "/* Line 1"
    str = cat(str, newline)
    str = cat(str, "Line 2")
    str = cat(str, newline)
    str = cat(str, "    Line 3")
    str = cat(str, newline)
    str = cat(str, "    //Line 4 */")
    str = cat(str, newline)
    str = cat(str, "    //Line 5")

    return str

//    currentbuf=GetCurrentBuf ()
//    currentselection=GetBufSelText (currentbuf)
//    return currentselection
    //测试文本,测试前请用鼠标选择这几行,选中后将作为测试字符串
    /* Line 1
    Line 2
    Line 3
    //Line 4 */
    //Line 5

}

// create_complex_test_string - 创建复杂测试字符串
function create_complex_test_string()
{
    newline = CharFromAscii(10)
    carriage_return = CharFromAscii(13)
    tab = CharFromAscii(9)
    
    str = "    // /* hello \\r\\n  world "
    str = cat(str, carriage_return)
    str = cat(str, newline)
    str = cat(str, " */ \\r\\n  ")
    str = cat(str, newline)
    
    return str

//    currentbuf=GetCurrentBuf ()
//    currentselection=GetBufSelText (currentbuf)
//    return currentselection
    //测试文本,测试前请用鼠标选择这几行,选中后将作为测试行
    // /* hello \\r\\n  world
     /* \\r\\n  
     */
    
}


// test_complex_string - 测试复杂字符串
macro test_complex_string()
{

    //测试文本,测试前请用鼠标选择这几行,选中后将作为测试行
    // /* hello \\r\\n  world
     /* \\r\\n  
     */

    msg "=== 测试复杂字符串 ==="

    
//测试文本,测试前请用鼠标选择这几行,选中后将作为测试行
//1 /* hello \\r\\n  world
/*2 \\r\\n  
  3*/
    complex_str = create_complex_test_string()
    msg "选择文本为:@complex_str@" 
    msg "复杂字符串长度: " # strlen(complex_str)
    msg "复杂字符串行数: " # get_line_count(complex_str) # " (期望: 3)"

    // 显示字符串内容
    msg "字符串内容分析:"
    i = 0
    while (i < strlen(complex_str))
    {
        ch = complex_str[i]
        ascii = AsciiFromChar(ch)
        
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
            msg "位置 " # i # ": 换行符(\\n)"
        }
        else if (ascii == 13)
        {
            msg "位置 " # i # ": 回车符(\\r)"
        }
        else if (ascii >= 33 && ascii <= 126)
        {
            msg "位置 " # i # ": '" # ch # "' (ASCII " # ascii # ")"
        }
        else
        {
            msg "位置 " # i # ": 控制字符(ASCII " # ascii # ")"
        }
        
        i = i + 1
    }
    
    msg "=== 复杂字符串测试结束 ==="
}

// test_multiline_string - 测试新增函数（使用实际换行符）
macro test_multiline_string()
{
   

    msg "=== 测试新增函数（使用实际换行符） ==="
    
//    currentbuf=GetCurrentBuf()
//    currentselection=GetBufSelText (currentbuf)//获取当前选中行的文字(只有1行)
    
//    hbuf=newbuf("ets")
//    hwnd=NewWnd (hbuf)
//    SetBufSelText(hbuf,GetBufSelText (currentbuf))
    
//测试文本,测试前请用鼠标选择这几行,选中后将作为测试字符串
/*1 Line 1
  2Line 2
  3Line 3
//4Line 4 */
//5Line 5

    // 创建测试字符串（使用实际换行符）
    test_str = create_multilines_test_string()
    msg "选择文本为:@test_str@" 
    msg "测试字符串创建成功，长度: " # strlen(currentselection)
    
    // 1. 测试get_line_count
    msg "--- 测试get_line_count ---"
    lines = get_line_count(test_str)
    msg "行数: " # lines # " (期望: 5)"
    
    // 显示字符串的ASCII值以验证
    msg "验证字符串中的换行符:"
    i = 0
    newline_count = 0
    while (i < strlen(test_str) && i < 50)  // 限制显示数量
    {
        ascii = AsciiFromChar(test_str[i])
        if (ascii == 10)
        {
            newline_count = newline_count + 1
        }
        i = i + 1
    }
    msg "总共找到 " # newline_count # " 个换行符"
    
    // 2. 测试get_line_content
    msg "--- 测试get_line_content ---"
    line3 = get_line_content(test_str, 3)
    line3_len = strlen(line3)
    msg "第3行内容: \"" # line3 # "\""
    msg "第3行长度: " # line3_len
    
    // 3. 测试find_strln_frombegin
    msg "--- 测试find_strln_frombegin ---"
    first_line = find_strln_frombegin(test_str, "Line 3")
    msg "第一个包含'Line 3'的行: " # first_line # " (期望: 3)"
    
    // 4. 测试find_strln_fromend
    msg "--- 测试find_strln_fromend ---"
    last_line = find_strln_fromend(test_str, "Line")
    msg "最后一个包含'Line'的行: " # last_line # " (期望: 5)"
    
    // 5. 测试str_insert_line
    msg "--- 测试str_insert_line ---"
    // 创建要插入的字符串（也使用实际换行符）
    newline = CharFromAscii(10)
    str_inserting = "Inserted line"
    inserted = str_insert_line(test_str, 3, str_inserting)
    inserted_lines = get_line_count(inserted)
    msg "在第3行插入后的行数: " # inserted_lines # " (期望: 6)"
    
    // 显示插入后的内容
    if (inserted_lines > 0)
    {
        msg "插入后的第3行: \"" # get_line_content(inserted, 3) # "\""
    }
    
    // 6. 测试str_delete_line（使用简化版本）
    msg "--- 测试str_delete_line ---"
    deleted = str_delete_line(test_str, 2)
    deleted_lines = get_line_count(deleted)
    msg "删除第2行后的行数: " # deleted_lines # " (期望: 4)"
    
    // 显示删除后的内容
    if (deleted_lines > 0)
    {
        msg "删除后第1行: \"" # get_line_content(deleted, 1) # "\""
        msg "删除后第2行: \"" # get_line_content(deleted, 2) # "\""
        msg "删除后第3行: \"" # get_line_content(deleted, 3) # "\""
    }
    

    // 8. 测试replace_once_from_begin
    msg "--- 测试replace_once_from_begin ---"
    replaced = replace_once_from_begin("abc def abc ghi", "abc", "XYZ")
    msg "替换第一个'abc': \"" # replaced # "\" (期望: \"XYZ def abc ghi\")"
    
    // 9. 测试replace_all
    msg "--- 测试replace_all ---"
    all_replaced = replace_all("abc def abc ghi", "abc", "XYZ")
    msg "替换所有'abc': \"" # all_replaced # "\" (期望: \"XYZ def XYZ ghi\")"
    
    // 10. 测试位置操作
    msg "--- 测试位置操作 ---"
    pos_inserted = str_insert("Hello World", 5, " Beautiful")
    msg "在位置5插入: \"" # pos_inserted # "\" (期望: \"Hello Beautiful World\")"
    
    msg "=== 新增函数测试结束 ==="
    test_str_delete_line_edge_cases()
}

// test_str_delete_line_edge_cases - 专门测试删除行的边界情况
function test_str_delete_line_edge_cases()
{
    msg "=== 测试删除行边界情况 ==="
    newline = CharFromAscii(10)
    
    // 测试1: 只有一行的字符串
    msg "--- 测试1: 只有一行 ---"
    single_line = "Only one line"
    deleted1 = str_delete_line(single_line, 1)
    msg "原始: \"" # single_line # "\""
    msg "删除后: \"" # deleted1 # "\" (期望: 空字符串)"
    msg "删除后长度: " # strlen(deleted1)
    
    // 测试2: 删除第一行
    msg "--- 测试2: 删除第一行 ---"
    two_lines = "First line"
    two_lines = cat(two_lines, newline)
    two_lines = cat(two_lines, "Second line")
    
    deleted_first = str_delete_line(two_lines, 1)
    msg "原始: \"" # two_lines # "\""
    msg "删除第一行后: \"" # deleted_first # "\""
    msg "删除后行数: " # get_line_count(deleted_first) # " (期望: 1)"
    
    // 测试3: 删除最后一行
    msg "--- 测试3: 删除最后一行 ---"
    deleted_last = str_delete_line(two_lines, 2)
    msg "删除最后一行后: \"" # deleted_last # "\""
    msg "删除后行数: " # get_line_count(deleted_last) # " (期望: 1)"
    
    // 测试4: 删除中间行
    msg "--- 测试4: 删除中间行 ---"
    three_lines = "Line 1"
    three_lines = cat(three_lines, newline)
    three_lines = cat(three_lines, "Line 2")
    three_lines = cat(three_lines, newline)
    three_lines = cat(three_lines, "Line 3")
    
    deleted_middle = str_delete_line(three_lines, 2)
    msg "原始: \"" # three_lines # "\""
    msg "删除中间行后: \"" # deleted_middle # "\""
    msg "删除后行数: " # get_line_count(deleted_middle) # " (期望: 2)"
    
    // 测试5: 以换行符结尾的字符串
    msg "--- 测试5: 以换行符结尾 ---"
    with_trailing_nl = "Line 1"
    with_trailing_nl = cat(with_trailing_nl, newline)
    with_trailing_nl = cat(with_trailing_nl, "Line 2")
    with_trailing_nl = cat(with_trailing_nl, newline)
    
    deleted_trailing = str_delete_line(with_trailing_nl, 3)
    msg "原始: \"" # with_trailing_nl # "\""
    msg "删除最后一行后: \"" # deleted_trailing # "\""
    msg "删除后长度: " # strlen(deleted_trailing)
    msg "删除后最后字符ASCII: " # AsciiFromChar(deleted_trailing[strlen(deleted_trailing)-1])
    
    msg "=== 删除行边界测试结束 ==="
}


