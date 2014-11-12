#define _SPI_WRITE_READ SPI1_Read
#define _MCP3304_OP_CS LATC6_Bit
#define _MCP3304_DR_CS TRISC6_Bit

extern unsigned int MCP3304_Data;

void MCP3304_Init();
void MCP3304_Read(unsigned char Channel);