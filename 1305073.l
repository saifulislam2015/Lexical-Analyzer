%option noyywrap

%x MYSTATE

%x MYSTATE2

%{
#include <bits/stdc++.h>
using namespace std;

FILE *logout;
FILE *tokenout;

class symbolInfo
{
public:
    char name[40];
    char type[40];
    class symbolInfo *next;
};

class symbolTable
{
    symbolInfo **arr;
    int arrsize;
public:
    symbolTable(int a);
    int myhash(char *p);
    int search(char *p);
    int insert(char *n,char *t);
    int mydelete(char *p);
    void print();
    ~symbolTable();
};
symbolTable::symbolTable(int a)
{
    arr=(symbolInfo **)malloc(a*sizeof(symbolInfo *));
    for(int i=0;i<a;i++) arr[i]=0;
    arrsize=a;
}

int symbolTable::myhash(char *p)
{
    int s=0;
    int l=strlen(p);
    for(int i=0;i<l;i++){
        int temp=(int) p[i];
        s+=temp;
    }
    return (s%arrsize);
}
int symbolTable::search(char *p)
{
    int j=0,i=myhash(p);
    symbolInfo *h=arr[i];
    while(1){
        if(h==0) break;
        if(strcmp(h->name,p)==0) {
            return j;
        }
        h=h->next;
        j++;
    }
    return -1;
}

int symbolTable::insert(char *n,char *t)
{
    if(search(n)!=-1){
	fprintf(logout,"<%s,%s> already exists\n",n,t);
        return -1;
    }
    else{
        int j=0,i=myhash(n);
        symbolInfo *nw;
        nw=new symbolInfo;
        strcpy(nw->name,n);
        strcpy(nw->type,t);
        nw->next=0;
        if(arr[i]==0){
            arr[i]=nw;
        }
        else{
            j++;
            struct symbolInfo *h=arr[i];
            while(h->next!=0) {
                h=h->next;
                j++;
            }
            h->next=nw;
        }
        return j;
    }
}

int symbolTable::mydelete(char *p)
{
	if(search(p)==-1){
        return -1;
	}
	else{
        symbolInfo *temp, *prev ;
        int j=0,i=myhash(p);
        temp = arr[i];
        while (temp != 0)
        {
            if (strcmp(temp->name,p)==0) break;
            prev = temp;
            temp = temp->next ;
            j++;
        }
        if (temp == arr[i])
        {
            arr[i]=arr[i]->next;
            delete temp ;
        }
        else
        {
            prev->next = temp->next ;
            delete temp;
        }
        return j ;
	}
}

void symbolTable::print()
{
    for(int i=0;i<arrsize;i++){
        symbolInfo *h=arr[i];
	if(h==0) continue;
	fprintf(logout,"%d ->",i);
        while(h!=0){
	    fprintf(logout,"<%s,%s>",h->name,h->type);
            h=h->next;
        }
	fprintf(logout,"\n");
    }
    cout<<endl<<endl;
    fprintf(logout,"\n");
}
symbolTable::~symbolTable()
{
    free(arr);
}
symbolTable ob(30);
int line_count=1;
int error_count=0;
string str="";
string str2="";
int a,b;


%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
DIGITS {DIGIT}+
NUMBER {DIGITS}(\.{DIGITS})?(E[+-]?{DIGITS})?
NEWLINE \n

%%

{NEWLINE} {line_count++;}
{WHITESPACE} {}

"if"	{
			fprintf(tokenout,"<IF>");
			fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);
		}
		
"else"	{
			fprintf(tokenout,"<ELSE>");
			fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);
		}
"for"	{
			fprintf(tokenout,"<FOR>");
			fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);
		}
"while"	{
			fprintf(tokenout,"<WHILE>");
			fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);
		}
"do"	{
			fprintf(tokenout,"<DO>");
			fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);
		}
"break"	{
			fprintf(tokenout,"<BREAK>");
			fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);
		}
"int"	{
			fprintf(tokenout,"<INT>");
			fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
		}
"char"	{
			fprintf(tokenout,"<CHAR>");
			fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);
		}
"float"	{
			fprintf(tokenout,"<FLOAT>");
			fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);
		}
"double"        {
			fprintf(tokenout,"<DOUBLE>");
			fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);
		}
"void"	{
			fprintf(tokenout,"<VOID>");
			fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);
		}
"return"	{
			fprintf(tokenout,"<RETURN>");
			fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);
		}

"switch"	{
			fprintf(tokenout,"<SWITCH>");
			fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
		}
"case"	{
			fprintf(tokenout,"<CASE>");
			fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);
		}
"default"	{
			fprintf(tokenout,"<DEFAULT>");
			fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
		}
"continue"	{
			fprintf(tokenout,"<CONTINUE>");
			fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n",line_count,yytext);
		}

"+"		|

