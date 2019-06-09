%{
  int yylex(void);
  void yyerror(const char *,...);
  void printMain();
  char* addIndentation(char *dest, unsigned int i);
  char* constructForLoop(char* var, char* cond, char* acc, char* statement);
  char* extractJavadoc(char* source, char** javadoc);
  char* generateJavadoc(char* Type, char* Declarator, char* ArgumentList);
  int yyparse(void);
  extern int yylineno;
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
%union
{
  int ival;
  char *text;
}

%token KWD_auto KWD_break KWD_case KWD_char KWD_const KWD_continue KWD_default KWD_do KWD_double
%right KWD_else
%token KWD_enum KWD_extern KWD_float KWD_for KWD_goto KWD_if KWD_int KWD_long
%token KWD_register KWD_return KWD_short KWD_signed KWD_sizeof KWD_static KWD_struct KWD_switch
%token KWD_typedef KWD_union KWD_unsigned KWD_void KWD_volatile KWD_while

%token OP_SHR_ASSIGN OP_SHL_ASSIGN OP_ADD_ASSIGN OP_SUB_ASSIGN OP_MUL_ASSIGN OP_DIV_ASSIGN
%token OP_MOD_ASSIGN OP_AND_ASSIGN OP_XOR_ASSIGN OP_OR_ASSIGN OP_SHR OP_SHL OP_INC OP_DEC
%token OP_PTR OP_AND OP_OR OP_LE OP_GE OP_EQ OP_NE OP_ELIPSIS

%token CONST_INT CONST_LONG_INT CONST_UNSIGNED CONST_UNSIGNED_LONG_INT CONST_DOUBLE CONST_FLOAT CONST_LONG_DOUBLE CONST_STRING CONST_CHAR

%token IDENT TYPE_NAME
%%
Wrapper
  : {printf("public class DefaultClass\n{\n");} Input {printf("}\n");};
  

Input
  : ExternalDefinition
  | Input ExternalDefinition
  ;


PrimaryExpr
  : IDENT		
{$<text>$ = malloc(strlen($<text>1) + 2);
 strcpy($<text>$,$<text>1);
 free($<text>1);
}
  | Constant		
{$<text>$ = $<text>1;
}
  | '(' Expr ')'	
{$<text>$ = malloc(strlen($<text>1) + 3);	 
strcpy($<text>$, "(");	 
strcat($<text>$,$<text>1);	 
strcat($<text>$,")");  
free($<text>1);
}
  ;


PostfixExpr
  : PrimaryExpr			
{$<text>$ = $<text>1;
}
  | PostfixExpr '[' Expr ']'    
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3); 	
strcpy($<text>$,$<text>1);	
strcat($<text>$,"[");	
strcat($<text>$,$<text>3);	
strcat($<text>$,"]");  	
free($<text>1); free($<text>3);
}
  | PostfixExpr '(' ')'		
{$<text>$ = malloc(strlen($<text>1) + 3);	 	
strcpy($<text>$,"ref.");
strcat($<text>$,$<text>1);	
strcat($<text>$,"()");
free($<text>1); 
}
  | PostfixExpr '(' ArgumentExprList ')' 
{	 		  
if(strcmp($<text>1, "$puts") == 0){
	free($<text>1);
	$<text>1 = malloc(20);
	strcpy($<text>1, "System.out.println");
}
else{
	strcpy($<text>$,"ref.");
}
$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);
strcpy($<text>$,$<text>1);		  
strcat($<text>$,"("); 		  
strcat($<text>$,$<text>3);  
strcat($<text>$,")"); 	 		  
free($<text>1); free($<text>3);
}
  | PostfixExpr '.' IDENT 
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
strcpy($<text>$,$<text>1);
strcat($<text>$,".");
strcat($<text>$,$<text>3);
free($<text>1); free($<text>3);
}
  | PostfixExpr OP_PTR IDENT
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);
 strcpy($<text>$, $<text>1);
 strcat($<text>$, "->");
 strcat($<text>$, $<text>3);
 free($<text>1); free($<text>3);
}
  | PostfixExpr OP_INC
{$<text>$ = malloc(strlen($<text>1) + 3);
 strcpy($<text>$, $<text>1);
 strcat($<text>$, "++");
 free($<text>1); 
}
  | PostfixExpr OP_DEC
{$<text>$ = malloc(strlen($<text>1) + 3);
 strcpy($<text>$, $<text>1);
 strcat($<text>$, "--");
 free($<text>1); 
}
  ;


ArgumentExprList
  : AssignmentExpr
{$<text>$ = $<text>1;
}	
  | ArgumentExprList ',' AssignmentExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);
strcpy($<text>$,$<text>1);
strcat($<text>$,", ");
strcat($<text>$,$<text>3);
free($<text>1); free($<text>3);
}
  ;


