#!/bin/sh
###############################################################################
# spksrc.native-toolchain/pgo-sources.sh <dir>
#
# Writes <dir>/train.c, <dir>/train.cpp and <dir>/train.f90, the inputs the toolchain
# producers run their instrumented tools on (TOOLCHAIN_PGO, spksrc.native-toolchain.mk): gcc
# compiles all three, binutils assembles and links what the vendor gcc makes of the first two.
#
# Wide and shallow on purpose -- thousands of small functions and classes, so parsing at
# volume, inlining, loop and arithmetic optimisation, register allocation, template
# instantiation, STL, exceptions and RAII all get exercised, with nothing needed from the
# target beyond libc and libstdc++ headers. Generated rather than kept as ~9400 lines of
# repetition; train.c and train.cpp are byte-identical to the files the published archives
# were profiled with. train.f90 came after them: archives built since train f951 too, the
# Fortran compiler a LAPACK build spends a fifth of its time in.
###############################################################################
set -e
dir=${1:?usage: $0 <dir>}
mkdir -p "$dir"

awk 'BEGIN {
  print "/* PGO training input for cc1: a wide, shallow translation unit that exercises the"
  print "   passes a package build actually spends its time in -- parsing at volume, inlining,"
  print "   loop and arithmetic optimisation, register allocation -- without needing anything"
  print "   from the target beyond libc headers. Compiled at -O2 and -O3 by gcc-pgo-train. */"
  print "#include <stdlib.h>"
  print "#include <string.h>"
  print "#include <stdio.h>"
  for (i = 0; i < 2500; i++)
    printf "int t%d(int a,int b){int r=a;for(int k=0;k<11;k++)r=(r*b+k)^(a<<(k&7));return r;}\n", i
  print "struct rec { int id; char name[32]; double w; };"
  for (i = 0; i < 300; i++) {
    printf "int agg%d(struct rec *v,int n){ int s=0; for(int i=0;i<n;i++){ if(v[i].id%%%d==0) s+=v[i].id;\n", i, i + 2
    print  "  else s-=(int)v[i].w; if(strlen(v[i].name)>3) s^=v[i].name[0]; } return s; }"
  }
  printf "int main(void){int s=0;"
  for (i = 0; i < 2500; i++) printf "s+=t%d(s,%d);", i, i + 1
  print "printf(\"%d\\n\",s);return 0;}"
}' > "$dir/train.c"

awk 'BEGIN {
  print "/* PGO training input for cc1plus: template instantiation, STL containers and"
  print "   algorithms, exceptions and RAII -- where a C++ package build spends its time. */"
  n = split("string vector map set algorithm memory functional stdexcept", inc, " ")
  for (i = 1; i <= n; i++) printf "#include <%s>\n", inc[i]
  print "template<class T,int N> struct Arr { T v[N]; Arr(){for(int i=0;i<N;i++)v[i]=T(i);} T sum() const {T s=T();for(int i=0;i<N;i++)s=s+v[i];return s;} };"
  for (i = 0; i < 900; i++) {
    printf "struct C%d { std::string n; std::vector<std::string> v; std::map<std::string,std::vector<int>> m; Arr<int,8> a;\n", i
    printf "  C%d():n(\"c%d\"){ for(int k=0;k<9;k++) v.push_back(n+std::to_string(k)); m[n]=std::vector<int>{1,2,3}; }\n", i, i
    print  "  int f() const { auto c=v; std::sort(c.begin(),c.end()); std::set<std::string> s(c.begin(),c.end());"
    print  "    std::function<int(int)> h=[&](int x){ return x+(int)s.size(); };"
    print  "    try { if (c.empty()) throw std::runtime_error(\"empty\"); } catch (const std::exception&) { return 0; }"
    print  "    auto p = std::make_unique<std::vector<int>>(a.v, a.v+8);"
    print  "    return h(a.sum()) + (int)m.size() + (int)p->size(); } };"
  }
  printf "int main(){int s=0;"
  for (i = 0; i < 900; i++) printf "{C%d o; s+=o.f();}", i
  print "return s;}"
}' > "$dir/train.cpp"

awk 'BEGIN {
  print "! PGO training input for f951: the numerical Fortran a package build compiles --"
  print "! LAPACK-like loops over arrays, real(8) and complex(8) arithmetic, constants folded"
  print "! at compile time, intrinsics, derived types and modules -- needing nothing from the"
  print "! target. Compiled at -O2 and -O3 by gcc-pgo-train."
  print "module train_kinds"
  print "  implicit none"
  print "  integer, parameter :: dp = kind(1.0d0)"
  print "  real(dp), parameter :: pi = 3.141592653589793238462643383279502884_dp, eps = 2.220446049250313e-16_dp"
  print "  type :: vec3"
  print "    real(dp) :: x = 0.0_dp, y = 0.0_dp, z = 0.0_dp"
  print "  end type vec3"
  print "end module train_kinds"
  print "module train_ops"
  print "  use train_kinds"
  print "  implicit none"
  print "contains"
  for (i = 0; i < 1500; i++) {
    printf "  subroutine axpy%d(n, a, x, y)\n", i
    print  "    integer, intent(in) :: n"
    print  "    real(dp), intent(in) :: a, x(n)"
    print  "    real(dp), intent(inout) :: y(n)"
    print  "    integer :: k"
    printf "    do k = 1, n\n      y(k) = y(k) + a*x(k)*%d.%d_dp - sqrt(abs(x(k)) + eps)/(pi*%d.0_dp)\n    end do\n", i % 97 + 1, i % 10, i % 13 + 1
    printf "  end subroutine axpy%d\n", i
  }
  for (i = 0; i < 400; i++) {
    printf "  function nrm%d(n, z) result(r)\n", i
    print  "    integer, intent(in) :: n"
    print  "    complex(dp), intent(in) :: z(n)"
    print  "    real(dp) :: r, s"
    print  "    integer :: k"
    print  "    r = 0.0_dp"
    print  "    do k = 1, n"
    printf "      s = max(abs(real(z(k))), abs(aimag(z(k))), %d.0e-12_dp)\n", i % 7 + 1
    print  "      r = r + s*exp(-real(k, dp)/real(n, dp)) + abs(z(k)*conjg(z(k)))"
    print  "    end do"
    printf "  end function nrm%d\n", i
  }
  for (i = 0; i < 200; i++) {
    printf "  subroutine gemm%d(m, a, b, c)\n", i
    print  "    integer, intent(in) :: m"
    print  "    real(dp), intent(in) :: a(m, m), b(m, m)"
    print  "    real(dp), intent(out) :: c(m, m)"
    print  "    type(vec3) :: v"
    print  "    integer :: i, j"
    print  "    c = matmul(a, transpose(b))"
    print  "    do j = 1, m"
    print  "      do i = 1, m"
    printf "        if (abs(c(i, j)) < %d.0_dp*eps) c(i, j) = 0.0_dp\n", i % 5 + 1
    print  "      end do"
    print  "    end do"
    print  "    v%x = dot_product(a(:, 1), b(:, 1)); v%y = sum(c); v%z = maxval(abs(a))"
    print  "    c(1, 1) = c(1, 1) + v%x + v%y - v%z"
    printf "  end subroutine gemm%d\n", i
  }
  print "end module train_ops"
}' > "$dir/train.f90"
