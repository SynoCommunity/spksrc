/* PGO training input for cc1: a wide, shallow translation unit that exercises the
   passes a package build actually spends its time in -- parsing at volume, inlining,
   loop and arithmetic optimisation, register allocation -- without needing anything
   from the target beyond libc headers. Compiled at -O2 and -O3 by gcc-pgo-train. */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
int t0(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t3(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t4(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t5(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t6(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t7(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t8(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t9(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t10(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t11(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t12(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t13(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t14(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t15(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t16(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t17(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t18(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t19(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t20(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t21(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t22(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t23(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t24(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t25(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t26(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t27(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t28(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t29(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t30(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t31(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t32(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t33(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t34(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t35(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t36(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t37(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t38(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t39(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t40(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t41(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t42(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t43(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t44(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t45(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t46(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t47(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t48(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t49(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t50(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t51(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t52(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t53(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t54(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t55(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t56(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t57(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t58(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t59(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t60(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t61(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t62(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t63(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t64(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t65(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t66(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t67(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t68(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t69(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t70(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t71(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t72(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t73(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t74(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t75(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t76(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t77(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t78(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t79(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t80(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t81(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t82(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t83(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t84(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t85(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t86(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t87(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t88(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t89(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t90(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t91(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t92(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t93(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t94(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t95(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t96(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t97(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t98(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t99(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t100(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t101(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t102(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t103(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t104(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t105(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t106(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t107(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t108(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t109(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t110(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t111(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t112(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t113(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t114(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t115(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t116(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t117(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t118(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t119(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t120(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t121(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t122(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t123(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t124(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t125(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t126(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t127(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t128(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t129(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t130(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t131(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t132(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t133(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t134(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t135(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t136(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t137(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t138(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t139(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t140(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t141(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t142(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t143(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t144(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t145(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t146(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t147(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t148(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t149(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t150(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t151(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t152(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t153(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t154(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t155(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t156(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t157(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t158(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t159(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t160(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t161(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t162(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t163(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t164(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t165(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t166(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t167(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t168(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t169(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t170(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t171(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t172(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t173(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t174(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t175(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t176(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t177(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t178(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t179(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t180(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t181(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t182(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t183(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t184(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t185(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t186(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t187(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t188(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t189(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t190(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t191(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t192(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t193(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t194(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t195(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t196(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t197(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t198(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t199(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t200(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t201(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t202(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t203(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t204(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t205(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t206(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t207(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t208(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t209(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t210(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t211(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t212(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t213(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t214(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t215(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t216(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t217(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t218(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t219(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t220(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t221(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t222(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t223(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t224(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t225(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t226(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t227(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t228(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t229(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t230(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t231(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t232(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t233(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t234(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t235(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t236(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t237(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t238(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t239(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t240(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t241(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t242(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t243(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t244(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t245(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t246(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t247(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t248(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t249(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t250(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t251(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t252(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t253(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t254(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t255(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t256(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t257(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t258(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t259(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t260(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t261(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t262(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t263(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t264(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t265(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t266(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t267(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t268(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t269(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t270(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t271(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t272(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t273(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t274(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t275(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t276(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t277(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t278(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t279(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t280(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t281(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t282(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t283(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t284(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t285(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t286(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t287(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t288(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t289(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t290(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t291(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t292(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t293(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t294(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t295(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t296(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t297(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t298(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t299(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t300(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t301(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t302(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t303(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t304(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t305(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t306(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t307(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t308(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t309(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t310(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t311(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t312(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t313(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t314(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t315(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t316(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t317(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t318(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t319(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t320(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t321(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t322(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t323(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t324(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t325(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t326(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t327(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t328(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t329(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t330(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t331(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t332(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t333(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t334(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t335(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t336(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t337(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t338(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t339(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t340(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t341(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t342(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t343(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t344(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t345(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t346(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t347(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t348(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t349(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t350(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t351(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t352(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t353(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t354(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t355(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t356(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t357(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t358(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t359(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t360(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t361(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t362(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t363(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t364(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t365(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t366(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t367(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t368(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t369(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t370(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t371(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t372(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t373(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t374(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t375(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t376(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t377(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t378(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t379(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t380(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t381(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t382(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t383(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t384(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t385(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t386(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t387(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t388(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t389(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t390(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t391(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t392(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t393(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t394(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t395(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t396(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t397(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t398(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t399(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t400(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t401(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t402(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t403(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t404(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t405(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t406(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t407(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t408(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t409(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t410(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t411(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t412(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t413(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t414(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t415(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t416(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t417(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t418(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t419(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t420(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t421(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t422(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t423(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t424(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t425(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t426(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t427(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t428(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t429(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t430(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t431(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t432(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t433(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t434(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t435(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t436(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t437(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t438(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t439(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t440(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t441(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t442(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t443(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t444(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t445(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t446(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t447(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t448(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t449(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t450(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t451(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t452(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t453(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t454(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t455(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t456(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t457(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t458(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t459(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t460(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t461(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t462(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t463(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t464(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t465(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t466(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t467(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t468(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t469(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t470(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t471(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t472(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t473(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t474(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t475(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t476(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t477(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t478(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t479(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t480(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t481(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t482(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t483(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t484(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t485(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t486(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t487(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t488(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t489(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t490(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t491(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t492(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t493(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t494(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t495(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t496(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t497(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t498(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t499(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t500(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t501(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t502(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t503(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t504(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t505(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t506(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t507(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t508(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t509(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t510(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t511(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t512(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t513(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t514(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t515(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t516(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t517(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t518(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t519(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t520(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t521(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t522(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t523(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t524(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t525(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t526(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t527(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t528(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t529(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t530(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t531(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t532(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t533(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t534(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t535(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t536(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t537(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t538(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t539(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t540(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t541(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t542(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t543(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t544(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t545(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t546(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t547(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t548(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t549(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t550(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t551(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t552(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t553(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t554(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t555(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t556(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t557(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t558(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t559(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t560(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t561(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t562(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t563(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t564(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t565(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t566(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t567(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t568(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t569(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t570(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t571(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t572(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t573(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t574(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t575(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t576(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t577(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t578(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t579(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t580(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t581(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t582(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t583(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t584(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t585(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t586(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t587(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t588(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t589(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t590(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t591(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t592(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t593(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t594(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t595(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t596(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t597(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t598(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t599(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t600(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t601(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t602(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t603(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t604(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t605(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t606(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t607(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t608(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t609(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t610(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t611(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t612(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t613(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t614(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t615(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t616(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t617(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t618(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t619(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t620(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t621(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t622(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t623(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t624(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t625(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t626(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t627(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t628(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t629(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t630(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t631(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t632(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t633(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t634(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t635(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t636(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t637(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t638(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t639(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t640(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t641(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t642(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t643(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t644(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t645(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t646(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t647(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t648(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t649(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t650(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t651(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t652(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t653(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t654(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t655(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t656(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t657(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t658(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t659(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t660(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t661(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t662(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t663(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t664(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t665(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t666(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t667(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t668(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t669(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t670(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t671(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t672(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t673(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t674(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t675(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t676(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t677(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t678(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t679(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t680(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t681(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t682(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t683(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t684(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t685(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t686(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t687(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t688(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t689(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t690(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t691(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t692(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t693(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t694(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t695(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t696(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t697(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t698(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t699(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t700(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t701(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t702(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t703(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t704(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t705(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t706(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t707(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t708(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t709(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t710(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t711(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t712(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t713(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t714(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t715(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t716(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t717(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t718(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t719(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t720(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t721(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t722(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t723(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t724(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t725(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t726(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t727(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t728(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t729(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t730(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t731(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t732(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t733(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t734(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t735(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t736(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t737(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t738(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t739(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t740(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t741(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t742(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t743(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t744(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t745(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t746(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t747(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t748(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t749(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t750(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t751(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t752(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t753(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t754(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t755(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t756(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t757(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t758(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t759(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t760(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t761(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t762(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t763(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t764(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t765(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t766(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t767(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t768(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t769(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t770(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t771(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t772(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t773(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t774(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t775(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t776(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t777(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t778(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t779(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t780(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t781(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t782(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t783(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t784(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t785(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t786(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t787(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t788(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t789(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t790(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t791(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t792(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t793(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t794(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t795(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t796(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t797(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t798(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t799(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t800(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t801(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t802(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t803(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t804(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t805(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t806(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t807(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t808(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t809(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t810(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t811(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t812(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t813(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t814(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t815(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t816(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t817(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t818(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t819(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t820(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t821(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t822(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t823(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t824(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t825(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t826(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t827(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t828(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t829(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t830(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t831(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t832(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t833(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t834(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t835(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t836(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t837(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t838(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t839(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t840(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t841(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t842(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t843(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t844(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t845(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t846(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t847(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t848(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t849(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t850(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t851(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t852(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t853(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t854(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t855(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t856(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t857(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t858(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t859(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t860(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t861(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t862(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t863(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t864(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t865(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t866(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t867(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t868(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t869(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t870(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t871(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t872(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t873(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t874(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t875(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t876(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t877(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t878(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t879(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t880(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t881(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t882(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t883(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t884(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t885(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t886(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t887(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t888(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t889(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t890(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t891(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t892(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t893(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t894(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t895(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t896(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t897(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t898(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t899(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t900(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t901(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t902(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t903(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t904(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t905(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t906(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t907(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t908(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t909(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t910(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t911(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t912(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t913(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t914(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t915(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t916(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t917(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t918(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t919(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t920(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t921(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t922(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t923(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t924(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t925(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t926(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t927(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t928(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t929(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t930(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t931(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t932(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t933(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t934(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t935(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t936(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t937(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t938(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t939(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t940(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t941(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t942(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t943(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t944(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t945(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t946(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t947(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t948(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t949(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t950(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t951(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t952(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t953(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t954(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t955(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t956(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t957(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t958(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t959(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t960(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t961(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t962(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t963(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t964(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t965(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t966(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t967(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t968(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t969(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t970(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t971(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t972(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t973(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t974(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t975(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t976(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t977(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t978(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t979(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t980(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t981(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t982(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t983(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t984(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t985(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t986(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t987(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t988(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t989(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t990(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t991(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t992(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t993(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t994(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t995(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t996(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t997(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t998(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t999(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1000(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1001(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1002(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1003(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1004(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1005(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1006(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1007(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1008(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1009(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1010(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1011(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1012(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1013(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1014(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1015(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1016(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1017(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1018(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1019(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1020(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1021(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1022(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1023(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1024(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1025(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1026(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1027(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1028(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1029(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1030(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1031(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1032(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1033(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1034(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1035(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1036(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1037(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1038(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1039(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1040(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1041(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1042(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1043(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1044(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1045(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1046(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1047(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1048(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1049(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1050(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1051(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1052(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1053(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1054(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1055(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1056(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1057(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1058(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1059(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1060(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1061(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1062(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1063(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1064(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1065(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1066(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1067(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1068(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1069(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1070(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1071(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1072(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1073(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1074(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1075(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1076(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1077(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1078(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1079(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1080(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1081(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1082(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1083(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1084(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1085(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1086(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1087(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1088(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1089(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1090(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1091(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1092(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1093(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1094(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1095(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1096(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1097(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1098(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1099(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1100(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1101(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1102(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1103(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1104(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1105(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1106(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1107(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1108(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1109(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1110(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1111(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1112(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1113(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1114(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1115(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1116(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1117(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1118(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1119(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1120(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1121(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1122(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1123(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1124(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1125(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1126(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1127(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1128(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1129(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1130(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1131(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1132(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1133(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1134(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1135(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1136(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1137(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1138(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1139(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1140(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1141(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1142(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1143(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1144(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1145(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1146(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1147(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1148(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1149(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1150(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1151(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1152(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1153(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1154(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1155(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1156(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1157(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1158(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1159(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1160(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1161(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1162(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1163(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1164(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1165(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1166(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1167(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1168(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1169(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1170(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1171(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1172(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1173(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1174(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1175(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1176(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1177(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1178(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1179(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1180(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1181(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1182(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1183(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1184(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1185(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1186(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1187(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1188(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1189(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1190(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1191(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1192(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1193(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1194(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1195(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1196(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1197(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1198(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1199(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1200(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1201(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1202(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1203(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1204(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1205(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1206(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1207(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1208(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1209(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1210(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1211(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1212(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1213(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1214(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1215(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1216(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1217(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1218(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1219(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1220(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1221(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1222(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1223(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1224(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1225(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1226(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1227(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1228(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1229(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1230(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1231(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1232(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1233(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1234(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1235(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1236(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1237(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1238(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1239(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1240(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1241(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1242(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1243(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1244(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1245(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1246(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1247(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1248(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1249(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1250(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1251(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1252(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1253(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1254(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1255(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1256(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1257(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1258(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1259(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1260(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1261(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1262(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1263(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1264(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1265(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1266(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1267(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1268(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1269(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1270(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1271(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1272(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1273(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1274(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1275(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1276(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1277(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1278(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1279(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1280(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1281(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1282(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1283(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1284(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1285(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1286(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1287(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1288(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1289(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1290(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1291(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1292(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1293(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1294(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1295(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1296(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1297(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1298(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1299(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1300(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1301(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1302(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1303(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1304(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1305(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1306(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1307(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1308(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1309(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1310(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1311(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1312(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1313(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1314(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1315(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1316(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1317(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1318(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1319(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1320(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1321(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1322(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1323(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1324(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1325(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1326(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1327(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1328(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1329(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1330(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1331(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1332(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1333(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1334(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1335(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1336(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1337(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1338(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1339(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1340(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1341(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1342(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1343(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1344(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1345(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1346(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1347(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1348(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1349(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1350(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1351(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1352(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1353(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1354(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1355(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1356(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1357(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1358(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1359(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1360(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1361(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1362(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1363(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1364(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1365(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1366(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1367(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1368(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1369(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1370(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1371(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1372(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1373(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1374(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1375(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1376(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1377(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1378(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1379(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1380(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1381(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1382(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1383(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1384(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1385(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1386(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1387(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1388(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1389(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1390(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1391(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1392(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1393(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1394(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1395(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1396(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1397(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1398(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1399(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1400(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1401(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1402(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1403(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1404(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1405(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1406(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1407(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1408(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1409(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1410(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1411(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1412(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1413(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1414(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1415(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1416(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1417(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1418(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1419(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1420(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1421(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1422(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1423(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1424(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1425(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1426(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1427(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1428(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1429(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1430(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1431(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1432(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1433(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1434(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1435(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1436(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1437(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1438(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1439(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1440(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1441(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1442(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1443(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1444(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1445(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1446(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1447(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1448(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1449(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1450(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1451(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1452(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1453(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1454(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1455(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1456(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1457(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1458(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1459(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1460(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1461(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1462(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1463(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1464(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1465(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1466(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1467(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1468(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1469(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1470(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1471(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1472(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1473(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1474(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1475(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1476(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1477(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1478(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1479(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1480(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1481(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1482(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1483(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1484(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1485(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1486(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1487(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1488(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1489(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1490(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1491(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1492(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1493(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1494(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1495(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1496(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1497(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1498(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1499(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1500(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1501(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1502(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1503(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1504(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1505(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1506(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1507(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1508(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1509(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1510(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1511(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1512(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1513(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1514(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1515(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1516(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1517(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1518(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1519(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1520(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1521(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1522(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1523(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1524(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1525(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1526(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1527(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1528(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1529(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1530(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1531(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1532(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1533(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1534(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1535(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1536(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1537(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1538(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1539(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1540(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1541(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1542(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1543(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1544(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1545(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1546(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1547(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1548(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1549(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1550(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1551(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1552(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1553(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1554(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1555(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1556(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1557(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1558(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1559(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1560(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1561(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1562(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1563(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1564(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1565(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1566(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1567(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1568(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1569(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1570(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1571(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1572(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1573(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1574(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1575(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1576(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1577(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1578(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1579(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1580(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1581(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1582(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1583(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1584(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1585(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1586(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1587(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1588(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1589(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1590(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1591(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1592(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1593(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1594(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1595(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1596(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1597(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1598(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1599(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1600(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1601(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1602(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1603(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1604(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1605(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1606(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1607(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1608(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1609(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1610(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1611(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1612(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1613(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1614(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1615(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1616(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1617(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1618(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1619(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1620(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1621(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1622(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1623(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1624(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1625(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1626(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1627(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1628(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1629(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1630(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1631(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1632(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1633(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1634(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1635(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1636(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1637(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1638(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1639(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1640(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1641(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1642(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1643(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1644(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1645(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1646(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1647(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1648(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1649(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1650(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1651(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1652(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1653(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1654(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1655(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1656(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1657(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1658(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1659(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1660(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1661(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1662(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1663(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1664(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1665(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1666(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1667(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1668(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1669(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1670(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1671(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1672(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1673(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1674(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1675(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1676(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1677(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1678(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1679(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1680(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1681(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1682(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1683(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1684(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1685(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1686(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1687(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1688(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1689(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1690(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1691(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1692(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1693(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1694(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1695(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1696(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1697(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1698(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1699(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1700(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1701(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1702(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1703(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1704(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1705(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1706(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1707(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1708(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1709(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1710(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1711(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1712(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1713(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1714(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1715(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1716(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1717(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1718(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1719(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1720(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1721(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1722(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1723(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1724(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1725(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1726(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1727(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1728(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1729(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1730(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1731(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1732(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1733(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1734(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1735(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1736(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1737(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1738(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1739(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1740(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1741(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1742(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1743(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1744(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1745(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1746(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1747(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1748(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1749(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1750(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1751(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1752(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1753(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1754(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1755(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1756(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1757(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1758(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1759(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1760(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1761(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1762(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1763(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1764(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1765(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1766(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1767(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1768(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1769(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1770(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1771(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1772(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1773(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1774(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1775(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1776(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1777(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1778(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1779(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1780(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1781(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1782(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1783(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1784(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1785(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1786(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1787(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1788(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1789(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1790(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1791(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1792(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1793(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1794(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1795(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1796(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1797(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1798(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1799(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1800(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1801(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1802(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1803(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1804(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1805(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1806(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1807(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1808(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1809(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1810(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1811(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1812(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1813(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1814(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1815(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1816(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1817(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1818(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1819(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1820(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1821(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1822(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1823(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1824(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1825(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1826(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1827(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1828(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1829(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1830(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1831(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1832(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1833(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1834(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1835(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1836(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1837(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1838(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1839(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1840(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1841(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1842(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1843(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1844(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1845(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1846(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1847(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1848(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1849(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1850(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1851(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1852(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1853(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1854(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1855(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1856(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1857(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1858(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1859(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1860(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1861(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1862(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1863(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1864(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1865(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1866(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1867(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1868(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1869(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1870(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1871(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1872(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1873(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1874(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1875(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1876(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1877(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1878(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1879(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1880(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1881(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1882(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1883(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1884(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1885(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1886(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1887(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1888(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1889(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1890(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1891(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1892(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1893(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1894(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1895(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1896(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1897(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1898(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1899(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1900(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1901(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1902(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1903(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1904(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1905(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1906(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1907(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1908(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1909(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1910(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1911(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1912(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1913(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1914(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1915(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1916(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1917(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1918(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1919(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1920(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1921(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1922(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1923(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1924(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1925(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1926(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1927(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1928(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1929(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1930(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1931(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1932(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1933(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1934(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1935(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1936(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1937(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1938(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1939(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1940(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1941(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1942(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1943(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1944(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1945(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1946(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1947(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1948(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1949(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1950(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1951(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1952(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1953(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1954(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1955(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1956(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1957(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1958(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1959(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1960(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1961(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1962(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1963(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1964(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1965(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1966(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1967(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1968(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1969(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1970(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1971(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1972(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1973(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1974(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1975(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1976(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1977(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1978(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1979(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1980(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1981(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1982(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1983(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1984(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1985(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1986(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1987(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1988(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1989(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1990(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1991(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1992(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1993(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1994(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1995(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1996(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1997(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1998(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t1999(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2000(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2001(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2002(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2003(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2004(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2005(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2006(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2007(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2008(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2009(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2010(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2011(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2012(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2013(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2014(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2015(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2016(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2017(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2018(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2019(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2020(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2021(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2022(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2023(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2024(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2025(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2026(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2027(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2028(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2029(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2030(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2031(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2032(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2033(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2034(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2035(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2036(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2037(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2038(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2039(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2040(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2041(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2042(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2043(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2044(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2045(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2046(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2047(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2048(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2049(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2050(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2051(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2052(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2053(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2054(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2055(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2056(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2057(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2058(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2059(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2060(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2061(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2062(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2063(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2064(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2065(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2066(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2067(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2068(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2069(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2070(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2071(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2072(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2073(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2074(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2075(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2076(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2077(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2078(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2079(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2080(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2081(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2082(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2083(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2084(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2085(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2086(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2087(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2088(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2089(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2090(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2091(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2092(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2093(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2094(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2095(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2096(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2097(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2098(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2099(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2100(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2101(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2102(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2103(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2104(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2105(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2106(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2107(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2108(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2109(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2110(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2111(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2112(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2113(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2114(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2115(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2116(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2117(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2118(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2119(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2120(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2121(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2122(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2123(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2124(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2125(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2126(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2127(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2128(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2129(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2130(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2131(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2132(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2133(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2134(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2135(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2136(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2137(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2138(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2139(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2140(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2141(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2142(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2143(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2144(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2145(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2146(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2147(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2148(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2149(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2150(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2151(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2152(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2153(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2154(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2155(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2156(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2157(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2158(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2159(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2160(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2161(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2162(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2163(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2164(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2165(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2166(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2167(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2168(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2169(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2170(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2171(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2172(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2173(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2174(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2175(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2176(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2177(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2178(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2179(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2180(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2181(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2182(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2183(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2184(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2185(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2186(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2187(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2188(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2189(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2190(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2191(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2192(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2193(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2194(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2195(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2196(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2197(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2198(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2199(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2200(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2201(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2202(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2203(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2204(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2205(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2206(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2207(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2208(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2209(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2210(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2211(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2212(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2213(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2214(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2215(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2216(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2217(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2218(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2219(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2220(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2221(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2222(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2223(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2224(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2225(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2226(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2227(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2228(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2229(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2230(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2231(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2232(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2233(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2234(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2235(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2236(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2237(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2238(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2239(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2240(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2241(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2242(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2243(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2244(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2245(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2246(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2247(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2248(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2249(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2250(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2251(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2252(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2253(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2254(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2255(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2256(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2257(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2258(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2259(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2260(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2261(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2262(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2263(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2264(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2265(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2266(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2267(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2268(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2269(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2270(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2271(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2272(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2273(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2274(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2275(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2276(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2277(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2278(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2279(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2280(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2281(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2282(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2283(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2284(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2285(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2286(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2287(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2288(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2289(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2290(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2291(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2292(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2293(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2294(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2295(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2296(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2297(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2298(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2299(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2300(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2301(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2302(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2303(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2304(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2305(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2306(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2307(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2308(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2309(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2310(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2311(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2312(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2313(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2314(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2315(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2316(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2317(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2318(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2319(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2320(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2321(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2322(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2323(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2324(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2325(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2326(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2327(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2328(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2329(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2330(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2331(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2332(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2333(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2334(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2335(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2336(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2337(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2338(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2339(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2340(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2341(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2342(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2343(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2344(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2345(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2346(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2347(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2348(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2349(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2350(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2351(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2352(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2353(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2354(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2355(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2356(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2357(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2358(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2359(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2360(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2361(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2362(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2363(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2364(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2365(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2366(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2367(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2368(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2369(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2370(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2371(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2372(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2373(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2374(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2375(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2376(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2377(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2378(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2379(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2380(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2381(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2382(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2383(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2384(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2385(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2386(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2387(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2388(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2389(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2390(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2391(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2392(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2393(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2394(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2395(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2396(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2397(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2398(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2399(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2400(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2401(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2402(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2403(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2404(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2405(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2406(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2407(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2408(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2409(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2410(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2411(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2412(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2413(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2414(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2415(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2416(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2417(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2418(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2419(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2420(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2421(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2422(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2423(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2424(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2425(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2426(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2427(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2428(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2429(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2430(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2431(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2432(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2433(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2434(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2435(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2436(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2437(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2438(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2439(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2440(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2441(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2442(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2443(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2444(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2445(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2446(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2447(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2448(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2449(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2450(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2451(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2452(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2453(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2454(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2455(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2456(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2457(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2458(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2459(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2460(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2461(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2462(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2463(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2464(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2465(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2466(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2467(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2468(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2469(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2470(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2471(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2472(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2473(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2474(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2475(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2476(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2477(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2478(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2479(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2480(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2481(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2482(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2483(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2484(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2485(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2486(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2487(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2488(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2489(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2490(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2491(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2492(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2493(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2494(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2495(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2496(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2497(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2498(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
int t2499(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}
struct rec { int id; char name[32]; double w; };
int agg0(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%2==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg1(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%3==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg2(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%4==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg3(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%5==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg4(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%6==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg5(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%7==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg6(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%8==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg7(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%9==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg8(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%10==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg9(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%11==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg10(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%12==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg11(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%13==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg12(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%14==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg13(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%15==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg14(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%16==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg15(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%17==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg16(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%18==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg17(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%19==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg18(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%20==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg19(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%21==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg20(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%22==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg21(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%23==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg22(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%24==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg23(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%25==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg24(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%26==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg25(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%27==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg26(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%28==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg27(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%29==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg28(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%30==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg29(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%31==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg30(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%32==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg31(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%33==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg32(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%34==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg33(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%35==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg34(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%36==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg35(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%37==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg36(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%38==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg37(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%39==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg38(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%40==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg39(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%41==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg40(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%42==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg41(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%43==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg42(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%44==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg43(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%45==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg44(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%46==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg45(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%47==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg46(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%48==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg47(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%49==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg48(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%50==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg49(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%51==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg50(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%52==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg51(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%53==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg52(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%54==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg53(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%55==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg54(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%56==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg55(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%57==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg56(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%58==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg57(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%59==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg58(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%60==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg59(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%61==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg60(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%62==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg61(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%63==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg62(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%64==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg63(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%65==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg64(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%66==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg65(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%67==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg66(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%68==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg67(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%69==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg68(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%70==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg69(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%71==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg70(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%72==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg71(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%73==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg72(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%74==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg73(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%75==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg74(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%76==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg75(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%77==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg76(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%78==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg77(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%79==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg78(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%80==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg79(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%81==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg80(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%82==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg81(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%83==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg82(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%84==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg83(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%85==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg84(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%86==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg85(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%87==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg86(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%88==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg87(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%89==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg88(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%90==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg89(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%91==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg90(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%92==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg91(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%93==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg92(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%94==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg93(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%95==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg94(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%96==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg95(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%97==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg96(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%98==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg97(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%99==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg98(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%100==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg99(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%101==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg100(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%102==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg101(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%103==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg102(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%104==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg103(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%105==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg104(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%106==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg105(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%107==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg106(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%108==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg107(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%109==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg108(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%110==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg109(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%111==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg110(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%112==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg111(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%113==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg112(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%114==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg113(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%115==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg114(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%116==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg115(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%117==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg116(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%118==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg117(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%119==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg118(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%120==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg119(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%121==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg120(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%122==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg121(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%123==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg122(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%124==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg123(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%125==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg124(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%126==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg125(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%127==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg126(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%128==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg127(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%129==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg128(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%130==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg129(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%131==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg130(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%132==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg131(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%133==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg132(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%134==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg133(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%135==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg134(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%136==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg135(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%137==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg136(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%138==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg137(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%139==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg138(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%140==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg139(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%141==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg140(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%142==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg141(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%143==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg142(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%144==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg143(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%145==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg144(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%146==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg145(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%147==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg146(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%148==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg147(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%149==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg148(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%150==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg149(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%151==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg150(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%152==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg151(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%153==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg152(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%154==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg153(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%155==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg154(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%156==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg155(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%157==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg156(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%158==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg157(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%159==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg158(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%160==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg159(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%161==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg160(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%162==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg161(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%163==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg162(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%164==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg163(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%165==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg164(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%166==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg165(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%167==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg166(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%168==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg167(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%169==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg168(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%170==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg169(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%171==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg170(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%172==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg171(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%173==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg172(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%174==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg173(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%175==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg174(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%176==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg175(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%177==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg176(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%178==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg177(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%179==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg178(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%180==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg179(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%181==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg180(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%182==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg181(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%183==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg182(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%184==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg183(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%185==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg184(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%186==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg185(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%187==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg186(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%188==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg187(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%189==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg188(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%190==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg189(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%191==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg190(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%192==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg191(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%193==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg192(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%194==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg193(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%195==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg194(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%196==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg195(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%197==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg196(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%198==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg197(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%199==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg198(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%200==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg199(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%201==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg200(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%202==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg201(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%203==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg202(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%204==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg203(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%205==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg204(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%206==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg205(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%207==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg206(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%208==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg207(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%209==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg208(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%210==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg209(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%211==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg210(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%212==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg211(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%213==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg212(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%214==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg213(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%215==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg214(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%216==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg215(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%217==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg216(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%218==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg217(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%219==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg218(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%220==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg219(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%221==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg220(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%222==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg221(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%223==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg222(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%224==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg223(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%225==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg224(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%226==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg225(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%227==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg226(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%228==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg227(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%229==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg228(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%230==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg229(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%231==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg230(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%232==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg231(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%233==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg232(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%234==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg233(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%235==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg234(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%236==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg235(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%237==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg236(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%238==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg237(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%239==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg238(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%240==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg239(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%241==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg240(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%242==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg241(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%243==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg242(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%244==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg243(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%245==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg244(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%246==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg245(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%247==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg246(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%248==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg247(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%249==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg248(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%250==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg249(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%251==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg250(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%252==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg251(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%253==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg252(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%254==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg253(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%255==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg254(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%256==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg255(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%257==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg256(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%258==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg257(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%259==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg258(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%260==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg259(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%261==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg260(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%262==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg261(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%263==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg262(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%264==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg263(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%265==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg264(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%266==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg265(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%267==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg266(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%268==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg267(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%269==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg268(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%270==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg269(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%271==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg270(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%272==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg271(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%273==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg272(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%274==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg273(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%275==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg274(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%276==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg275(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%277==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg276(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%278==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg277(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%279==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg278(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%280==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg279(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%281==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg280(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%282==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg281(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%283==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg282(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%284==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg283(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%285==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg284(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%286==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg285(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%287==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg286(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%288==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg287(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%289==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg288(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%290==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg289(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%291==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg290(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%292==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg291(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%293==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg292(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%294==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg293(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%295==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg294(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%296==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg295(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%297==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg296(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%298==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg297(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%299==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg298(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%300==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int agg299(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%301==0) s+=v[i].id;
  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }
int main(void){int s=0;s+=t0(s,1);s+=t1(s,2);s+=t2(s,3);s+=t3(s,4);s+=t4(s,5);s+=t5(s,6);s+=t6(s,7);s+=t7(s,8);s+=t8(s,9);s+=t9(s,10);s+=t10(s,11);s+=t11(s,12);s+=t12(s,13);s+=t13(s,14);s+=t14(s,15);s+=t15(s,16);s+=t16(s,17);s+=t17(s,18);s+=t18(s,19);s+=t19(s,20);s+=t20(s,21);s+=t21(s,22);s+=t22(s,23);s+=t23(s,24);s+=t24(s,25);s+=t25(s,26);s+=t26(s,27);s+=t27(s,28);s+=t28(s,29);s+=t29(s,30);s+=t30(s,31);s+=t31(s,32);s+=t32(s,33);s+=t33(s,34);s+=t34(s,35);s+=t35(s,36);s+=t36(s,37);s+=t37(s,38);s+=t38(s,39);s+=t39(s,40);s+=t40(s,41);s+=t41(s,42);s+=t42(s,43);s+=t43(s,44);s+=t44(s,45);s+=t45(s,46);s+=t46(s,47);s+=t47(s,48);s+=t48(s,49);s+=t49(s,50);s+=t50(s,51);s+=t51(s,52);s+=t52(s,53);s+=t53(s,54);s+=t54(s,55);s+=t55(s,56);s+=t56(s,57);s+=t57(s,58);s+=t58(s,59);s+=t59(s,60);s+=t60(s,61);s+=t61(s,62);s+=t62(s,63);s+=t63(s,64);s+=t64(s,65);s+=t65(s,66);s+=t66(s,67);s+=t67(s,68);s+=t68(s,69);s+=t69(s,70);s+=t70(s,71);s+=t71(s,72);s+=t72(s,73);s+=t73(s,74);s+=t74(s,75);s+=t75(s,76);s+=t76(s,77);s+=t77(s,78);s+=t78(s,79);s+=t79(s,80);s+=t80(s,81);s+=t81(s,82);s+=t82(s,83);s+=t83(s,84);s+=t84(s,85);s+=t85(s,86);s+=t86(s,87);s+=t87(s,88);s+=t88(s,89);s+=t89(s,90);s+=t90(s,91);s+=t91(s,92);s+=t92(s,93);s+=t93(s,94);s+=t94(s,95);s+=t95(s,96);s+=t96(s,97);s+=t97(s,98);s+=t98(s,99);s+=t99(s,100);s+=t100(s,101);s+=t101(s,102);s+=t102(s,103);s+=t103(s,104);s+=t104(s,105);s+=t105(s,106);s+=t106(s,107);s+=t107(s,108);s+=t108(s,109);s+=t109(s,110);s+=t110(s,111);s+=t111(s,112);s+=t112(s,113);s+=t113(s,114);s+=t114(s,115);s+=t115(s,116);s+=t116(s,117);s+=t117(s,118);s+=t118(s,119);s+=t119(s,120);s+=t120(s,121);s+=t121(s,122);s+=t122(s,123);s+=t123(s,124);s+=t124(s,125);s+=t125(s,126);s+=t126(s,127);s+=t127(s,128);s+=t128(s,129);s+=t129(s,130);s+=t130(s,131);s+=t131(s,132);s+=t132(s,133);s+=t133(s,134);s+=t134(s,135);s+=t135(s,136);s+=t136(s,137);s+=t137(s,138);s+=t138(s,139);s+=t139(s,140);s+=t140(s,141);s+=t141(s,142);s+=t142(s,143);s+=t143(s,144);s+=t144(s,145);s+=t145(s,146);s+=t146(s,147);s+=t147(s,148);s+=t148(s,149);s+=t149(s,150);s+=t150(s,151);s+=t151(s,152);s+=t152(s,153);s+=t153(s,154);s+=t154(s,155);s+=t155(s,156);s+=t156(s,157);s+=t157(s,158);s+=t158(s,159);s+=t159(s,160);s+=t160(s,161);s+=t161(s,162);s+=t162(s,163);s+=t163(s,164);s+=t164(s,165);s+=t165(s,166);s+=t166(s,167);s+=t167(s,168);s+=t168(s,169);s+=t169(s,170);s+=t170(s,171);s+=t171(s,172);s+=t172(s,173);s+=t173(s,174);s+=t174(s,175);s+=t175(s,176);s+=t176(s,177);s+=t177(s,178);s+=t178(s,179);s+=t179(s,180);s+=t180(s,181);s+=t181(s,182);s+=t182(s,183);s+=t183(s,184);s+=t184(s,185);s+=t185(s,186);s+=t186(s,187);s+=t187(s,188);s+=t188(s,189);s+=t189(s,190);s+=t190(s,191);s+=t191(s,192);s+=t192(s,193);s+=t193(s,194);s+=t194(s,195);s+=t195(s,196);s+=t196(s,197);s+=t197(s,198);s+=t198(s,199);s+=t199(s,200);s+=t200(s,201);s+=t201(s,202);s+=t202(s,203);s+=t203(s,204);s+=t204(s,205);s+=t205(s,206);s+=t206(s,207);s+=t207(s,208);s+=t208(s,209);s+=t209(s,210);s+=t210(s,211);s+=t211(s,212);s+=t212(s,213);s+=t213(s,214);s+=t214(s,215);s+=t215(s,216);s+=t216(s,217);s+=t217(s,218);s+=t218(s,219);s+=t219(s,220);s+=t220(s,221);s+=t221(s,222);s+=t222(s,223);s+=t223(s,224);s+=t224(s,225);s+=t225(s,226);s+=t226(s,227);s+=t227(s,228);s+=t228(s,229);s+=t229(s,230);s+=t230(s,231);s+=t231(s,232);s+=t232(s,233);s+=t233(s,234);s+=t234(s,235);s+=t235(s,236);s+=t236(s,237);s+=t237(s,238);s+=t238(s,239);s+=t239(s,240);s+=t240(s,241);s+=t241(s,242);s+=t242(s,243);s+=t243(s,244);s+=t244(s,245);s+=t245(s,246);s+=t246(s,247);s+=t247(s,248);s+=t248(s,249);s+=t249(s,250);s+=t250(s,251);s+=t251(s,252);s+=t252(s,253);s+=t253(s,254);s+=t254(s,255);s+=t255(s,256);s+=t256(s,257);s+=t257(s,258);s+=t258(s,259);s+=t259(s,260);s+=t260(s,261);s+=t261(s,262);s+=t262(s,263);s+=t263(s,264);s+=t264(s,265);s+=t265(s,266);s+=t266(s,267);s+=t267(s,268);s+=t268(s,269);s+=t269(s,270);s+=t270(s,271);s+=t271(s,272);s+=t272(s,273);s+=t273(s,274);s+=t274(s,275);s+=t275(s,276);s+=t276(s,277);s+=t277(s,278);s+=t278(s,279);s+=t279(s,280);s+=t280(s,281);s+=t281(s,282);s+=t282(s,283);s+=t283(s,284);s+=t284(s,285);s+=t285(s,286);s+=t286(s,287);s+=t287(s,288);s+=t288(s,289);s+=t289(s,290);s+=t290(s,291);s+=t291(s,292);s+=t292(s,293);s+=t293(s,294);s+=t294(s,295);s+=t295(s,296);s+=t296(s,297);s+=t297(s,298);s+=t298(s,299);s+=t299(s,300);s+=t300(s,301);s+=t301(s,302);s+=t302(s,303);s+=t303(s,304);s+=t304(s,305);s+=t305(s,306);s+=t306(s,307);s+=t307(s,308);s+=t308(s,309);s+=t309(s,310);s+=t310(s,311);s+=t311(s,312);s+=t312(s,313);s+=t313(s,314);s+=t314(s,315);s+=t315(s,316);s+=t316(s,317);s+=t317(s,318);s+=t318(s,319);s+=t319(s,320);s+=t320(s,321);s+=t321(s,322);s+=t322(s,323);s+=t323(s,324);s+=t324(s,325);s+=t325(s,326);s+=t326(s,327);s+=t327(s,328);s+=t328(s,329);s+=t329(s,330);s+=t330(s,331);s+=t331(s,332);s+=t332(s,333);s+=t333(s,334);s+=t334(s,335);s+=t335(s,336);s+=t336(s,337);s+=t337(s,338);s+=t338(s,339);s+=t339(s,340);s+=t340(s,341);s+=t341(s,342);s+=t342(s,343);s+=t343(s,344);s+=t344(s,345);s+=t345(s,346);s+=t346(s,347);s+=t347(s,348);s+=t348(s,349);s+=t349(s,350);s+=t350(s,351);s+=t351(s,352);s+=t352(s,353);s+=t353(s,354);s+=t354(s,355);s+=t355(s,356);s+=t356(s,357);s+=t357(s,358);s+=t358(s,359);s+=t359(s,360);s+=t360(s,361);s+=t361(s,362);s+=t362(s,363);s+=t363(s,364);s+=t364(s,365);s+=t365(s,366);s+=t366(s,367);s+=t367(s,368);s+=t368(s,369);s+=t369(s,370);s+=t370(s,371);s+=t371(s,372);s+=t372(s,373);s+=t373(s,374);s+=t374(s,375);s+=t375(s,376);s+=t376(s,377);s+=t377(s,378);s+=t378(s,379);s+=t379(s,380);s+=t380(s,381);s+=t381(s,382);s+=t382(s,383);s+=t383(s,384);s+=t384(s,385);s+=t385(s,386);s+=t386(s,387);s+=t387(s,388);s+=t388(s,389);s+=t389(s,390);s+=t390(s,391);s+=t391(s,392);s+=t392(s,393);s+=t393(s,394);s+=t394(s,395);s+=t395(s,396);s+=t396(s,397);s+=t397(s,398);s+=t398(s,399);s+=t399(s,400);s+=t400(s,401);s+=t401(s,402);s+=t402(s,403);s+=t403(s,404);s+=t404(s,405);s+=t405(s,406);s+=t406(s,407);s+=t407(s,408);s+=t408(s,409);s+=t409(s,410);s+=t410(s,411);s+=t411(s,412);s+=t412(s,413);s+=t413(s,414);s+=t414(s,415);s+=t415(s,416);s+=t416(s,417);s+=t417(s,418);s+=t418(s,419);s+=t419(s,420);s+=t420(s,421);s+=t421(s,422);s+=t422(s,423);s+=t423(s,424);s+=t424(s,425);s+=t425(s,426);s+=t426(s,427);s+=t427(s,428);s+=t428(s,429);s+=t429(s,430);s+=t430(s,431);s+=t431(s,432);s+=t432(s,433);s+=t433(s,434);s+=t434(s,435);s+=t435(s,436);s+=t436(s,437);s+=t437(s,438);s+=t438(s,439);s+=t439(s,440);s+=t440(s,441);s+=t441(s,442);s+=t442(s,443);s+=t443(s,444);s+=t444(s,445);s+=t445(s,446);s+=t446(s,447);s+=t447(s,448);s+=t448(s,449);s+=t449(s,450);s+=t450(s,451);s+=t451(s,452);s+=t452(s,453);s+=t453(s,454);s+=t454(s,455);s+=t455(s,456);s+=t456(s,457);s+=t457(s,458);s+=t458(s,459);s+=t459(s,460);s+=t460(s,461);s+=t461(s,462);s+=t462(s,463);s+=t463(s,464);s+=t464(s,465);s+=t465(s,466);s+=t466(s,467);s+=t467(s,468);s+=t468(s,469);s+=t469(s,470);s+=t470(s,471);s+=t471(s,472);s+=t472(s,473);s+=t473(s,474);s+=t474(s,475);s+=t475(s,476);s+=t476(s,477);s+=t477(s,478);s+=t478(s,479);s+=t479(s,480);s+=t480(s,481);s+=t481(s,482);s+=t482(s,483);s+=t483(s,484);s+=t484(s,485);s+=t485(s,486);s+=t486(s,487);s+=t487(s,488);s+=t488(s,489);s+=t489(s,490);s+=t490(s,491);s+=t491(s,492);s+=t492(s,493);s+=t493(s,494);s+=t494(s,495);s+=t495(s,496);s+=t496(s,497);s+=t497(s,498);s+=t498(s,499);s+=t499(s,500);s+=t500(s,501);s+=t501(s,502);s+=t502(s,503);s+=t503(s,504);s+=t504(s,505);s+=t505(s,506);s+=t506(s,507);s+=t507(s,508);s+=t508(s,509);s+=t509(s,510);s+=t510(s,511);s+=t511(s,512);s+=t512(s,513);s+=t513(s,514);s+=t514(s,515);s+=t515(s,516);s+=t516(s,517);s+=t517(s,518);s+=t518(s,519);s+=t519(s,520);s+=t520(s,521);s+=t521(s,522);s+=t522(s,523);s+=t523(s,524);s+=t524(s,525);s+=t525(s,526);s+=t526(s,527);s+=t527(s,528);s+=t528(s,529);s+=t529(s,530);s+=t530(s,531);s+=t531(s,532);s+=t532(s,533);s+=t533(s,534);s+=t534(s,535);s+=t535(s,536);s+=t536(s,537);s+=t537(s,538);s+=t538(s,539);s+=t539(s,540);s+=t540(s,541);s+=t541(s,542);s+=t542(s,543);s+=t543(s,544);s+=t544(s,545);s+=t545(s,546);s+=t546(s,547);s+=t547(s,548);s+=t548(s,549);s+=t549(s,550);s+=t550(s,551);s+=t551(s,552);s+=t552(s,553);s+=t553(s,554);s+=t554(s,555);s+=t555(s,556);s+=t556(s,557);s+=t557(s,558);s+=t558(s,559);s+=t559(s,560);s+=t560(s,561);s+=t561(s,562);s+=t562(s,563);s+=t563(s,564);s+=t564(s,565);s+=t565(s,566);s+=t566(s,567);s+=t567(s,568);s+=t568(s,569);s+=t569(s,570);s+=t570(s,571);s+=t571(s,572);s+=t572(s,573);s+=t573(s,574);s+=t574(s,575);s+=t575(s,576);s+=t576(s,577);s+=t577(s,578);s+=t578(s,579);s+=t579(s,580);s+=t580(s,581);s+=t581(s,582);s+=t582(s,583);s+=t583(s,584);s+=t584(s,585);s+=t585(s,586);s+=t586(s,587);s+=t587(s,588);s+=t588(s,589);s+=t589(s,590);s+=t590(s,591);s+=t591(s,592);s+=t592(s,593);s+=t593(s,594);s+=t594(s,595);s+=t595(s,596);s+=t596(s,597);s+=t597(s,598);s+=t598(s,599);s+=t599(s,600);s+=t600(s,601);s+=t601(s,602);s+=t602(s,603);s+=t603(s,604);s+=t604(s,605);s+=t605(s,606);s+=t606(s,607);s+=t607(s,608);s+=t608(s,609);s+=t609(s,610);s+=t610(s,611);s+=t611(s,612);s+=t612(s,613);s+=t613(s,614);s+=t614(s,615);s+=t615(s,616);s+=t616(s,617);s+=t617(s,618);s+=t618(s,619);s+=t619(s,620);s+=t620(s,621);s+=t621(s,622);s+=t622(s,623);s+=t623(s,624);s+=t624(s,625);s+=t625(s,626);s+=t626(s,627);s+=t627(s,628);s+=t628(s,629);s+=t629(s,630);s+=t630(s,631);s+=t631(s,632);s+=t632(s,633);s+=t633(s,634);s+=t634(s,635);s+=t635(s,636);s+=t636(s,637);s+=t637(s,638);s+=t638(s,639);s+=t639(s,640);s+=t640(s,641);s+=t641(s,642);s+=t642(s,643);s+=t643(s,644);s+=t644(s,645);s+=t645(s,646);s+=t646(s,647);s+=t647(s,648);s+=t648(s,649);s+=t649(s,650);s+=t650(s,651);s+=t651(s,652);s+=t652(s,653);s+=t653(s,654);s+=t654(s,655);s+=t655(s,656);s+=t656(s,657);s+=t657(s,658);s+=t658(s,659);s+=t659(s,660);s+=t660(s,661);s+=t661(s,662);s+=t662(s,663);s+=t663(s,664);s+=t664(s,665);s+=t665(s,666);s+=t666(s,667);s+=t667(s,668);s+=t668(s,669);s+=t669(s,670);s+=t670(s,671);s+=t671(s,672);s+=t672(s,673);s+=t673(s,674);s+=t674(s,675);s+=t675(s,676);s+=t676(s,677);s+=t677(s,678);s+=t678(s,679);s+=t679(s,680);s+=t680(s,681);s+=t681(s,682);s+=t682(s,683);s+=t683(s,684);s+=t684(s,685);s+=t685(s,686);s+=t686(s,687);s+=t687(s,688);s+=t688(s,689);s+=t689(s,690);s+=t690(s,691);s+=t691(s,692);s+=t692(s,693);s+=t693(s,694);s+=t694(s,695);s+=t695(s,696);s+=t696(s,697);s+=t697(s,698);s+=t698(s,699);s+=t699(s,700);s+=t700(s,701);s+=t701(s,702);s+=t702(s,703);s+=t703(s,704);s+=t704(s,705);s+=t705(s,706);s+=t706(s,707);s+=t707(s,708);s+=t708(s,709);s+=t709(s,710);s+=t710(s,711);s+=t711(s,712);s+=t712(s,713);s+=t713(s,714);s+=t714(s,715);s+=t715(s,716);s+=t716(s,717);s+=t717(s,718);s+=t718(s,719);s+=t719(s,720);s+=t720(s,721);s+=t721(s,722);s+=t722(s,723);s+=t723(s,724);s+=t724(s,725);s+=t725(s,726);s+=t726(s,727);s+=t727(s,728);s+=t728(s,729);s+=t729(s,730);s+=t730(s,731);s+=t731(s,732);s+=t732(s,733);s+=t733(s,734);s+=t734(s,735);s+=t735(s,736);s+=t736(s,737);s+=t737(s,738);s+=t738(s,739);s+=t739(s,740);s+=t740(s,741);s+=t741(s,742);s+=t742(s,743);s+=t743(s,744);s+=t744(s,745);s+=t745(s,746);s+=t746(s,747);s+=t747(s,748);s+=t748(s,749);s+=t749(s,750);s+=t750(s,751);s+=t751(s,752);s+=t752(s,753);s+=t753(s,754);s+=t754(s,755);s+=t755(s,756);s+=t756(s,757);s+=t757(s,758);s+=t758(s,759);s+=t759(s,760);s+=t760(s,761);s+=t761(s,762);s+=t762(s,763);s+=t763(s,764);s+=t764(s,765);s+=t765(s,766);s+=t766(s,767);s+=t767(s,768);s+=t768(s,769);s+=t769(s,770);s+=t770(s,771);s+=t771(s,772);s+=t772(s,773);s+=t773(s,774);s+=t774(s,775);s+=t775(s,776);s+=t776(s,777);s+=t777(s,778);s+=t778(s,779);s+=t779(s,780);s+=t780(s,781);s+=t781(s,782);s+=t782(s,783);s+=t783(s,784);s+=t784(s,785);s+=t785(s,786);s+=t786(s,787);s+=t787(s,788);s+=t788(s,789);s+=t789(s,790);s+=t790(s,791);s+=t791(s,792);s+=t792(s,793);s+=t793(s,794);s+=t794(s,795);s+=t795(s,796);s+=t796(s,797);s+=t797(s,798);s+=t798(s,799);s+=t799(s,800);s+=t800(s,801);s+=t801(s,802);s+=t802(s,803);s+=t803(s,804);s+=t804(s,805);s+=t805(s,806);s+=t806(s,807);s+=t807(s,808);s+=t808(s,809);s+=t809(s,810);s+=t810(s,811);s+=t811(s,812);s+=t812(s,813);s+=t813(s,814);s+=t814(s,815);s+=t815(s,816);s+=t816(s,817);s+=t817(s,818);s+=t818(s,819);s+=t819(s,820);s+=t820(s,821);s+=t821(s,822);s+=t822(s,823);s+=t823(s,824);s+=t824(s,825);s+=t825(s,826);s+=t826(s,827);s+=t827(s,828);s+=t828(s,829);s+=t829(s,830);s+=t830(s,831);s+=t831(s,832);s+=t832(s,833);s+=t833(s,834);s+=t834(s,835);s+=t835(s,836);s+=t836(s,837);s+=t837(s,838);s+=t838(s,839);s+=t839(s,840);s+=t840(s,841);s+=t841(s,842);s+=t842(s,843);s+=t843(s,844);s+=t844(s,845);s+=t845(s,846);s+=t846(s,847);s+=t847(s,848);s+=t848(s,849);s+=t849(s,850);s+=t850(s,851);s+=t851(s,852);s+=t852(s,853);s+=t853(s,854);s+=t854(s,855);s+=t855(s,856);s+=t856(s,857);s+=t857(s,858);s+=t858(s,859);s+=t859(s,860);s+=t860(s,861);s+=t861(s,862);s+=t862(s,863);s+=t863(s,864);s+=t864(s,865);s+=t865(s,866);s+=t866(s,867);s+=t867(s,868);s+=t868(s,869);s+=t869(s,870);s+=t870(s,871);s+=t871(s,872);s+=t872(s,873);s+=t873(s,874);s+=t874(s,875);s+=t875(s,876);s+=t876(s,877);s+=t877(s,878);s+=t878(s,879);s+=t879(s,880);s+=t880(s,881);s+=t881(s,882);s+=t882(s,883);s+=t883(s,884);s+=t884(s,885);s+=t885(s,886);s+=t886(s,887);s+=t887(s,888);s+=t888(s,889);s+=t889(s,890);s+=t890(s,891);s+=t891(s,892);s+=t892(s,893);s+=t893(s,894);s+=t894(s,895);s+=t895(s,896);s+=t896(s,897);s+=t897(s,898);s+=t898(s,899);s+=t899(s,900);s+=t900(s,901);s+=t901(s,902);s+=t902(s,903);s+=t903(s,904);s+=t904(s,905);s+=t905(s,906);s+=t906(s,907);s+=t907(s,908);s+=t908(s,909);s+=t909(s,910);s+=t910(s,911);s+=t911(s,912);s+=t912(s,913);s+=t913(s,914);s+=t914(s,915);s+=t915(s,916);s+=t916(s,917);s+=t917(s,918);s+=t918(s,919);s+=t919(s,920);s+=t920(s,921);s+=t921(s,922);s+=t922(s,923);s+=t923(s,924);s+=t924(s,925);s+=t925(s,926);s+=t926(s,927);s+=t927(s,928);s+=t928(s,929);s+=t929(s,930);s+=t930(s,931);s+=t931(s,932);s+=t932(s,933);s+=t933(s,934);s+=t934(s,935);s+=t935(s,936);s+=t936(s,937);s+=t937(s,938);s+=t938(s,939);s+=t939(s,940);s+=t940(s,941);s+=t941(s,942);s+=t942(s,943);s+=t943(s,944);s+=t944(s,945);s+=t945(s,946);s+=t946(s,947);s+=t947(s,948);s+=t948(s,949);s+=t949(s,950);s+=t950(s,951);s+=t951(s,952);s+=t952(s,953);s+=t953(s,954);s+=t954(s,955);s+=t955(s,956);s+=t956(s,957);s+=t957(s,958);s+=t958(s,959);s+=t959(s,960);s+=t960(s,961);s+=t961(s,962);s+=t962(s,963);s+=t963(s,964);s+=t964(s,965);s+=t965(s,966);s+=t966(s,967);s+=t967(s,968);s+=t968(s,969);s+=t969(s,970);s+=t970(s,971);s+=t971(s,972);s+=t972(s,973);s+=t973(s,974);s+=t974(s,975);s+=t975(s,976);s+=t976(s,977);s+=t977(s,978);s+=t978(s,979);s+=t979(s,980);s+=t980(s,981);s+=t981(s,982);s+=t982(s,983);s+=t983(s,984);s+=t984(s,985);s+=t985(s,986);s+=t986(s,987);s+=t987(s,988);s+=t988(s,989);s+=t989(s,990);s+=t990(s,991);s+=t991(s,992);s+=t992(s,993);s+=t993(s,994);s+=t994(s,995);s+=t995(s,996);s+=t996(s,997);s+=t997(s,998);s+=t998(s,999);s+=t999(s,1000);s+=t1000(s,1001);s+=t1001(s,1002);s+=t1002(s,1003);s+=t1003(s,1004);s+=t1004(s,1005);s+=t1005(s,1006);s+=t1006(s,1007);s+=t1007(s,1008);s+=t1008(s,1009);s+=t1009(s,1010);s+=t1010(s,1011);s+=t1011(s,1012);s+=t1012(s,1013);s+=t1013(s,1014);s+=t1014(s,1015);s+=t1015(s,1016);s+=t1016(s,1017);s+=t1017(s,1018);s+=t1018(s,1019);s+=t1019(s,1020);s+=t1020(s,1021);s+=t1021(s,1022);s+=t1022(s,1023);s+=t1023(s,1024);s+=t1024(s,1025);s+=t1025(s,1026);s+=t1026(s,1027);s+=t1027(s,1028);s+=t1028(s,1029);s+=t1029(s,1030);s+=t1030(s,1031);s+=t1031(s,1032);s+=t1032(s,1033);s+=t1033(s,1034);s+=t1034(s,1035);s+=t1035(s,1036);s+=t1036(s,1037);s+=t1037(s,1038);s+=t1038(s,1039);s+=t1039(s,1040);s+=t1040(s,1041);s+=t1041(s,1042);s+=t1042(s,1043);s+=t1043(s,1044);s+=t1044(s,1045);s+=t1045(s,1046);s+=t1046(s,1047);s+=t1047(s,1048);s+=t1048(s,1049);s+=t1049(s,1050);s+=t1050(s,1051);s+=t1051(s,1052);s+=t1052(s,1053);s+=t1053(s,1054);s+=t1054(s,1055);s+=t1055(s,1056);s+=t1056(s,1057);s+=t1057(s,1058);s+=t1058(s,1059);s+=t1059(s,1060);s+=t1060(s,1061);s+=t1061(s,1062);s+=t1062(s,1063);s+=t1063(s,1064);s+=t1064(s,1065);s+=t1065(s,1066);s+=t1066(s,1067);s+=t1067(s,1068);s+=t1068(s,1069);s+=t1069(s,1070);s+=t1070(s,1071);s+=t1071(s,1072);s+=t1072(s,1073);s+=t1073(s,1074);s+=t1074(s,1075);s+=t1075(s,1076);s+=t1076(s,1077);s+=t1077(s,1078);s+=t1078(s,1079);s+=t1079(s,1080);s+=t1080(s,1081);s+=t1081(s,1082);s+=t1082(s,1083);s+=t1083(s,1084);s+=t1084(s,1085);s+=t1085(s,1086);s+=t1086(s,1087);s+=t1087(s,1088);s+=t1088(s,1089);s+=t1089(s,1090);s+=t1090(s,1091);s+=t1091(s,1092);s+=t1092(s,1093);s+=t1093(s,1094);s+=t1094(s,1095);s+=t1095(s,1096);s+=t1096(s,1097);s+=t1097(s,1098);s+=t1098(s,1099);s+=t1099(s,1100);s+=t1100(s,1101);s+=t1101(s,1102);s+=t1102(s,1103);s+=t1103(s,1104);s+=t1104(s,1105);s+=t1105(s,1106);s+=t1106(s,1107);s+=t1107(s,1108);s+=t1108(s,1109);s+=t1109(s,1110);s+=t1110(s,1111);s+=t1111(s,1112);s+=t1112(s,1113);s+=t1113(s,1114);s+=t1114(s,1115);s+=t1115(s,1116);s+=t1116(s,1117);s+=t1117(s,1118);s+=t1118(s,1119);s+=t1119(s,1120);s+=t1120(s,1121);s+=t1121(s,1122);s+=t1122(s,1123);s+=t1123(s,1124);s+=t1124(s,1125);s+=t1125(s,1126);s+=t1126(s,1127);s+=t1127(s,1128);s+=t1128(s,1129);s+=t1129(s,1130);s+=t1130(s,1131);s+=t1131(s,1132);s+=t1132(s,1133);s+=t1133(s,1134);s+=t1134(s,1135);s+=t1135(s,1136);s+=t1136(s,1137);s+=t1137(s,1138);s+=t1138(s,1139);s+=t1139(s,1140);s+=t1140(s,1141);s+=t1141(s,1142);s+=t1142(s,1143);s+=t1143(s,1144);s+=t1144(s,1145);s+=t1145(s,1146);s+=t1146(s,1147);s+=t1147(s,1148);s+=t1148(s,1149);s+=t1149(s,1150);s+=t1150(s,1151);s+=t1151(s,1152);s+=t1152(s,1153);s+=t1153(s,1154);s+=t1154(s,1155);s+=t1155(s,1156);s+=t1156(s,1157);s+=t1157(s,1158);s+=t1158(s,1159);s+=t1159(s,1160);s+=t1160(s,1161);s+=t1161(s,1162);s+=t1162(s,1163);s+=t1163(s,1164);s+=t1164(s,1165);s+=t1165(s,1166);s+=t1166(s,1167);s+=t1167(s,1168);s+=t1168(s,1169);s+=t1169(s,1170);s+=t1170(s,1171);s+=t1171(s,1172);s+=t1172(s,1173);s+=t1173(s,1174);s+=t1174(s,1175);s+=t1175(s,1176);s+=t1176(s,1177);s+=t1177(s,1178);s+=t1178(s,1179);s+=t1179(s,1180);s+=t1180(s,1181);s+=t1181(s,1182);s+=t1182(s,1183);s+=t1183(s,1184);s+=t1184(s,1185);s+=t1185(s,1186);s+=t1186(s,1187);s+=t1187(s,1188);s+=t1188(s,1189);s+=t1189(s,1190);s+=t1190(s,1191);s+=t1191(s,1192);s+=t1192(s,1193);s+=t1193(s,1194);s+=t1194(s,1195);s+=t1195(s,1196);s+=t1196(s,1197);s+=t1197(s,1198);s+=t1198(s,1199);s+=t1199(s,1200);s+=t1200(s,1201);s+=t1201(s,1202);s+=t1202(s,1203);s+=t1203(s,1204);s+=t1204(s,1205);s+=t1205(s,1206);s+=t1206(s,1207);s+=t1207(s,1208);s+=t1208(s,1209);s+=t1209(s,1210);s+=t1210(s,1211);s+=t1211(s,1212);s+=t1212(s,1213);s+=t1213(s,1214);s+=t1214(s,1215);s+=t1215(s,1216);s+=t1216(s,1217);s+=t1217(s,1218);s+=t1218(s,1219);s+=t1219(s,1220);s+=t1220(s,1221);s+=t1221(s,1222);s+=t1222(s,1223);s+=t1223(s,1224);s+=t1224(s,1225);s+=t1225(s,1226);s+=t1226(s,1227);s+=t1227(s,1228);s+=t1228(s,1229);s+=t1229(s,1230);s+=t1230(s,1231);s+=t1231(s,1232);s+=t1232(s,1233);s+=t1233(s,1234);s+=t1234(s,1235);s+=t1235(s,1236);s+=t1236(s,1237);s+=t1237(s,1238);s+=t1238(s,1239);s+=t1239(s,1240);s+=t1240(s,1241);s+=t1241(s,1242);s+=t1242(s,1243);s+=t1243(s,1244);s+=t1244(s,1245);s+=t1245(s,1246);s+=t1246(s,1247);s+=t1247(s,1248);s+=t1248(s,1249);s+=t1249(s,1250);s+=t1250(s,1251);s+=t1251(s,1252);s+=t1252(s,1253);s+=t1253(s,1254);s+=t1254(s,1255);s+=t1255(s,1256);s+=t1256(s,1257);s+=t1257(s,1258);s+=t1258(s,1259);s+=t1259(s,1260);s+=t1260(s,1261);s+=t1261(s,1262);s+=t1262(s,1263);s+=t1263(s,1264);s+=t1264(s,1265);s+=t1265(s,1266);s+=t1266(s,1267);s+=t1267(s,1268);s+=t1268(s,1269);s+=t1269(s,1270);s+=t1270(s,1271);s+=t1271(s,1272);s+=t1272(s,1273);s+=t1273(s,1274);s+=t1274(s,1275);s+=t1275(s,1276);s+=t1276(s,1277);s+=t1277(s,1278);s+=t1278(s,1279);s+=t1279(s,1280);s+=t1280(s,1281);s+=t1281(s,1282);s+=t1282(s,1283);s+=t1283(s,1284);s+=t1284(s,1285);s+=t1285(s,1286);s+=t1286(s,1287);s+=t1287(s,1288);s+=t1288(s,1289);s+=t1289(s,1290);s+=t1290(s,1291);s+=t1291(s,1292);s+=t1292(s,1293);s+=t1293(s,1294);s+=t1294(s,1295);s+=t1295(s,1296);s+=t1296(s,1297);s+=t1297(s,1298);s+=t1298(s,1299);s+=t1299(s,1300);s+=t1300(s,1301);s+=t1301(s,1302);s+=t1302(s,1303);s+=t1303(s,1304);s+=t1304(s,1305);s+=t1305(s,1306);s+=t1306(s,1307);s+=t1307(s,1308);s+=t1308(s,1309);s+=t1309(s,1310);s+=t1310(s,1311);s+=t1311(s,1312);s+=t1312(s,1313);s+=t1313(s,1314);s+=t1314(s,1315);s+=t1315(s,1316);s+=t1316(s,1317);s+=t1317(s,1318);s+=t1318(s,1319);s+=t1319(s,1320);s+=t1320(s,1321);s+=t1321(s,1322);s+=t1322(s,1323);s+=t1323(s,1324);s+=t1324(s,1325);s+=t1325(s,1326);s+=t1326(s,1327);s+=t1327(s,1328);s+=t1328(s,1329);s+=t1329(s,1330);s+=t1330(s,1331);s+=t1331(s,1332);s+=t1332(s,1333);s+=t1333(s,1334);s+=t1334(s,1335);s+=t1335(s,1336);s+=t1336(s,1337);s+=t1337(s,1338);s+=t1338(s,1339);s+=t1339(s,1340);s+=t1340(s,1341);s+=t1341(s,1342);s+=t1342(s,1343);s+=t1343(s,1344);s+=t1344(s,1345);s+=t1345(s,1346);s+=t1346(s,1347);s+=t1347(s,1348);s+=t1348(s,1349);s+=t1349(s,1350);s+=t1350(s,1351);s+=t1351(s,1352);s+=t1352(s,1353);s+=t1353(s,1354);s+=t1354(s,1355);s+=t1355(s,1356);s+=t1356(s,1357);s+=t1357(s,1358);s+=t1358(s,1359);s+=t1359(s,1360);s+=t1360(s,1361);s+=t1361(s,1362);s+=t1362(s,1363);s+=t1363(s,1364);s+=t1364(s,1365);s+=t1365(s,1366);s+=t1366(s,1367);s+=t1367(s,1368);s+=t1368(s,1369);s+=t1369(s,1370);s+=t1370(s,1371);s+=t1371(s,1372);s+=t1372(s,1373);s+=t1373(s,1374);s+=t1374(s,1375);s+=t1375(s,1376);s+=t1376(s,1377);s+=t1377(s,1378);s+=t1378(s,1379);s+=t1379(s,1380);s+=t1380(s,1381);s+=t1381(s,1382);s+=t1382(s,1383);s+=t1383(s,1384);s+=t1384(s,1385);s+=t1385(s,1386);s+=t1386(s,1387);s+=t1387(s,1388);s+=t1388(s,1389);s+=t1389(s,1390);s+=t1390(s,1391);s+=t1391(s,1392);s+=t1392(s,1393);s+=t1393(s,1394);s+=t1394(s,1395);s+=t1395(s,1396);s+=t1396(s,1397);s+=t1397(s,1398);s+=t1398(s,1399);s+=t1399(s,1400);s+=t1400(s,1401);s+=t1401(s,1402);s+=t1402(s,1403);s+=t1403(s,1404);s+=t1404(s,1405);s+=t1405(s,1406);s+=t1406(s,1407);s+=t1407(s,1408);s+=t1408(s,1409);s+=t1409(s,1410);s+=t1410(s,1411);s+=t1411(s,1412);s+=t1412(s,1413);s+=t1413(s,1414);s+=t1414(s,1415);s+=t1415(s,1416);s+=t1416(s,1417);s+=t1417(s,1418);s+=t1418(s,1419);s+=t1419(s,1420);s+=t1420(s,1421);s+=t1421(s,1422);s+=t1422(s,1423);s+=t1423(s,1424);s+=t1424(s,1425);s+=t1425(s,1426);s+=t1426(s,1427);s+=t1427(s,1428);s+=t1428(s,1429);s+=t1429(s,1430);s+=t1430(s,1431);s+=t1431(s,1432);s+=t1432(s,1433);s+=t1433(s,1434);s+=t1434(s,1435);s+=t1435(s,1436);s+=t1436(s,1437);s+=t1437(s,1438);s+=t1438(s,1439);s+=t1439(s,1440);s+=t1440(s,1441);s+=t1441(s,1442);s+=t1442(s,1443);s+=t1443(s,1444);s+=t1444(s,1445);s+=t1445(s,1446);s+=t1446(s,1447);s+=t1447(s,1448);s+=t1448(s,1449);s+=t1449(s,1450);s+=t1450(s,1451);s+=t1451(s,1452);s+=t1452(s,1453);s+=t1453(s,1454);s+=t1454(s,1455);s+=t1455(s,1456);s+=t1456(s,1457);s+=t1457(s,1458);s+=t1458(s,1459);s+=t1459(s,1460);s+=t1460(s,1461);s+=t1461(s,1462);s+=t1462(s,1463);s+=t1463(s,1464);s+=t1464(s,1465);s+=t1465(s,1466);s+=t1466(s,1467);s+=t1467(s,1468);s+=t1468(s,1469);s+=t1469(s,1470);s+=t1470(s,1471);s+=t1471(s,1472);s+=t1472(s,1473);s+=t1473(s,1474);s+=t1474(s,1475);s+=t1475(s,1476);s+=t1476(s,1477);s+=t1477(s,1478);s+=t1478(s,1479);s+=t1479(s,1480);s+=t1480(s,1481);s+=t1481(s,1482);s+=t1482(s,1483);s+=t1483(s,1484);s+=t1484(s,1485);s+=t1485(s,1486);s+=t1486(s,1487);s+=t1487(s,1488);s+=t1488(s,1489);s+=t1489(s,1490);s+=t1490(s,1491);s+=t1491(s,1492);s+=t1492(s,1493);s+=t1493(s,1494);s+=t1494(s,1495);s+=t1495(s,1496);s+=t1496(s,1497);s+=t1497(s,1498);s+=t1498(s,1499);s+=t1499(s,1500);s+=t1500(s,1501);s+=t1501(s,1502);s+=t1502(s,1503);s+=t1503(s,1504);s+=t1504(s,1505);s+=t1505(s,1506);s+=t1506(s,1507);s+=t1507(s,1508);s+=t1508(s,1509);s+=t1509(s,1510);s+=t1510(s,1511);s+=t1511(s,1512);s+=t1512(s,1513);s+=t1513(s,1514);s+=t1514(s,1515);s+=t1515(s,1516);s+=t1516(s,1517);s+=t1517(s,1518);s+=t1518(s,1519);s+=t1519(s,1520);s+=t1520(s,1521);s+=t1521(s,1522);s+=t1522(s,1523);s+=t1523(s,1524);s+=t1524(s,1525);s+=t1525(s,1526);s+=t1526(s,1527);s+=t1527(s,1528);s+=t1528(s,1529);s+=t1529(s,1530);s+=t1530(s,1531);s+=t1531(s,1532);s+=t1532(s,1533);s+=t1533(s,1534);s+=t1534(s,1535);s+=t1535(s,1536);s+=t1536(s,1537);s+=t1537(s,1538);s+=t1538(s,1539);s+=t1539(s,1540);s+=t1540(s,1541);s+=t1541(s,1542);s+=t1542(s,1543);s+=t1543(s,1544);s+=t1544(s,1545);s+=t1545(s,1546);s+=t1546(s,1547);s+=t1547(s,1548);s+=t1548(s,1549);s+=t1549(s,1550);s+=t1550(s,1551);s+=t1551(s,1552);s+=t1552(s,1553);s+=t1553(s,1554);s+=t1554(s,1555);s+=t1555(s,1556);s+=t1556(s,1557);s+=t1557(s,1558);s+=t1558(s,1559);s+=t1559(s,1560);s+=t1560(s,1561);s+=t1561(s,1562);s+=t1562(s,1563);s+=t1563(s,1564);s+=t1564(s,1565);s+=t1565(s,1566);s+=t1566(s,1567);s+=t1567(s,1568);s+=t1568(s,1569);s+=t1569(s,1570);s+=t1570(s,1571);s+=t1571(s,1572);s+=t1572(s,1573);s+=t1573(s,1574);s+=t1574(s,1575);s+=t1575(s,1576);s+=t1576(s,1577);s+=t1577(s,1578);s+=t1578(s,1579);s+=t1579(s,1580);s+=t1580(s,1581);s+=t1581(s,1582);s+=t1582(s,1583);s+=t1583(s,1584);s+=t1584(s,1585);s+=t1585(s,1586);s+=t1586(s,1587);s+=t1587(s,1588);s+=t1588(s,1589);s+=t1589(s,1590);s+=t1590(s,1591);s+=t1591(s,1592);s+=t1592(s,1593);s+=t1593(s,1594);s+=t1594(s,1595);s+=t1595(s,1596);s+=t1596(s,1597);s+=t1597(s,1598);s+=t1598(s,1599);s+=t1599(s,1600);s+=t1600(s,1601);s+=t1601(s,1602);s+=t1602(s,1603);s+=t1603(s,1604);s+=t1604(s,1605);s+=t1605(s,1606);s+=t1606(s,1607);s+=t1607(s,1608);s+=t1608(s,1609);s+=t1609(s,1610);s+=t1610(s,1611);s+=t1611(s,1612);s+=t1612(s,1613);s+=t1613(s,1614);s+=t1614(s,1615);s+=t1615(s,1616);s+=t1616(s,1617);s+=t1617(s,1618);s+=t1618(s,1619);s+=t1619(s,1620);s+=t1620(s,1621);s+=t1621(s,1622);s+=t1622(s,1623);s+=t1623(s,1624);s+=t1624(s,1625);s+=t1625(s,1626);s+=t1626(s,1627);s+=t1627(s,1628);s+=t1628(s,1629);s+=t1629(s,1630);s+=t1630(s,1631);s+=t1631(s,1632);s+=t1632(s,1633);s+=t1633(s,1634);s+=t1634(s,1635);s+=t1635(s,1636);s+=t1636(s,1637);s+=t1637(s,1638);s+=t1638(s,1639);s+=t1639(s,1640);s+=t1640(s,1641);s+=t1641(s,1642);s+=t1642(s,1643);s+=t1643(s,1644);s+=t1644(s,1645);s+=t1645(s,1646);s+=t1646(s,1647);s+=t1647(s,1648);s+=t1648(s,1649);s+=t1649(s,1650);s+=t1650(s,1651);s+=t1651(s,1652);s+=t1652(s,1653);s+=t1653(s,1654);s+=t1654(s,1655);s+=t1655(s,1656);s+=t1656(s,1657);s+=t1657(s,1658);s+=t1658(s,1659);s+=t1659(s,1660);s+=t1660(s,1661);s+=t1661(s,1662);s+=t1662(s,1663);s+=t1663(s,1664);s+=t1664(s,1665);s+=t1665(s,1666);s+=t1666(s,1667);s+=t1667(s,1668);s+=t1668(s,1669);s+=t1669(s,1670);s+=t1670(s,1671);s+=t1671(s,1672);s+=t1672(s,1673);s+=t1673(s,1674);s+=t1674(s,1675);s+=t1675(s,1676);s+=t1676(s,1677);s+=t1677(s,1678);s+=t1678(s,1679);s+=t1679(s,1680);s+=t1680(s,1681);s+=t1681(s,1682);s+=t1682(s,1683);s+=t1683(s,1684);s+=t1684(s,1685);s+=t1685(s,1686);s+=t1686(s,1687);s+=t1687(s,1688);s+=t1688(s,1689);s+=t1689(s,1690);s+=t1690(s,1691);s+=t1691(s,1692);s+=t1692(s,1693);s+=t1693(s,1694);s+=t1694(s,1695);s+=t1695(s,1696);s+=t1696(s,1697);s+=t1697(s,1698);s+=t1698(s,1699);s+=t1699(s,1700);s+=t1700(s,1701);s+=t1701(s,1702);s+=t1702(s,1703);s+=t1703(s,1704);s+=t1704(s,1705);s+=t1705(s,1706);s+=t1706(s,1707);s+=t1707(s,1708);s+=t1708(s,1709);s+=t1709(s,1710);s+=t1710(s,1711);s+=t1711(s,1712);s+=t1712(s,1713);s+=t1713(s,1714);s+=t1714(s,1715);s+=t1715(s,1716);s+=t1716(s,1717);s+=t1717(s,1718);s+=t1718(s,1719);s+=t1719(s,1720);s+=t1720(s,1721);s+=t1721(s,1722);s+=t1722(s,1723);s+=t1723(s,1724);s+=t1724(s,1725);s+=t1725(s,1726);s+=t1726(s,1727);s+=t1727(s,1728);s+=t1728(s,1729);s+=t1729(s,1730);s+=t1730(s,1731);s+=t1731(s,1732);s+=t1732(s,1733);s+=t1733(s,1734);s+=t1734(s,1735);s+=t1735(s,1736);s+=t1736(s,1737);s+=t1737(s,1738);s+=t1738(s,1739);s+=t1739(s,1740);s+=t1740(s,1741);s+=t1741(s,1742);s+=t1742(s,1743);s+=t1743(s,1744);s+=t1744(s,1745);s+=t1745(s,1746);s+=t1746(s,1747);s+=t1747(s,1748);s+=t1748(s,1749);s+=t1749(s,1750);s+=t1750(s,1751);s+=t1751(s,1752);s+=t1752(s,1753);s+=t1753(s,1754);s+=t1754(s,1755);s+=t1755(s,1756);s+=t1756(s,1757);s+=t1757(s,1758);s+=t1758(s,1759);s+=t1759(s,1760);s+=t1760(s,1761);s+=t1761(s,1762);s+=t1762(s,1763);s+=t1763(s,1764);s+=t1764(s,1765);s+=t1765(s,1766);s+=t1766(s,1767);s+=t1767(s,1768);s+=t1768(s,1769);s+=t1769(s,1770);s+=t1770(s,1771);s+=t1771(s,1772);s+=t1772(s,1773);s+=t1773(s,1774);s+=t1774(s,1775);s+=t1775(s,1776);s+=t1776(s,1777);s+=t1777(s,1778);s+=t1778(s,1779);s+=t1779(s,1780);s+=t1780(s,1781);s+=t1781(s,1782);s+=t1782(s,1783);s+=t1783(s,1784);s+=t1784(s,1785);s+=t1785(s,1786);s+=t1786(s,1787);s+=t1787(s,1788);s+=t1788(s,1789);s+=t1789(s,1790);s+=t1790(s,1791);s+=t1791(s,1792);s+=t1792(s,1793);s+=t1793(s,1794);s+=t1794(s,1795);s+=t1795(s,1796);s+=t1796(s,1797);s+=t1797(s,1798);s+=t1798(s,1799);s+=t1799(s,1800);s+=t1800(s,1801);s+=t1801(s,1802);s+=t1802(s,1803);s+=t1803(s,1804);s+=t1804(s,1805);s+=t1805(s,1806);s+=t1806(s,1807);s+=t1807(s,1808);s+=t1808(s,1809);s+=t1809(s,1810);s+=t1810(s,1811);s+=t1811(s,1812);s+=t1812(s,1813);s+=t1813(s,1814);s+=t1814(s,1815);s+=t1815(s,1816);s+=t1816(s,1817);s+=t1817(s,1818);s+=t1818(s,1819);s+=t1819(s,1820);s+=t1820(s,1821);s+=t1821(s,1822);s+=t1822(s,1823);s+=t1823(s,1824);s+=t1824(s,1825);s+=t1825(s,1826);s+=t1826(s,1827);s+=t1827(s,1828);s+=t1828(s,1829);s+=t1829(s,1830);s+=t1830(s,1831);s+=t1831(s,1832);s+=t1832(s,1833);s+=t1833(s,1834);s+=t1834(s,1835);s+=t1835(s,1836);s+=t1836(s,1837);s+=t1837(s,1838);s+=t1838(s,1839);s+=t1839(s,1840);s+=t1840(s,1841);s+=t1841(s,1842);s+=t1842(s,1843);s+=t1843(s,1844);s+=t1844(s,1845);s+=t1845(s,1846);s+=t1846(s,1847);s+=t1847(s,1848);s+=t1848(s,1849);s+=t1849(s,1850);s+=t1850(s,1851);s+=t1851(s,1852);s+=t1852(s,1853);s+=t1853(s,1854);s+=t1854(s,1855);s+=t1855(s,1856);s+=t1856(s,1857);s+=t1857(s,1858);s+=t1858(s,1859);s+=t1859(s,1860);s+=t1860(s,1861);s+=t1861(s,1862);s+=t1862(s,1863);s+=t1863(s,1864);s+=t1864(s,1865);s+=t1865(s,1866);s+=t1866(s,1867);s+=t1867(s,1868);s+=t1868(s,1869);s+=t1869(s,1870);s+=t1870(s,1871);s+=t1871(s,1872);s+=t1872(s,1873);s+=t1873(s,1874);s+=t1874(s,1875);s+=t1875(s,1876);s+=t1876(s,1877);s+=t1877(s,1878);s+=t1878(s,1879);s+=t1879(s,1880);s+=t1880(s,1881);s+=t1881(s,1882);s+=t1882(s,1883);s+=t1883(s,1884);s+=t1884(s,1885);s+=t1885(s,1886);s+=t1886(s,1887);s+=t1887(s,1888);s+=t1888(s,1889);s+=t1889(s,1890);s+=t1890(s,1891);s+=t1891(s,1892);s+=t1892(s,1893);s+=t1893(s,1894);s+=t1894(s,1895);s+=t1895(s,1896);s+=t1896(s,1897);s+=t1897(s,1898);s+=t1898(s,1899);s+=t1899(s,1900);s+=t1900(s,1901);s+=t1901(s,1902);s+=t1902(s,1903);s+=t1903(s,1904);s+=t1904(s,1905);s+=t1905(s,1906);s+=t1906(s,1907);s+=t1907(s,1908);s+=t1908(s,1909);s+=t1909(s,1910);s+=t1910(s,1911);s+=t1911(s,1912);s+=t1912(s,1913);s+=t1913(s,1914);s+=t1914(s,1915);s+=t1915(s,1916);s+=t1916(s,1917);s+=t1917(s,1918);s+=t1918(s,1919);s+=t1919(s,1920);s+=t1920(s,1921);s+=t1921(s,1922);s+=t1922(s,1923);s+=t1923(s,1924);s+=t1924(s,1925);s+=t1925(s,1926);s+=t1926(s,1927);s+=t1927(s,1928);s+=t1928(s,1929);s+=t1929(s,1930);s+=t1930(s,1931);s+=t1931(s,1932);s+=t1932(s,1933);s+=t1933(s,1934);s+=t1934(s,1935);s+=t1935(s,1936);s+=t1936(s,1937);s+=t1937(s,1938);s+=t1938(s,1939);s+=t1939(s,1940);s+=t1940(s,1941);s+=t1941(s,1942);s+=t1942(s,1943);s+=t1943(s,1944);s+=t1944(s,1945);s+=t1945(s,1946);s+=t1946(s,1947);s+=t1947(s,1948);s+=t1948(s,1949);s+=t1949(s,1950);s+=t1950(s,1951);s+=t1951(s,1952);s+=t1952(s,1953);s+=t1953(s,1954);s+=t1954(s,1955);s+=t1955(s,1956);s+=t1956(s,1957);s+=t1957(s,1958);s+=t1958(s,1959);s+=t1959(s,1960);s+=t1960(s,1961);s+=t1961(s,1962);s+=t1962(s,1963);s+=t1963(s,1964);s+=t1964(s,1965);s+=t1965(s,1966);s+=t1966(s,1967);s+=t1967(s,1968);s+=t1968(s,1969);s+=t1969(s,1970);s+=t1970(s,1971);s+=t1971(s,1972);s+=t1972(s,1973);s+=t1973(s,1974);s+=t1974(s,1975);s+=t1975(s,1976);s+=t1976(s,1977);s+=t1977(s,1978);s+=t1978(s,1979);s+=t1979(s,1980);s+=t1980(s,1981);s+=t1981(s,1982);s+=t1982(s,1983);s+=t1983(s,1984);s+=t1984(s,1985);s+=t1985(s,1986);s+=t1986(s,1987);s+=t1987(s,1988);s+=t1988(s,1989);s+=t1989(s,1990);s+=t1990(s,1991);s+=t1991(s,1992);s+=t1992(s,1993);s+=t1993(s,1994);s+=t1994(s,1995);s+=t1995(s,1996);s+=t1996(s,1997);s+=t1997(s,1998);s+=t1998(s,1999);s+=t1999(s,2000);s+=t2000(s,2001);s+=t2001(s,2002);s+=t2002(s,2003);s+=t2003(s,2004);s+=t2004(s,2005);s+=t2005(s,2006);s+=t2006(s,2007);s+=t2007(s,2008);s+=t2008(s,2009);s+=t2009(s,2010);s+=t2010(s,2011);s+=t2011(s,2012);s+=t2012(s,2013);s+=t2013(s,2014);s+=t2014(s,2015);s+=t2015(s,2016);s+=t2016(s,2017);s+=t2017(s,2018);s+=t2018(s,2019);s+=t2019(s,2020);s+=t2020(s,2021);s+=t2021(s,2022);s+=t2022(s,2023);s+=t2023(s,2024);s+=t2024(s,2025);s+=t2025(s,2026);s+=t2026(s,2027);s+=t2027(s,2028);s+=t2028(s,2029);s+=t2029(s,2030);s+=t2030(s,2031);s+=t2031(s,2032);s+=t2032(s,2033);s+=t2033(s,2034);s+=t2034(s,2035);s+=t2035(s,2036);s+=t2036(s,2037);s+=t2037(s,2038);s+=t2038(s,2039);s+=t2039(s,2040);s+=t2040(s,2041);s+=t2041(s,2042);s+=t2042(s,2043);s+=t2043(s,2044);s+=t2044(s,2045);s+=t2045(s,2046);s+=t2046(s,2047);s+=t2047(s,2048);s+=t2048(s,2049);s+=t2049(s,2050);s+=t2050(s,2051);s+=t2051(s,2052);s+=t2052(s,2053);s+=t2053(s,2054);s+=t2054(s,2055);s+=t2055(s,2056);s+=t2056(s,2057);s+=t2057(s,2058);s+=t2058(s,2059);s+=t2059(s,2060);s+=t2060(s,2061);s+=t2061(s,2062);s+=t2062(s,2063);s+=t2063(s,2064);s+=t2064(s,2065);s+=t2065(s,2066);s+=t2066(s,2067);s+=t2067(s,2068);s+=t2068(s,2069);s+=t2069(s,2070);s+=t2070(s,2071);s+=t2071(s,2072);s+=t2072(s,2073);s+=t2073(s,2074);s+=t2074(s,2075);s+=t2075(s,2076);s+=t2076(s,2077);s+=t2077(s,2078);s+=t2078(s,2079);s+=t2079(s,2080);s+=t2080(s,2081);s+=t2081(s,2082);s+=t2082(s,2083);s+=t2083(s,2084);s+=t2084(s,2085);s+=t2085(s,2086);s+=t2086(s,2087);s+=t2087(s,2088);s+=t2088(s,2089);s+=t2089(s,2090);s+=t2090(s,2091);s+=t2091(s,2092);s+=t2092(s,2093);s+=t2093(s,2094);s+=t2094(s,2095);s+=t2095(s,2096);s+=t2096(s,2097);s+=t2097(s,2098);s+=t2098(s,2099);s+=t2099(s,2100);s+=t2100(s,2101);s+=t2101(s,2102);s+=t2102(s,2103);s+=t2103(s,2104);s+=t2104(s,2105);s+=t2105(s,2106);s+=t2106(s,2107);s+=t2107(s,2108);s+=t2108(s,2109);s+=t2109(s,2110);s+=t2110(s,2111);s+=t2111(s,2112);s+=t2112(s,2113);s+=t2113(s,2114);s+=t2114(s,2115);s+=t2115(s,2116);s+=t2116(s,2117);s+=t2117(s,2118);s+=t2118(s,2119);s+=t2119(s,2120);s+=t2120(s,2121);s+=t2121(s,2122);s+=t2122(s,2123);s+=t2123(s,2124);s+=t2124(s,2125);s+=t2125(s,2126);s+=t2126(s,2127);s+=t2127(s,2128);s+=t2128(s,2129);s+=t2129(s,2130);s+=t2130(s,2131);s+=t2131(s,2132);s+=t2132(s,2133);s+=t2133(s,2134);s+=t2134(s,2135);s+=t2135(s,2136);s+=t2136(s,2137);s+=t2137(s,2138);s+=t2138(s,2139);s+=t2139(s,2140);s+=t2140(s,2141);s+=t2141(s,2142);s+=t2142(s,2143);s+=t2143(s,2144);s+=t2144(s,2145);s+=t2145(s,2146);s+=t2146(s,2147);s+=t2147(s,2148);s+=t2148(s,2149);s+=t2149(s,2150);s+=t2150(s,2151);s+=t2151(s,2152);s+=t2152(s,2153);s+=t2153(s,2154);s+=t2154(s,2155);s+=t2155(s,2156);s+=t2156(s,2157);s+=t2157(s,2158);s+=t2158(s,2159);s+=t2159(s,2160);s+=t2160(s,2161);s+=t2161(s,2162);s+=t2162(s,2163);s+=t2163(s,2164);s+=t2164(s,2165);s+=t2165(s,2166);s+=t2166(s,2167);s+=t2167(s,2168);s+=t2168(s,2169);s+=t2169(s,2170);s+=t2170(s,2171);s+=t2171(s,2172);s+=t2172(s,2173);s+=t2173(s,2174);s+=t2174(s,2175);s+=t2175(s,2176);s+=t2176(s,2177);s+=t2177(s,2178);s+=t2178(s,2179);s+=t2179(s,2180);s+=t2180(s,2181);s+=t2181(s,2182);s+=t2182(s,2183);s+=t2183(s,2184);s+=t2184(s,2185);s+=t2185(s,2186);s+=t2186(s,2187);s+=t2187(s,2188);s+=t2188(s,2189);s+=t2189(s,2190);s+=t2190(s,2191);s+=t2191(s,2192);s+=t2192(s,2193);s+=t2193(s,2194);s+=t2194(s,2195);s+=t2195(s,2196);s+=t2196(s,2197);s+=t2197(s,2198);s+=t2198(s,2199);s+=t2199(s,2200);s+=t2200(s,2201);s+=t2201(s,2202);s+=t2202(s,2203);s+=t2203(s,2204);s+=t2204(s,2205);s+=t2205(s,2206);s+=t2206(s,2207);s+=t2207(s,2208);s+=t2208(s,2209);s+=t2209(s,2210);s+=t2210(s,2211);s+=t2211(s,2212);s+=t2212(s,2213);s+=t2213(s,2214);s+=t2214(s,2215);s+=t2215(s,2216);s+=t2216(s,2217);s+=t2217(s,2218);s+=t2218(s,2219);s+=t2219(s,2220);s+=t2220(s,2221);s+=t2221(s,2222);s+=t2222(s,2223);s+=t2223(s,2224);s+=t2224(s,2225);s+=t2225(s,2226);s+=t2226(s,2227);s+=t2227(s,2228);s+=t2228(s,2229);s+=t2229(s,2230);s+=t2230(s,2231);s+=t2231(s,2232);s+=t2232(s,2233);s+=t2233(s,2234);s+=t2234(s,2235);s+=t2235(s,2236);s+=t2236(s,2237);s+=t2237(s,2238);s+=t2238(s,2239);s+=t2239(s,2240);s+=t2240(s,2241);s+=t2241(s,2242);s+=t2242(s,2243);s+=t2243(s,2244);s+=t2244(s,2245);s+=t2245(s,2246);s+=t2246(s,2247);s+=t2247(s,2248);s+=t2248(s,2249);s+=t2249(s,2250);s+=t2250(s,2251);s+=t2251(s,2252);s+=t2252(s,2253);s+=t2253(s,2254);s+=t2254(s,2255);s+=t2255(s,2256);s+=t2256(s,2257);s+=t2257(s,2258);s+=t2258(s,2259);s+=t2259(s,2260);s+=t2260(s,2261);s+=t2261(s,2262);s+=t2262(s,2263);s+=t2263(s,2264);s+=t2264(s,2265);s+=t2265(s,2266);s+=t2266(s,2267);s+=t2267(s,2268);s+=t2268(s,2269);s+=t2269(s,2270);s+=t2270(s,2271);s+=t2271(s,2272);s+=t2272(s,2273);s+=t2273(s,2274);s+=t2274(s,2275);s+=t2275(s,2276);s+=t2276(s,2277);s+=t2277(s,2278);s+=t2278(s,2279);s+=t2279(s,2280);s+=t2280(s,2281);s+=t2281(s,2282);s+=t2282(s,2283);s+=t2283(s,2284);s+=t2284(s,2285);s+=t2285(s,2286);s+=t2286(s,2287);s+=t2287(s,2288);s+=t2288(s,2289);s+=t2289(s,2290);s+=t2290(s,2291);s+=t2291(s,2292);s+=t2292(s,2293);s+=t2293(s,2294);s+=t2294(s,2295);s+=t2295(s,2296);s+=t2296(s,2297);s+=t2297(s,2298);s+=t2298(s,2299);s+=t2299(s,2300);s+=t2300(s,2301);s+=t2301(s,2302);s+=t2302(s,2303);s+=t2303(s,2304);s+=t2304(s,2305);s+=t2305(s,2306);s+=t2306(s,2307);s+=t2307(s,2308);s+=t2308(s,2309);s+=t2309(s,2310);s+=t2310(s,2311);s+=t2311(s,2312);s+=t2312(s,2313);s+=t2313(s,2314);s+=t2314(s,2315);s+=t2315(s,2316);s+=t2316(s,2317);s+=t2317(s,2318);s+=t2318(s,2319);s+=t2319(s,2320);s+=t2320(s,2321);s+=t2321(s,2322);s+=t2322(s,2323);s+=t2323(s,2324);s+=t2324(s,2325);s+=t2325(s,2326);s+=t2326(s,2327);s+=t2327(s,2328);s+=t2328(s,2329);s+=t2329(s,2330);s+=t2330(s,2331);s+=t2331(s,2332);s+=t2332(s,2333);s+=t2333(s,2334);s+=t2334(s,2335);s+=t2335(s,2336);s+=t2336(s,2337);s+=t2337(s,2338);s+=t2338(s,2339);s+=t2339(s,2340);s+=t2340(s,2341);s+=t2341(s,2342);s+=t2342(s,2343);s+=t2343(s,2344);s+=t2344(s,2345);s+=t2345(s,2346);s+=t2346(s,2347);s+=t2347(s,2348);s+=t2348(s,2349);s+=t2349(s,2350);s+=t2350(s,2351);s+=t2351(s,2352);s+=t2352(s,2353);s+=t2353(s,2354);s+=t2354(s,2355);s+=t2355(s,2356);s+=t2356(s,2357);s+=t2357(s,2358);s+=t2358(s,2359);s+=t2359(s,2360);s+=t2360(s,2361);s+=t2361(s,2362);s+=t2362(s,2363);s+=t2363(s,2364);s+=t2364(s,2365);s+=t2365(s,2366);s+=t2366(s,2367);s+=t2367(s,2368);s+=t2368(s,2369);s+=t2369(s,2370);s+=t2370(s,2371);s+=t2371(s,2372);s+=t2372(s,2373);s+=t2373(s,2374);s+=t2374(s,2375);s+=t2375(s,2376);s+=t2376(s,2377);s+=t2377(s,2378);s+=t2378(s,2379);s+=t2379(s,2380);s+=t2380(s,2381);s+=t2381(s,2382);s+=t2382(s,2383);s+=t2383(s,2384);s+=t2384(s,2385);s+=t2385(s,2386);s+=t2386(s,2387);s+=t2387(s,2388);s+=t2388(s,2389);s+=t2389(s,2390);s+=t2390(s,2391);s+=t2391(s,2392);s+=t2392(s,2393);s+=t2393(s,2394);s+=t2394(s,2395);s+=t2395(s,2396);s+=t2396(s,2397);s+=t2397(s,2398);s+=t2398(s,2399);s+=t2399(s,2400);s+=t2400(s,2401);s+=t2401(s,2402);s+=t2402(s,2403);s+=t2403(s,2404);s+=t2404(s,2405);s+=t2405(s,2406);s+=t2406(s,2407);s+=t2407(s,2408);s+=t2408(s,2409);s+=t2409(s,2410);s+=t2410(s,2411);s+=t2411(s,2412);s+=t2412(s,2413);s+=t2413(s,2414);s+=t2414(s,2415);s+=t2415(s,2416);s+=t2416(s,2417);s+=t2417(s,2418);s+=t2418(s,2419);s+=t2419(s,2420);s+=t2420(s,2421);s+=t2421(s,2422);s+=t2422(s,2423);s+=t2423(s,2424);s+=t2424(s,2425);s+=t2425(s,2426);s+=t2426(s,2427);s+=t2427(s,2428);s+=t2428(s,2429);s+=t2429(s,2430);s+=t2430(s,2431);s+=t2431(s,2432);s+=t2432(s,2433);s+=t2433(s,2434);s+=t2434(s,2435);s+=t2435(s,2436);s+=t2436(s,2437);s+=t2437(s,2438);s+=t2438(s,2439);s+=t2439(s,2440);s+=t2440(s,2441);s+=t2441(s,2442);s+=t2442(s,2443);s+=t2443(s,2444);s+=t2444(s,2445);s+=t2445(s,2446);s+=t2446(s,2447);s+=t2447(s,2448);s+=t2448(s,2449);s+=t2449(s,2450);s+=t2450(s,2451);s+=t2451(s,2452);s+=t2452(s,2453);s+=t2453(s,2454);s+=t2454(s,2455);s+=t2455(s,2456);s+=t2456(s,2457);s+=t2457(s,2458);s+=t2458(s,2459);s+=t2459(s,2460);s+=t2460(s,2461);s+=t2461(s,2462);s+=t2462(s,2463);s+=t2463(s,2464);s+=t2464(s,2465);s+=t2465(s,2466);s+=t2466(s,2467);s+=t2467(s,2468);s+=t2468(s,2469);s+=t2469(s,2470);s+=t2470(s,2471);s+=t2471(s,2472);s+=t2472(s,2473);s+=t2473(s,2474);s+=t2474(s,2475);s+=t2475(s,2476);s+=t2476(s,2477);s+=t2477(s,2478);s+=t2478(s,2479);s+=t2479(s,2480);s+=t2480(s,2481);s+=t2481(s,2482);s+=t2482(s,2483);s+=t2483(s,2484);s+=t2484(s,2485);s+=t2485(s,2486);s+=t2486(s,2487);s+=t2487(s,2488);s+=t2488(s,2489);s+=t2489(s,2490);s+=t2490(s,2491);s+=t2491(s,2492);s+=t2492(s,2493);s+=t2493(s,2494);s+=t2494(s,2495);s+=t2495(s,2496);s+=t2496(s,2497);s+=t2497(s,2498);s+=t2498(s,2499);s+=t2499(s,2500);printf("%d\n",s);return 0;}
