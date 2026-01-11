/*
 *  The scanner definition for COOL.
 */

/*
 *  Stuff enclosed in %{ %} in the first section is copied verbatim to the
 *  output, so headers and global definitions are placed here to be visible
 * to the code in the file.  Don't remove anything that was here initially
 */
%{
#include <cool-parse.h>
#include <stringtab.h>
#include <utilities.h>
#include <string.h>

/* The compiler assumes these identifiers. */
#define yylval cool_yylval
#define yylex  cool_yylex

/* Max size of string constants */
#define MAX_STR_CONST 1025
#define YY_NO_UNPUT   /* keep g++ happy */

extern FILE *fin; /* we read from this file */

/* define YY_INPUT so we read from the FILE fin:
 * This change makes it possible to use this scanner in
 * the Cool compiler.
 */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
	if ( (result = fread( (char*)buf, sizeof(char), max_size, fin)) < 0) \
		YY_FATAL_ERROR( "read() in flex scanner failed");

char string_buf[MAX_STR_CONST]; /* to assemble string constants */
char *string_buf_ptr;

extern int curr_lineno;
extern int verbose_flag;

extern YYSTYPE cool_yylval;

/*
 *  Add Your own definitions here
 */
int comment_level = 0;  // 用于处理嵌套注释
%}

/*
 * Define names for regular expressions here.
 */
 
 /* Flex选项 */

%option noyywrap         
%option yylineno  

/* 状态声明 */
%x STRING
%x COMMENT
%x LINECOMMENT

/* 操作符 */
DARROW          =>
ASSIGN          <-
LE              <=

/* 字符类别 */
DIGIT           [0-9]
LETTER          [a-zA-Z]
UPPER           [A-Z]
LOWER           [a-z]
ALNUM		[a-zA-Z0-9]
WHITESPACE      [ \t\f\r\v]
NEWLINE         \n





%%

 /*
  *  Nested comments
  */


 /*
  *  The multiple-character operators.
  */
  



 /*
  * Keywords are case-insensitive except for the values true and false,
  * which must begin with a lower-case letter.
  */

[cC][lL][aA][sS][sS]          { return (CLASS); }
[iI][nN][hH][eE][rR][iI][tT][sS]  { return (INHERITS); }
[iI][fF]                      { return (IF); }
[tT][hH][eE][nN]              { return (THEN); }
[eE][lL][sS][eE]              { return (ELSE); }
[fF][iI]                      { return (FI); }
[wW][hH][iI][lL][eE]          { return (WHILE); }
[lL][oO][oO][pP]              { return (LOOP); }
[pP][oO][oO][lL]              { return (POOL); }
[lL][eE][tT]                  { return (LET); }
[iI][nN]                      { return (IN); }
[cC][aA][sS][eE]              { return (CASE); }
[oO][fF]                      { return (OF); }
[eE][sS][aA][cC]              { return (ESAC); }
[nN][eE][wW]                  { return (NEW); }
[iI][sS][vV][oO][iI][dD]      { return (ISVOID); }
[nN][oO][tT]                  { return (NOT); }


 /*
  *布尔常量（必须小写开头)
  */
t[rR][uU][eE]                 { 
    cool_yylval.boolean = 1; 
    return (BOOL_CONST); 
}
f[aA][lL][sS][eE]             { 
    cool_yylval.boolean = 0; 
    return (BOOL_CONST); 
}
  
  
 /*
  *标识符
  */
{UPPER}({LETTER}|{DIGIT}|_)*  {
    cool_yylval.symbol = stringtable.add_string(yytext);
    return (TYPEID);
}

