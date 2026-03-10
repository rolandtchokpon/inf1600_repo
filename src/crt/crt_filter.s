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

    #reserver de la memoire pour x et y
    subl $8, %esp                 

    # TODO
    pushl %edi
    pushl %esi
    pushl %ebx

    #charger image
    movl 8(%ebp), %ecx
    #recupere pixel** dimage struct
    movl 8(%ecx), %edi

    #initialiser y
    movl $0, -4(%ebp)
boucle_y:
    movl 8(%ebp), %ecx
    movl -4(%ebp), %eax
    cmpl  4(%ecx), %eax
    jae fin
    
    #recuperer le numero de ligne du pixel courant
    movl (%edi, %eax, 4), %ebx

    #initialiser x
    movl $0, -8(%ebp)
boucle_x:
    movl 8(%ebp), %ecx
    movl -8(%ebp), %eax
    cmpl 0(%ecx), %eax
    jae ligne_suivante

    #recuperer ladresse du pixel sur x
    leal (%ebx, %eax, 4), %esi

    #on controle que y soit multiple de scanlineSpacing
    movl -4(%ebp), %eax
    xorl %edx, %edx
    movl 12(%ebp), %ecx
    divl %ecx
    cmpl $0, %edx
    jne apply_scanline

    #si multiple appliquer 60% dassombrissement
    pushl less_color
    pushl %esi
    call applyScanline
    add $8, %esp
    jmp apply_phosphor

    #sinon garder lasssombrissement 100%
    apply_scanline:
    pushl full_color
    pushl %esi
    call applyScanline
    add $8, %esp

    #determiner la position horizontal du pixel
    apply_phosphor:
    movl -8(%ebp), %eax
    xorl %edx, %edx
    movl max_index, %ecx
    divl %ecx
    
    #appel dapplyPhosphor
    pushl %edx
    pushl %esi
    call applyPhosphor
    add $8, %esp

    #incrementation de x pour passer a la valeur suivante
    incl -8(%ebp)
    jmp boucle_x

    ligne_suivante:
    incl -4(%ebp)
    jmp boucle_y

    # epilogue
    fin:
    popl %ebx
    popl %esi
    popl %edi
    leave 
    ret 
