/*
 * Tcl 9.0 Compatibility Layer for Expect
 *
 * Tcl 9 removed deprecated macros and changed function signatures.
 * This header restores compatibility for code written for Tcl 8.x.
 */
#ifndef TCL9_COMPAT_H
#define TCL9_COMPAT_H

#include <stdarg.h>

/* Removed ANSI compatibility macros */
#ifndef _ANSI_ARGS_
#define _ANSI_ARGS_(x) x
#endif

/* Removed const macros */
#ifndef CONST
#define CONST const
#endif
#ifndef CONST84
#define CONST84 const
#endif
#ifndef CONST86
#define CONST86 const
#endif

/* Removed varargs macros */
#ifndef TCL_VARARGS
#define TCL_VARARGS(type, name) (type name, ...)
#endif
#ifndef TCL_VARARGS_DEF
#define TCL_VARARGS_DEF(type, name) (type name, ...)
#endif
#ifndef TCL_VARARGS_START
#define TCL_VARARGS_START(type, name, list) (va_start(list, name), name)
#endif

/* Renamed Unicode functions (now UTF-based) */
#ifndef Tcl_UniCharNcmp
#define Tcl_UniCharNcmp Tcl_UtfNcmp
#endif
#ifndef Tcl_UniCharNcasecmp
#define Tcl_UniCharNcasecmp Tcl_UtfNcasecmp
#endif

#endif /* TCL9_COMPAT_H */

/*
 * Tcl_EvalTokens wrapper - MUST be outside the include guard.
 * Tcl 9 removed Tcl_EvalTokens in favour of Tcl_EvalTokensStandard.
 */
#if defined(_TCL) && !defined(TCL9_EVALTOKENS_DEFINED)
#define TCL9_EVALTOKENS_DEFINED
static inline Tcl_Obj* Tcl_EvalTokens_Compat(
    Tcl_Interp *interp, Tcl_Token *tokenPtr, Tcl_Size count)
{
    if (Tcl_EvalTokensStandard(interp, tokenPtr, count) != TCL_OK) return NULL;
    Tcl_Obj *result = Tcl_GetObjResult(interp);
    Tcl_IncrRefCount(result);
    return result;
}
#define Tcl_EvalTokens Tcl_EvalTokens_Compat
#endif
