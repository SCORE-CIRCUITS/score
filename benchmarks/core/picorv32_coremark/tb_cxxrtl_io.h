#ifndef _TB_CXXRTL_IO_H
#define _TB_CXXRTL_IO_H

#include <stdint.h>

static inline void tb_putc(char c) {
    *((volatile uint32_t *)0x10000000) = (uint32_t)c;
}

#endif /* _TB_CXXRTL_IO_H */

