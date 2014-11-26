/*
 * Project name
     HID Custom Demo
 * Project file
     HID_Descriptor.c
*/

#include <stdint.h>

const uint8_t _USB_HID_MANUFACTURER_STRING[]  = "INFRA Tech";
const uint8_t _USB_HID_PRODUCT_STRING[]       = "USB Battery Analyzer";
const uint8_t _USB_HID_SERIALNUMBER_STRING[]  = "ITUBA010001";
const uint8_t _USB_HID_CONFIGURATION_STRING[] = "";
const uint8_t _USB_HID_INTERFACE_STRING[]     = "";

// device config
const uint8_t _USB_VENDOR_ID0 = 0x1F;
const uint8_t _USB_VENDOR_ID1 = 0xBD;
const uint8_t _USB_PRODUCT_ID0 = 0x00;
const uint8_t _USB_PRODUCT_ID1 = 0x04;
const uint8_t _USB_SERVICE_INTERVAL = 1;           // minimum 1ms

// Endpoint max packte size
const uint8_t _USB_HID_IN_PACKET  = 64;
const uint8_t _USB_HID_OUT_PACKET = 64;

// power option
const uint8_t _USB_POWER_OPTION = 0xE0;            // Self powered 0xC0,  0x80 bus powered
const uint8_t _USB_MAX_POWER = 0x32;                // Bus power required in units of 2 mA

// Endpoint address
const uint8_t _USB_HID_IN_EP      = 0x81;
const uint8_t _USB_HID_OUT_EP     = 0x01;

// Sizes of various descriptors
const uint8_t _USB_HID_CONFIG_DESC_SIZ   = 34+7;
const uint8_t _USB_HID_DESC_SIZ          = 9;
const uint8_t _USB_HID_REPORT_DESC_SIZE  = 33;
const uint8_t _USB_HID_DESCRIPTOR_TYPE   = 0x21;

//String Descriptor Zero, Specifying Languages Supported by the Device
const uint8_t USB_HID_LangIDDesc[0x04] = {
  0x04,
  _USB_DEV_DESCRIPTOR_TYPE_STRING,
  0x409 & 0xFF,
  0x409 >> 8,
};


// device descriptor
const uint8_t USB_HID_device_descriptor[] = {
  0x12,       // bLength
  0x01,       // bDescriptorType
  0x00,       // bcdUSB
  0x02,
  0x00,       // bDeviceClass
  0x00,       // bDeviceSubClass
  0x00,       // bDeviceProtocol
  0x40,       // bMaxPacketSize0
  _USB_VENDOR_ID1, _USB_VENDOR_ID0,         // idVendor
  _USB_PRODUCT_ID1, _USB_PRODUCT_ID0,       // idProduct
  0x00,       // bcdDevice
  0x01,
  0x01,       // iManufacturer
  0x02,       // iProduct
  0x03,       // iSerialNumber
  0x01        // bNumConfigurations

};

//contain configuration descriptor, all interface descriptors, and endpoint
//descriptors for all of the interfaces
const uint8_t USB_HID_cfg_descriptor[_USB_HID_CONFIG_DESC_SIZ] = {
  // Configuration descriptor
  0x09,                                   // bLength: Configuration Descriptor size
  _USB_DEV_DESCRIPTOR_TYPE_CONFIGURATION, // bDescriptorType: Configuration
  _USB_HID_CONFIG_DESC_SIZ & 0xFF,        // wTotalLength: Bytes returned
  _USB_HID_CONFIG_DESC_SIZ >> 8,          // wTotalLength: Bytes returned
  0x01,                                   // bNumInterfaces: 1 interface
  0x01,                                   // bConfigurationValue: Configuration value
  0x04,                                   // iConfiguration: Index of string descriptor describing  the configuration
  _USB_POWER_OPTION,                      // bmAttributes: self powered and Support Remote Wake-up
  _USB_MAX_POWER,                         // MaxPower 100 mA: this current is used for detecting Vbus

  // Interface Descriptor
  0x09,                                   // bLength: Interface Descriptor size
  0x04,                                   // bDescriptorType: Interface descriptor type
  0x00,                                   // bInterfaceNumber: Number of Interface
  0x00,                                   // bAlternateSetting: Alternate setting
  0x02,                                   // bNumEndpoints
  0x03,                                   // bInterfaceClass: HID
  0x00,                                   // bInterfaceSubClass : 1=BOOT, 0=no boot
  0x00,                                   // nInterfaceProtocol : 0=none, 1=keyboard, 2=mouse
  5,                                      // iInterface: Index of string descriptor

  // HID Descriptor
  0x09,                                   // bLength: HID Descriptor size
  _USB_HID_DESCRIPTOR_TYPE,               // bDescriptorType: HID
  0x01,                                   // bcdHID: HID Class Spec release number
  0x01,
  0x00,                                   // bCountryCode: Hardware target country
  0x01,                                   // bNumDescriptors: Number of HID class descriptors to follow
  0x22,                                   // bDescriptorType
  _USB_HID_REPORT_DESC_SIZE,              // wItemLength: Total length of Report descriptor
  0x00,

  // Endpoint descriptor
  0x07,                                   // bLength: Endpoint Descriptor size
  _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,      // bDescriptorType:
  _USB_HID_IN_EP,                         // bEndpointAddress: Endpoint Address (IN)
  0x03,                                   // bmAttributes: Interrupt endpoint
  0x40,                                   // wMaxPacketSize: 4 Byte max
  0x00,
  _USB_SERVICE_INTERVAL,                  // bInterval: Polling Interval (1 ms)

  // Endpoint descriptor
  0x07,                                   // bLength: Endpoint Descriptor size
  _USB_DEV_DESCRIPTOR_TYPE_ENDPOINT,      // bDescriptorType:
  _USB_HID_OUT_EP,                        // bEndpointAddress: Endpoint Address (OUT)
  0x03,                                   // bmAttributes: Interrupt endpoint
  0x40,                                   // wMaxPacketSize: 4 Byte max
  0x00,
  _USB_SERVICE_INTERVAL                   // bInterval: Polling Interval (1 ms)
};

// HID report descriptor
const uint8_t USB_HID_ReportDesc[_USB_HID_REPORT_DESC_SIZE] ={
     0x06, 0x00, 0xFF,       // Usage Page = 0xFF00 (Vendor Defined Page 1)
      0x09, 0x01,             // Usage (Vendor Usage 1)
      0xA1, 0x01,             // Collection (Application)
  // Input report
      0x19, 0x01,             // Usage Minimum
      0x29, 0x40,             // Usage Maximum
      0x15, 0x00,             // Logical Minimum (data bytes in the report may have minimum value = 0x00)
      0x26, 0xFF, 0x00,       // Logical Maximum (data bytes in the report may have maximum value = 0x00FF = unsigned 255)
      0x75, 0x08,             // Report Size: 8-bit field size
      0x95, _USB_HID_IN_PACKET,               // Report Count
      0x81, 0x02,             // Input (Data, Array, Abs)
  // Output report
      0x19, 0x01,             // Usage Minimum
      0x29, 0x40,             // Usage Maximum
      0x75, 0x08,             // Report Size: 8-bit field size
      0x95, _USB_HID_OUT_PACKET,               // Report Count
      0x91, 0x02,             // Output (Data, Array, Abs)
      0xC0                   // End Collection
};