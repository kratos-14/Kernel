#include <stdint.h>
#include "io-access.h"
#include "global.h"

uint16_t get_cursor_pos(void) 
{
  uint16_t pos = 0;
  outb(0x3D4, 0x0F);
  pos |= inb(0x3D5);
  outb(0x3D4, 0x0E);
  pos |= ((uint16_t)inb(0x3D5)) << 8;
  return pos;
}

void update_cursor_pos(int x, int y)
{
  uint16_t pos = y * VGA_WIDTH + x;
  outb(0x3D4, 0x0F);
  outb(0x3D5, (uint8_t) (pos & 0x0FF));
  outb(0x3D4, 0x0E);
  outb(0x3D5, (uint8_t) ((pos >> 8) & 0x0FF));
}
