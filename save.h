/****************************************************************************
Image data created by the LCD Vision V1.05 font & image editor/converter
(C) Copyright 2011-2013 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Graphic LCD controller: PCD8544 (Nokia 3310, 5110) 84x48
Image width: 12 pixels
Image height: 13 pixels
Color depth: 1 bits/pixel
Imported image file name: disquete.bmp

Exported monochrome image data size:
30 bytes for displays organized as horizontal rows of bytes
28 bytes for displays organized as rows of vertical bytes.
****************************************************************************/

#ifndef _SAVE2_INCLUDED_
#define _SAVE2_INCLUDED_

flash unsigned char save2[]=
{
/* Image width: 12 pixels */
0x0C, 0x00,
/* Image height: 13 pixels */
0x0D, 0x00,
#ifndef _GLCD_DATA_BYTEY_
/* Image data for monochrome displays organized
   as horizontal rows of bytes */
0xFF, 0x01, 0x63, 0x03, 0x63, 0x07, 0xFF, 0x0F, 
0xFF, 0x0F, 0xFF, 0x0F, 0x03, 0x0C, 0x03, 0x0C, 
0x03, 0x0C, 0x03, 0x0C, 0x03, 0x0C, 0x03, 0x0C, 
0xFF, 0x0F, 
#else
/* Image data for monochrome displays organized
   as rows of vertical bytes */
0xFF, 0xFF, 0x39, 0x39, 0x39, 0x3F, 0x3F, 0x39, 
0x3F, 0x3E, 0xFC, 0xF8, 0x1F, 0x1F, 0x10, 0x10, 
0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x1F, 0x1F, 
#endif
};


#endif

