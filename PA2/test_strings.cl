(* 字符串和转义字符测试 *)
class StringTest {
    normal_string : String <- "Hello World";
    escape_string : String <- "Line1\\nLine2\\tTab\\\"Quote\\\\Backslash";
    empty_string : String <- "";
    
    -- 测试字符串操作
    test_string_ops() : String {
        "Concatenated" + " " + "String"
    };
};