UnaryExpr
  : PostfixExpr
{$<text>$ = $<text>1;
}
  | OP_INC UnaryExpr
{$<text>$ = malloc(strlen($<text>1) + 3);
 strcpy($<text>$, "++"); 
 strcat($<text>$, $<text>1);
 free($<text>1); 
}
  | OP_DEC UnaryExpr
{$<text>$ = malloc(strlen($<text>1) + 3);
 strcpy($<text>$, "--"); 
 strcat($<text>$, $<text>1);
 free($<text>1); 
}
  | UnaryOperator CastExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 2);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 free($<text>1);  free($<text>2); 
}
  | KWD_sizeof UnaryExpr
{$<text>$ = malloc(strlen($<text>2) + 7);
 strcpy($<text>$, "sizeof"); 
 strcat($<text>$, $<text>2);
 free($<text>2); 
}
  | KWD_sizeof '(' TypeName ')'
{$<text>$ = malloc(strlen($<text>2) + 9);
 strcpy($<text>$, "sizeof("); 
 strcat($<text>$, $<text>2);
 strcat($<text>$, ")");
 free($<text>3); 
}
  ;


UnaryOperator
  : '&' {$<text>$ = malloc(2); strcpy($<text>$, "&");}
  | '*' {$<text>$ = malloc(2); strcpy($<text>$, "*");}
  | '+' {$<text>$ = malloc(2); strcpy($<text>$, "+");}
  | '-' {$<text>$ = malloc(2); strcpy($<text>$, "-");}
  | '~' {$<text>$ = malloc(2); strcpy($<text>$, "~");}
  | '!' {$<text>$ = malloc(2); strcpy($<text>$, "!");}
  ;

CastExpr
  : UnaryExpr
{$<text>$ = $<text>1;
}
  | '(' TypeName ')' CastExpr
{$<text>$ = malloc(strlen($<text>2) + strlen($<text>4) + 3);	 		  
 strcpy($<text>$,"(");		  
 strcat($<text>$,$<text>2); 		  
 strcat($<text>$,")");  
 strcat($<text>$,$<text>4); 	 		  
 free($<text>1); free($<text>3);
}
  ;


MultiplicativeExpr
  : CastExpr
{$<text>$ = $<text>1;
}
  | MultiplicativeExpr '*' CastExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"*");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  | MultiplicativeExpr '/' CastExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"/");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  | MultiplicativeExpr '%' CastExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"%");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;


AdditiveExpr
  : MultiplicativeExpr
{$<text>$ = $<text>1;
}
  | AdditiveExpr '+' MultiplicativeExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"+");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  | AdditiveExpr '-' MultiplicativeExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"-");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;


ShiftExpr
  : AdditiveExpr
{$<text>$ = $<text>1;
}
  | ShiftExpr OP_SHL AdditiveExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"<<");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  | ShiftExpr OP_SHR AdditiveExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,">>");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;


RelationalExpr
  : ShiftExpr
{$<text>$ = $<text>1;
}
  | RelationalExpr '<' ShiftExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"<");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  | RelationalExpr '>' ShiftExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,">");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  | RelationalExpr OP_LE ShiftExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"<=");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  | RelationalExpr OP_GE ShiftExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,">=");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;

EqualityExpr
  : RelationalExpr
{$<text>$ = $<text>1;
}
  | EqualityExpr OP_EQ RelationalExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"==");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  | EqualityExpr OP_NE RelationalExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"!=");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;

AndExpr
  : EqualityExpr
{$<text>$ = $<text>1;
}
  | AndExpr '&' EqualityExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"&");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;
ExclusiveOrExpr
  : AndExpr
{$<text>$ = $<text>1;
}
  | ExclusiveOrExpr '^' AndExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"^");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;


InclusiveOrExpr
  : ExclusiveOrExpr
{$<text>$ = $<text>1;
}
  | InclusiveOrExpr '|' ExclusiveOrExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"|");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;


LogicalAndExpr
  : InclusiveOrExpr
{$<text>$ = $<text>1;
}
  | LogicalAndExpr OP_AND InclusiveOrExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"&&");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;


LogicalOrExpr
  : LogicalAndExpr
{$<text>$ = $<text>1;
}
  | LogicalOrExpr OP_OR LogicalAndExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,"||");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>3);
}
  ;


ConditionalExpr
  : LogicalOrExpr
{$<text>$ = $<text>1;
}
  | LogicalOrExpr '?' LogicalOrExpr ':' ConditionalExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + strlen($<text>5) + 7);
 strcpy($<text>$,$<text>1);
 strcat($<text>$," ? ");
 strcat($<text>$,$<text>3);
 strcat($<text>$," : ");
 strcat($<text>$,$<text>5);
 free($<text>1); free($<text>3); free($<text>5);
} 
  ;


