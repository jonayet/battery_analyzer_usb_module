#include "HardwareProfile.h"
#include "CompilerDefinations.h"


/*** I/O pin Configuration ***/
void ConfigureIO()
{
	// clear all port data
	PORTA = 0;
	PORtB = 0;
	PORTC = 0;
	
	// configure LED1
	_OP_LED1 = 0;
	_DR_LED1 = 0;
	
	// configure SW1
	_IP_SW1 = 0;
	_DR_SW1 = 1;
}


/*** Built-in Hardware Module Configuration ***/
void ConfigureModules()
{
	// use all AN input as Digital Input
	ADCON1 = 6;
	
	// disable internal comparator
	CMCON = 7;
}


/*** Interrupt Configuration ***/
void ConfigureInterrupts()
{
	// disable all interrupt
	INTCON = 0;
}