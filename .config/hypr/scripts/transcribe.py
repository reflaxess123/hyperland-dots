#!/usr/bin/env python3
import os, sys, glob

# Add venv nvidia libs to path
venv = os.path.join(os.path.expanduser("~"), ".local/share/voice-input/venv")
for lib in glob.glob(os.path.join(venv, "lib/python*/site-packages/nvidia/*/lib")):
    os.environ.setdefault("LD_LIBRARY_PATH", "")
    os.environ["LD_LIBRARY_PATH"] = lib + ":" + os.environ["LD_LIBRARY_PATH"]

import ctypes
for lib in glob.glob(os.path.join(venv, "lib/python*/site-packages/nvidia/cublas/lib/libcublas.so*")):
    ctypes.CDLL(lib, mode=ctypes.RTLD_GLOBAL)

from faster_whisper import WhisperModel

model = WhisperModel("large-v3-turbo", device="cuda", compute_type="float16")
segments, _ = model.transcribe(sys.argv[1], beam_size=1, vad_filter=True)
print(" ".join(seg.text.strip() for seg in segments))