AssignmentExpr
  : ConditionalExpr 
{$<text>$ = $<text>1;
}					
  | UnaryExpr AssignmentOperator AssignmentExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + strlen($<text>3) + 3);
 strcpy($<text>$,$<text>1);
 strcat($<text>$," ");
 strcat($<text>$,$<text>2);
 strcat($<text>$," ");
 strcat($<text>$,$<text>3);
 free($<text>1); free($<text>2); free($<text>3);
} 	
  ;


AssignmentOperator
  : '='			{$<text>$ = malloc(2); strcpy($<text>$, "=");}
  | OP_MUL_ASSIGN	{$<text>$ = malloc(3); strcpy($<text>$, "*=");}
  | OP_DIV_ASSIGN	{$<text>$ = malloc(3); strcpy($<text>$, "/=");}
  | OP_MOD_ASSIGN	{$<text>$ = malloc(3); strcpy($<text>$, "%=");}
  | OP_ADD_ASSIGN	{$<text>$ = malloc(3); strcpy($<text>$, "+=");}
  | OP_SUB_ASSIGN	{$<text>$ = malloc(3); strcpy($<text>$, "-+");}
  | OP_SHL_ASSIGN	{$<text>$ = malloc(4); strcpy($<text>$, "<<=");}
  | OP_SHR_ASSIGN 	{$<text>$ = malloc(4); strcpy($<text>$, ">>=");}
  | OP_AND_ASSIGN	{$<text>$ = malloc(3); strcpy($<text>$, "&=");}
  | OP_XOR_ASSIGN 	{$<text>$ = malloc(3); strcpy($<text>$, "^=");}
  | OP_OR_ASSIGN	{$<text>$ = malloc(3); strcpy($<text>$, "|=");}
  ;


Expr
  : AssignmentExpr
{$<text>$ = $<text>1;
}
  | Expr ',' AssignmentExpr 
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 2);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, ",");	     
 strcat($<text>$, $<text>3);	     
 free($<text>1); free($<text>3); 
}
  ;


ConstantExpr
  : ConditionalExpr
{$<text>$ = $<text>1;
}
  ;


Declaration
  : DeclarationSpecifiers ';'
{$<text>$ = malloc(strlen($<text>1) + 3);
 strcpy($<text>$,$<text>1);
 strcat($<text>$,";\n");
 free($<text>1); 
} 	
  | DeclarationSpecifiers InitDeclaratorList ';'
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2)+ 4);
 strcpy($<text>$,$<text>1);
 strcat($<text>$," ");
 strcat($<text>$,$<text>2);
 strcat($<text>$,";\n");
 free($<text>1); free($<text>2); 
} 	
  ;


DeclarationSpecifiers
  : StorageClassSpecifier
{$<text>$ = $<text>1;
}
  | StorageClassSpecifier DeclarationSpecifiers
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 2);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 free($<text>1);  free($<text>2); 
}
  | TypeSpecifier
{$<text>$ = $<text>1;
}
  | TypeSpecifier DeclarationSpecifiers
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 2);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 free($<text>1);  free($<text>2); 
}
  ;
InitDeclaratorList
  : InitDeclarator
{$<text>$ = $<text>1;
}
  | InitDeclaratorList ',' InitDeclarator
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, ", ");	     
 strcat($<text>$, $<text>3);	     
 free($<text>1); free($<text>3); 
}
  ;


InitDeclarator
  : Declarator
{$<text>$ = $<text>1;
}
  | Declarator '=' Initializer
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 4);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, " = ");	     
 strcat($<text>$, $<text>3);	     
 free($<text>1); free($<text>3); 
}
  ;


StorageClassSpecifier
  : KWD_typedef			{$<text>$ = malloc(15); strcpy($<text>$, "typedef");}
  | KWD_extern			{$<text>$ = malloc(15); strcpy($<text>$, "extern");}
  | KWD_static			{$<text>$ = malloc(15); strcpy($<text>$, "static");}
  | KWD_auto			{$<text>$ = malloc(15); strcpy($<text>$, "auto");}
  | KWD_register		{$<text>$ = malloc(15); strcpy($<text>$, "register");}
  ;


TypeSpecifier
  : KWD_char 			{$<text>$ = malloc(10); strcpy($<text>$, "char");}
  | KWD_short 			{$<text>$ = malloc(10); strcpy($<text>$, "short");}
  | KWD_int   			{$<text>$ = malloc(10); strcpy($<text>$, "int");}
  | KWD_long  			{$<text>$ = malloc(10); strcpy($<text>$, "long");}
  | KWD_signed  		{$<text>$ = malloc(19); strcpy($<text>$, "signed");}
  | KWD_unsigned 		{$<text>$ = malloc(13); strcpy($<text>$, "unsigned");}
  | KWD_float 			{$<text>$ = malloc(10); strcpy($<text>$, "float");}
  | KWD_double 			{$<text>$ = malloc(10); strcpy($<text>$, "double");}
  | KWD_const 			{$<text>$ = malloc(10); strcpy($<text>$, "const");}
  | KWD_volatile 		{$<text>$ = malloc(10); strcpy($<text>$, "volatile");}
  | KWD_void 			{$<text>$ = malloc(10); strcpy($<text>$, "void");}
  | StructOrUnionSpecifier 	{$<text>$ = $<text>1;}
  | EnumSpecifier		{$<text>$ = $<text>1;}
  | TYPE_NAME			{yyerror("Jednak czasem to sie odpala ");}
  ;


