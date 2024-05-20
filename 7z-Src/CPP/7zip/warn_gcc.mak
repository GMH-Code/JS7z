CFLAGS_WARN_GCC_4_8 = \
  -Waddress \
  -Waggressive-loop-optimizations \
  -Wattributes \
  -Wcast-align \
  -Wcomment \
  -Wdiv-by-zero \
  -Wformat-contains-nul \
  -Winit-self \
  -Wint-to-pointer-cast \
  -Wunused \
  -Wunused-macros \

ifdef EMSCRIPTEN
CFLAGS_WARN_GCC_4_8_REMOVE := \
  -Waggressive-loop-optimizations \
  -Wformat-contains-nul

CFLAGS_WARN_GCC_4_8_ADD := \
  -Wno-unused-but-set-variable

CFLAGS_WARN_GCC_4_8 := $(filter-out $(CFLAGS_WARN_GCC_4_8_REMOVE),$(CFLAGS_WARN_GCC_4_8)) $(CFLAGS_WARN_GCC_4_8_ADD)
endif # EMSCRIPTEN

CFLAGS_WARN_GCC_6 = $(CFLAGS_WARN_GCC_4_8)\
  -Wbool-compare \
  -Wduplicated-cond \

#  -Wno-strict-aliasing

ifdef EMSCRIPTEN
CFLAGS_WARN_GCC_6_REMOVE := \
  -Wbool-compare \
  -Wduplicated-cond

CFLAGS_WARN_GCC_6 := $(filter-out $(CFLAGS_WARN_GCC_6_REMOVE),$(CFLAGS_WARN_GCC_6))
endif # EMSCRIPTEN

CFLAGS_WARN_GCC_9 = $(CFLAGS_WARN_GCC_6)\
  -Waddress-of-packed-member \
  -Wbool-operation \
  -Wcast-align=strict \
  -Wconversion \
  -Wdangling-else \
  -Wduplicated-branches \
  -Wimplicit-fallthrough=5 \
  -Wint-in-bool-context \
  -Wmaybe-uninitialized \
  -Wmisleading-indentation \
  -Wmissing-attributes

ifdef EMSCRIPTEN
CFLAGS_WARN_GCC_9_REMOVE := \
  -Wcast-align=strict \
  -Wduplicated-branches \
  -Wimplicit-fallthrough=5 \
  -Wmaybe-uninitialized \
  -Wmissing-attributes

CFLAGS_WARN_GCC_9_ADD := \
  -Wimplicit-fallthrough \
  -Wuninitialized

CFLAGS_WARN_GCC_9 := $(filter-out $(CFLAGS_WARN_GCC_9_REMOVE),$(CFLAGS_WARN_GCC_9)) $(CFLAGS_WARN_GCC_9_ADD)
endif # EMSCRIPTEN

# In C: -Wsign-conversion enabled also by -Wconversion
#  -Wno-sign-conversion \


CFLAGS_WARN_GCC_PPMD_UNALIGNED = \
  -Wno-strict-aliasing \


CFLAGS_WARN = $(CFLAGS_WARN_GCC_4_8)
CFLAGS_WARN = $(CFLAGS_WARN_GCC_6)
CFLAGS_WARN = $(CFLAGS_WARN_GCC_9)

# CXX_STD_FLAGS = -std=c++11
# CXX_STD_FLAGS =
