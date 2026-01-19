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
macro strcmp(s1, s2)
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
macro strncmp(s1, s2, n)
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
macro stricmp(s1, s2)
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
macro strchr(s, ch)
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
macro strrchr(s, ch)
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
macro strstr(haystack, needle)
{
    haystack_len = strlen(haystack)
    needle_len = strlen(needle)
    
    // 如果needle为空字符串，返回0
    if (needle_len == 0)
    {
        return 0
    }
    
    // 如果needle比haystack长，不可能找到
    if (needle_len > haystack_len)
    {
        return -1
    }
    
    i = 0
    max_i = haystack_len - needle_len
    
    while (i <= max_i)
    {
        match = 1  // 假设匹配
        
        j = 0
        while (j < needle_len)
        {
            // 比较字符的ASCII值
            ch1 = haystack[i + j]
            ch2 = needle[j]
            ascii1 = AsciiFromChar(ch1)
            ascii2 = AsciiFromChar(ch2)
            
            if (ascii1 != ascii2)
            {
                match = 0  // 不匹配
                break
            }
            j = j + 1
        }
        
        if (match)
        {
            return i
        }
        
        i = i + 1
    }
    
    return -1
}

// strpbrk - 查找字符串中第一个匹配指定字符集中任意字符的位置
// 返回: 字符位置的索引，未找到返回-1
macro strpbrk(s, accept)
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
macro strcpy(dest, src)
{
    return src  // 直接返回源字符串
}

// strncpy - 字符串拷贝n个字符（模拟，返回新字符串）
macro strncpy(dest, src, n)
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
macro strcat(dest, src)
{
    return cat(dest, src)  // 使用基础宏的cat函数
}

// strncat - 字符串连接n个字符（模拟，返回新字符串）
macro strncat(dest, src, n)
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
macro strspn(s, accept)
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
macro strcspn(s, reject)
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
macro strtok_simple(s, delim)
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
macro isalpha(ch)
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
macro isdigit(ch)
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
macro isalnum(ch)
{
    if (isalpha(ch))
    {
        return 1
    }
    return isdigit(ch)
}

// isspace - 检查字符是否为空白字符
// 返回: TRUE(1)或FALSE(0)
macro isspace(ch)
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
macro strrev(s)
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
macro strtrim(s)
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
macro contains_special_chars(s)
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
macro is_printable_char(ch)
{
    if (strlen(ch) == 0)
    {
        return 0
    }
    
    ascii = AsciiFromChar(ch)
    
    // 可打印字符范围：空格(32)到波浪号(126)
    if (ascii >= 32)
    {
        if (ascii <= 126)
        {
            return 1
        }
    }
    return 0
}


// unescape_string - 将转义序列转换回控制字符（简化版）
// 注意：这个函数不能处理所有转义序列，是简化实现
macro unescape_string(s)
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

// string.em - C语言字符串函数实现
// 基于Source Insight宏语言实现

/////////////////////////////////////////////////////////////////////////////
// 字符串比较函数（保持不变）
/////////////////////////////////////////////////////////////////////////////

// ...（之前的代码保持不变）...

/////////////////////////////////////////////////////////////////////////////
// 新增函数：行操作和扩展功能（修复版）
/////////////////////////////////////////////////////////////////////////////

// get_line_count - 获取字符串中的行数，以\n为行结束标志
// 末尾行不以\n结尾也算一行
// 返回: 行数
macro get_line_count(s)
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

// find_first_non_printable - 查找第一个非打印字符的索引（正向）
// 返回: 索引位置，未找到返回-1
macro find_first_non_printable(s)
{
    len = strlen(s)
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        if (!is_printable_char(ch))
        {
            return i
        }
        i = i + 1
    }
    
    return -1
}

// find_last_non_printable - 查找最后一个非打印字符的索引（反向）
// 返回: 索引位置，未找到返回-1
macro find_last_non_printable(s)
{
    len = strlen(s)
    i = len - 1
    
    while (i >= 0)
    {
        ch = s[i]
        if (!is_printable_char(ch))
        {
            return i
        }
        i = i - 1
    }
    
    return -1
}

