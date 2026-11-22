#!/bin/sh
# Reviewed Tcl 9 port from the NixOS Expect 5.45.4 patch set.
set -e

# Tcl 9 compatibility transformations used by the reviewed NixOS port.
for f in *.h; do
    [ "$f" != "tcl9_compat.h" ] && sed -i '1i #include "tcl9_compat.h"' "$f"
done
for f in *.c; do
    sed -i '1i #include "tcl9_compat.h"' "$f"
done

sed -i 's/Tcl_InitStubs(interp, "8.1"/Tcl_InitStubs(interp, "9.0"/g' exp_main_sub.c

# Tcl_Size length parameters
sed -i 's/int strlen;$/Tcl_Size strlen;/' expect.c
sed -i 's/int plen;$/Tcl_Size plen;/' expect.c
sed -i 's/int start, end;/Tcl_Size start, end;/g' expect.c
sed -i 's/int match;.*\*.*chars that matched/Tcl_Size match; \/* # of chars that matched/g' expect.c
sed -i 's/int match = -1;.*characters matched/Tcl_Size match = -1;\t\t\/* characters matched/g' expect.c

# 64-bit match_max and buffer sizes
sed -i 's/^int exp_default_match_max/Tcl_WideInt exp_default_match_max/' expect.c
sed -i 's/int size = -1;$/Tcl_WideInt size = -1;/' expect.c
sed -i 's/Tcl_GetIntFromObj (interp, objv\[i\], \&size)/Tcl_GetWideIntFromObj(interp, objv[i], \&size)/' expect.c
sed -i 's/Tcl_SetObjResult (interp, Tcl_NewIntObj (size));/Tcl_SetObjResult(interp, Tcl_NewWideIntObj(size));/' expect.c
sed -i 's/EXTERN int exp_default_match_max;/EXTERN Tcl_WideInt exp_default_match_max;/' exp_command.h
sed -i 's/int umsize;/Tcl_WideInt umsize;/' exp_command.h
sed -i 's/int          max;       \/\* number of CHARS/Tcl_Size     max;       \/* number of CHARS/' exp_command.h
sed -i 's/int          use;       \/\* number of CHARS/Tcl_Size     use;       \/* number of CHARS/' exp_command.h
sed -i 's/int new_msize, excess;/Tcl_Size new_msize, excess;/' expect.c
sed -i 's/int numchars, flags, dummy, globmatch;/Tcl_Size numchars, flags, dummy, globmatch;/' expect.c
sed -i 's/int numchars, newlen, skiplen;/Tcl_Size numchars, newlen, skiplen;/' expect.c
sed -i 's/\tint numchars;$/\tTcl_Size numchars;/' expect.c
sed -i 's/^    int numchars;$/    Tcl_Size numchars;/' exp_inter.c
sed -i 's/    int cc;$/    Tcl_Size cc;/' exp_inter.c
