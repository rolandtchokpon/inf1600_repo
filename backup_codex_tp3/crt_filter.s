/*
Signature : void crtFilter(Image& img, int scanlineSpacing)

Paramètres :
img : la référence vers l’image à modifier (sur place)
scanlineSpacing : espacement entre les lignes que l’on va dessiner sur l’image pour l’effet CRT


Description : Cette fonction applique un filtre global à une image afin de reproduire l’apparence d’un ancien écran CRT. Elle combine les deux fonctions précédentes.
Il faut parcourir TOUS les pixels et appliquer les traitements suivants:
1.	Appeler applyScanline() 
    	Si la ligne y est un multiple de scanlineSpacing on applique un assombrissement de 60 %.

2.	Appler applyPhosphor()
        Le paramètre subpixel est déterminé par la position horizontale du pixel : x % 3

*/
.data   

full_color:
    .int 100

less_color:
    .int 60

max_index:
    .int 3

.text 
.globl crtFilter                      

crtFilter:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  
    pushl   %ebx
    pushl   %esi
    pushl   %edi

    subl    $8, %esp           # -4: y, -8: x

    movl    $0, -4(%ebp)

.outer_loop:
    movl    8(%ebp), %eax
    movl    4(%eax), %ecx
    movl    -4(%ebp), %edx
    cmpl    %ecx, %edx
    jae     .done

    movl    $0, -8(%ebp)

.inner_loop:
    movl    8(%ebp), %eax
    movl    (%eax), %ecx
    movl    -8(%ebp), %edx
    cmpl    %ecx, %edx
    jae     .next_row

    movl    8(%ebp), %eax
    movl    8(%eax), %eax              # Pixel**
    movl    -4(%ebp), %edx
    movl    (%eax, %edx, 4), %ebx      # Pixel* row
    movl    -8(%ebp), %edx
    leal    (%ebx, %edx, 4), %esi      # &pixel

    movl    -4(%ebp), %eax
    xorl    %edx, %edx
    divl    12(%ebp)
    cmpl    $0, %edx
    jne     .skip_scanline

    pushl   less_color
    pushl   %esi
    call    applyScanline
    addl    $8, %esp

.skip_scanline:
    movl    -8(%ebp), %eax
    xorl    %edx, %edx
    divl    max_index
    pushl   %edx
    pushl   %esi
    call    applyPhosphor
    addl    $8, %esp

    incl    -8(%ebp)
    jmp     .inner_loop

.next_row:
    incl    -4(%ebp)
    jmp     .outer_loop
   
.done:
    addl    $8, %esp
    popl    %edi
    popl    %esi
    popl    %ebx
    # epilogue
    leave 
    ret 