"-"		{
			fprintf(tokenout,"<ADDOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"ADDOP");
			ob.print();
		}
[*/%]           {
			fprintf(tokenout,"<MULOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"MULOP");
			ob.print();
		}

"++"		|
"--"           {
			fprintf(tokenout,"<INCOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"INCOP");
			ob.print();
		}
		
"<="            |
">="		|
"=="		|
"!="		|
[<>]           {
			fprintf(tokenout,"<RELOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"RELOP");
			ob.print();
		}
"="		{
			fprintf(tokenout,"<ASSIGNOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"ASSIGNLOP");
			ob.print();
		}
"&&"		|
"||"		|
"!"		{
			fprintf(tokenout,"<LOGICOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"LOGICOP");
			ob.print();
		}

[()]           {
			fprintf(tokenout,"<PAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <PAREN> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"PAREN");
			ob.print();
		}

[{}]           {
			fprintf(tokenout,"<CURL,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <CURL> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"CURL");
			ob.print();
		}
"["          |
"]"          {
			fprintf(tokenout,"<BRACKET,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <BRACKET> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"BRACKET");
			ob.print();
		}
","           {
			fprintf(tokenout,"<COMMA,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"COMMA");
			ob.print();
		}
";"           {
			fprintf(tokenout,"<SEMICOLON,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"SEMICOLON");
			ob.print();
		}

{DIGITS} 	{
			fprintf(tokenout,"<CONST_INT,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"CONST_INT");
			ob.print();
		}
{NUMBER} 	{
			fprintf(tokenout,"<CONST_FLOAT,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"CONST_FLOAT");
			ob.print();
		}
"'"."'"           |
"'\\n'" 	|
"'\\0'"        |
"'\\t'"        |
"'\\\'"        |
"'\\r'"        |
"'\\b'" 	|
"'\\f'"       |
"'\\n'"        |
"'\"'"		{
			fprintf(tokenout,"<CONST_CHAR,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"CONST_CHAR");
			ob.print();
		}
[_A-Za-z]({LETTER}|{DIGIT})*	{
			fprintf(tokenout,"<ID,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
			ob.insert(yytext,"ID");
			ob.print();
		}	

"\"" {    
	str="";	
	a=line_count;
	str=str+yytext;
	BEGIN MYSTATE;
	}
<MYSTATE>[^"\\\n\r]*  { 
		     str=str+yytext;
		   }
<MYSTATE>"\\\n" {line_count++;}
<MYSTATE>{NEWLINE}  {
			fprintf(logout,"Line no %d: <UNFINISHED STRING ERROR>  %s found\n",a,str.c_str());
			error_count++;
			line_count++;
			BEGIN INITIAL;
		}
<MYSTATE>"\""  {
		str=str+yytext;
		fprintf(tokenout,"<STRING,%s>",str.c_str());
		fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",a,str.c_str());
		BEGIN INITIAL;
		}


"//"[^\n]*	  {
			fprintf(logout,"Line no %d:TOKEN <COMMENT> Lexeme %s found\n",line_count,yytext);
		}
"/*"   {
	str2="";
	b=line_count;
	str2=str2+yytext;
	BEGIN MYSTATE2;
	}
<MYSTATE2><<EOF>> {
		fprintf(logout,"Line no %d: <UNFINISHED COMMENT ERROR>  %s found\n",b,str2.c_str());
		error_count++;
		BEGIN INITIAL;
		}
<MYSTATE2>"*/" {
		str2=str2+yytext;
		fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n",b,str2.c_str());
		BEGIN INITIAL;
		}
<MYSTATE2>{NEWLINE}	{
			line_count++;
			str2=str2+yytext;
		} 
<MYSTATE2>.  {str2=str2+yytext;}

({DIGIT}*"\."{DIGIT}*){2,}   {
				fprintf(logout,"Line no %d: TOO MANY DECIMAL POINT  %s \n",line_count,yytext);
				error_count++;
			     }

{DIGITS}(\.{DIGITS})?E[+-]?{DIGITS}?\.[^\n\r]*    {
				fprintf(logout,"Line no %d: ILL FORMED NUMBER %s \n",line_count,yytext);
				error_count++;
			     }
{DIGITS}{LETTER}+      |
{NUMBER}{LETTER}+          {
				fprintf(logout,"Line no %d: INVALID SUFFIX ON NUMERIC CONSTANT ERROR  %s found\n",line_count,yytext);
				error_count++;
			     }

"'"[^"\n\t\a\f\r\b\v\0\\]{2,}"'"  {
				fprintf(logout,"Line no %d: ILL FORMED CHARACTER  %s \n",line_count,yytext);
				error_count++;
			     }

"'"[^'"\n\t\a\f\r\b\v\0\\]+ {
	fprintf(logout,"Line no %d: UNDETERMINED CHARACTER FOUND  %s \n",line_count,yytext);
	error_count++;
	}
.   {  
	fprintf(logout,"Line no %d: UNDETERMINED CHARACTER FOUND  %s \n",line_count,yytext);
	error_count++;
	}


%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");

	yyin= fin;
	yylex();
	fprintf(logout,"total LINES: %d\n",line_count-1);
	fprintf(logout,"total ERRORS: %d\n",error_count);
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
