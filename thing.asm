;1099 - make draw sprites and update in loopidiloop 1 and 2 to check if there is sprite in spritemap
.686
        .MODEL  Flat,StdCall
        OPTION  CaseMap:None
        .MMX
        .XMM
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
include \masm32\include\Advapi32.inc
;include \masm32\include\masm32rt.inc
include \masm32\include\winmm.inc
include \masm32\include\comctl32.inc
;include \masm32\include\commctrl.inc

includelib \masm32\lib\winmm.lib
      include \masm32\include\dialogs.inc       ; macro file for dialogs
      include \masm32\macros\macros.asm         ; masm32 macro file
          includelib \masm32\lib\gdi32.lib
     includelib \masm32\lib\user32.lib
      includelib \masm32\lib\kernel32.lib
      includelib \masm32\lib\Comctl32.lib
      includelib \masm32\lib\comdlg32.lib
      includelib \masm32\lib\shell32.lib
      includelib \masm32\lib\oleaut32.lib
      includelib \masm32\lib\ole32.lib
      includelib \masm32\lib\msvcrt.lib
	  include \masm32\include\msvcrt.inc

	  include \masm32\include\Ws2_32.inc
includelib \masm32\lib\Ws2_32.lib
 
 include \masm32\include\ntoskrnl.inc
 includelib \masm32\lib\ntoskrnl.lib

 ;include \masm32\include\win32k.inc
 ;includelib \masm32\lib\win32k.lib
 
.const
	WINDOW_WIDTH    equ     800
	WINDOW_HEIGHT   equ     600

	
	
	MAIN_TIMER_ID equ 0
.data
	xPos DWORD 0
	ClassName       DB      "TheClass",0
	windowTitle     DB      "ayy lmao",0
	
	linewidth DWORD 2
	TWOPI real4 6.283185307179586f
	PI real4 3.141592653589793f
	fov real4 1.0471975511965976f ; 60 * pi / 180
 	viewdist real4 692.820323027551
 	magicnum real4 0.001308996938995747 ; fov / 800 foreach x
 	globalfloatvar real4 ?
        globalfloatvar2 real4 ?
        efes75 real4 0.75
        efes25 real4 0.25
        sngMinusOneHalf REAL4 -0.5
        pt POINT <0,0>
        lastmousept POINT <0,0>
        lasttime DWORD 0
        timebetweenframes real4 0.0f ; 1000/60
        middlemousept POINT <WINDOW_WIDTH/2,WINDOW_HEIGHT/2>
	PLAYER STRUCT
		x    real4  16.0f
		y     real4  10.0f
		dir   DWORD  0.0f
		rot  real4  0.0f
		moveSpeed real4 0.15
                speed real4 0.0f
		rotSpeed real4  0.06981317007977318f
                moveDir real4 0.0f
	PLAYER ENDS

	
     Player PLAYER <16.0f,10.0f,0,0.0f,0.05f,0.0f,0.05f,0.0f>
     MAP DWORD  1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
DWORD           1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,0,1,0,0,1,1,1,1,1,2,3,4,5,6,7,8,1,1,1,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,0,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1
DWORD	        1,0,0,1,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1
DWORD	        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD          	1,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1
DWORD       	1,0,0,0,0,0,0,0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,0,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,0,0,1,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1
DWORD       	1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,1
DWORD	        1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1
DWORD	        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
DWORD	        1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

SPRITEMAP DWORD  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD          	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD       	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD       	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
DWORD	        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


    mapWidth DWORD 32
    mapHeight DWORD 24

    
    SPRITE STRUCT
            x DWORD 0
            y DWORD 0
    SPRITE ENDS
    
    spritestodraw    SPRITE   1000 dup (<0,0>)
    spritestodrawlen DWORD 0
    spritetodrawlen DWORD 9
    lamp HBITMAP ?
    wolftextures HBITMAP ?
    lampstr DB "C:/FFOutput/lamp.bmp",0
       
.code

BUILDRECT       PROC,   x:DWORD,        y:DWORD, w:DWORD,       h:DWORD,        hdc:HDC,        brush:HBRUSH
	LOCAL rectangle:RECT
	mov eax, x
	mov rectangle.left, eax
	add eax, w
	mov     rectangle.right, eax
 
	mov eax, y
	mov     rectangle.top, eax
	add     eax, h
	mov rectangle.bottom, eax
 
	invoke FillRect, hdc, addr rectangle, brush
	ret
BUILDRECT ENDP


 
NewBrushColor 	PROC,	color:DWORD, brush:DWORD        ;BGR FORMAT
	mov eax,color
	push eax
	invoke DeleteObject,[brush] 
	pop eax
	invoke CreateSolidBrush,eax
	ret
NewBrushColor ENDP

FLOOR PROC , floatvalue:real4
    cvttss2si    ebx,    [floatvalue]
    mov          eax,    [floatvalue]
    shr          eax,    31
    sub          ebx,    eax
    cvtsi2ss     xmm0,   ebx
    ret
