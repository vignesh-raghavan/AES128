/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "system.h"
#include "io.h"

#define DMA_WR_BASE DMA_0_BASE
#define DMA_RD_BASE DMA_1_BASE


static unsigned int* aes_control = AES_SLAVE_INTERFACE_9_0_AVALON_SLAVE_WR_BASE;
static unsigned int* aes_status = AES_SLAVE_INTERFACE_9_0_AVALON_SLAVE_RD_BASE + 16;
//static unsigned int* aes_control = AES_SLAVE_INTERFACE_0_0_BASE;
//static unsigned int* aes_status = AES_SLAVE_INTERFACE_0_0_BASE + 16;

unsigned int data1;
unsigned int data2;
unsigned int data3;
unsigned int data4;

unsigned int ewords[64];

unsigned int words[64] = {
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732
};


void encrypt1()
{
	int k, i;

	for(k = 0; k<3; k++)
	{

		*(aes_control) = words[0];
		*(aes_control) = words[1];
		*(aes_control) = words[2];
		*(aes_control) = words[3];

		//while(*(aes_status+4) == 0x0);

		data1 = *(aes_status);
		data2 = *(aes_status);
		data3 = *(aes_status);
		data4 = *(aes_status);

		printf("0x%08x%08x%08x%08x \n", data1, data2, data3, data4);

		*(aes_control) = words[4];
		*(aes_control) = words[5];
		*(aes_control) = words[6];
		*(aes_control) = words[7];

		//while(*(aes_status+4) == 0x0);

		data1 = *(aes_status);
		data2 = *(aes_status);
		data3 = *(aes_status);
		data4 = *(aes_status);

		printf("0x%08x%08x%08x%08x \n", data1, data2, data3, data4);
	}
}

void encrypt2()
{
	int k;

	for(k = 0; k<3; k++)
	{

		*(aes_control) = words[0];
		*(aes_control) = words[1];
		*(aes_control) = words[2];
		*(aes_control) = words[3];

		*(aes_control) = words[4];
		*(aes_control) = words[5];
		*(aes_control) = words[6];
		*(aes_control) = words[7];

		//while(*(aes_status+4) == 0x0);

		data1 = *(aes_status);
		data2 = *(aes_status);
		data3 = *(aes_status);
		data4 = *(aes_status);

		printf("0x%08x%08x%08x%08x \n", data1, data2, data3, data4);

		//while(*(aes_status+4) == 0x0);

		data1 = *(aes_status);
		data2 = *(aes_status);
		data3 = *(aes_status);
		data4 = *(aes_status);

		printf("0x%08x%08x%08x%08x \n", data1, data2, data3, data4);
	}
}

void encrypt3()
{
	IOWR(DMA_WR_BASE, 6, 1<<12);
	IOWR(DMA_WR_BASE, 6, 1<<12);
	IOWR(DMA_WR_BASE, 1, words);
	IOWR(DMA_WR_BASE, 2, aes_control);
	IOWR(DMA_WR_BASE, 3, 256);

	IOWR(DMA_WR_BASE, 6, 1<<9 | 1<< 7 | 1<<3 | 1<<2);
	while((IORD(DMA_WR_BASE, 0) & 0x1) == 0)
	{
		data1 = *(aes_status);
		data2 = *(aes_status);
		data3 = *(aes_status);
		data4 = *(aes_status);

		printf("0x%08x%08x%08x%08x \n", data1, data2, data3, data4);
	}
	IOWR(DMA_WR_BASE, 0, 0);

	while(*(aes_status+4))
	{
		data1 = *(aes_status);
		data2 = *(aes_status);
		data3 = *(aes_status);
		data4 = *(aes_status);

		printf("0x%08x%08x%08x%08x \n", data1, data2, data3, data4);
	}
}


void encrypt4()
{
	int i;

	IOWR(DMA_WR_BASE, 6, 1<<12);
	IOWR(DMA_WR_BASE, 6, 1<<12);
	IOWR(DMA_WR_BASE, 1, words);
	IOWR(DMA_WR_BASE, 2, aes_control);
	IOWR(DMA_WR_BASE, 3, 256);

	IOWR(DMA_RD_BASE, 6, 1<<12);
	IOWR(DMA_RD_BASE, 6, 1<<12);
	IOWR(DMA_RD_BASE, 1, aes_status);
	IOWR(DMA_RD_BASE, 2, ewords);
	IOWR(DMA_RD_BASE, 3, 256);

	IOWR(DMA_WR_BASE, 6, 1<<9 | 1<< 7 | 1<<3 | 1<<2);
	IOWR(DMA_RD_BASE, 6, 1<<8 | 1<< 7 | 1<<3 | 1<<2);
	while((IORD(DMA_WR_BASE, 0) & 0x1) == 0);
	IOWR(DMA_WR_BASE, 0, 0);

	while((IORD(DMA_RD_BASE, 0) & 0x1) == 0);
	IOWR(DMA_RD_BASE, 0, 0);

	for(i = 0; i < 64; i = i+4)
	{
		data1 = ewords[i];
		data2 = ewords[i+1];
		data3 = ewords[i+2];
		data4 = ewords[i+3];
		printf("0x%08x%08x%08x%08x \n", data1, data2, data3, data4);
	}
}


int main()
{
	int i, j;
	printf("Hello from Nios II!\n");

	encrypt3();

	return 0;
}
