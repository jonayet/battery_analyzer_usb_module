#ifndef _HARDWAREPROFILE_H_
#define _HARDWAREPROFILE_H_

// define System Clock
#define _XTAL_FREQ 48000000UL


// define IO
sbit _OP_SIG at LATA0_bit;
sbit _DR_SIG at TRISA0_bit;


/*** Function Prototypes ***/
void ConfigureIO();
void ConfigureModules();
void ConfigureInterrupts();

#endif