FLOOR ENDP
      
      
CEIL PROC , floatvalue:real4
     ;movss xmm0,FP4(1.0)
      movss xmm0, floatvalue
      addss xmm0, xmm0
      movss xmm1, sngMinusOneHalf
      subss xmm1, xmm0
      cvtss2si eax, xmm1
      sar eax, 1
      neg eax
      cvtsi2ss xmm0, eax
      ret
CEIL ENDP

MODULUS PROC , nvalue:real4 , dvalue:real4
    ;int c=8, m=3, result=c-(c/m*m);  result=2 
    LOCAL tempvalue:real4
    COMMENT @
    movss xmm1,cvalue
    movss xmm0,mvalue
    mulss xmm0,xmm0 ; m^m
    divss xmm1,xmm0 ; xmm1 = c/m*m
    movss xmm2,cvalue
    subss xmm2,xmm1
    movss xmm0,xmm2
    @
    movss xmm0,nvalue
    divss xmm0,dvalue
    movss tempvalue,xmm0
    invoke FLOOR,tempvalue
    movss xmm3,xmm0
    movss xmm0,dvalue
    mulss xmm0,xmm3
    movss xmm1,nvalue
    subss xmm1,xmm0
    movss xmm0,xmm1
    
    
    ret
MODULUS ENDP

DrawImage PROC, hdc:HDC, img:HBITMAP, x:DWORD, y:DWORD,x2:DWORD,y2:DWORD,w:DWORD,h:DWORD,wstrech:DWORD,hstrech:DWORD
    ;--------------------------------------------------------------------------------
    local hdcMem:HDC
    local HOld:HBITMAP
      invoke CreateCompatibleDC, hdc
      mov hdcMem, eax
      invoke SelectObject, hdcMem, img
      mov HOld, eax
      invoke SetStretchBltMode,hdc,COLORONCOLOR
      invoke StretchBlt ,hdc,x,y,wstrech,hstrech,hdcMem,x2,y2,w,h,SRCCOPY
      invoke SelectObject,hdcMem,HOld
      invoke DeleteDC,hdcMem 
      invoke DeleteObject,HOld
    ;================================================================================
    ret
DrawImage ENDP

CONTAINSPOSITIONINSPRITES PROC, x:DWORD ,y:DWORD
    local tempx:DWORD
    local tempy:DWORD
    
    mov ecx,0
    startloopcontains:
    cmp ecx,spritestodrawlen
    je CONTAINSPOSITIONINSPRITESFALSE
    pusha
    mov eax,spritestodraw[ecx * SizeOf SPRITE].x
    mov tempx ,eax
    mov eax,spritestodraw[ecx * SizeOf SPRITE].y
    mov tempy,eax
    
    mov eax,tempx
    cmp eax,x
    jne ENDOFLOOPCONTAINS
    mov eax,tempy
    cmp eax,y
    je CONTAINSPOSITIONINSPRITESTRUE
    
    
    ENDOFLOOPCONTAINS:
    popa
    inc ecx
    jmp startloopcontains


    CONTAINSPOSITIONINSPRITESTRUE:
    mov eax,1
    ret
    CONTAINSPOSITIONINSPRITESFALSE:
    mov eax,0
    ret
CONTAINSPOSITIONINSPRITES ENDP