StructOrUnionSpecifier
  : StructOrUnion IDENT '{' StructDeclarationList '}'
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + strlen($<text>4) + 7);			 
 strcpy($<text>$, $<text>1);		 
 strcat($<text>$, $<text>2);
 strcat($<text>$, "\n{\n");
 strcat($<text>$, $<text>4);
 strcat($<text>$, "}\n");
 free($<text>1); free($<text>2); free($<text>4);
}
  | StructOrUnion '{' StructDeclarationList '}'
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 7);			 
 strcpy($<text>$, $<text>1);		 
 strcat($<text>$, "\n{\n");
 strcat($<text>$, $<text>3);
 strcat($<text>$, "}\n");
 free($<text>1);  free($<text>3);
}
  | StructOrUnion IDENT
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 2);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 free($<text>1);  free($<text>2); 
}
  ;


StructOrUnion
  : KWD_struct {$<text>$ = malloc(7); strcpy($<text>$, "struct");}
  | KWD_union  {$<text>$ = malloc(7); strcpy($<text>$, "union");}
  ;


StructDeclarationList
  : StructDeclaration
{$<text>$ = $<text>1;
}
  | StructDeclarationList StructDeclaration
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 2);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 free($<text>1);  free($<text>2); 
}
  ;


StructDeclaration
  : TypeSpecifierList StructDeclaratorList ';'
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 4);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 strcat($<text>$, ";\n");
 free($<text>1);  free($<text>2); 
}
  ;


StructDeclaratorList
  : StructDeclarator
{$<text>$ = $<text>1;
}
  | StructDeclaratorList ',' StructDeclarator
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, ", ");	     
 strcat($<text>$, $<text>3);	     
 free($<text>1); free($<text>3); 
}
  ;


StructDeclarator
  : Declarator
{$<text>$ = $<text>1;
}
  | ':' ConstantExpr
{$<text>$ = malloc(strlen($<text>2) + 4);	     
 strcpy($<text>$, " : ");	     	     
 strcat($<text>$, $<text>2);	     
 free($<text>2); 
}
  | Declarator ':' ConstantExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 4);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, " : ");	     
 strcat($<text>$, $<text>3);	     
 free($<text>1); free($<text>3); 
}
  ;


EnumSpecifier
  : KWD_enum '{' EnumeratorList '}'
{$<text>$ = malloc(sizeof($<text>3) + 10);			 
 strcpy($<text>$, "enum {\n");		 
 strcat($<text>$, $<text>3);
 strcat($<text>$, "}\n");
 free($<text>3);
}
  | KWD_enum IDENT '{' EnumeratorList '}'
{$<text>$ = malloc(sizeof($<text>2) + sizeof($<text>4) + 20);			 
 strcpy($<text>$, "enum ");		 
 strcat($<text>$, $<text>2);
 strcat($<text>$, "\n{\n");
 strcat($<text>$, $<text>4);
 strcat($<text>$, "}\n");
 free($<text>2); free($<text>4);
}
  | KWD_enum IDENT
{$<text>$ = malloc(sizeof($<text>2) + 6);			 
 strcpy($<text>$, "enum ");		 
 strcat($<text>$, $<text>2);
 free($<text>2);
}
  ;


EnumeratorList
  : Enumerator
{$<text>$ = $<text>1;
}
  | EnumeratorList ',' Enumerator
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, ", ");	     
 strcat($<text>$, $<text>3);	     
 free($<text>1); free($<text>3); 
}
  ;


Enumerator
  : IDENT
{$<text>$ = $<text>1;
}
  | IDENT '=' ConstantExpr
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 4);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, " = ");	     
 strcat($<text>$, $<text>3);	     
 free($<text>1); free($<text>3); 
}
  ;


Declarator
  : Declarator2 
{$<text>$ = malloc(strlen($<text>1) + 2); 
 strcpy($<text>$, $<text>1);
 free($<text>1); 
}
  | Pointer Declarator2
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 2);
 if(strcmp($<text>0, "char") == 0)
 {
	free($<text>0);
	$<text>0 = malloc(10);
	strcpy($<text>0, "String");
 }
 else
 {
	strcpy($<text>$, $<text>1); 
	strcat($<text>$, " ");
 } 
 strcat($<text>$, $<text>2); 
 free($<text>1);  free($<text>2); 
}
  ;


