%{
  #include <stdio.h>
  int yywrap(void);
  int yylex(void);
  #include "y.tab.h"
  typedef struct DefinePairStruct{
  	char* key;
	char* val;
  } DefinePair;
  DefinePair* defineRules;
%}
%s Javadoc
%s Code
%s Define
%s Include1
%s Include2
%s Comment
%s Comment2
%%
<INITIAL>"/*"                                { BEGIN Javadoc; }
<Javadoc>[^\*]*"*/"                          { BEGIN Code;
					       yylval.text = malloc(strlen(yytext) + 30);
					       strcpy(yylval.text, "/* ");
					       strcat(yylval.text, yytext);
                                               return JAVA_DOC; /* typedef -> check type */ }

<Code>#include[ \t\v\n\f]*\"		     { BEGIN Include1; }
<Include1>\" 				     { BEGIN Code; }
<Include1>.|\n 				     { ; }

<Code>#include[ \t\v\n\f]*<		     	     { BEGIN Include2; }
<Include2>> 				     { BEGIN Code; }
<Include2>.|\n 				     { ; }




<Code>"//"                                   { BEGIN Comment2; }
<Comment2>\n				     { BEGIN Code; }
<Comment2>.|\n 				     { ; }

<Code>"/*"                                   { BEGIN Comment; }
<Comment>"*/"                                { BEGIN Code; }
<Comment>.|\n                                { ; }

<Code>auto                                   { return KWD_auto; }
<Code>break                                  { return KWD_break; }
<Code>case                                   { return KWD_case; }
<Code>char                                   { return KWD_char; }
<Code>const                                  { return KWD_const; }
<Code>continue                               { return KWD_continue; }
<Code>default                                { return KWD_default; }
<Code>do                                     { return KWD_do; }
<Code>double                                 { return KWD_double; }
<Code>else                                   { return KWD_else; }
<Code>enum                                   { return KWD_enum; }
<Code>extern                                 { return KWD_extern; }
<Code>float                                  { return KWD_float; }
<Code>for                                    { return KWD_for; }
<Code>goto                                   { return KWD_goto; }
<Code>if                                     { return KWD_if; }
<Code>int                                    { return KWD_int; }
<Code>long                                   { return KWD_long; }
<Code>register                               { return KWD_register; }
<Code>return                                 { return KWD_return; }
<Code>short                                  { return KWD_short; }
<Code>signed                                 { return KWD_signed; }
<Code>sizeof                                 { return KWD_sizeof; }
<Code>static                                 { return KWD_static; }
<Code>struct                                 { return KWD_struct; }
<Code>switch                                 { return KWD_switch; }
<Code>typedef                                { return KWD_typedef; }
<Code>union                                  { return KWD_union; }
<Code>unsigned                               { return KWD_unsigned; }
<Code>void                                   { return KWD_void; }
<Code>volatile                               { return KWD_volatile; }
<Code>while                                  { return KWD_while; }
<Code>">>="                                  { return OP_SHR_ASSIGN; }
<Code>"<<="                                  { return OP_SHL_ASSIGN; }
<Code>"+="                                   { return OP_ADD_ASSIGN; }
<Code>"-="                                   { return OP_SUB_ASSIGN; }
<Code>"*="                                   { return OP_MUL_ASSIGN; }
<Code>"/="                                   { return OP_DIV_ASSIGN; }
<Code>"%="                                   { return OP_MOD_ASSIGN; }
<Code>"&="                                   { return OP_AND_ASSIGN; }
<Code>"^="                                   { return OP_XOR_ASSIGN; }
<Code>"|="                                   { return OP_OR_ASSIGN; }
<Code>">>"                                   { return OP_SHR; }
<Code>"<<"                                   { return OP_SHL; }
<Code>"++"                                   { return OP_INC; }
<Code>"--"                                   { return OP_DEC; }
<Code>"->"                                   { return OP_PTR; }
<Code>"&&"                                   { return OP_AND; }
<Code>"||"                                   { return OP_OR; }
<Code>"<="                                   { return OP_LE; }
<Code>">="                                   { return OP_GE; }
<Code>"=="                                   { return OP_EQ; }
<Code>"!="                                   { return OP_NE; }
<Code>"..."                                  { return OP_ELIPSIS; }
<Code>\;                                     { return ';'; }
<Code>\{                                     { return '{'; }
<Code>\}                                     { return '}'; }
<Code>\,                                     { return ','; }
<Code>\:                                     { return ':'; }
<Code>\=                                     { return '='; }
<Code>\(                                     { return '('; }
<Code>\)                                     { return ')'; }
<Code>\[                                     { return '['; }
<Code>\]                                     { return ']'; }
<Code>\.                                     { return '.'; }
<Code>\&                                     { return '&'; }
<Code>\!                                     { return '!'; }
<Code>\~                                     { return '~'; }
<Code>\+                                     { return '+'; }
<Code>\-                                     { return '-'; }
<Code>\*                                     { return '*'; }
<Code>\/                                     { return '/'; }
<Code>\%                                     { return '%'; }
<Code>\<                                     { return '<'; }
<Code>\>                                     { return '>'; }
<Code>\^                                     { return '^'; }
<Code>\|                                     { return '|'; }
<Code>\?                                     { return '?'; }
<Code>[+\-]?[0-9]+                           { 
                                                  yylval.text = strdup(yytext);
                                                  return CONST_INT;
                                                }
