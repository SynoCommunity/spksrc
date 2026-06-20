project('demometa-python-meson', 'c')

# pkg-config resolution of python-meta libs (python314 ships libzstd, sqlite3).
# meson reads PKG_CONFIG_LIBDIR from the environment (RUN macro), which carries
# the ordered local:meta list.
zstd = dependency('libzstd')
sqlite = dependency('sqlite3')

executable('demometa-python-meson', 'main.c',
           dependencies: [zstd, sqlite],
           install: true)
