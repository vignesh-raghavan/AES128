/*
 * dma.h
 *
 *  Created on: Dec 6, 2017
 *      Author: 695r24
 */

#ifndef DMA_H_
#define DMA_H_

#include "io.h"

#define PERF_CNTR_BASE alt_get_performance_counter_base()
#define DMA_WR_BASE DMA_0_BASE
#define DMA_RD_BASE DMA_1_BASE


//static unsigned int* aes_control =   AES_SLAVE_INTERFACE_11_0_AVALON_SLAVE_WR_BASE;
//static unsigned int* aes_status =    AES_SLAVE_INTERFACE_11_0_AVALON_SLAVE_RD_BASE + 16;

extern unsigned int* aes_control;
extern unsigned int* aes_status;

void dma_encrypt(unsigned int* ptext, unsigned int* ctext, unsigned int size)
{
	int i;
	unsigned int data1;
	unsigned int data2;
	unsigned int data3;
	unsigned int data4;

	//printf("Entering DMA Encryption! \n\n");

	//Performance Counter
	PERF_BEGIN(PERF_CNTR_BASE, 1);

	IOWR(DMA_WR_BASE, 6, 1<<12);
	IOWR(DMA_WR_BASE, 6, 1<<12);
	IOWR(DMA_WR_BASE, 1, ptext);
	IOWR(DMA_WR_BASE, 2, aes_control);
	IOWR(DMA_WR_BASE, 3, size);

	IOWR(DMA_RD_BASE, 6, 1<<12);
	IOWR(DMA_RD_BASE, 6, 1<<12);
	IOWR(DMA_RD_BASE, 1, aes_status);
	IOWR(DMA_RD_BASE, 2, ctext);
	IOWR(DMA_RD_BASE, 3, size);

	IOWR(DMA_WR_BASE, 6, 1<<9 | 1<< 7 | 1<<3 | 1<<2);
	IOWR(DMA_RD_BASE, 6, 1<<8 | 1<< 7 | 1<<3 | 1<<2);
	while((IORD(DMA_WR_BASE, 0) & 0x1) == 0);
	IOWR(DMA_WR_BASE, 0, 0);

	while((IORD(DMA_RD_BASE, 0) & 0x1) == 0);
	IOWR(DMA_RD_BASE, 0, 0);

	//Performance Counter
	PERF_END(PERF_CNTR_BASE, 1);

	/*for(i = 0; i < 16; i = i+4)
	{
		data1 = ctext[i];
		data2 = ctext[i+1];
		data3 = ctext[i+2];
		data4 = ctext[i+3];
		//printf("0x%08x%08x%08x%08x \n", data1, data2, data3, data4);
	}*/

	//printf("\nExiting DMA Encryption! \n");
}


#endif /* DMA_H_ */