DRAWSPRITES PROC , hdc:HDC
    local spritex:DWORD
    local spritey:DWORD
    local distance:real4
    local spriteangle:real4
    local sprxonscreen:real4
    local spryonscreen:real4
    local tempravrriable:real4
    
    local dxx:real4
    local dyy:real4
    
    local sprxscreen:DWORD
    local spryscreen:DWORD
    
    local sizeofspr:real4
    local sizeofsprfloor:DWORD
    
    mov eax,spritetodrawlen
    mov ecx,0
    
    loopspritestobedrawndraw:
    cmp ecx,spritestodrawlen
    je endloopspritestobedrawndraw
    pusha
    mov eax,spritestodraw[ecx * SizeOf SPRITE].x
    mov spritex,eax
    mov eax,spritestodraw[ecx * SizeOf SPRITE].y
    mov spritey,eax
    
    mov ebx,spritex
    cvtsi2ss xmm0,ebx
    subss xmm0,Player.x
    
    mov ebx,spritey
    cvtsi2ss xmm1,ebx
    subss xmm1,Player.y
    
    movss dxx,xmm0
    movss dyy,xmm1
    
    mulss xmm0,xmm0
    mulss xmm1,xmm1
    addss xmm0,xmm1
    movss tempravrriable,xmm0
    FLD tempravrriable
    fsqrt
    fstp distance
    
    FLD dyy
    fld dxx
    fpatan
    fstp tempravrriable
    movss xmm0,tempravrriable
    subss xmm0,Player.rot
    movss spriteangle,xmm0
    
    fld spriteangle
    fsincos
    fdiv
    fstp tempravrriable
    movss xmm0,tempravrriable
    mulss xmm0,viewdist
    movss sprxonscreen,xmm0
    
    movss xmm0,spriteangle
    movss tempravrriable,xmm0
    fld tempravrriable
    fcos
    fstp tempravrriable
    movss xmm0,tempravrriable
    mulss xmm0,distance
    
    movss xmm1,viewdist
    divss xmm1,xmm0 ; viewdist / (cos(spriteangle) * distance)
    movss sizeofspr,xmm1
    
    movss xmm0,FP4(600.0f) ;WINDOW_HEIGHT
    subss xmm0,sizeofspr
    divss xmm0,FP4(2.0f)
    
    movss spryonscreen,xmm0
    
    movss xmm0,FP4(400.0f);WINDOW_WIDTH / 2
    addss xmm0,sprxonscreen
    movss xmm1,sizeofspr
    divss xmm1,FP4(2.0f)
    
    subss xmm0,xmm1 ; xmm0=(WINDOW_WIDTH / 2 + x - sizeofspr/2)
    movss sprxonscreen,xmm0
    
    
    invoke FLOOR,sizeofspr
    cvtss2si eax, xmm0
    mov sizeofsprfloor,eax
    
    movss xmm0,sprxonscreen
    movss tempravrriable,xmm0
    invoke FLOOR, tempravrriable
    cvtss2si eax, xmm0
    mov sprxscreen,eax
    
    movss xmm0,spryonscreen
    movss tempravrriable,xmm0
    invoke FLOOR, tempravrriable
    cvtss2si eax, xmm0
    mov spryscreen,eax
    
    invoke DrawImage,hdc,lamp,sprxscreen,spryscreen,0,0,64,64,sizeofsprfloor,sizeofsprfloor
    
    popa
    inc ecx
    jmp loopspritestobedrawndraw
    endloopspritestobedrawndraw:
    
    
    
    ret
DRAWSPRITES ENDP


ISBLOCKING PROC , xvalue:real4 , yvalue:real4
        local temporary:real4
        local floorx:DWORD
        local floory:DWORD
        
        
        movss xmm0,xvalue
        mov ebx,0
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jb isblockfuncret0
        
        mov ebx,mapWidth
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jae isblockfuncret0
        
        movss xmm0,yvalue
        mov ebx,0
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jb isblockfuncret0
        
        mov ebx,mapHeight
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jae isblockfuncret0
        
        movss xmm0,xvalue
        movss temporary,xmm0
        invoke FLOOR,temporary
        cvtss2si eax, xmm0
        mov floorx,eax
        
        movss xmm0,yvalue
        movss temporary,xmm0
        invoke FLOOR,temporary
        cvtss2si eax, xmm0
        mov floory,eax
        
        mov ecx,floory
        imul ecx,mapWidth
        add ecx,floorx
        imul ecx,type DWORD
        mov edx,MAP[ecx]
        cmp edx,0
        je isblockfuncret0
        
        
        isblockfuncret1:
        mov eax,1
        ret
        isblockfuncret0:
        mov eax,0
        ret

ISBLOCKING ENDP


