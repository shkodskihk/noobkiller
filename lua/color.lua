local ffi = require("ffi")
 
ffi.cdef[[
typedef uintptr_t HANDLE;
typedef uint32_t  DWORD;
typedef uint16_t  WORD;
typedef uint16_t  SHORT;
typedef uint32_t  BOOL;
//typedef wchar_t* LPWCSTR;
 
/* COPY paste from windows header files*/
typedef struct _COORD 
{  
    SHORT X;  
    SHORT Y;
} COORD; 
 
typedef struct _SMALL_RECT 
{  
    SHORT Left;  
    SHORT Top;  
    SHORT Right;  
    SHORT Bottom;
} SMALL_RECT;
 
typedef struct _CONSOLE_SCREEN_BUFFER_INFO 
{  
    COORD dwSize;  
    COORD dwCursorPosition;  
    WORD wAttributes;  
    SMALL_RECT srWindow;  
    COORD dwMaximumWindowSize;
} CONSOLE_SCREEN_BUFFER_INFO, *PCONSOLE_SCREEN_BUFFER_INFO;
 
HANDLE GetStdHandle(DWORD nStdHandle);
BOOL SetConsoleTextAttribute(HANDLE hConsoleOutput, WORD wAttributes);
//BOOL SetConsoleTitleW(LPCWSTR);
BOOL GetConsoleScreenBufferInfo(HANDLE hConsoleOutput, PCONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo);
]]
 
local console = ffi.C.GetStdHandle(-11)

function ResetColor()
	ffi.C.SetConsoleTextAttribute(console, 0x17)
end

function SetColor(num)
	ffi.C.SetConsoleTextAttribute(console, num)
end