Declarator2
  : IDENT 
{$<text>$ = $<text>1;
}
  | '(' Declarator ')'
{$<text>$ = malloc(sizeof($<text>1) + 5);			 
 strcpy($<text>$, "( ");		 
 strcat($<text>$, $<text>1);
 strcat($<text>$, " )");			 
 free($<text>1);
}
  | Declarator2 '[' ']'
{$<text>$ = malloc(sizeof($<text>1) + 2);			 
 strcpy($<text>$, $<text>1);		 
 strcat($<text>$, "[]");			 
 free($<text>1);
}
  | Declarator2 '[' ConstantExpr ']'
{$<text>$ = malloc(sizeof($<text>1) + sizeof($<text>3) + 5);			 
 strcpy($<text>$, $<text>1);		 
 strcat($<text>$, "[ ");
 strcat($<text>$, $<text>3);
 strcat($<text>$, " ]");
 free($<text>1); free($<text>3);
}
  | Declarator2 '(' ')' 
{
 if (strcmp("$main", $<text>1) == 0)
 {	
	$<text>$ = malloc(strlen($<text>1) + 150);
	free($<text>0);
	$<text>0 = malloc(15);
	strcpy($<text>0, "static void");	
	strcpy($<text>$, "/*This is an entry point for the application.\n * @param args the arguments for main function\n */main(String[] args)");
 }
 else{	
	char* javadoc = generateJavadoc($<text>0, $<text>1, NULL);
	$<text>$ = malloc(strlen($<text>1) + strlen(javadoc) + 10);	 
 	strcpy($<text>$, javadoc);
 	strcat($<text>$, $<text>1);		 
 	strcat($<text>$, "()");
	free(javadoc);
 }
			 
 free($<text>1);
}
  | Declarator2 '(' ParameterTypeList ')' 
{
 char* javadoc = generateJavadoc($<text>0, $<text>1, $<text>3);	
 $<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + strlen(javadoc) + 5);			 
 strcpy($<text>$, javadoc);
 strcat($<text>$, $<text>1);		 
 strcat($<text>$, "( ");
 strcat($<text>$, $<text>3);
 strcat($<text>$, " )");
 free($<text>1); free($<text>3); free(javadoc);
}
  | Declarator2 '(' ParameterIdentifierList ')'
{
 char* javadoc = generateJavadoc($<text>0, $<text>1, $<text>3);	
 $<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + strlen(javadoc) + 5);			 
 strcpy($<text>$, javadoc);
 strcat($<text>$, $<text>1);		 
 strcat($<text>$, "( ");
 strcat($<text>$, $<text>3);
 strcat($<text>$, " )");
 free($<text>1); free($<text>3); free(javadoc);
}
 ;


Pointer
  : '*' 
{$<text>$ = malloc(2); 
 strcpy($<text>$, "*"); 
}
  | '*' TypeSpecifierList
{$<text>$ = malloc(strlen($<text>2) + 2); 
 strcpy($<text>$, "*");
 strcat($<text>$, $<text>2);
 free($<text>2);
}
  | '*' Pointer
{$<text>$ = malloc(strlen($<text>2) + 2); 
 strcpy($<text>$, "*");
 strcat($<text>$, $<text>2);
 free($<text>2);
} 
 | '*' TypeSpecifierList Pointer
{$<text>$ = malloc(strlen($<text>2) + 3); 
 strcpy($<text>$, "*");
 strcat($<text>$, $<text>2);
 strcat($<text>$, " ");
 strcat($<text>$, $<text>3);
 free($<text>2); free($<text>3);
}
  ;
TypeSpecifierList
  : TypeSpecifier
{$<text>$ = $<text>1;
}
  | TypeSpecifierList TypeSpecifier
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 1);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, $<text>2);
 free($<text>1);  free($<text>2); 
}
  ;
ParameterIdentifierList
  : IdentifierList
{$<text>$ = $<text>1;
}
  | IdentifierList ',' OP_ELIPSIS
{$<text>$ = malloc(strlen($<text>1) + 6);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, ", ...");	     	     
 free($<text>1); 
}
  ;
IdentifierList
  : IDENT
{$<text>$ = $<text>1;
}
  | IdentifierList ',' IDENT
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, ", ");	     
 strcat($<text>$, $<text>3);	     
 free($<text>1); free($<text>3); 
}
  ;
ParameterTypeList
  : ParameterList
{$<text>$ = $<text>1;
}
  | ParameterList ',' OP_ELIPSIS
{$<text>$ = malloc(strlen($<text>1) + 6);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, ", ...");	     
 free($<text>1); 
}
  ;
ParameterList
  : ParameterDeclaration
{$<text>$ = $<text>1;
}
  | ParameterList ',' ParameterDeclaration
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 3);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, ", ");	     
 strcat($<text>$, $<text>3);	     
 free($<text>1); free($<text>3); 
}
  ;
ParameterDeclaration
  : TypeSpecifierList Declarator
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 2);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 free($<text>1);  free($<text>2); 
}
  | TypeName
{$<text>$ = $<text>1;
}
  ;
TypeName
  : TypeSpecifierList
{$<text>$ = $<text>1;
}
  | TypeSpecifierList AbstractDeclarator
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 2);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 free($<text>1);  free($<text>2); 
}
  ;