// find_first_line_with_string - 查找包含指定字符串的行号（正向）
// 返回: 行号（从1开始），未找到返回0
macro find_first_line_with_string(s, search)
{
    len = strlen(s)
    if (len == 0 || strlen(search) == 0)
    {
        return 0
    }
    
    line_num = 1
    line_start = 0
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        ascii = AsciiFromChar(ch)
        
        // 检查当前位置是否能匹配search
        if (i + strlen(search) <= len)
        {
            match = 1
            j = 0
            while (j < strlen(search))
            {
                if (AsciiFromChar(s[i + j]) != AsciiFromChar(search[j]))
                {
                    match = 0
                    break
                }
                j = j + 1
            }
            
            if (match == 1)
            {
                // 找到匹配，确定行号
                // 从当前位置向前找最近的换行符
                k = i
                found_line_start = 0
                while (k >= line_start)
                {
                    if (k == line_start)
                    {
                        found_line_start = 1
                        break
                    }
                    
                    prev_ch = s[k-1]
                    prev_ascii = AsciiFromChar(prev_ch)
                    if (prev_ascii == 10)  // 换行符
                    {
                        found_line_start = 1
                        break
                    }
                    k = k - 1
                }
                
                if (found_line_start == 1)
                {
                    return line_num
                }
            }
        }
        
        if (ascii == 10)  // 换行符
        {
            line_num = line_num + 1
            line_start = i + 1
        }
        
        i = i + 1
    }
    
    return 0
}

// find_last_line_with_string_simple - 查找包含指定字符串的行号（反向，简化版）
// 返回: 行号（从1开始），未找到返回0
macro find_last_line_with_string_simple(s, search)
{
    len = strlen(s)
    search_len = strlen(search)
    
    if (len == 0 || search_len == 0)
    {
        return 0
    }
    
    // 简单的实现：逐行检查
    total_lines = get_line_count(s)
    line_num = total_lines
    
    while (line_num >= 1)
    {
        line_content = get_line_content(s, line_num)
        
        // 检查这一行是否包含search
        if (strstr(line_content, search) != -1)
        {
            return line_num
        }
        
        line_num = line_num - 1
    }
    
    return 0
}

// get_line_content - 获取指定行内容
// 返回: 整行字符，从上一行换行符(不含)开始到本行换行符(包含)或结束
macro get_line_content(s, line_num)
{
    len = strlen(s)
    if (len == 0 || line_num < 1)
    {
        return ""
    }
    
    current_line = 1
    line_start = 0
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        ascii = AsciiFromChar(ch)
        
        if (ascii == 10)  // 换行符
        {
            if (current_line == line_num)
            {
                // 返回包括换行符的整行
                return strmid(s, line_start, i + 1)
            }
            current_line = current_line + 1
            line_start = i + 1
        }
        
        i = i + 1
    }
    
    // 处理最后一行（不以换行符结尾）
    if (current_line == line_num)
    {
        return strmid(s, line_start, len)
    }
    
    return ""  // 行号超出范围
}

// insert_at_line - 在指定行插入字符串
// 返回: 插入后的新字符串
macro insert_at_line(s, line_num, insert_str)
{
    total_lines = get_line_count(s)
    
    if (line_num < 1)
    {
        return s  // 无效行号，返回原字符串
    }
    
    if (line_num > total_lines + 1)
    {
        line_num = total_lines + 1  // 如果行号太大，插入到最后
    }
    
    if (line_num == total_lines + 1)
    {
        // 插入到最后一行之后
        if (strlen(s) == 0)
        {
            return insert_str
        }
        
        // 检查最后一行是否有换行符
        last_ch = s[strlen(s) - 1]
        if (AsciiFromChar(last_ch) == 10)
        {
            return cat(s, insert_str)
        }
        else
        {
            // 添加换行符再插入
            newline = CharFromAscii(10)
            return cat(cat(s, newline), insert_str)
        }
    }
    
    // 找到目标行的开始位置
    len = strlen(s)
    current_line = 1
    line_start = 0
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        ascii = AsciiFromChar(ch)
        
        if (ascii == 10)  // 换行符
        {
            if (current_line == line_num)
            {
                // 在行首插入
                before = strmid(s, 0, line_start)
                after = strmid(s, line_start, len)
                return cat(cat(before, insert_str), after)
            }
            current_line = current_line + 1
            line_start = i + 1
        }
        
        i = i + 1
    }
    
    // 处理最后一行
    if (current_line == line_num)
    {
        // 在最后一行行首插入
        before = strmid(s, 0, line_start)
        after = strmid(s, line_start, len)
        return cat(cat(before, insert_str), after)
    }
    
    return s
}

