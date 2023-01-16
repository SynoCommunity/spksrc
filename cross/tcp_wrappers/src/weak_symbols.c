 /*
  * @(#) weak_symbols.h 1.5 99/12/29 23:50
  * 
  * Author: Anthony Towns <ajt@debian.org>
  */

#ifdef HAVE_WEAKSYMS
#include <syslog.h>
int deny_severity = LOG_WARNING;
int allow_severity = SEVERITY; 
#endif
