
#ifndef SQLITE_API
# define SQLITE_API
#endif

SQLITE_API int sqlite3_key(
  void *db,                   /* Database to be rekeyed */
  const void *pKey, int nKey     /* The key */
)
{
    return 1; // SQLITE_ERROR
}

SQLITE_API int sqlite3_rekey(
  void *db,                   /* Database to be rekeyed */
  const void *pKey, int nKey     /* The new key */
)
{
    return 1; // SQLITE_ERROR
}

SQLITE_API int sqlite3_key_v2(
  void *db,                   /* Database to be rekeyed */
  const char* szName,
  const void *pKey, int nKey     /* The key */
)
{
    return 1; // SQLITE_ERROR
}

SQLITE_API int sqlite3_rekey_v2(
  void *db,                   /* Database to be rekeyed */
  const char* szName,
  const void *pKey, int nKey     /* The new key */
)
{
    return 1; // SQLITE_ERROR
}