// delete_line - 删除指定行
// 返回: 删除后的新字符串
macro delete_line(s, line_num)
{
    total_lines = get_line_count(s)
    
    if (line_num < 1 || line_num > total_lines)
    {
        return s  // 无效行号，返回原字符串
    }
    
    len = strlen(s)
    if (len == 0)
    {
        return s  // 空字符串
    }
    
    current_line = 1
    line_start = 0
    i = 0
    
    while (i < len)
    {
        ch = s[i]
        ascii = AsciiFromChar(ch)
        
        if (ascii == 10)  // 换行符
        {
            if (current_line == line_num)
            {
                // 删除这一行（从line_start到i，包括换行符）
                // 计算删除的结束位置
                delete_end = i
                
                // 如果是最后一行且后面没有换行符？
                if (i == len - 1)
                {
                    // 这是最后一行，且以换行符结尾
                    delete_end = i  // 包括换行符
                }
                
                // 构建结果
                if (line_start == 0)
                {
                    // 删除第一行
                    after = strmid(s, delete_end + 1, len)
                    return after
                }
                else
                {
                    // 删除中间行
                    before = strmid(s, 0, line_start)
                    after = strmid(s, delete_end + 1, len)
                    return cat(before, after)
                }
            }
            current_line = current_line + 1
            line_start = i + 1
        }
        
        i = i + 1
    }
    
    // 处理最后一行（不以换行符结尾）
    if (current_line == line_num)
    {
        // 删除最后一行
        if (line_start == 0)
        {
            return ""  // 删除唯一一行
        }
        else
        {
            // 返回除了最后一行之外的所有内容
            // 需要找到前一行的换行符
            prev_nl = line_start - 1
            found_nl = 0
            while (prev_nl >= 0)
            {
                if (AsciiFromChar(s[prev_nl]) == 10)
                {
                    found_nl = 1
                    break
                }
                prev_nl = prev_nl - 1
            }
            
            if (found_nl == 1)
            {
                return strmid(s, 0, prev_nl + 1)
            }
            else
            {
                return ""  // 只剩一行了
            }
        }
    }
    
    return s
}

// 为了完整，让我也提供一个更简单的删除行实现
// delete_line_simple - 删除指定行（简化版本）
// 返回: 删除后的新字符串
macro delete_line_simple(s, line_num)
{
    total_lines = get_line_count(s)
    
    if (line_num < 1 || line_num > total_lines)
    {
        return s  // 无效行号，返回原字符串
    }
    
    // 方法：构建新字符串，跳过要删除的行
    len = strlen(s)
    result = ""
    current_line = 1
    line_start = 0
    i = 0
    in_target_line = 0
    
    while (i < len)
    {
        ch = s[i]
        ascii = AsciiFromChar(ch)
        
        if (ascii == 10)  // 换行符
        {
            if (current_line == line_num)
            {
                // 这是要删除的行，跳过它
                in_target_line = 0
            }
            else
            {
                // 这不是要删除的行，添加到结果
                if (in_target_line == 0)
                {
                    // 添加这一行（从line_start到i+1）
                    line_content = strmid(s, line_start, i + 1)
                    result = cat(result, line_content)
                }
            }
            
            current_line = current_line + 1
            line_start = i + 1
            in_target_line = 0
        }
        
        i = i + 1
    }
    
    // 处理最后一行（如果不以换行符结尾）
    if (line_start < len && current_line == line_num)
    {
        // 最后一行是要删除的行，什么都不做
    }
    else if (line_start < len)
    {
        // 最后一行不是要删除的行，添加它
        last_line = strmid(s, line_start, len)
        result = cat(result, last_line)
    }
    
    return result
}


// replace_line - 替换指定行内容
// 新字符串可以是多行字符串，中间可以包含换行符
// 返回: 替换后的新字符串
macro replace_line(s, line_num, new_content)
{
    total_lines = get_line_count(s)
    
    if (line_num < 1 || line_num > total_lines)
    {
        return s  // 无效行号，返回原字符串
    }
    
    // 先删除原行，再插入新内容
    temp = delete_line(s, line_num)
    return insert_at_line(temp, line_num, new_content)
}

// strchr_reverse - 从后往前查找字符在字符串中第一次出现的位置
// 返回: 索引位置，未找到返回-1
macro strchr_reverse(s, ch)
{
    return strrchr(s, ch)  // strrchr就是从后往前找
}