{LOWER}({LETTER}|{DIGIT}|_)*  {
    cool_yylval.symbol = stringtable.add_string(yytext);
    return (OBJECTID);
}
  
  
 /*
  *整数常量
  */
{DIGIT}+                      {
    cool_yylval.symbol = stringtable.add_string(yytext);
    return (INT_CONST);
}


 /*
  *操作符
  */
{DARROW}		{ return (DARROW); }
{ASSIGN}                      { return ASSIGN; }
{LE}                          { return LE; }
"+"                           { return '+'; }
"-"                           { return '-'; }
"*"                           { return '*'; }
"/"                           { return '/'; }
"~"                           { return '~'; }
"<"                           { return '<'; }
">"                           { return '>'; }
"="                           { return '='; }
"("                           { return '('; }
")"                           { return ')'; }
"{"                           { return '{'; }
"}"                           { return '}'; }
":"                           { return ':'; }
";"                           { return ';'; }
","                           { return ','; }
"."                           { return '.'; }
"@"                           { return '@'; } 


 /*
  *字符串处理
  */
\"    { 
    BEGIN(STRING); 
    string_buf_ptr = string_buf; 
}

<STRING>\"      	{
        		BEGIN(INITIAL);
        		*string_buf_ptr = '\0';
        
        		if (string_buf_ptr - string_buf >= MAX_STR_CONST-1) 				{
            			cool_yylval.error_msg = "String constant too long";
            			return ERROR;
        		}
        
        		cool_yylval.symbol = stringtable.add_string(string_buf);
        		return STR_CONST; 
    		}
    
<STRING>\n	{ 
        		curr_lineno++;
        		BEGIN(INITIAL); 
        		cool_yylval.error_msg = "Unterminated string constant";
        		return ERROR; 
   	 	}
    
<STRING><<EOF>>	{ 
        		BEGIN(INITIAL); 
        		cool_yylval.error_msg = "EOF in string constant";
        		return ERROR; 
    		}
    
<STRING>\\n { *string_buf_ptr++ = '\n'; }
<STRING>\\t { *string_buf_ptr++ = '\t'; }
<STRING>\\b { *string_buf_ptr++ = '\b'; }
<STRING>\\f { *string_buf_ptr++ = '\f'; }
<STRING>\\. { *string_buf_ptr++ = yytext[1]; }
<STRING>. {
 		if (yytext[0] == '\0') {
 			cool_yylval.error_msg = "String contains null character.";
 			BEGIN(INITIAL);
 			return ERROR;
 		}
 		if (string_buf_ptr - string_buf >= MAX_STR_CONST - 1) {
 			cool_yylval.error_msg = "String constant too long";
 			BEGIN(INITIAL);
 			return ERROR;
 		}
 		*string_buf_ptr++ = yytext[0];
 	  }  


 /*
  *注释处理 
  */
%{
static int comment_level;
%}


"--".*                        { /*单行注释 */ }

"(*"    { 
    BEGIN(COMMENT); 
    comment_level = 1; 
}
<COMMENT>"(*"		{ comment_level++; }
<COMMENT>"*)"		{ 
        			comment_level--; 
        			if (comment_level == 0) BEGIN(INITIAL); 
    	        	}
<COMMENT>\n 		{ curr_lineno++; }
<COMMENT><<EOF>> 	{ 
        			cool_yylval.error_msg = "EOF in comment"; 
        			BEGIN(INITIAL); 
        			return ERROR; 
    			}		
<COMMENT>.                         { /* 忽略注释内容 */ }

"*)" { 
 	cool_yylval.error_msg = "Unmatched *)";
 	return ERROR;
 	}
 	
 	
 /*
  *空白字符,行号
  */	
\n                  { curr_lineno++; }  // 换行符
[ \f\r\t\v]+ { /* 忽略空白字符 */ }



 /*
  *错误处理
  */	
.                   { 
    cool_yylval.error_msg = yytext;  // 存储未匹配字符
    return ERROR;                    // 返回错误Token
}
  
	
 /*
  *  String constants (C syntax)
  *  Escape sequence \c is accepted for all characters c. Except for 
  *  \n \t \b \f, the result is c.
  *
  */


%%
