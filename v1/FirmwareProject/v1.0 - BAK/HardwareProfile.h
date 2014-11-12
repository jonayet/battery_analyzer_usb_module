#ifndef _HARDWAREPROFILE_H_
#define _HARDWAREPROFILE_H_

// define System Clock
#define _XTAL_FREQ 48000000UL


// define IO
#define _IP_SW1 RB0_bit
#define _DR_SW1 TRISB0_bit
#define _OP_LED1 RB1_bit
#define _DR_LED1 TRISB1_bit


/*** Function Prototypes ***/
void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();

#endif
