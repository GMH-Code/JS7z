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

CFLAGS_WARN_GCC_5 = $(CFLAGS_WARN_GCC_4_8)\
  -Wbool-compare \

ifdef EMSCRIPTEN
CFLAGS_WARN_GCC_5_REMOVE := \
  -Wbool-compare

CFLAGS_WARN_GCC_5 := $(filter-out $(CFLAGS_WARN_GCC_5_REMOVE),$(CFLAGS_WARN_GCC_5))
endif # EMSCRIPTEN

CFLAGS_WARN_GCC_6 = $(CFLAGS_WARN_GCC_5)\
  -Wduplicated-cond \

ifdef EMSCRIPTEN
CFLAGS_WARN_GCC_6_REMOVE := \
  -Wduplicated-cond

CFLAGS_WARN_GCC_6 := $(filter-out $(CFLAGS_WARN_GCC_6_REMOVE),$(CFLAGS_WARN_GCC_6))
endif # EMSCRIPTEN

#  -Wno-strict-aliasing

CFLAGS_WARN_GCC_7 = $(CFLAGS_WARN_GCC_6)\
  -Wbool-operation \
  -Wconversion \
  -Wdangling-else \
  -Wduplicated-branches \
  -Wimplicit-fallthrough=5 \
  -Wint-in-bool-context \
  -Wmaybe-uninitialized \
  -Wmisleading-indentation \

ifdef EMSCRIPTEN
CFLAGS_WARN_GCC_7_REMOVE := \
  -Wduplicated-branches \
  -Wimplicit-fallthrough=5 \
  -Wmaybe-uninitialized

CFLAGS_WARN_GCC_7_ADD := \
  -Wimplicit-fallthrough \
  -Wuninitialized

CFLAGS_WARN_GCC_7 := $(filter-out $(CFLAGS_WARN_GCC_7_REMOVE),$(CFLAGS_WARN_GCC_7)) $(CFLAGS_WARN_GCC_7_ADD)
endif # EMSCRIPTEN

CFLAGS_WARN_GCC_8 = $(CFLAGS_WARN_GCC_7)\
  -Wcast-align=strict \
  -Wmissing-attributes

ifdef EMSCRIPTEN
CFLAGS_WARN_GCC_8_REMOVE := \
  -Wcast-align=strict \
  -Wmissing-attributes

CFLAGS_WARN_GCC_8 := $(filter-out $(CFLAGS_WARN_GCC_8_REMOVE),$(CFLAGS_WARN_GCC_8))
endif # EMSCRIPTEN

CFLAGS_WARN_GCC_9 = $(CFLAGS_WARN_GCC_8)\
  -Waddress-of-packed-member \

# In C: -Wsign-conversion enabled also by -Wconversion
#  -Wno-sign-conversion \


CFLAGS_WARN_GCC_PPMD_UNALIGNED = \
  -Wno-strict-aliasing \


CFLAGS_WARN = $(CFLAGS_WARN_GCC_4_8)
CFLAGS_WARN = $(CFLAGS_WARN_GCC_5)
CFLAGS_WARN = $(CFLAGS_WARN_GCC_6)
CFLAGS_WARN = $(CFLAGS_WARN_GCC_7)
CFLAGS_WARN = $(CFLAGS_WARN_GCC_8)
CFLAGS_WARN = $(CFLAGS_WARN_GCC_9)

# CXX_STD_FLAGS = -std=c++11
# CXX_STD_FLAGS =
