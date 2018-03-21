/* 
File with actions to add ids to symbol table.

*/
%{
import java.io.*;
%}

%token <ival> NUMBER
%token <sval> ADDOP SUBOP MULOP DIVOP LPAREN RPAREN NEWLINE ERROR 
%%
explist:   exp NEWLINE explist	
         | exp					
;
exp:       term addop exp
         | term
		 | error 				
;
addop:     ADDOP				
         | SUBOP                
; 
term:      factor mulop term
         | factor
;
mulop:     MULOP                
         | DIVOP               
; 
factor:    LPAREN exp RPAREN	
         | number				
; 
number:    NUMBER				
;
%%
   
/* reference to the lexer object */
private static Yylex lexer;

/* interface to the lexer */
private int yylex()
{
    String s = "";
    int retVal = -1;
    try
	{
		retVal = lexer.yylex();
        s += lexer.yytext();
        System.out.print(s);
    }
	catch (IOException e)
	{
		System.err.println("IO Error:" + e);
    }
    return retVal;
}
	
/* error reporting */
public void yyerror (String error)
{
    System.err.println("\nError : " + error + " at line " + 
		lexer.getLine() + " column " + 
		lexer.getCol() + ". Got: " + lexer.yytext());
}

/* constructor taking in File Input */
public Parser (Reader r)
{
	lexer = new Yylex(r, this);
}
