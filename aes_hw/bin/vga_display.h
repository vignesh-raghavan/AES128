/*
 * vga_display.h
 *
 *  Created on: Dec 8, 2017
 *      Author: 695r24
 */

#ifndef VGA_DISPLAY_H_
#define VGA_DISPLAY_H_

void pixel_vga_display(alt_up_pixel_buffer_dma_dev *pixel_buffer, unsigned int *pixel, int32_t imsize_x, int32_t imsize_y)
{
    register unsigned int addr;
    register unsigned int limit_x;
    register unsigned int limit_y;

    addr = pixel_buffer->buffer_start_address;
    limit_x = pixel_buffer->x_resolution;
    limit_x = limit_x << 1;//since i am converting the 32 bit to 16 bit pixel
    limit_y = pixel_buffer->y_resolution;

    register int x = 0;
    register int y = 0;
    register int i = 0;

    for (y = 0; y < limit_y; y++)
    {
    	for (x = 0; x < limit_x; x = x+2)
    	{
    		if(x < imsize_x && y < imsize_y)
    		{
    		    	IOWR_16DIRECT(addr, x << 1, (pixel[i]>>16));
    		    	IOWR_16DIRECT(addr, (x+1) << 1, (pixel[i] & 0xFFFF));
    		    	i++;
    		}
    		else
    		{
    			IOWR_16DIRECT(addr, x<<1, 0xF81F);
    			IOWR_16DIRECT(addr, (x+1)<<1, 0xF81F);
    		}
    	}
    	addr = addr + limit_x;
    }
}



#endif /* VGA_DISPLAY_H_ */