castRay PROC, rayangle:real4 , screenpos:DWORD , hdc:HDC , localbrush:HBRUSH
	local right:DWORD
	local up:DWORD
	local angleSin:real4
	local angleCos:real4
	local dist:real4
	
        local distchanged:DWORD
	local wallX:DWORD
	local wallY:DWORD
        local height:DWORD	

	local slope:real4
        local horizontal:DWORD	


	local dXVer:real4
	local dYVer:real4
	
	local dYHor:real4
	local dXHor:real4

        local x:real4
        local y:real4
        
        local tempvarr:real4
        local tempvarr1:real4
        
        local posinspritearr:DWORD
        
        local todraw:DWORD
        
        local typeofwall:DWORD
        local floatingpoint:real4
        
        local finaltexturex:DWORD
        
        local screenypos:DWORD
        
        local xHit:DWORD
        local yHit:DWORD
        
        mov right,0
        mov up,0
        mov horizontal,0
        mov todraw,1
        mov eax,spritestodrawlen
        mov posinspritearr,eax
        mov typeofwall,0
        
        mov xHit,0
        mov yHit,0
        
        
        
        
        mov ebx,0
        cvtsi2ss xmm0,ebx
        movss dist,xmm0
        ;int c=8, m=3, result=c-(c/m*m);  result=2 
        movss xmm0,rayangle
        movss xmm1,TWOPI
        movss tempvarr,xmm0
        movss tempvarr1,xmm1
        invoke MODULUS,tempvarr,tempvarr1
        movss rayangle,xmm0
        
        
        movss tempvarr,xmm0
        movss tempvarr1,xmm1
        
        
        modulusangle: ; xmm0=angle ,xmm1=pi * 2
        ucomiss xmm0,xmm1
        jge endmodulusangle
        subss xmm0,xmm1
        jmp modulusangle
        endmodulusangle:
        movss rayangle,xmm0
        
        
        
        movss xmm0,rayangle
        mov ebx,0
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1 ; xmm0=rayangle , xmm1=0 
        ja notneeded
        addss xmm0,TWOPI
        movss rayangle,xmm0
        notneeded:
        
        
        movss xmm1,TWOPI
        movss xmm2,efes75
        mulss xmm1,xmm2 ; xmm1 = TWOPI * 0.75
        rightcheck:
        movss xmm0,rayangle
        comiss xmm0,xmm1 ;xmm0=angle ,TWOPI * 0.75
        jbe rightcheck2
        mov right,1
        jmp afterrightcheck
        rightcheck2:
        movss xmm1,TWOPI
        movss xmm2,efes25
        mulss xmm1,xmm2 ; xmm1=TWOPI * 0.25
        comiss xmm0,xmm1 ;xmm0=angle ,TWOPI * 0.25
        ja afterrightcheck
        mov right,1
        afterrightcheck:
        
        
        upcheck:
        movss xmm0,rayangle
        mov ebx,0
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1 ; xmm0=rayangle , xmm1=0
        ja upcheck2
        mov up,1
        jmp afterupcheck
        upcheck2:
        movss xmm1,PI
        comiss xmm0,xmm1
        jb afterupcheck
        mov up,1
        afterupcheck:
        
        ;movss xmm0,rayangle
        FLD rayangle
        fcos
        FSTP angleCos
        
        FLD rayangle
        fsin 
        FSTP angleSin
        
        movss xmm0,angleSin
        divss xmm0,angleCos
        ;divss xmm0,xmm1
        movss slope,xmm0
        
        mov eax,right
        cmp eax,0
        je thing1
        mov ebx,1
        cvtsi2ss xmm0,ebx
        movss dXVer,xmm0
        jmp afterthing1
        thing1:
        mov ebx,-1
        cvtsi2ss xmm0,ebx
        movss dXVer,xmm0
        afterthing1:
        
        movss xmm0,dXVer
        movss xmm1,slope
        mulss xmm0,xmm1
        movss dYVer,xmm0
        ;checking right
        mov eax,right
        cmp eax,0
        jne isrightayy
        movss xmm0,Player.x
        movss tempvarr,xmm0
        invoke FLOOR ,tempvarr
        movss x,xmm0
        jmp jumpafterrightcheckingthing
        isrightayy:
        movss xmm0,Player.x
        movss tempvarr,xmm0
        invoke CEIL ,tempvarr
        movss x,xmm0
        jumpafterrightcheckingthing:
        
        
        movss xmm0,x
        subss xmm0,Player.x
        mulss xmm0,slope
        addss xmm0,Player.y
        movss y,xmm0
        
        
        loopidiloop1:
        movss xmm0,x
        mov ebx,0
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jb endloopidiloop1
        
        mov ebx,mapWidth
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jae endloopidiloop1
        
        movss xmm0,y
        mov ebx,0
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jb endloopidiloop1
        
        mov ebx,mapHeight
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jae endloopidiloop1
        
        movss xmm0,x
        mov ebx,0
        mov eax,right
        cmp eax,0
        jne afterchangewallx ; right = 1
        mov ebx,-1
        cvtsi2ss xmm2,ebx
        addss xmm0,xmm2
        
        afterchangewallx:
        movss tempvarr,xmm0
        invoke FLOOR ,tempvarr
        cvtss2si eax, xmm0
        mov wallX,eax
        
        movss xmm1,y
        movss tempvarr,xmm1
        invoke FLOOR ,tempvarr
        cvtss2si eax, xmm0
        mov wallY,eax
        
        mov eax,wallX
        mov ebx,wallY
        ;eax = round x
        ;ebx = round y
        mov ecx,ebx
        imul ecx,mapWidth
        add ecx,eax
        imul ecx,type DWORD
        
        pusha
        mov edx,SPRITEMAP[ecx]
        cmp edx,0
        je endofspriteadding1
        invoke CONTAINSPOSITIONINSPRITES,wallX,wallY
        cmp eax,0
        jne endofspriteadding1
        mov ebx,posinspritearr
        mov eax,wallX
        mov spritestodraw[ebx * SizeOf SPRITE].x,eax
        mov eax,wallY
        mov spritestodraw[ebx * SizeOf SPRITE].y,eax
        inc posinspritearr
        endofspriteadding1:
        popa
        
        mov edx,MAP[ecx]
        mov typeofwall,edx
        cmp edx,0
        
        jne ayylmao1
        jmp after
        
        ayylmao1:
        ;mov typeofwall,edx
        movss xmm0,x
        movss xmm1,y
        subss xmm0,Player.x
        subss xmm1,Player.y
        
        mulss xmm0,xmm0
        mulss xmm1,xmm1
        
        addss xmm0,xmm1;xmm0=new found dist
        
        movss dist,xmm0 ; dist squared
        mov distchanged,1
        
        
        movss xmm0,y
	movss globalfloatvar,xmm0

	movss xmm1,FP4(1.0f)
	movss globalfloatvar2,xmm1

	invoke MODULUS ,globalfloatvar,globalfloatvar2
        
        
        
        movss floatingpoint,xmm0
        
        mov ebx,right
        cmp ebx,1
        je afterrightchecktexture
        
        movss xmm1,FP4(1.0f)
        movss xmm0,floatingpoint
        subss xmm1,xmm0
        movss floatingpoint,xmm1
        
        afterrightchecktexture:
        mov eax,wallX
        mov ebx,wallY
        ;eax = round x
        ;ebx = round y
        mov ecx,ebx
        imul ecx,mapWidth
        add ecx,eax
        imul ecx,type DWORD
        mov edx ,MAP[ecx]
        mov typeofwall,edx
        
        mov eax,wallX
        mov xHit,eax
        mov eax,wallY
        mov yHit,eax
        
        jmp endloopidiloop1
        
        after:
        
        movss xmm0,dXVer
        addss xmm0,x
        movss x,xmm0
        
        movss xmm0,dYVer
        addss xmm0,y
        movss y,xmm0
        
        jmp loopidiloop1
        endloopidiloop1:
        
        movss xmm0,angleCos
        divss xmm0,angleSin
        ;divss xmm0,xmm1
        movss slope,xmm0
        
        mov eax,up
        cmp eax,0
        je isnotup
        mov ebx,-1
        cvtsi2ss xmm0,ebx
        movss dYHor,xmm0
        mulss xmm0,slope
        movss dXHor,xmm0
        jmp afterupping
        isnotup:
        mov ebx,1
        cvtsi2ss xmm0,ebx
        movss dYHor,xmm0
        mulss xmm0,slope
        movss dXHor,xmm0
        
        afterupping:
        
        mov eax,up
        cmp eax,0
        jne isuppayy
        movss xmm0,Player.y
        movss tempvarr,xmm0
        invoke CEIL ,tempvarr
        movss y,xmm0
        jmp jumpafterupcheckingthing
        isuppayy:
        movss xmm0,Player.y
        movss tempvarr,xmm0
        invoke FLOOR ,tempvarr
        movss y,xmm0
        jumpafterupcheckingthing:
        
        
        
        movss xmm1,y
        subss xmm1,Player.y
        mulss xmm1,slope
        addss xmm1,Player.x
        movss x,xmm1
        
        
        loopidiloop2:
        movss xmm0,x
        mov ebx,0
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jb endloopidiloop2
        
        mov ebx,mapWidth
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jae endloopidiloop2
        
        movss xmm0,y
        mov ebx,0
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jb endloopidiloop2
        
        mov ebx,mapHeight
        cvtsi2ss xmm1,ebx
        comiss xmm0,xmm1
        jae endloopidiloop2
        
        mov ebx,0
        movss xmm0,y
        mov eax,up
        cmp eax,0
        je afterupcheckk
        mov ebx,-1
        afterupcheckk:
        
        cvtsi2ss xmm1,ebx
        addss xmm0,xmm1 ; y + up
        movss tempvarr,xmm0
        invoke FLOOR , tempvarr
        cvtss2si eax, xmm0
        mov wallY,eax
        
        movss xmm0,x
        movss tempvarr,xmm0
        invoke FLOOR , tempvarr
        cvtss2si eax, xmm0
        mov wallX,eax
        
        mov ecx,wallY
        imul ecx,mapWidth
        add ecx,wallX
        imul ecx,type DWORD
        
        pusha
        mov edx,SPRITEMAP[ecx]
        cmp edx,0
        je endofspriteadding2
        invoke CONTAINSPOSITIONINSPRITES,wallX,wallY
        cmp eax,0
        jne endofspriteadding2
        mov ebx,posinspritearr
        mov eax,wallX
        mov spritestodraw[ebx * SizeOf SPRITE].x,eax
        mov eax,wallY
        mov spritestodraw[ebx * SizeOf SPRITE].y,eax
        inc posinspritearr
        endofspriteadding2:
        popa
        
        mov edx,MAP[ecx]
        
        cmp edx,0
        
        jne ayylmao2
        jmp after2
        ayylmao2:
        
        ;cvtsi2ss xmm0,eax
        ;cvtsi2ss xmm1,ebx
        movss xmm0,x
        movss xmm1,y
        subss xmm0,Player.x
        subss xmm1,Player.y
        
        mulss xmm0,xmm0
        mulss xmm1,xmm1
        
        addss xmm0,xmm1;xmm0=new found dist
        movss xmm3,xmm0
        
        mov ebx,0
        cvtsi2ss xmm1,ebx
        movss xmm0,dist
        comiss xmm0,xmm1
        jne othercheck
        
        ;movss xmm0,xmm3
        ;mov eax ,distchanged
        ;cmp eax,0
        ;je othercheck ; 
        
        movss dist,xmm3
        mov distchanged,1
        
        jmp dootherstuffthatareneeded
        othercheck:
        movss xmm0,xmm3
        movss xmm1,dist
        movss tempvarr,xmm0
        comiss xmm0,xmm1 ; 0=new dist 1 = olddist
        jae endloopidiloop2
        movss dist,xmm0
        mov distchanged,1
        dootherstuffthatareneeded:
        mov typeofwall,edx
        movss xmm0,x
	movss globalfloatvar,xmm0
    
	movss xmm1,FP4(1.0f)
	movss globalfloatvar2,xmm1

	invoke MODULUS ,globalfloatvar,globalfloatvar2
        movss floatingpoint,xmm0
        
        mov ebx,up
        cmp ebx,0
        je afterupchecktexture
        
        movss xmm1,FP4(1.0f)
        ;movss xmm0,floatingpoint
        subss xmm1,floatingpoint
        movss floatingpoint,xmm1
        
        afterupchecktexture:
        mov eax,wallX
        mov ebx,wallY
        ;eax = round x
        ;ebx = round y
        mov ecx,ebx
        imul ecx,mapWidth
        add ecx,eax
        imul ecx,type DWORD
        mov edx ,MAP[ecx]
        mov typeofwall,edx
        
        mov eax,wallX
        mov xHit,eax
        mov eax,wallY
        mov yHit,eax
        
        
        jmp endloopidiloop2
        after2:
        movss xmm0,dXHor
        movss xmm1,x
        addss xmm1,xmm0
        movss x,xmm1
        
        movss xmm0,dYHor
        movss xmm1,y
        addss xmm1,xmm0
        movss y,xmm1
        jmp loopidiloop2
        endloopidiloop2:
        
        
        mov eax,distchanged
        cmp eax,0
        je endthis
        
        mov ebx,0
        cvtsi2ss xmm1,ebx
        movss xmm0,dist
        comiss xmm0,xmm1
        je endthis
        
        ;movss xmm0,dist
        ;mov ebx,0
        ;cvtsi2ss xmm1,ebx
        ;comiss xmm0,xmm1
        ;jb endthis
        
        FLD dist
        fsqrt
        FSTP dist
        
        
        
        ;movss dist,xmm0
        movss xmm0,Player.rot
        subss xmm0,rayangle
        movss tempvarr,xmm0
        FLD tempvarr
        fcos
        FSTP tempvarr
        movss xmm0,tempvarr
        mulss xmm0,dist
        movss dist,xmm0
        
        movss xmm0,viewdist
        movss xmm1,dist
        divss xmm0,xmm1
        movss tempvarr,xmm0
        ;FLD tempvarr
        ;FRNDINT
        ;FISTP height
        cvtss2si eax,xmm0 ; eax = height
        
        mov height,eax
        
        ;debugging huge wall heights - removing them is on top
        ;movss xmm0,height
        ;mov ebx,WINDOW_HEIGHT-600
        ;cvtsi2ss xmm1,ebx
        ;comiss xmm0,xmm1
        ;ja endthis
        
        mov eax,height
        mov ebx,2
        xor edx,edx
        idiv ebx
        
        
        
        mov ebx,WINDOW_HEIGHT / 2
        sub ebx,eax
        mov eax,height
        
        mov screenypos,ebx
        
        mov eax,xHit
        mov ebx,yHit
        ;eax = round x
        ;ebx = round y
        mov ecx,ebx
        imul ecx,mapWidth
        add ecx,eax
        imul ecx,type DWORD
        mov edx ,MAP[ecx]
        mov typeofwall,edx
        dec typeofwall
        
        movss xmm0,floatingpoint
        mulss xmm0,FP4(63.0f) ; WIDTH - 1
        
        mov eax,typeofwall
        cvtsi2ss xmm1,eax
        mulss xmm1,FP4(64.0f)
        
        addss xmm0,xmm1
        
        movss tempvarr,xmm0
        invoke FLOOR,tempvarr
        cvtss2si eax, xmm0
        mov finaltexturex,eax
        
        ;invoke BUILDRECT,screenpos,screenypos,linewidth,height,hdc,localbrush
        
        invoke DrawImage,hdc,wolftextures,screenpos,screenypos,finaltexturex,0,linewidth,64,linewidth,height
        
        endthis:
        ;invoke BUILDRECT,screenpos,300,1,1,hdc,localbrush
        mov eax,posinspritearr
        mov spritestodrawlen,eax
	
	ret
