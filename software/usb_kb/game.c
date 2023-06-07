/*
 * game.c
 *
 *  Created on: Apr 15, 2023
 *      Author: rfnew
 */

#include <system.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <alt_types.h>
#include "game.h"
//
//void map_init()
//{
//	int map[16][16] = {
//			{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
//			{1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1},
//			{1,1,1,1,0,1,0,1,0,1,0,1,1,0,1,1},
//			{1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1},
//			{1,0,1,1,1,1,0,1,1,0,0,0,1,1,0,1},
//			{1,0,1,0,0,0,0,0,0,0,0,0,1,0,0,1},
//			{1,0,1,0,1,0,0,0,0,0,1,0,1,0,1,1},
//			{1,0,1,0,1,0,0,0,0,0,1,0,1,0,0,1},
//			{1,0,1,0,1,0,0,0,0,0,0,0,1,1,0,1},
//			{1,0,1,0,1,0,0,0,1,0,1,0,1,0,0,1},
//			{1,0,0,0,0,0,1,0,0,0,1,0,1,0,1,1},
//			{1,1,0,1,1,1,1,1,0,1,0,0,0,0,0,1},
//			{1,0,0,0,0,0,0,0,0,0,1,0,1,1,0,1},
//			{1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1},
//			{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
//			{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
//	};
//
//	for(int i=0; i<16; i++)
//	{
//		for(int j=0; j<16; j++)
//		{
//			if(map[i][j] == 1){
//				if(j>10)
//					ram->MAP_RAM[i*16+j] = 16 + (rand()%2) * 4 + (rand()%2);
//				else if (i>10)
//					ram->MAP_RAM[i*16+j] = 16 + (rand()%2) * 8 + (rand()%2) * 2;
//				else if (i>4)
//					ram->MAP_RAM[i*16+j] = 21 + (rand()%2) * 8 + (rand()%2) * 2;
//				else
//					ram->MAP_RAM[i*16+j] = 26 + (rand()%2) * 4 + (rand()%2);
//			}
//			else
//				ram->MAP_RAM[i*16+j] = 0x00;
//		}
//	}
//}
//
//void map_init()
//{
//	for(int i=0; i<16; i++)
//	{
//		for(int j=0; j<16; j++)
//		{
//			if (i==0 || i==15 || j==0 || j==15)
//				ram->MAP_RAM[i*16+j] = 0x80;
//			else if (i>1 && i<3 && j>3 && j<9)
//				ram->MAP_RAM[i*16+j] = 0x81;
//			else if (i>3 && i<5 && j>3 && j<9)
//				ram->MAP_RAM[i*16+j] = 0x86;
//			else if (i>5 && i<7 && j>3 && j<9)
//				ram->MAP_RAM[i*16+j] = 0x8b;
//			else if (i>7 && i<9 && j>3 && j<9)
//				ram->MAP_RAM[i*16+j] = 0x8c;
//			else
//				ram->MAP_RAM[i*16+j] = 0x00;
//		}
//	}
//}
//
void map_init()
{
	for(int i=0; i<16; i++)

	{
		for(int j=0; j<16; j++)
		{
			if (i==0 || i==15 || j==0 || j==15)
				ram->MAP_RAM[i*16+j] = 0x10;
			else
				ram->MAP_RAM[i*16+j] = 0x00;
		}
	}
}


void sin_init()
{
	for(int i=0; i<601; i++){
		double rad = M_PI*0.15*i/180;
		int s = sin(rad) * 256;
		int c = cos(rad) * 256;
		ram->SIN_RAM[i] = (s << 16) + c;
	}
}

void set_keycode(alt_u8* keys){
	alt_u8 keycode = 0x00;
	for(int i=0; i<6; i++)
	{
		if(keys[i] == 0x1a)		 	// W
			keycode |= 0x01;
		else if(keys[i] == 0x04) 	// A
			keycode |= 0x02;
		else if(keys[i] == 0x16) 	// S
			keycode |= 0x04;
		else if(keys[i] == 0x07) 	// D
			keycode |= 0x08;
		else if(keys[i] == 0x50) 	// left
			keycode |= 0x10;
		else if(keys[i] == 0x4f) 	// right
			keycode |= 0x20;
		else if(keys[i] == 0x2c)	// space
			keycode |= 0x40;
		else if(keys[i] == 0x28)    // enter
			keycode |= 0x80;
	}
	ram->KEYCODE = keycode;
}

