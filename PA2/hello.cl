(* 
   简单的Hello World程序
   用于集成测试
*)
class Main inherits IO {
    main() : SELF_TYPE {
        {
            out_string("Hello, COOL!\\n");
            out_string("This program demonstrates ");
            out_string("that the lexer works correctly.\\n");
        }
    };
};
