#ifndef prtypes_h___
#define prtypes_h___

#ifdef __BIG_ENDIAN
#   undef  IS_LITTLE_ENDIAN
#   define IS_BIG_ENDIAN 1
#else
#   define IS_LITTLE_ENDIAN 1
#   undef IS_BIG_ENDIAN
#endif

#define PRInt64   long long

#define PR_BYTES_PER_BYTE   1L
#define PR_BYTES_PER_SHORT  2L
#define PR_BYTES_PER_INT    4L
#define PR_BYTES_PER_INT64  8L
#define PR_BYTES_PER_LONG   4L
#define PR_BYTES_PER_FLOAT  4L
#define PR_BYTES_PER_DOUBLE 8L
#define PR_BYTES_PER_WORD   4L
#define PR_BYTES_PER_DWORD  8L

#define PR_BITS_PER_BYTE    8L
#define PR_BITS_PER_SHORT   16L
#define PR_BITS_PER_INT     32L
#define PR_BITS_PER_INT64   64L
#define PR_BITS_PER_LONG    32L
#define PR_BITS_PER_FLOAT   32L
#define PR_BITS_PER_DOUBLE  64L
#define PR_BITS_PER_WORD    32L

#define PR_BITS_PER_BYTE_LOG2   3L
#define PR_BITS_PER_SHORT_LOG2  4L
#define PR_BITS_PER_INT_LOG2    5L
#define PR_BITS_PER_INT64_LOG2  6L
#define PR_BITS_PER_LONG_LOG2   5L
#define PR_BITS_PER_FLOAT_LOG2  5L
#define PR_BITS_PER_DOUBLE_LOG2 6L
#define PR_BITS_PER_WORD_LOG2   5L

#define PR_ALIGN_OF_SHORT   2L
#define PR_ALIGN_OF_INT     4L
#define PR_ALIGN_OF_LONG    4L
#define PR_ALIGN_OF_INT64   4L
#define PR_ALIGN_OF_FLOAT   4L
#define PR_ALIGN_OF_DOUBLE  4L
#define PR_ALIGN_OF_POINTER 4L
#define PR_ALIGN_OF_WORD    4L

#define PR_BYTES_PER_WORD_LOG2   2L
#define PR_BYTES_PER_DWORD_LOG2  3L
#define PR_WORDS_PER_DWORD_LOG2  1L

#define PR_STACK_GROWTH_DIRECTION (-1)

#endif /* prtypes_h___ */
