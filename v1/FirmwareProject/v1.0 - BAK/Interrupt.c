// Interrupt service routines
#include "HardwareProfile.h"
#include "CompilerDefinations.h"

// Interrupt service routine
void interrupt()
{
    // USB servicing is done inside the interrupt
    USB_Interrupt_Proc();
}