AbstractDeclarator
  : Pointer
{$<text>$ = $<text>1;
}
  | AbstractDeclarator2
{$<text>$ = $<text>1;
}
  | Pointer AbstractDeclarator2
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 2);
 strcpy($<text>$, $<text>1); 
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 free($<text>1);  free($<text>2); 
}
  ;


AbstractDeclarator2
  : '(' AbstractDeclarator ')'
{$<text>$ = malloc(strlen($<text>2) + 3);
 strcpy($<text>$, "(");
 strcat($<text>$, $<text>2);
 strcat($<text>$, ")");
 free($<text>2);
}
  | '[' ']'
{$<text>$ = malloc(3);
 strcpy($<text>$, "[]");
}
  | '[' ConstantExpr ']'
{$<text>$ = malloc(strlen($<text>2) + 3);
 strcpy($<text>$, "[");
 strcat($<text>$, $<text>2);
 strcat($<text>$, "]");
 free($<text>2);
}
  | AbstractDeclarator2 '[' ']'
{$<text>$ = malloc(strlen($<text>1) + 3);
 strcpy($<text>$, $<text>1);
 strcat($<text>$, "[]");
 free($<text>1);
}
  | AbstractDeclarator2 '[' ConstantExpr ']'
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 5);
 strcpy($<text>$, $<text>1);
 strcat($<text>$, "[ ");
 strcat($<text>$, $<text>3);
 strcat($<text>$, " ]");
 free($<text>1); free($<text>3);
}
  | '(' ')'
{$<text>$ = malloc(3);
 strcpy($<text>$, "()");
}
  | '(' ParameterTypeList ')'
{$<text>$ = malloc(strlen($<text>2) + 3);
 strcpy($<text>$, "(");
 strcat($<text>$, $<text>2);
 strcat($<text>$, ")");
 free($<text>2);
}
  | AbstractDeclarator2 '(' ')'
{$<text>$ = malloc(strlen($<text>1) + 3);
 strcpy($<text>$, $<text>1);
 strcat($<text>$, "()");
 free($<text>1); 
}
  | AbstractDeclarator2 '(' ParameterTypeList ')'
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>3) + 5);
 strcpy($<text>$, $<text>1);
 strcat($<text>$, "( ");
 strcat($<text>$, $<text>3);
 strcat($<text>$, " )");
 free($<text>1); free($<text>3); 
}
  ;


Initializer
  : AssignmentExpr
{$<text>$ = $<text>1;
}
  | '{' InitializerList '}'
{$<text>$ = malloc(strlen($<text>2) + 3);
 strcpy($<text>$, "{");
 strcat($<text>$, $<text>2);
 strcat($<text>$, "}");
 free($<text>2);
}
  | '{' InitializerList ',' '}'
{$<text>$ = malloc(strlen($<text>2) + 5);
 strcpy($<text>$, "{");
 strcat($<text>$, $<text>2);
 strcat($<text>$, ", }");
 free($<text>2);
}
  ;


InitializerList
  : Initializer
{$<text>$ = $<text>1;
}
  | InitializerList ',' Initializer
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>1) + 6);	     
 strcpy($<text>$, $<text>1);	     
 strcat($<text>$, ", ");
 strcat($<text>$, $<text>3);	     
 free($<text>1);  free($<text>3); 
}
  ;


Statement
  : LabeledStatement
{$<text>$ = $<text>1;
}
  | CompoundStatement
{$<text>$ = $<text>1;
}
  | ExpressionStatement
{$<text>$ = $<text>1;
}
  | SelectionStatement
{$<text>$ = $<text>1;
}
  | IterationStatement
{$<text>$ = $<text>1;
}
  | JumpStatement
{$<text>$ = $<text>1;
}		
  ;


LabeledStatement
  : IDENT ':' Statement
  | KWD_case ConstantExpr ':' Statement
  | KWD_default ':' Statement
  ;


CompoundStatement
  : '{' '}'
{$<text>$ = malloc(5);
 strcpy($<text>$,"{\n}\n");
}
  | '{' StatementList '}' 
{$<text>$ = malloc(strlen($<text>2) + 6);
 strcpy($<text>$,"{\n");
 strcat($<text>$, $<text>2);
 strcat($<text>$, "}\n");
 free($<text>2);
}
  | '{' DeclarationList '}'
{$<text>$ = malloc(strlen($<text>2) + 6);
 strcpy($<text>$,"{\n");
 strcat($<text>$, $<text>2);
 strcat($<text>$, "\n}\n");
 free($<text>2);
}
  | '{' DeclarationList StatementList '}'
{$<text>$ = malloc(strlen($<text>2) + strlen($<text>3) + 7);
 strcpy($<text>$,"{\n");
 strcat($<text>$, $<text>2);
 strcat($<text>$, "\n");
 strcat($<text>$, $<text>3);
 strcat($<text>$, "}\n");
 free($<text>2); free($<text>3);
}
  ;


