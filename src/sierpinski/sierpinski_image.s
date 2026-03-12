/*
Implementation en C:
void sierpinskiImage(uint32_t x, uint32_t y, uint32_t size, Image& img, Pixel color) {
    // vérifier les bornes
    if (x >= img.largeur || y >= img.hauteur) return;

    // Cas de base: dessiner un seul pixel
    if (size == 1) {
        img.pixels[y][x] = color;
        return;
    }

    uint32_t half = size / 2;

    // Triangle en bas à gauche
    sierpinskiImage(x, y + half, half, img, color);
    // Triangle en bas à droite
    sierpinskiImage(x + half, y + half, half, img, color);
    // Triangle du haut
    sierpinskiImage(x + half / 2, y, half, img, color);
}

L’algorithme fonctionne mieux avec des tailles puissances de 2.
L’appel de la fonction dans le main sera ainsi : sierpinskiImage(0, 0, 1024, img, color);
*/

.data 

.text 
.globl sierpinskiImage                      

sierpinskiImage:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp  
    subl    $12, %esp       #Pour half, x, y       

    pushl %edi
    pushl %esi
    pushl %ebx
    # TODO
    #charger image
    movl 20(%ebp), %ecx

    #pointe ladresse de pixel** de image
    movl 8(%ecx), %edi

    #recuperation de color
    movl 24(%ebp), %ebx

    #verification des bornes
    movl 8(%ebp), %eax
    cmpl 0(%ecx), %eax
    jae fin

    movl 12(%ebp), %eax
    cmpl 4(%ecx), %eax
    jae fin

    #cas de base: dessiner un seul pixel
    movl 16(%ebp), %eax
    cmpl $1, %eax
    jne calculHalf

    dessinerPixel:
        movl 12(%ebp), %eax
        movl (%edi, %eax, 4), %edx
        movl 8(%ebp), %eax
        leal (%edx, %eax, 4), %esi
        movl %ebx, (%esi)
        jmp fin
    

    calculHalf:
    #le resultat de half
    movl 16(%ebp), %eax
    movl $2, %esi
    xorl %edx, %edx
    divl %esi
    movl %eax, -4(%ebp)

  

    #Triangle en bas a gauche
    #Calcul du new y
    movl 12(%ebp), %eax
    addl -4(%ebp), %eax

    #Premier appel de sierpinski
    pushl %ebx
    pushl 20(%ebp)
    pushl -4(%ebp)
    pushl %eax
    pushl 8(%ebp)
    call sierpinskiImage
    add $20, %esp

    #Triangle en bas a droite
    movl  8(%ebp), %eax
    addl -4(%ebp), %eax
    movl %eax, -8(%ebp) #new x

    movl  12(%ebp), %eax
    addl -4(%ebp), %eax
    movl %eax, -12(%ebp) #new y

    pushl %ebx
    pushl 20(%ebp)
    pushl -4(%ebp)
    pushl -12(%ebp)
    pushl -8(%ebp)   
    call sierpinskiImage
    add $20, %esp

    #Triangle du haut
    movl -4(%ebp), %eax
    xorl %edx, %edx
    movl $2, %ecx
    divl %ecx
    addl 8(%ebp), %eax

    pushl %ebx
    pushl 20(%ebp)
    pushl -4(%ebp)
    pushl 12(%ebp)
    pushl %eax  
    call sierpinskiImage
    addl $20, %esp

    fin:
    popl %ebx
    popl %esi
    popl %edi
    # epilogue
    leave 
    ret   
