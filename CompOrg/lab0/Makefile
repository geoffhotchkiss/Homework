#
# Makefile for CompOrg Experiment 0 - bubble sort
#

#
# Location of the processing programs
#
RASM  = /home/fac/wrc/bin/rasm
RLINK = /home/fac/wrc/bin/rlink

#
# Suffixes to be used or created
#
.SUFFIXES:	.asm .obj .lst .out

#
# Transformation rule: .asm into .obj
#
.asm.obj:
	$(RASM) -l $*.asm > $*.lst

#
# Transformation rule: .obj into .out
#
.obj.out:
	$(RLINK) -o $*.out $*.obj

#
# Main target
#
bubble.out:	bubble.obj

clean:
	rm *.obj *.lst *.out
