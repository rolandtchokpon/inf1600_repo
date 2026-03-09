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
    pushl   %ebx
    pushl   %esi
    pushl   %edi

    subl    $4, %esp            # -4: half

    movl    20(%ebp), %eax      # &img

    movl    8(%ebp), %edx       # x
    cmpl    (%eax), %edx
    jae     .done

    movl    12(%ebp), %edx      # y
    cmpl    4(%eax), %edx
    jae     .done

    cmpl    $1, 16(%ebp)
    jne     .recurse

    movl    8(%eax), %eax       # img.pixels
    movl    12(%ebp), %edx      # y
    movl    (%eax, %edx, 4), %eax
    movl    8(%ebp), %edx       # x
    leal    (%eax, %edx, 4), %eax
    movl    24(%ebp), %edx      # color
    movl    %edx, (%eax)
    jmp     .done

.recurse:
    movl    16(%ebp), %eax
    shrl    $1, %eax
    movl    %eax, -4(%ebp)

    # Bottom-left
    pushl   24(%ebp)
    pushl   20(%ebp)
    pushl   -4(%ebp)
    movl    12(%ebp), %eax
    addl    -4(%ebp), %eax
    pushl   %eax
    pushl   8(%ebp)
    call    sierpinskiImage
    addl    $20, %esp

    # Bottom-right
    pushl   24(%ebp)
    pushl   20(%ebp)
    pushl   -4(%ebp)
    movl    12(%ebp), %eax
    addl    -4(%ebp), %eax
    pushl   %eax
    movl    8(%ebp), %eax
    addl    -4(%ebp), %eax
    pushl   %eax
    call    sierpinskiImage
    addl    $20, %esp

    # Top
    pushl   24(%ebp)
    pushl   20(%ebp)
    pushl   -4(%ebp)
    pushl   12(%ebp)
    movl    -4(%ebp), %eax
    shrl    $1, %eax
    addl    8(%ebp), %eax
    pushl   %eax
    call    sierpinskiImage
    addl    $20, %esp

.done:
    addl    $4, %esp
    popl    %edi
    popl    %esi
    popl    %ebx
    # epilogue
    leave 
    ret   