castRay ENDP

ProjectWndProc  PROC,   hWnd:HWND, message:UINT, wParam:WPARAM, lParam:LPARAM
	local paint:PAINTSTRUCT
	local hdc:HDC
	local localbrush:HBRUSH   
	local ecxbackup:DWORD
	local anglee:real4
        local tempvar:real4
        local tempvar2:real4
        
        local backupnewx:real4
        local backupnewy:real4
        local movestep:real4
        local currenttime:DWORD
        local movespeed:real4
        
        local movedupordown:DWORD
        local movedleftorright:DWORD
        
 	updatestate:
        invoke timeGetTime
        mov currenttime,eax
        sub eax,lasttime
        cvtsi2ss xmm0,ebx
        comiss xmm0,timebetweenframes ; 1000/60=16.6666666
        jae endofupdatestate
        mov eax,currenttime
        mov lasttime,eax
        
        mov ebx,0
        cvtsi2ss xmm0,ebx
        movss Player.speed,xmm0
        movss Player.dir,xmm0
        movss Player.moveDir,xmm0
        
        movss xmm0,Player.moveSpeed
        movss movespeed,xmm0
        
        mov movedupordown,0
        mov movedleftorright,0
        
        mov eax, LPARAM
        and eax, 0ffffh
        mov pt.x,eax
        ;invoke GET_Y_LPARAM,LPARAM
        ;mov pt.y,eax
        
        
        invoke GetAsyncKeyState, VK_ESCAPE
        cmp eax,0
        jne closing
         
	invoke GetAsyncKeyState, VK_W
	cmp eax,0
	je after
	mov ebx,1
        cvtsi2ss xmm0,ebx
        movss Player.speed,xmm0
	mov movedupordown,1
	after:


        invoke GetAsyncKeyState, VK_S
	cmp eax,0
        je r
        mov ebx,-1
        cvtsi2ss xmm0,ebx
        movss Player.speed,xmm0
        mov movedupordown,1
        r:
        invoke GetAsyncKeyState, VK_RIGHT
	cmp eax,0
        je r2
        mov ebx,1
        cvtsi2ss xmm0,ebx
        movss Player.dir,xmm0
        
        r2:
        
        invoke GetAsyncKeyState, VK_LEFT
	cmp eax,0
        je r3
        mov ebx,-1
        cvtsi2ss xmm0,ebx
        movss Player.dir,xmm0
        
        r3:
        
        ;mov eax,pt.x
        ;mov ebx,WINDOW_WIDTH/2
        ;sub eax,ebx
        ;cvtsi2ss xmm0,eax
        ;divss xmm0,FP4(100.0f)
        ;movss Player.dir,xmm0
        ;jg rtright
        ;mov ebx,-1
        ;cvtsi2ss xmm0,ebx
        ;movss Player.dir,xmm0
        ;jmp afterrotat
        ;rtright:
        ;mov ebx,1
        ;cvtsi2ss xmm0,ebx
        ;movss Player.dir,xmm0
        ;afterrotat:
        
        invoke GetAsyncKeyState, VK_A
        cmp eax,0
        je afterAcheck
        mov ebx,1
        cvtsi2ss xmm0,ebx
        movss Player.moveDir,xmm0
        mov movedleftorright,1
        afterAcheck:
        
        invoke GetAsyncKeyState, VK_D
        cmp eax,0
        je afterDcheck
        mov ebx,-1
        cvtsi2ss xmm0,ebx
        movss Player.moveDir,xmm0
        mov movedleftorright,1
        afterDcheck:
        
        
        mov eax,pt.x
        mov ebx,pt.y
        mov lastmousept.x , eax
        mov lastmousept.y , ebx
        
        mov eax,movedleftorright
        cmp eax,0
        je notmorecheckneededforslow
        mov eax,movedupordown
        cmp eax,0
        je notmorecheckneededforslow
        ; normilizing movment speed
        movss xmm0,movespeed
        movss xmm1,movespeed
        mulss xmm0,xmm0
        mulss xmm1,xmm1
        addss xmm0,xmm1
        movss tempvar,xmm0
        FLD tempvar
        FSQRT
        FSTP tempvar
        movss xmm0,tempvar
        movss xmm1,movespeed
        divss xmm0,xmm1
        movss xmm3,movespeed
        divss xmm3,xmm0
        movss movespeed,xmm3
        ;movss movespeed,xmm0
        
        ;got only rotation 

        notmorecheckneededforslow:
        
        movss xmm0,Player.speed
        mulss xmm0,movespeed ; xmm0=movestep
        movss movestep,xmm0
        
        movss xmm1,Player.dir
        mulss xmm1,Player.rotSpeed
        addss xmm1,Player.rot
        movss Player.rot,xmm1
        
        
        FLD Player.rot
        fcos
        FSTP tempvar
        
        movss xmm1,tempvar
        mulss xmm1,movestep
        addss xmm1,Player.x
        ;movss Player.x,xmm1
        movss backupnewx,xmm1
        
        FLD Player.rot
        fsin
        FSTP tempvar
        movss xmm0,tempvar
        mulss xmm0,movespeed
        mulss xmm0,Player.moveDir
        addss xmm0,backupnewx
        movss backupnewx,xmm0
        
        
        
        FLD Player.rot
        fsin
        FSTP tempvar
        
        movss xmm1,tempvar
        mulss xmm1,movestep
        addss xmm1,Player.y
        ;movss Player.y,xmm1
        movss backupnewy,xmm1
        
        FLD Player.rot
        fcos
        FSTP tempvar
        movss xmm0,tempvar
        mulss xmm0,movespeed
        mulss xmm0,Player.moveDir
        movss xmm1,backupnewy
        subss xmm1,xmm0
        movss backupnewy,xmm1
        
        invoke ISBLOCKING,backupnewx,backupnewy
        cmp eax,0
        jne notmove
        movss xmm0,backupnewy
        movss Player.y,xmm0
        movss xmm0,backupnewx
        movss Player.x,xmm0
        notmove:
   
        ;endofupdatestate:
        
	cmp     message,        WM_PAINT
	je      renderstate
	cmp message,    WM_CLOSE
	je      closing
	cmp message,    WM_TIMER
	je      timing
        endofupdatestate:
	jmp OtherInstances
	ret

