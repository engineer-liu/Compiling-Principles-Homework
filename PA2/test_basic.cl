(* 基础功能测试用例 *)
class Main inherits IO {
    x : Int <- 42;
    flag : Bool <- true;
    name : String <- "COOL";
    
    main() : SELF_TYPE {
        {
            out_string("Hello, COOL!\\n");
            if flag then
                out_string("Flag is true\\n")
            else
                out_string("Flag is false\\n")
            fi;
            
            while x < 100 loop
                x <- x + 1
            pool;
        }
    };
};
