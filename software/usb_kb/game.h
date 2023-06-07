/*
 * game.h
 *
 *  Created on: Apr 15, 2023
 *      Author: rfnew
 */

#ifndef GAME_H_
#define GAME_H_

#include <system.h>
#include <alt_types.h>

struct GAME_STRUCT {
	alt_u32 KEYCODE;
	alt_u32 buff0 [7];
	alt_u32 ARROW [8];
	alt_u32 buff1 [496];
	alt_u8 MAP_RAM [256];
	alt_u32 buff2 [448];
	alt_u32 SIN_RAM [601];
};

static volatile struct GAME_STRUCT* ram = VGA_TEXT_MODE_CONTROLLER_0_BASE;

void map_init();
void sin_init();
void set_keycode(alt_u8* keys);
void arrow_init();
void set_arrow(double* arrow_x, double* arrow_y, int* who_shoot_arr, int* num, int* aim_x, int* aim_y, int* map);

#endif /* GAME_H_ */
