import glob
import subprocess
import sys

pattern = "${CMAKE_CURRENT_BINARY_DIR}/PyCFFIlib_cffi*.so"
for so in glob.glob(pattern):
    print("rpath hack %s" % (so))
    rpath_hack = subprocess.run(
        ["${CMAKE_INSTALL_NAME_TOOL}", "-change", "@rpath/$<TARGET_FILE_NAME:mylib>", "$<TARGET_FILE:mylib>", so])
    if rpath_hack.returncode != 0:
        sys.exit(rpath_hack.returncode)

