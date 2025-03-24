# Kakoune default color scheme

# For Code
face global value         red
face global type          yellow
face global variable      green
face global module        green
face global function      cyan
face global string        magenta
face global keyword       blue
face global operator      yellow
face global attribute     green
face global comment       cyan
face global documentation comment
face global meta          magenta
face global builtin       default+b

# For markup
face global title  blue
face global header cyan
face global mono   green
face global block  magenta
face global link   cyan
face global bullet blue 
face global list   yellow

# builtin faces
face global Default            default,default
face global PrimarySelection   black,blue+fg
face global SecondarySelection black,rgb:9a9a9a
face global PrimaryCursor      black,blue+fg
face global SecondaryCursor    black,rgb:9a9a9a
face global PrimaryCursorEol   black,blue+fg
face global SecondaryCursorEol black,rgb:9a9a9a
face global LineNumbers        default,default
face global LineNumberCursor   rgb:8581e0,rgb:313131
face global MenuForeground     rgb:151515,blue
face global MenuBackground     blue,rgb:151515
face global MenuInfo           blue,rgb:151515 ## was cyan
face global Information        blue,rgb:232323
face global Error              default
face global DiagnosticError    red
face global DiagnosticWarning  yellow
face global StatusLine         blue,rgb:313131
face global StatusLineMode     rgb:313131,blue
face global StatusLineInfo     blue,rgb:313131
face global StatusLineValue    blue,rgb:313131
face global StatusCursor       default+r
face global Prompt             white,default
face global MatchingChar       default,default+b
face global Whitespace         default,default+fd
face global BufferPadding      blue,default