// strrchr_reverse - 从后往前查找字符串在字符串中第一次出现的位置
// 实际上是查找子串最后一次出现的位置
// 返回: 索引位置，未找到返回-1
macro strrchr_reverse(s, substr)
{
    len = strlen(s)
    sublen = strlen(substr)
    
    if (sublen == 0)
    {
        return 0
    }
    
    if (sublen > len)
    {
        return -1
    }
    
    i = len - sublen
    while (i >= 0)
    {
        match = 1
        j = 0
        while (j < sublen)
        {
            if (AsciiFromChar(s[i + j]) != AsciiFromChar(substr[j]))
            {
                match = 0
                break
            }
            j = j + 1
        }
        
        if (match == 1)
        {
            return i
        }
        
        i = i - 1
    }
    
    return -1
}

// insert_at_position - 在字符串指定位置插入字符串（正向位置）
// 返回: 插入后的新字符串
macro insert_at_position(s, position, insert_str)
{
    len = strlen(s)
    
    if (position < 0)
    {
        position = 0
    }
    
    if (position > len)
    {
        position = len
    }
    
    if (position == 0)
    {
        return cat(insert_str, s)
    }
    
    if (position == len)
    {
        return cat(s, insert_str)
    }
    
    before = strmid(s, 0, position)
    after = strmid(s, position, len)
    
    return cat(cat(before, insert_str), after)
}

// insert_at_position_reverse - 在字符串指定位置插入字符串（反向位置）
// position从末尾开始计算，0表示末尾
// 返回: 插入后的新字符串
macro insert_at_position_reverse(s, position, insert_str)
{
    len = strlen(s)
    
    if (position < 0)
    {
        position = 0
    }
    
    if (position > len)
    {
        position = len
    }
    
    forward_position = len - position
    return insert_at_position(s, forward_position, insert_str)
}

// delete_at_position - 在字符串指定位置删除指定长度字符（正向位置）
// 返回: 删除后的新字符串
macro delete_at_position(s, position, length)
{
    len = strlen(s)
    
    if (position < 0)
    {
        position = 0
    }
    
    if (position >= len || length <= 0)
    {
        return s  // 无效参数
    }
    
    if (position + length > len)
    {
        length = len - position  // 调整长度
    }
    
    before = strmid(s, 0, position)
    after = strmid(s, position + length, len)
    
    return cat(before, after)
}

// delete_at_position_reverse - 在字符串指定位置删除指定长度字符（反向位置）
// position从末尾开始计算，0表示末尾
// 返回: 删除后的新字符串
macro delete_at_position_reverse(s, position, length)
{
    len = strlen(s)
    
    if (position < 0)
    {
        position = 0
    }
    
    if (position > len || length <= 0)
    {
        return s  // 无效参数
    }
    
    forward_position = len - position - length
    if (forward_position < 0)
    {
        forward_position = 0
        length = len - position  // 调整长度
    }
    
    return delete_at_position(s, forward_position, length)
}

// replace_at_position - 在字符串指定位置替换字符串（正向位置）
// 返回: 替换后的新字符串
macro replace_at_position(s, position, length, new_str)
{
    // 先删除，再插入
    temp = delete_at_position(s, position, length)
    return insert_at_position(temp, position, new_str)
}

// replace_at_position_reverse - 在字符串指定位置替换字符串（反向位置）
// position从末尾开始计算，0表示末尾
// 返回: 替换后的新字符串
macro replace_at_position_reverse(s, position, length, new_str)
{
    len = strlen(s)
    
    if (position < 0)
    {
        position = 0
    }
    
    if (position > len)
    {
        return s  // 无效位置
    }
    
    forward_position = len - position - length
    if (forward_position < 0)
    {
        forward_position = 0
        length = len - position  // 调整长度
    }
    
    return replace_at_position(s, forward_position, length, new_str)
}

// get_substring - 获取指定长度的字符串（正向）
// 返回: 从指定位置开始的指定长度子串
macro get_substring(s, position, length)
{
    len = strlen(s)
    
    if (position < 0)
    {
        position = 0
    }
    
    if (position >= len || length <= 0)
    {
        return ""
    }
    
    if (position + length > len)
    {
        length = len - position
    }
    
    return strmid(s, position, position + length)
}

