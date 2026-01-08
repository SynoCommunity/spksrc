# chunk.py – minimal Python 3.13 stub
# 
# Workaround for tami4 integration that depends on Python 2 'chunk' module
# This is a replacement implementation

class Chunk:
    def __init__(self, file, align=True, bigendian=True, inclheader=False):
        self.file = file

    def getname(self):
        return None

    def getsize(self):
        return 0

    def read(self, size=-1):
        return b""

    def skip(self):
        pass

def open(file, *args, **kwargs):
    return Chunk(file, *args, **kwargs)
