%{
    { 
      Version for PLex and PYacc for a basic calculator grammar
      jhon jame quintero
      use something like this to generate (adapt for other OSes):
      C:\development\ate-bc> C:\bin\lazarus\fpc\3.2.2\bin\i386-win32\plex.exe .\assets\ate-bc.lex .\deps\Generated\ate-bx.lex.pas      
    }
%}


%%
[0-9]+          begin yylval.yyInteger := StrToInt(yytext); return(IntLiteral); end;
[ \t]			; { Ignore whitespace, dont do anything }


%%