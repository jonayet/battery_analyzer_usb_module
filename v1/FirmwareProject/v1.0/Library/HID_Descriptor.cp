#line 1 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Library/HID_Descriptor.c"
#line 1 "c:/users/jonayet.hossain/documents/mikroelektronika/mikroc pro for pic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed char int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 10 "F:/Projects/Personal/Embedded System/Pearl Enterprise/battery_analyzer_usb_module/v1/FirmwareProject/v1.0/Library/HID_Descriptor.c"
const uint8_t _USB_HID_MANUFACTURER_STRING[] = "Mikroelektronika";
const uint8_t _USB_HID_PRODUCT_STRING[] = "HID Custom Demo";
const uint8_t _USB_HID_SERIALNUMBER_STRING[] = "0x00000003";
const uint8_t _USB_HID_CONFIGURATION_STRING[] = "HID Config desc string";
const uint8_t _USB_HID_INTERFACE_STRING[] = "HID Interface desc string";


const uint8_t _USB_VENDOR_ID0 = 0x1F;
const uint8_t _USB_VENDOR_ID1 = 0xBD;
const uint8_t _USB_PRODUCT_ID0 = 0x00;
const uint8_t _USB_PRODUCT_ID1 = 0x03;
const uint8_t _USB_SERVICE_INTERVAL = 1;


const uint8_t _USB_HID_IN_PACKET = 64;
const uint8_t _USB_HID_OUT_PACKET = 64;


const uint8_t _USB_POWER_OPTION = 0xE0;
const uint8_t _USB_MAX_POWER = 0x32;


const uint8_t _USB_HID_IN_EP = 0x81;
const uint8_t _USB_HID_OUT_EP = 0x01;


const uint8_t _USB_HID_CONFIG_DESC_SIZ = 34+7;
const uint8_t _USB_HID_DESC_SIZ = 9;
const uint8_t _USB_HID_REPORT_DESC_SIZE = 33;
const uint8_t _USB_HID_DESCRIPTOR_TYPE = 0x21;


const uint8_t USB_HID_LangIDDesc[0x04] = {
 0x04,
 _USB_DEV_DESCRIPTOR_TYPE_STRING,
 0x409 & 0xFF,
 0x409 >> 8,
};



const uint8_t USB_HID_device_descriptor[] = {
 0x12,
 0x01,
 0x00,
 0x02,
 0x00,
 0x00,
 0x00,
 0x40,
 _USB_VENDOR_ID1, _USB_VENDOR_ID0,
 _USB_PRODUCT_ID1, _USB_PRODUCT_ID0,
 0x00,
 0x01,
 0x01,
 0x02,
 0x03,
 0x01

};



const uint8_t USB_HID_cfg_descriptor[_USB_HID_CONFIG_DESC_SIZ] = {

 0x09,
 _USB_DEV_DESCRIPTOR_TYPE_CONFIGURATION,
 _USB_HID_CONFIG_DESC_SIZ & 0xFF,
 _USB_HID_CONFIG_DESC_SIZ >> 8,
 0x01,
 0x01,
 0x04,
 _USB_POWER_OPTION,
 _USB_MAX_POWER,


 0x09,
 0x04,
 0x00,
 0x00,
 0x02,
 0x03,
 0x00,
 0x00,
 5,


 0x09,
 _USB_HID_DESCRIPTOR_TYPE,
 0x01,
 0x01,
 0x00,
 0x01,
 0x22,
 _USB_HID_REPORT_DESC_SIZE,
 0x00,


 0x07,
 _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,
 _USB_HID_IN_EP,
 0x03,
 0x40,
 0x00,
 _USB_SERVICE_INTERVAL,


 0x07,
 _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,
 _USB_HID_OUT_EP,
 0x03,
 0x40,
 0x00,
 _USB_SERVICE_INTERVAL
};


const uint8_t USB_HID_ReportDesc[_USB_HID_REPORT_DESC_SIZE] ={
 0x06, 0x00, 0xFF,
 0x09, 0x01,
 0xA1, 0x01,

 0x19, 0x01,
 0x29, 0x40,
 0x15, 0x00,
 0x26, 0xFF, 0x00,
 0x75, 0x08,
 0x95, _USB_HID_IN_PACKET,
 0x81, 0x02,

 0x19, 0x01,
 0x29, 0x40,
 0x75, 0x08,
 0x95, _USB_HID_OUT_PACKET,
 0x91, 0x02,
 0xC0
};
