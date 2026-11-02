#!/bin/sh
###############################################################################
# spksrc.native/toolchain-pgo-sources.sh <dir>
#
# Writes <dir>/train.c and <dir>/train.cpp, the inputs the toolchain producers run their
# instrumented tools on (TOOLCHAIN_PGO, spksrc.native-toolchain.mk): gcc compiles them,
# binutils assembles and links what the vendor gcc makes of them.
#
# Wide and shallow on purpose -- thousands of small functions and classes, so parsing at
# volume, inlining, loop and arithmetic optimisation, register allocation, template
# instantiation, STL, exceptions and RAII all get exercised, with nothing needed from the
# target beyond libc and libstdc++ headers. Generated rather than kept as ~9400 lines of
# repetition; the output is byte-identical to the files the published archives were
# profiled with, so a rebuild trains on exactly the same input.
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