// get_substring_reverse - 获取指定长度的字符串（反向）
// 从末尾开始获取指定长度的子串
// 返回: 子串
macro get_substring_reverse(s, length)
{
    len = strlen(s)
    
    if (length <= 0)
    {
        return ""
    }
    
    if (length > len)
    {
        length = len
    }
    
    start = len - length
    return strmid(s, start, len)
}

// replace_first - 单次替换，用A字符串替换原字符串中的首次匹配到的B字符串（正向）
// 返回: 替换后的新字符串
macro replace_first(s, old_str, new_str)
{
    pos = strstr(s, old_str)
    if (pos == -1)
    {
        return s  // 未找到，返回原字符串
    }
    
    return replace_at_position(s, pos, strlen(old_str), new_str)
}

// replace_first_reverse - 单次替换，用A字符串替换原字符串中的首次匹配到的B字符串（反向）
// 从末尾开始查找第一次匹配
// 返回: 替换后的新字符串
macro replace_first_reverse(s, old_str, new_str)
{
    pos = strrchr_reverse(s, old_str)
    if (pos == -1)
    {
        return s  // 未找到，返回原字符串
    }
    
    return replace_at_position(s, pos, strlen(old_str), new_str)
}

// replace_all - 全部替换，用A字符串替换原字符串中的所有匹配到的B字符串
// 返回: 替换后的新字符串
macro replace_all(s, old_str, new_str)
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
        
        result = replace_at_position(result, pos, old_len, new_str)
    }
    
    return result
}

/////////////////////////////////////////////////////////////////////////////
// 工具函数：创建包含换行符的测试字符串
/////////////////////////////////////////////////////////////////////////////

// create_test_string_with_newlines - 创建包含换行符的测试字符串
// 使用CharFromAscii(10)创建换行符，避免转义问题
macro create_test_string_with_newlines()
{
    // 使用实际的换行符（ASCII 10）而不是"\n"
    newline = CharFromAscii(10)
    
    str = "Line 1"
    str = cat(str, newline)
    str = cat(str, "Line 2")
    str = cat(str, newline)
    str = cat(str, "Line 3")
    str = cat(str, newline)
    str = cat(str, "Line 4")
    str = cat(str, newline)
    str = cat(str, "Line 5")
    
    return str
}

// create_complex_test_string - 创建复杂测试字符串
macro create_complex_test_string()
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
}

/////////////////////////////////////////////////////////////////////////////
// 测试函数（修复版，使用实际换行符）
/////////////////////////////////////////////////////////////////////////////

