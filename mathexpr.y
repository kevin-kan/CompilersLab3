/* 
File with actions to add ids to symbol table.

*/
%{
import java.io.*;
import java.util.*; 
%}

%token <ival> NUMBER
%token <sval> ADDOP SUBOP MULOP DIVOP LPAREN RPAREN NEWLINE ERROR 
%%
explist:   exp NEWLINE explist	
         | exp					
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
number:    SUBOP NUMBER| NUMBER				
;
%%
   
/* reference to the lexer object */
private static Yylex lexer;
private ArrayList<Integer> Apple = new ArrayList<Integer>();
private int E_FLAG;
private String explist="Input: ";
/* interface to the lexer */
private int yylex()
{
    int retVal = -1;
    try
	{
		retVal = lexer.yylex();
    }
	catch (IOException e)
	{
		System.err.println("IO Error:" + e);
    }
  //if the previous char was newline and reject flag is false then accept and set rejet true
  
  if(Apple.size()>=1){
    if(Apple.get(Apple.size()-1)==264&&E_FLAG==0){ // ADD or for eof 
        System.out.print(explist);
        System.out.println("ACCEPT\n-------------------------\n");
        explist="Input: ";
    }
    if(Apple.get(Apple.size()-1)==264&&E_FLAG!=0){
            System.out.print(explist);
            System.out.println("REJECT\n-------------------------\n");
            E_FLAG=0;
            explist="Input: ";
    }
  }
    explist=explist+lexer.yytext();
    Apple.add(retVal);
    return retVal;

}

public String decode(){
    
    int val= Apple.get(Apple.size()-2);
    switch(val)
    {
        case 257:
            return "number";
        case 258:
            return "ADDOP";
        case 259:
            return "SUBOP";
        case 260:
            return "MULOP";
        case 261:
            return "DIVOP";
        case 262:
            return "LPAREN";
        case 263:
            return "RPAREN";
        case 264:
            return "NEWLINE";
        case 265:
            return "ERROR";
    }
    return "FAIL";
}
/* error reporting */
public void yyerror (String error)
{   if(Apple.size()>=2){//handle first line 1 char size 1 error
        //implement case handling for specfic errors
        System.err.println("Error : " + error + " at line " + 
            lexer.getLine() + " column " + 
            lexer.getCol() + ". Got: " + decode() +" followed by an "+yyname[yychar]);
    }
       E_FLAG=1;

    
}

/* constructor taking in File Input */
public Parser (Reader r)
{   
	lexer = new Yylex(r, this);
}
