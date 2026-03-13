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
               

    #################### Filtre CRT #######################

    # TODO: Charger l'image inputCrt en appelant loadImage()
    #charger limage
    subl    $12, %esp #reserver 12octets pour le type struct image
    subl    $4, %esp #reserver pour color
    subl    $12, %esp #nouvelle image
    movl    $inputCrt, %ecx 
    leal    -12(%ebp), %eax #recuperer ladresse de limage

    pushl %eax
    pushl %ecx
    call loadImage
    addl $8, %esp
    cmpl $0, %eax
    je fin_main
    # TODO: Appliquer le filtre crtFilter() sur cette image
    
    leal -12(%ebp), %eax

    pushl $5
    pushl %eax
    call  crtFilter
    addl  $8, %esp

    # TODO: Sauvegarder cette image dans le fichier outputCrt avec saveImage()
    leal -12(%ebp), %eax
    movl $outputCrt, %ecx

    pushl %eax
    pushl %ecx
    call saveImage
    addl $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    leal -12(%ebp), %eax

    pushl %eax
    call freeImage
    addl $4, %esp
    #################### Triangle de Sierpinski #######################


    # TODO: Créer une image vide de taille d'une puissance de 2 en appelant createImage()
    # Puisque createImage() retourne une struct Image, il faut d’abord allouer de l’espace sur la pile pour l’image, puit push l’adresse de cet espace comme 3e paramètre avant de call la fonction.
    leal -28(%ebp), %ebx

    pushl $1024 # height
    pushl $1024 # width
    pushl %ebx # adresse de retour (img)
    call createImage
    addl $8, %esp # enlever width + height
    # TODO: Dessiner le triangle de Sierpinski avec la fonction récursive sierpinskiImage()
    movb $255, -16(%ebp)
    movb $255, -15(%ebp)
    movb $255, -14(%ebp)
    movb $255, -13(%ebp)
    movl -16(%ebp), %eax
    leal -28(%ebp), %ebx

    pushl %eax
    pushl %ebx
    pushl $1024
    pushl $0
    pushl $0
    call sierpinskiImage
    addl $20, %esp
    # TODO: Sauvegarder cette image dans le fichier outputSierpinski avec saveImage()
    leal -28(%ebp), %eax
    movl $outputSierpinski, %ecx

    pushl %eax
    pushl %ecx
    call saveImage
    addl $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    leal -28(%ebp), %eax

    pushl %eax
    call freeImage
    addl $4, %esp


    fin_main:
    movl    $0, %eax
    # epilogue
    leave 
    ret   