DeclarationList
  : Declaration
{$<text>$ = $<text>1;
}
  | DeclarationList Declaration
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 1);
 strcpy($<text>$, $<text>1);
 strcat($<text>$, $<text>2);
 free($<text>1); free($<text>2);
} 
  ;


StatementList
  : Statement
{$<text>$ = $<text>1;
}
  | StatementList Statement
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2) + 1);
 strcpy($<text>$, $<text>1);
 strcat($<text>$, $<text>2);
 free($<text>1); free($<text>2);
} 
  ;


ExpressionStatement
  : ';'
{$<text>$ = malloc(2); strcpy($<text>$, ";");
}
  | Expr ';'
{$<text>$ = malloc(strlen($<text>1) + 3);
 strcpy($<text>$,$<text>1);
 strcat($<text>$, ";\n");
 free($<text>1);
}
  ;


SelectionStatement
  : KWD_if '(' Expr ')' Statement %prec KWD_else
  | KWD_if '(' Expr ')' Statement KWD_else Statement
  | KWD_switch '(' Expr ')' Statement
  ;
IterationStatement
  : KWD_while '(' Expr ')' Statement
{ $<text>$ = malloc(strlen($<text>3) + strlen($<text>5) + 40);
  strcpy($<text>$, "while (");
  strcat($<text>$, $<text>3);
  strcat($<text>$, ")\n");
  strcat($<text>$, $<text>5);
  free($<text>3); free($<text>5);  
}
  | KWD_do Statement KWD_while '(' Expr ')' ';'
{ $<text>$ = malloc(strlen($<text>2) + strlen($<text>5) + 40);
  strcpy($<text>$, "do\n");
  strcat($<text>$, $<text>2);
  strcat($<text>$, " while ( ");
  strcat($<text>$, $<text>5);
  strcat($<text>$, " );\n");
  free($<text>2); free($<text>5);  
}
  | KWD_for '(' ';' ';' ')' Statement
{$<text>$ = constructForLoop(NULL, NULL, NULL, $<text>6);
 free($<text>6);
}
  | KWD_for '(' ';' ';' Expr ')' Statement
{$<text>$ = constructForLoop(NULL, NULL, $<text>5, $<text>7);
 free($<text>5); free($<text>7);
}
  | KWD_for '(' ';' Expr ';' ')' Statement
{$<text>$ = constructForLoop(NULL, $<text>4, NULL, $<text>7);
 free($<text>4); free($<text>7);
}
  | KWD_for '(' ';' Expr ';' Expr ')' Statement
{$<text>$ = constructForLoop(NULL, $<text>4, $<text>6, $<text>8);
 free($<text>4); free($<text>6); free($<text>8);
}
  | KWD_for '(' Expr ';' ';' ')' Statement
{$<text>$ = constructForLoop($<text>3, NULL, NULL, $<text>7);
 free($<text>3); free($<text>7);
}
  | KWD_for '(' Expr ';' ';' Expr ')' Statement
{$<text>$ = constructForLoop($<text>3, NULL, $<text>6, $<text>8);
 free($<text>3); free($<text>6); free($<text>8);
}
  | KWD_for '(' Expr ';' Expr ';' ')' Statement
{$<text>$ = constructForLoop($<text>3, $<text>5, NULL, $<text>8);
 free($<text>3); free($<text>5); free($<text>8);
}
  | KWD_for '(' Expr ';' Expr ';' Expr ')' Statement
{$<text>$ = constructForLoop($<text>3, $<text>5, $<text>7, $<text>9);
 free($<text>3); free($<text>5); free($<text>7); free($<text>9);
}
  ;
JumpStatement
  : KWD_goto IDENT ';'
{yyerror("Java does not use goto statement. ");
}
  | KWD_continue ';'
{$<text>$ = malloc(12);
 strcpy($<text>$, "continue ;\n");
}

  | KWD_break ';'
{$<text>$ = malloc(12);
 strcpy($<text>$, "break ;\n");
}
  | KWD_return ';'      
{$<text>$ = malloc(12);
 strcpy($<text>$, "return ;\n");
}
  | KWD_return Expr ';'
{$<text>$ = malloc(strlen($<text>2) + 15);
 strcpy($<text>$, "return ");
 strcat($<text>$, " ");
 strcat($<text>$, $<text>2);
 strcat($<text>$, ";\n");
 free($<text>2);
}
  ;
ExternalDefinition
  : FunctionDefinition
{$<text>$ = $<text>1;
}
  | Declaration
{$<text>$ = $<text>1;
}
  ;
FunctionDefinition
  : {yyerror("syntax error");} Declarator FunctionBody
  | DeclarationSpecifiers Declarator FunctionBody
{
 char* javadoc;
 char* newDeclarator = extractJavadoc($<text>2, &javadoc); 
 printf("%s\n%s %s\n%s ", javadoc, $<text>1, newDeclarator, $<text>3);
 free($<text>1); free($<text>2); free($<text>3); free(javadoc); free(newDeclarator);
} 
  ;
