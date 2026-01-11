(* 错误处理测试用例 *)
class ErrorTest {
    -- 这个文件包含一些错误，用于测试词法分析器的错误检测能力
    
    -- 未闭合的字符串（用于测试）
    bad_string : String <- "This string is not closed
    
    -- 非法字符测试
    illegal_char : Int <- @42;  -- @是非法字符
    
    -- 未匹配的注释结束符
    test_method() : Int {
        42
    };
*)  -- 这个*)没有匹配的(*
};
