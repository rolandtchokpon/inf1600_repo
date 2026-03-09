/*
    Vous pouvez modifier le liens des images. SVP mettre leur source si pris en ligne.

    Commandes:

	make : compile le projet en générant l’exécutable principal.
	make run : compile le projet (si nécessaire) puis exécute l’application.
	make test : lance la suite de tests prévue pour vérifier le bon fonctionnement des fonctions et filtres implémentés.
	make remise : crée un fichier zip contenant l’ensemble des fichiers nécessaires pour la remise du projet, prêt à être soumis.

*/

.data 

inputCrt: 
    .asciz "images/image.png"

outputCrt:
    .asciz "crt.png"

outputSierpinski:
    .asciz "sierpinski.png"


.text 
.globl main                      

main:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  
    subl    $28, %esp                  # -12..-1 crt img, -24..-13 sierp img, -28..-25 color

    #################### Filtre CRT #######################

    # TODO: Charger l'image inputCrt en appelant loadImage()
    leal    -12(%ebp), %eax
    pushl   %eax
    pushl   $inputCrt
    call    loadImage
    addl    $8, %esp

    # TODO: Appliquer le filtre crtFilter() sur cette image
    pushl   $2
    leal    -12(%ebp), %eax
    pushl   %eax
    call    crtFilter
    addl    $8, %esp

    # TODO: Sauvegarder cette image dans le fichier outputCrt avec saveImage()
    leal    -12(%ebp), %eax
    pushl   %eax
    pushl   $outputCrt
    call    saveImage
    addl    $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    leal    -12(%ebp), %eax
    pushl   %eax
    call    freeImage
    addl    $4, %esp

    #################### Triangle de Sierpinski #######################


    # TODO: Créer une image vide de taille d'une puissance de 2 en appelant createImage()
    # Puisque createImage() retourne une struct Image, il faut d’abord allouer de l’espace sur la pile pour l’image, puit push l’adresse de cet espace comme 3e paramètre avant de call la fonction.
    leal    -24(%ebp), %eax
    pushl   $1024
    pushl   $1024
    pushl   %eax
    call    createImage
    addl    $12, %esp

    # TODO: Dessiner le triangle de Sierpinski avec la fonction récursive sierpinskiImage()
    movb    $227, -28(%ebp)
    movb    $171, -27(%ebp)
    movb    $59, -26(%ebp)
    movb    $255, -25(%ebp)

    pushl   -28(%ebp)
    leal    -24(%ebp), %eax
    pushl   %eax
    pushl   $1024
    pushl   $0
    pushl   $0
    call    sierpinskiImage
    addl    $20, %esp

    # TODO: Sauvegarder cette image dans le fichier outputSierpinski avec saveImage()
    leal    -24(%ebp), %eax
    pushl   %eax
    pushl   $outputSierpinski
    call    saveImage
    addl    $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    leal    -24(%ebp), %eax
    pushl   %eax
    call    freeImage
    addl    $4, %esp




    movl    $0, %eax
    # epilogue
    leave 
    ret   