FunctionBody
  : CompoundStatement 
{$<text>$ = $<text>1;
}
  | DeclarationList CompoundStatement 
{$<text>$ = malloc(strlen($<text>1) + strlen($<text>2));
 strcpy($<text>$, $<text>1);
 strcat($<text>$, $<text>2);
 free($<text>1); free($<text>2);
}
  ;


Constant : CONST_INT
         | CONST_LONG_INT
         | CONST_UNSIGNED
         | CONST_UNSIGNED_LONG_INT
         | CONST_DOUBLE
         | CONST_FLOAT
         | CONST_LONG_DOUBLE
         | CONST_STRING
         | CONST_CHAR
         ;
%%
void yyerror(const char *fmt, ...)
{
  printf("%s in line %d\n", fmt, yylineno);
  exit(1);
}

void printMain(const char* fBody)
{
  printf("public static void main(String[] args)\n");	
}

char* addIndentation(char *dest, unsigned int i)
{
    char* indentation = malloc(i + 1 + strlen(dest));
    strcpy(indentation, "\t");
    for(int x = 1; x < i; x++){
        strcat(indentation, "\t");
    }
   strcat(indentation, dest);
   free(dest);
   return indentation;
}


char* constructForLoop(char* var, char* cond, char* acc, char* statement)
{
 int size = 40;
 if(var != NULL)
 	size+= strlen(var);
 if(cond != NULL)
 	size+= strlen(cond);
 if(acc != NULL)
 	size+= strlen(acc);
 if(statement != NULL)
 	size+= strlen(statement);

 char* forLoop = malloc(size);

 strcpy(forLoop,"for (");
 if(var != NULL)
 {
	strcat(forLoop, var);
 }
 strcat(forLoop, "; ");
 if(cond != NULL) 
 {
	strcat(forLoop, cond);
 }
 strcat(forLoop, "; ");
 if(acc != NULL) 
 {
	strcat(forLoop, acc);
 }
 strcat(forLoop, ")\n"); 
 char* hasBrackets = strstr(statement, "{"); 
 if(statement != NULL)
 {
	 if(hasBrackets == NULL) strcat(forLoop, "{\n");
	 strcat(forLoop, statement);
	 if(hasBrackets == NULL) strcat(forLoop, "}\n");
 }

 return forLoop; 
}


char* extractJavadoc(char* source, char** javadoc)
{
	char* javaDocStart = strstr(source, "/*");
	char* javaDocEnd   = strstr(source, "*/");
	int javaDocSize = javaDocEnd + 2 - javaDocStart;
	*javadoc = malloc(javaDocSize + 2);
	strncpy(*javadoc, javaDocStart, javaDocSize);
	(*javadoc)[javaDocSize] = '\0';
	int remainingSize = strlen(javaDocEnd + 2) + 1;
	char* remainings = malloc(remainingSize);
	strcpy(remainings, javaDocEnd + 2);
	return remainings;
}

char* generateJavadoc(char* Type, char* Declarator, char* ArgumentList){
	int javaDocAproxSize = strlen(Type) + strlen(Declarator) + 70;
	char* a = ArgumentList;	
	if(ArgumentList != NULL)
	{
		int numArguments = 0;
		while( a != NULL){
			a = strstr(a, ",");
			if(a != NULL)
			{
				a++;
			}
			numArguments++;
			
		}
		javaDocAproxSize += strlen(ArgumentList) + numArguments * 50;
	}
	    
	char* javadoc = malloc(javaDocAproxSize);
	strcpy(javadoc, "/**\n * This method is generated from ");
	strcat(javadoc, Declarator + 1);
	strcat(javadoc, "()\n");
	
	if(ArgumentList != NULL)
	{
		char* tempArgList = strdup(ArgumentList);
		a = tempArgList;
		char* argumentStart = a;		
		char* argument;	
		while( a != NULL)
		{
			a = strstr(a, ",");
			if(a != NULL)
			{
				a[0] = '\0';
				a += 2;
			}	
			argument = malloc(strlen(argumentStart) + 1);	
			strcpy(argument, argumentStart);
			strcat(javadoc, " * @param ");
			strcat(javadoc, argument);
			strcat(javadoc, " is a translation of formal parameter ");
			strcat(javadoc, strstr(argument, " ") + 2 );
			strcat(javadoc, "\n");
			free(argument);	
			argumentStart = a;	
		}
	}
	/*Not strcmp, because "static void" main.*/
	if(strstr(Type, "void") == NULL)
	{
		strcat(javadoc, " * return some ");
		strcat(javadoc, Type);
		strcat(javadoc, " value\n");
	}
	strcat(javadoc, " */");
	//printf("\n\n===============\n%s\n================\n\n", javadoc);
	
	return javadoc;
}

int main() { return yyparse(); }