// test_complex_string - 测试复杂字符串
macro test_complex_string()
{
    msg "=== 测试复杂字符串 ==="
    
    complex_str = create_complex_test_string()
    msg "复杂字符串长度: " # strlen(complex_str)
    msg "复杂字符串行数: " # get_line_count(complex_str) # " (期望: 2)"
    
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


// 简单演示函数
macro demo_line_functions()
{
    msg "=== 演示行操作函数 ==="
    
    // 创建多行字符串
    newline = CharFromAscii(10)
    multi_line = "第一行"
    multi_line = cat(multi_line, newline)
    multi_line = cat(multi_line, "第二行")
    multi_line = cat(multi_line, newline)
    multi_line = cat(multi_line, "第三行")
    
    msg "原始字符串:"
    msg "长度: " # strlen(multi_line)
    msg "行数: " # get_line_count(multi_line) # " (期望: 3)"
    
    // 显示各行内容
    msg "各行内容:"
    i = 1
    while (i <= get_line_count(multi_line))
    {
        line = get_line_content(multi_line, i)
        msg "第 " # i # " 行: \"" # line # "\""
        i = i + 1
    }
    
    // 测试查找
    line_with_second = find_first_line_with_string(multi_line, "第二")
    msg "包含'第二'的行号: " # line_with_second # " (期望: 2)"
    
    // 测试插入
    inserted = insert_at_line(multi_line, 2, "插入的行" # newline)
    msg "插入后行数: " # get_line_count(inserted) # " (期望: 4)"
    
    msg "=== 演示结束 ==="
}

// 快速测试
macro quick_test_fixed()
{
    msg "快速测试（修复版）:"
    
    // 使用实际换行符
    newline = CharFromAscii(10)
    test_str = "第一行"
    test_str = cat(test_str, newline)
    test_str = cat(test_str, "第二行")
    test_str = cat(test_str, newline)
    test_str = cat(test_str, "第三行")
    
    msg "1. 测试字符串长度: " # strlen(test_str)
    msg "2. 行数: " # get_line_count(test_str) # " (期望: 3)"
    msg "3. 第2行内容: \"" # get_line_content(test_str, 2) # "\""
    msg "4. 包含'第二'的行: " # find_first_line_with_string(test_str, "第二") # " (期望: 2)"
}

// test_new_functions_fixed - 测试新增函数（使用实际换行符）
macro test_new_functions_fixed()
{
    msg "=== 测试新增函数（使用实际换行符） ==="
    
    // 创建测试字符串（使用实际换行符）
    test_str = create_test_string_with_newlines()
    msg "测试字符串创建成功，长度: " # strlen(test_str)
    
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
    
    // 3. 测试find_first_line_with_string
    msg "--- 测试find_first_line_with_string ---"
    first_line = find_first_line_with_string(test_str, "Line 3")
    msg "第一个包含'Line 3'的行: " # first_line # " (期望: 3)"
    
    // 4. 测试find_last_line_with_string_simple
    msg "--- 测试find_last_line_with_string_simple ---"
    last_line = find_last_line_with_string_simple(test_str, "Line")
    msg "最后一个包含'Line'的行: " # last_line # " (期望: 5)"
    
    // 5. 测试insert_at_line
    msg "--- 测试insert_at_line ---"
    // 创建要插入的字符串（也使用实际换行符）
    newline = CharFromAscii(10)
    insert_str = "Inserted line"
    insert_str = cat(insert_str, newline)
    
    inserted = insert_at_line(test_str, 3, insert_str)
    inserted_lines = get_line_count(inserted)
    msg "在第3行插入后的行数: " # inserted_lines # " (期望: 6)"
    
    // 显示插入后的内容
    if (inserted_lines > 0)
    {
        msg "插入后的第3行: \"" # get_line_content(inserted, 3) # "\""
    }
    
    // 6. 测试delete_line_simple（使用简化版本）
    msg "--- 测试delete_line_simple ---"
    deleted = delete_line_simple(test_str, 2)
    deleted_lines = get_line_count(deleted)
    msg "删除第2行后的行数: " # deleted_lines # " (期望: 4)"
    
    // 显示删除后的内容
    if (deleted_lines > 0)
    {
        msg "删除后第1行: \"" # get_line_content(deleted, 1) # "\""
        msg "删除后第2行: \"" # get_line_content(deleted, 2) # "\""
        msg "删除后第3行: \"" # get_line_content(deleted, 3) # "\""
    }
    
    // 7. 测试delete_line（原始版本）
    msg "--- 测试delete_line（原始版本） ---"
    deleted2 = delete_line(test_str, 2)
    deleted2_lines = get_line_count(deleted2)
    msg "原始版本删除第2行后的行数: " # deleted2_lines # " (期望: 4)"
    
    // 8. 测试replace_first
    msg "--- 测试replace_first ---"
    replaced = replace_first("abc def abc ghi", "abc", "XYZ")
    msg "替换第一个'abc': \"" # replaced # "\" (期望: \"XYZ def abc ghi\")"
    
    // 9. 测试replace_all
    msg "--- 测试replace_all ---"
    all_replaced = replace_all("abc def abc ghi", "abc", "XYZ")
    msg "替换所有'abc': \"" # all_replaced # "\" (期望: \"XYZ def XYZ ghi\")"
    
    // 10. 测试位置操作
    msg "--- 测试位置操作 ---"
    pos_inserted = insert_at_position("Hello World", 5, " Beautiful")
    msg "在位置5插入: \"" # pos_inserted # "\" (期望: \"Hello Beautiful World\")"
    
    msg "=== 新增函数测试结束 ==="
}

// test_delete_line_edge_cases - 专门测试删除行的边界情况
macro test_delete_line_edge_cases()
{
    msg "=== 测试删除行边界情况 ==="
    newline = CharFromAscii(10)
    
    // 测试1: 只有一行的字符串
    msg "--- 测试1: 只有一行 ---"
    single_line = "Only one line"
    deleted1 = delete_line_simple(single_line, 1)
    msg "原始: \"" # single_line # "\""
    msg "删除后: \"" # deleted1 # "\" (期望: 空字符串)"
    msg "删除后长度: " # strlen(deleted1)
    
    // 测试2: 删除第一行
    msg "--- 测试2: 删除第一行 ---"
    two_lines = "First line"
    two_lines = cat(two_lines, newline)
    two_lines = cat(two_lines, "Second line")
    
    deleted_first = delete_line_simple(two_lines, 1)
    msg "原始: \"" # two_lines # "\""
    msg "删除第一行后: \"" # deleted_first # "\""
    msg "删除后行数: " # get_line_count(deleted_first) # " (期望: 1)"
    
    // 测试3: 删除最后一行
    msg "--- 测试3: 删除最后一行 ---"
    deleted_last = delete_line_simple(two_lines, 2)
    msg "删除最后一行后: \"" # deleted_last # "\""
    msg "删除后行数: " # get_line_count(deleted_last) # " (期望: 1)"
    
    // 测试4: 删除中间行
    msg "--- 测试4: 删除中间行 ---"
    three_lines = "Line 1"
    three_lines = cat(three_lines, newline)
    three_lines = cat(three_lines, "Line 2")
    three_lines = cat(three_lines, newline)
    three_lines = cat(three_lines, "Line 3")
    
    deleted_middle = delete_line_simple(three_lines, 2)
    msg "原始: \"" # three_lines # "\""
    msg "删除中间行后: \"" # deleted_middle # "\""
    msg "删除后行数: " # get_line_count(deleted_middle) # " (期望: 2)"
    
    // 测试5: 以换行符结尾的字符串
    msg "--- 测试5: 以换行符结尾 ---"
    with_trailing_nl = "Line 1"
    with_trailing_nl = cat(with_trailing_nl, newline)
    with_trailing_nl = cat(with_trailing_nl, "Line 2")
    with_trailing_nl = cat(with_trailing_nl, newline)
    
    deleted_trailing = delete_line_simple(with_trailing_nl, 2)
    msg "原始: \"" # with_trailing_nl # "\""
    msg "删除最后一行后: \"" # deleted_trailing # "\""
    msg "删除后长度: " # strlen(deleted_trailing)
    msg "删除后最后字符ASCII: " # AsciiFromChar(deleted_trailing[strlen(deleted_trailing)-1])
    
    msg "=== 删除行边界测试结束 ==="
}

// 主测试函数（修复版）
macro main_test_fixed()
{
    msg "开始测试字符串函数库（修复版）..."
    msg "========================================"
    
    test_new_functions_fixed()
    msg "========================================"
    test_delete_line_edge_cases()
    msg "========================================"
    test_complex_string()
    
    msg "所有测试完成！"
}

// 简单演示函数
macro demo_line_functions()
{
    msg "=== 演示行操作函数 ==="
    
    // 创建多行字符串
    newline = CharFromAscii(10)
    multi_line = "第一行"
    multi_line = cat(multi_line, newline)
    multi_line = cat(multi_line, "第二行")
    multi_line = cat(multi_line, newline)
    multi_line = cat(multi_line, "第三行")
    
    msg "原始字符串:"
    msg "长度: " # strlen(multi_line)
    msg "行数: " # get_line_count(multi_line) # " (期望: 3)"
    
    // 显示各行内容
    msg "各行内容:"
    i = 1
    while (i <= get_line_count(multi_line))
    {
        line = get_line_content(multi_line, i)
        line_len = strlen(line)
        last_char = line[line_len - 1]
        last_ascii = AsciiFromChar(last_char)
        
        if (last_ascii == 10)
        {
            msg "第 " # i # " 行: \"" # strmid(line, 0, line_len - 1) # "\" (以换行符结尾)"
        }
        else
        {
            msg "第 " # i # " 行: \"" # line # "\" (不以换行符结尾)"
        }
        i = i + 1
    }
    
    // 测试查找
    line_with_second = find_first_line_with_string(multi_line, "第二")
    msg "包含'第二'的行号: " # line_with_second # " (期望: 2)"
    
    // 测试插入
    inserted = insert_at_line(multi_line, 2, "插入的行" # newline)
    msg "插入后行数: " # get_line_count(inserted) # " (期望: 4)"
    
    // 测试删除
    deleted = delete_line_simple(multi_line, 2)
    msg "删除第2行后行数: " # get_line_count(deleted) # " (期望: 2)"
    
    msg "=== 演示结束 ==="
}