renderstate:
    
	invoke  BeginPaint,     hWnd,   addr paint
	mov hdc, eax

	;invoke BUILDRECT,xPos,0,200,200,hdc,localbrush
        ;invoke NewBrushColor , 0ffffffH,addr localbrush
        ;mov localbrush,eax
        
        ;invoke BUILDRECT,0,0,WINDOW_WIDTH,WINDOW_HEIGHT,hdc,localbrush
        mov spritestodrawlen,0
        mov eax,spritetodrawlen
        mov ecx,0
        
        loopspritetodrawreset:
        cmp ecx,spritetodrawlen
        je endloopspritetodrawreset
        
        mov spritestodraw[ecx * SizeOf SPRITE].x,0
        mov spritestodraw[ecx * SizeOf SPRITE].y,0
        inc ecx
        endloopspritetodrawreset:
        
        invoke NewBrushColor  , 000FF00H,addr localbrush
	mov localbrush,eax
        
        mov ecx,800
        rayloop:
            pusha ;; cvtsi2ss = convert register/integer to float and mov to xmm register
				  ;; movss = mov value from memory to xmm register
				;mov ecxbackup,ecx
				;movss xmm0,ecxbackup
				
				cvtsi2ss xmm0,ecx
				;movss xmm1,magicnum
				mulss xmm0,magicnum ;xmm0 = magicnum * ecx
				movss xmm2,fov
				mov ebx,2
				cvtsi2ss xmm3,ebx
				divss xmm2,xmm3 ; xmm2 = fov/2

				subss xmm0,xmm2 ;xmm0 = magicnum * ecx - fov/2
				movss xmm1,Player.rot
                                
				addss xmm0,xmm1 ; xmm0=Player.rot + magicnum * ecx - fov/2
				movss anglee,xmm0

                pusha
                        mov edx,800
                        ;sub edx,ecx
        		invoke castRay,anglee,ecx,hdc,localbrush
                popa
            popa
        loop rayloop	

        ;invoke DrawImage,hdc,lamp,0,0,0,0,64,64,64,64
        invoke DRAWSPRITES,hdc
	invoke EndPaint,hWnd,addr paint
	ret
	

