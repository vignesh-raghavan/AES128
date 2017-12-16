/*
 * cpu.h
 *
 *  Created on: Dec 8, 2017
 *      Author: 695r24
 */

#ifndef CPU_H_
#define CPU_H_

#define PERF_CNTR_BASE alt_get_performance_counter_base()

static unsigned int* aes_control =   AES_SLAVE_INTERFACE_11_0_AVALON_SLAVE_WR_BASE;
static unsigned int* aes_status =    AES_SLAVE_INTERFACE_11_0_AVALON_SLAVE_RD_BASE + 16;

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


#endif /* CPU_H_ */