<Code>[+\-]?0[xX][0-9a-fA-F]+                {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_INT;
                                                }
<Code>[+\-]?[0-9]+[lL]                       {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_LONG_INT;
                                                }
<Code>[+\-]?0[xX][0-9a-fA-F]+[lL]            { 
                                                  yylval.text = strdup(yytext);
                                                  return CONST_LONG_INT;
                                                }
<Code>\+?[0-9]+[uU]                          {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_UNSIGNED;
                                                }
<Code>\+?0[xX][0-9a-fA-F]+[uU]               {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_UNSIGNED;
                                                }
<Code>\+?[0-9]+[uU][lL]                      {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_UNSIGNED_LONG_INT;
                                                }
<Code>\+?[0-9]+[lL][uU]                      {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_UNSIGNED_LONG_INT;
                                                }
<Code>\+?0[xX][0-9a-fA-F]+[uU][lL]           {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_UNSIGNED_LONG_INT;
                                                }
<Code>\+?0[xX][0-9a-fA-F]+[lL][uU]           {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_UNSIGNED_LONG_INT;
                                                }
<Code>[0-9]*\.[0-9]+([Ee][+\-]?[0-9]+)?      {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_DOUBLE;
                                                }
<Code>[0-9]+\.[0-9]*([Ee][+\-]?[0-9]+)?      {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_DOUBLE;
                                                }
<Code>[0-9]*\.[0-9]+([Ee][+\-]?[0-9]+)?[fF]  {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_FLOAT;
                                                }
<Code>[0-9]+\.[0-9]*([Ee][+\-]?[0-9]+)?[fF]  {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_FLOAT;
                                                }
<Code>[0-9]*\.[0-9]+([Ee][+\-]?[0-9]+)?[lL]  {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_LONG_DOUBLE;
                                                }
<Code>[0-9]+\.[0-9]*([Ee][+\-]?[0-9]+)?[lL]  {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_LONG_DOUBLE;
                                                }
<Code>\"(\\.|[^\\"])*\"                      {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_STRING;
                                                }
<Code>'[0-9a-zA-Z]'|'\\n'|'\\t'|'\\v'        {
                                                  yylval.text = strdup(yytext);
                                                  return CONST_CHAR;
                                                }
<Code>[a-zA-Z_][a-zA-Z_0-9]*                 {
						  if (strcmp(yytext, "func2") == 0 )
                                                  {
							yylval.text = malloc(20);
							strcpy(yylval.text,"$honk2");
							return CONST_DEF_VAL;
						  }
						  else
						  {
							yylval.text = malloc(strlen(yytext + 2));
							strcpy(yylval.text, "$");
							strcat(yylval.text, yytext);
		                                        return IDENT; /* typedef -> check type */
						  }
                                                }

<Code>[ \t\v\n\f]                            { ; }
<Code>\\[^\n]*\n				{ ; }
%%
int yywrap(void) { return 1; }