void arrow_init(){
	for(int i = 0; i < 8; i++){
		ram->ARROW[i] = 0;
	}
}

void set_arrow(double* arrow_x, double* arrow_y, int* who_shoot_arr, int* num, int* aim_x, int* aim_y, int* map){
	alt_u32 mob_angle = ram->ARROW[0];
	alt_u32 steve_pos = ram->ARROW[1];
	ram->ARROW[0] = (((1<<16) - 1) & mob_angle);
	double angle = (int)(((1<<16) - 1) & mob_angle)*0.15;
	unsigned int who_shoot = (mob_angle >> 16);
	unsigned int steve_x = (steve_pos >> 16);
	unsigned int steve_y = (((1<<16) - 1) & steve_pos);
//	printf("num arrows: %d\n", *num);
	alt_u32 arrows[5] = {0};
	if(*num > 0 || who_shoot > 0){
		int exist = 0;
//		for(int i = 0; i < *num; i++){
//			if(who_shoot == who_shoot_arr[i]) exist = 1;
//		}
		if(exist == 0 && *num < 10){
			unsigned int mob_y = (((who_shoot>>4)<<1) + 1) << 7;
			unsigned int mob_x = (((((1<<4)-1) & who_shoot)<<1) + 1)<<7;
			arrow_x[*num] = mob_x;
			arrow_y[*num] = mob_y;
			aim_x[*num] = steve_x - mob_x;
			aim_y[*num] = steve_y - mob_y;
//			printf("mob_x : %d, ", mob_x);
//			printf("mob_y : %d \n", mob_y);
//			printf("steve_x : %d, ", steve_x);
//			printf("steve_y : %d \n", steve_y);
//			printf("aim_x : %d, ", aim_x[*num]);
//			printf("aim_y : %d \n", aim_y[*num]);
			who_shoot_arr[*num] = who_shoot;
			*num += 1;
		}

		for(int i = 0; i < *num; i++){
			int arrow_x_block = (((int)arrow_x[i])>>8);
			int arrow_y_block = (((int)arrow_y[i])>>8);
			printf("Arrow %d x block: %d ", i, arrow_x_block);
			printf("Arrow %d y block: %d\n", i, arrow_y_block);
			printf("Steve x block: %d ", ((int)steve_x)>>8 );
			printf("Steve y block: %d\n", ((int)steve_y)>>8 );
		}

		for(int i = 0; i < *num; i++){
			double abs = sqrt(aim_x[i]*aim_x[i] + aim_y[i]*aim_y[i]);
			arrow_x[i] += 0.0001 * aim_x[i]/abs;
			arrow_y[i] += 0.0001 * aim_y[i]/abs;
//			printf("x change : %d, ", (int)(250 * aim_x[i]/abs) >> 8);
//			printf("y change : %d \n", (int)(250 * aim_y[i]/abs) >> 8);
//			printf("Arrow %d x: %f", i, arrow_x[i]);
//			printf("Arrow %d y: %f", i, arrow_y[i]);
		}

		int arrow_display = 0;

		for(int i = 0; i < *num; i++){
			double dist_x_as = arrow_x[i] - steve_x;
			double dist_y_as = steve_y - arrow_y[i];
			double sin_value = dist_y_as/sqrt(dist_x_as*dist_x_as + dist_y_as*dist_y_as);
			double theta;
			int alpha;
			if(dist_x_as >= 0 && dist_y_as >= 0){
				theta = asin(sin_value) / M_PI * 180;
			}else if (dist_x_as <= 0){
				theta = 180 - asin(sin_value) / M_PI * 180;
			}else{
				theta = 360 + asin(sin_value) / M_PI * 180;
			}

			double gamma;
			if( theta - angle > 180) gamma = theta - angle - 360;
			else if ( theta - angle < -180) gamma = theta - angle + 360;
			else gamma = theta - angle;

			unsigned int mob_y = (((who_shoot_arr[i]>>4)<<1) + 1) << 7;
			unsigned int mob_x = (((((1<<4)-1) & who_shoot_arr[i])<<1) + 1)<<7;
			double dist_x_ma = mob_x - arrow_x[i];
			double dist_y_ma = arrow_y[i] - mob_y;
			double delta;
			sin_value = dist_y_ma/sqrt(dist_x_ma*dist_x_ma + dist_y_ma*dist_y_ma);
			if(dist_x_as >= 0 && dist_y_as >= 0){
				delta = asin(sin_value) / M_PI * 180;
			}else if (dist_x_as <= 0){
				delta = 180 - asin(sin_value) / M_PI * 180;
			}else{
				delta = 360 + asin(sin_value) / M_PI * 180;
			}

			double beta;
			if(delta > alpha) beta = delta - alpha;
			else beta = alpha - delta;

			int length = 63 * sin(beta);

			if( gamma >= -48 && gamma <= 48){
				alpha = (48 - gamma) / 0.15;
				if(arrow_display%2 == 0){
					arrows[arrow_display/2] = ((alpha<<6)+length)<<16;
				}else{
					arrows[arrow_display/2] = arrows[arrow_display/2] + ((alpha<<6)+length);
				}
				arrow_display += 1;
			}
		}

		int who_shot = 0;
		for(int i = 0; i < *num; i++){
			int arrow_x_block = (((int)arrow_x[i])>>8);
			int arrow_y_block = (((int)arrow_y[i])>>8);
			if(arrow_x_block == ((((int)steve_x)>>8)) && arrow_y_block == (((int)steve_y)>>8) ){
				who_shot = who_shoot_arr[i];
				for(int j = i; j < *num; j++){
					if(j+1 < 10){
						arrow_x[j] = arrow_x[j+1];
						arrow_y[j] = arrow_y[j+1];
						aim_x[j] = aim_x[j+1];
						aim_y[j] = aim_y[j+1];
						who_shoot_arr[j] = who_shoot_arr[j+1];
					}else{
						arrow_x[j] = 0;
						arrow_y[j] = 0;
						aim_x[j] = 0;
						aim_y[j] = 0;
						who_shoot_arr[j] = 0;
					}
				}
				*num -= 1;
			}else if(map[arrow_y_block * 16 + arrow_x_block] > 0 || arrow_x_block < 0 || arrow_x_block > 16 || arrow_y_block > 16){
				for(int j = i; j < *num; j++){
					if(j+1 < 10){
						arrow_x[j] = arrow_x[j+1];
						arrow_y[j] = arrow_y[j+1];
						aim_x[j] = aim_x[j+1];
						aim_y[j] = aim_y[j+1];
						who_shoot_arr[j] = who_shoot_arr[j+1];
					}else{
						arrow_x[j] = 0;
						arrow_y[j] = 0;
						aim_x[j] = 0;
						aim_y[j] = 0;
						who_shoot_arr[j] = 0;
					}
				}
				*num -= 1;
			}

//			printf("Arrow %d x block: %d ", i, arrow_x_block);
//			printf("Arrow %d y block: %d\n", i, arrow_y_block);
//			printf("Steve x block: %d ", ((int)steve_x)>>8 );
//			printf("Steve y block: %d\n", ((int)steve_y)>>8 );
//			printf("Arrow %d aim x : %d ,", i, aim_x[i]);
//			printf("Arrow %d aim y : %d\n", i, aim_y[i]);
		}

		ram->ARROW[7] = who_shot;
//		printf("who shot: %d\n", who_shot);

	}

	for(int i = 0; i < 5; i++){
		ram->ARROW[i+2] = arrows[i];
//		printf("%d ", ram->ARROW[i+2]);
	}


}
