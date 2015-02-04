#include "MCP3304.h"
#include "built_in.h"

void MCP3304_Init()
{
    _MCP3304_OP_CS = 1;
    _MCP3304_DR_CS = 0;
    MCP3304_Data = 0;
}

unsigned int last_data = 0;
unsigned char D2D1, D0;
void MCP3304_Read(unsigned char Channel)
{
    // Chip requires !CS drop low for TX/RX
    _MCP3304_OP_CS = 0;

    D0 = 0;
    D2D1 = 0;
    if(Channel & 0x01) { D0 = 0x80; }
    if(Channel & 0x02) { D2D1 |= 0x01; }
    if(Channel & 0x04) { D2D1 |= 0x02; }
  
    // send first byte (Start Bit + SGL_nDIFF + D2 + D1), nothing to read
    _SPI_WRITE_READ(0b00001000 | D2D1);      // 0b00001000
    
    // send second byte(D0), read data
    Hi(MCP3304_Data) = _SPI_WRITE_READ(D0) & 0x1F;
    
    // read data, nothing to
    Lo(MCP3304_Data) = _SPI_WRITE_READ(0);
    
    // restore chip select after read
    _MCP3304_OP_CS = 1;
    
    // check SIGN bit, convert to negetive number if needed
    if(MCP3304_Data & 0x1000)
    {
        MCP3304_Data |= 0xE000;
    }
}