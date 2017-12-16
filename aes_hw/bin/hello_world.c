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
#include <altera_avalon_performance_counter.h>

#define DMA_WR_BASE DMA_0_BASE
#define DMA_RD_BASE DMA_1_BASE
#define PERF_CNTR_BASE alt_get_performance_counter_base()

//static unsigned int* aes_control =   AES_SLAVE_INTERFACE_11_0_AVALON_SLAVE_WR_BASE;
//static unsigned int* aes_status =    AES_SLAVE_INTERFACE_11_0_AVALON_SLAVE_RD_BASE + 16;
//static unsigned int* cipher_status = AES_SLAVE_INTERFACE_11_0_AVALON_SLAVE_RD_BASE + 32;

static unsigned int* aes_control = AES_SLAVE_INTERFACE_0_0_BASE;
static unsigned int* aes_status = AES_SLAVE_INTERFACE_0_0_BASE + 16;
static unsigned int* cipher_status = AES_SLAVE_INTERFACE_0_0_BASE + 32;

//5ac5b47080b7cdd830047b6ad8e0c469
//26c3f4415c36600bc6e67b10df5047fa

unsigned int ewords[256];

unsigned int words[256] = {
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
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732,
		0xffeeddcc, 0xbbaa9988, 0x77665544, 0x33221100,
		0xf47237c1, 0x8b4c5a40, 0x59d1c3ab, 0x48966732
};

unsigned int dwords[64] = {
		0x11111111, 0x11111111, 0x11111111, 0x11111111,
		0x22222222, 0x22222222, 0x22222222, 0x22222222,
		0x33333333, 0x33333333, 0x33333333, 0x33333333,
		0x44444444, 0x44444444, 0x44444444, 0x44444444,
		0x55555555, 0x55555555, 0x55555555, 0x55555555,
		0x66666666, 0x66666666, 0x66666666, 0x66666666,
		0x77777777, 0x77777777, 0x77777777, 0x77777777,
		0x88888888, 0x88888888, 0x88888888, 0x88888888,
		0x99999999, 0x99999999, 0x99999999, 0x99999999,
		0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA, 0xAAAAAAAA,
		0xBBBBBBBB, 0xBBBBBBBB, 0xBBBBBBBB, 0xBBBBBBBB,
		0xCCCCCCCC, 0xCCCCCCCC, 0xCCCCCCCC, 0xCCCCCCCC,
		0xDDDDDDDD, 0xDDDDDDDD, 0xDDDDDDDD, 0xDDDDDDDD,
		0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE, 0xEEEEEEEE,
		0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
		0x12341234, 0x12341234, 0x12341234, 0x12341234
};

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


void cpu_encrypt(unsigned int* ptext, unsigned int* ctext)
{
	int i;
	unsigned int data1;
	unsigned int data2;
	unsigned int data3;
	unsigned int data4;

	//printf("Entering CPU Encryption! \n\n");

	//Performance Counter
	PERF_BEGIN(PERF_CNTR_BASE, 1);

	*(aes_control) = *(ptext);
	*(aes_control) = *(ptext+1);
	*(aes_control) = *(ptext+2);
	*(aes_control) = *(ptext+3);

	*(ctext)   = *(aes_status);
	*(ctext+1) = *(aes_status);
	*(ctext+2) = *(aes_status);
	*(ctext+3) = *(aes_status);

	//Performance Counter
	PERF_END(PERF_CNTR_BASE, 1);

	data1 = *(ctext);
	data2 = *(ctext+1);
	data3 = *(ctext+2);
	data4 = *(ctext+3);
	//printf("0x%08x%08x%08x%08x \n", data1, data2, data3, data4);

	//printf("\nExiting CPU Encryption! \n\n");
}

void encrypt2(unsigned int* pwords, unsigned int* cwords)
{
	int i;

	for(i = 0; i < 256; i = i+4)
	{
		cpu_encrypt(pwords+i, cwords+i);
//    	printf("0x%08x%08x%08x%08x \n", pwords[i], pwords[i+1], pwords[i+2], pwords[i+3]);
//    	printf("0x%08x%08x%08x%08x \n", cwords[i], cwords[i+1], cwords[i+2], cwords[i+3]);
	}

}

void encrypt3(unsigned int* pwords, unsigned int* cwords)
{
	dma_encrypt(pwords, cwords, 1024);
}

int main()
{
	int i, j;
	unsigned int *pwords = words;
	unsigned int *cwords;

	printf("Hello from Nios II!\n");

	//Performance Counter
	PERF_RESET(PERF_CNTR_BASE);
	PERF_START_MEASURING(PERF_CNTR_BASE);

	encrypt2(pwords, cwords);
	//encrypt3(pwords, cwords);

	//Performance Counter
	PERF_STOP_MEASURING(PERF_CNTR_BASE);
	perf_print_formatted_report(PERF_CNTR_BASE, 50000000, 1, "AES HW");

	return 0;
}
