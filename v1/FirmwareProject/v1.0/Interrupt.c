// Interrupt service routines
#include "HardwareProfile.h"
#include "CompilerDefinations.h"

// High Interrupt service routine
void interrupt()
{
    // Call library interrupt handler routine
    USBDev_IntHandler();
}

void interrupt_low()
{

}