closing:
	invoke ExitProcess, 1
	ret
timing:
	invoke InvalidateRect, hWnd, NULL, TRUE
	ret
OtherInstances:
	invoke DefWindowProc, hWnd, message, wParam, lParam
	ret
ProjectWndProc  ENDP
 
main PROC
        
	LOCAL wndcls:WNDCLASSA ; Class struct for the window
	LOCAL hWnd:HWND ;Handle to the window
	LOCAL msg:MSG
	invoke RtlZeroMemory, addr wndcls, SIZEOF wndcls ;Empty the window class
	mov eax, offset ClassName
	mov wndcls.lpszClassName, eax ;Set the class name
	invoke GetStockObject, WHITE_BRUSH
	mov wndcls.hbrBackground, eax ;Set the background color as black
	mov eax, ProjectWndProc
	mov wndcls.lpfnWndProc, eax ;Set the procedure that handles the window messages
	invoke RegisterClassA, addr wndcls ;Register the class
	invoke CreateWindowExA, WS_EX_COMPOSITED, addr ClassName, addr windowTitle, WS_SYSMENU, 100, 100, WINDOW_WIDTH, WINDOW_HEIGHT, 0, 0, 0, 0 ;Create the window
	mov hWnd, eax ;Save the handle
	invoke ShowWindow, eax, SW_SHOW ;Show it
	invoke SetTimer, hWnd, MAIN_TIMER_ID, 20, NULL ;Set the repaint timer

	;movss xmm0,PI
	;movss Player.rot,xmm0
        init:
	invoke timeGetTime
	mov lasttime,eax
        movss xmm0,FP4(1000.0f)	
        divss xmm0,FP4(60.0f)
        movss timebetweenframes,xmm0
        
        invoke GetModuleHandle,NULL
	invoke LoadBitmap,eax,1222
	mov lamp,eax

        invoke GetModuleHandle,NULL
	invoke LoadBitmap,eax,1223
	mov wolftextures,eax 
        
        ;mov spritestodraw[place * SizeOf SPRITE].x,1
        
	msgLoop:
	 ; PeekMessage
	invoke GetMessage, addr msg, hWnd, 0, 0 ;Retrieve the messages from the window
	invoke DispatchMessage, addr msg ;Dispatches a message to the window procedure
	jmp msgLoop
	closing:invoke ExitProcess, 1
main ENDP
end main
