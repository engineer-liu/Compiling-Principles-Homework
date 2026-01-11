(* 外层注释开始
   多行注释测试
(* 嵌套注释测试 *)
   外层注释继续 *)
class CommentTest {
    -- 单行注释测试
    attribute : Int; -- 行尾注释
    
    (* 
       方法的多行注释
       第二行注释
    *)
    method() : Int {
        42  -- 返回答案
    };
};
