#include <stdio.h>
#include <io.h>
#include <stdlib.h>
#include "bmp_cs50.h"
#include "altera_up_avalon_video_pixel_buffer_dma.h"
#include <altera_avalon_performance_counter.h>
#include "aes.h"
#include "vga_display.h"
#include "cpu.h"
#include "dma.h"

//#define PERF_CNTR_BASE alt_get_performance_counter_base()


//Expected Output
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

const char* s[3] = {"AES_SW", "AES_CPU", "AES_DMA"};

int main()
{
    int i;

	//Performance Counter
	PERF_RESET(PERF_CNTR_BASE);
	PERF_START_MEASURING(PERF_CNTR_BASE);

    printf("Hello from Nios II!\n");

	alt_up_pixel_buffer_dma_dev *pb = alt_up_pixel_buffer_dma_open_dev("/dev/video_pixel_buffer_dma_0");

    FILE *inptr = fopen("/mnt/rozipfs/tv.bmp", "r");

    if(inptr == NULL)
  	  printf("Image not found \n");

    BITMAPFILEHEADER bf;
    fread(&bf, sizeof(BITMAPFILEHEADER), 1, inptr);
    //printf("headerfile_size =  %d\n", sizeof(BITMAPFILEHEADER));

    BITMAPINFOHEADER bi;
    fread(&bi, sizeof(BITMAPINFOHEADER), 1, inptr);
    //printf("headerinfo_size = %d\n", sizeof(BITMAPFILEHEADER));

    int32_t biHeight;

    int k;
    unsigned int p;
    int j;
    int padding =  (4 - (bi.biWidth * sizeof(RGBTRIPLE)) % 4) % 4;
    int pixel_size = ( abs(bi.biHeight)*bi.biWidth )/2 ;//144
    unsigned int pixel[pixel_size];

    unsigned int *pixel1; // = (unsigned int*) 0x10800000;

    k = 0;
    p = 0;
    //printf("%d\n", pixel_size);
    printf("width = %d  height = %d\n", bi.biWidth, bi.biHeight);
    for (i = 0, biHeight = abs(bi.biHeight); i < biHeight; i++)
    {
    	j = 0;
		for (j = 0; j < bi.biWidth; j=j+2)
		{
			RGBTRIPLE triple;
			fread(&triple, sizeof(RGBTRIPLE), 1, inptr);

			p = (unsigned int) (triple.rgbtRed & (0xF8))<<8; // red
			p = p | ((triple.rgbtGreen & (0xFC)) << 3); // green
			p = p | ((triple.rgbtBlue & (0xF8)) >> 3); // blue

			p = p << 16;

			fread(&triple, sizeof(RGBTRIPLE), 1, inptr);

			p = p | (triple.rgbtRed & (0xF8))<<8; // red
			p = p | ((triple.rgbtGreen & (0xFC)) << 3); // green
			p = p | ((triple.rgbtBlue & (0xF8)) >> 3); // blue

			pixel[k] = p;
			k++;
			//printf("%0x\n", p);
		}
		//printf("\n\n");
		fseek(inptr, padding, SEEK_CUR);
    }
    i = pixel_size - 1;
    j = 0;
    for(i = pixel_size-1; i>=0; i--)
    {
    	pixel1[j] = pixel[i];
    	j++;
	}

    pixel_vga_display(pb, pixel1, bi.biWidth, biHeight);

    printf("Hello Encryption\n");

    unsigned int *pwords = pixel1; //words;
	unsigned int *cwords = (unsigned int*) 0x10800000;

	unsigned int mode = 3;
	//unsigned int pixel_size = 256;

	if(mode == 1)
	{
		for(i = 0; i < pixel_size; i = i+4)
		{
			sw_encrypt(pwords+i, cwords+i);
	//    	printf("0x%08x%08x%08x%08x \n", pwords[i], pwords[i+1], pwords[i+2], pwords[i+3]);
	//    	printf("0x%08x%08x%08x%08x \n", cwords[i], cwords[i+1], cwords[i+2], cwords[i+3]);
		}
	}

	else if(mode == 2)
	{
		for(i = 0; i < pixel_size; i = i+4)
		{
			cpu_encrypt(pwords+i, cwords+i);
	//    	printf("0x%08x%08x%08x%08x \n", pwords[i], pwords[i+1], pwords[i+2], pwords[i+3]);
	//    	printf("0x%08x%08x%08x%08x \n", cwords[i], cwords[i+1], cwords[i+2], cwords[i+3]);
		}
	}

	else if(mode == 3) dma_encrypt(pwords, cwords, 4*pixel_size);

    printf("End Encryption\n");

	//Performance Counter
	PERF_STOP_MEASURING(PERF_CNTR_BASE);
	perf_print_formatted_report(PERF_CNTR_BASE, 50000000, 1, s[mode-1]);

    return 0;
}
