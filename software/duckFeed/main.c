#include <io.h>
#include <system.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>

#define RADIUS 60

#define HWIDTH 640
#define HSYNC 96
#define HBACK_PORCH 48

#define VWIDTH 480
#define VSYNC 2
#define VBACK_PORCH 33
#define GROUND_HEIGHT 110

#define LEFT_MAX HSYNC+HBACK_PORCH
#define RIGHT_MAX HSYNC+HBACK_PORCH+HWIDTH-RADIUS
#define TOP_MAX VSYNC+VBACK_PORCH
#define BOTTOM_MAX VSYNC+VBACK_PORCH+VWIDTH-RADIUS-GROUND_HEIGHT


typedef struct {
    int timeLimit;
    int numDucks;
    int numShots;
    int speed;
    } LevelType;

//The level array
LevelType levels[10] = 
    {{30,2,14, 3000},
     {30,2,14, 5000},
     {30,4,14, 4000},
     {30,4,8, 3000},
     {20,4,8, 2500},
     {15,6,10, 2000},
     {15,8,12, 1500},
     {15,8,10, 1500},
     {15,8,8, 1000},
     {8,8,8, 1000}};

int playLevel(int level) {
    //Standard
    unsigned int i;

    
    ////SET HARDWARE VARIABLES////
    
    //Reset game immediately
    //Yes, 4 times is essential for these writes.  I hate NIOS.
    IOWR_16DIRECT(VGA_BASE, 0, 0x6005);
    IOWR_16DIRECT(VGA_BASE, 0, 0x6005);
    IOWR_16DIRECT(VGA_BASE, 0, 0x6005);
    IOWR_16DIRECT(VGA_BASE, 0, 0x6005);

    //A short delay
    usleep(500000);
    
    //Reset shot count
    IOWR_16DIRECT(ZAPPER_BASE, 0, 0x0001);
    IOWR_16DIRECT(ZAPPER_BASE, 0, 0x0001);
    IOWR_16DIRECT(ZAPPER_BASE, 0, 0x0001);
    IOWR_16DIRECT(ZAPPER_BASE, 0, 0x0001);    
    
    usleep(500000);
    //Set reset game to 0
    IOWR_16DIRECT(VGA_BASE, 0, 0x6000);
    IOWR_16DIRECT(VGA_BASE, 0, 0x6000);
    IOWR_16DIRECT(VGA_BASE, 0, 0x6000);
    IOWR_16DIRECT(VGA_BASE, 0, 0x6000);
    
    usleep(500000);
    
    IOWR_16DIRECT(ZAPPER_BASE, 0, 0);
    IOWR_16DIRECT(ZAPPER_BASE, 0, 0);
    IOWR_16DIRECT(ZAPPER_BASE, 0, 0);
    IOWR_16DIRECT(ZAPPER_BASE, 0, 0);
    
    usleep(500000);
    
    
    ////INITIALIZE SOFTWARE VARIABLES////

    //Initialize the countdown and shot counter
    double count = 0;
    int shots = 0;
    
    //Has any given duck been hit?
    //Only holds 1 or 0 values
    int duckHit[8];
    int hitCount = 0;
        
    //Horizontal and vertical positions and directions
    unsigned int h[8], v[8]; 
    int hdir[8], vdir[8];
    
    //Is any given duck visible? (depends on initial level)
    //Once invisible, does not change back
    volatile int duckVisible = 0x4000;
    
    //Initially, all of the level's ducks are visible
	for (i=0; i<levels[level].numDucks; i++) {
		duckVisible |= 1<<i;
		}

    //Initialize some default values
    for (i=0; i<8; i++) {
        v[i]=BOTTOM_MAX;    //Ducks will start at the ground
        vdir[i] = 1;        //They will all start by flying up
        h[i]=rand()%400+LEFT_MAX;   //Their horizontal position will be random
        hdir[i]=rand()%2;   //Their horizontal direction will be random
        duckHit[i]=0;       //No ducks are hit so far
        }
        
        


    
    //Initialize the game with duckVisibility
    IOWR_16DIRECT(VGA_BASE, 0, duckVisible);
    IOWR_16DIRECT(VGA_BASE, 0, duckVisible);
    IOWR_16DIRECT(VGA_BASE, 0, duckVisible);
    IOWR_16DIRECT(VGA_BASE, 0, duckVisible);
    
    

	////PLAY THE LEVEL WHILE////
    //1. the level has not been won 
    //2. and the countdown > 0 
    //3. and there are shots left
    int win=0;
	while (win==0 && count < levels[level].timeLimit && shots < levels[level].numShots) {
        
        //Increment count
        // determined this value by experiment
        count+= (double)levels[level].speed/(double)300000; 
        
       	//For each duck
		for (i=0; i<8; i++){
			//If the duck has been registered as hit, make it fly off the screen
			if (duckHit[i]==1) {
				if (v[i]>TOP_MAX)
        			v[i]-=4;
        		//Once the duck hits the top of the screen, make it invisible
    			else if (v[i]==TOP_MAX || v[i]==TOP_MAX-1 || v[i]==TOP_MAX-2 || v[i]==TOP_MAX-3) {
    				int tmpMask = 0xffff;
        			duckVisible &= tmpMask^(1<<i);
       				}
    			}
			//Otherwise, the duck has not been hit, make it fly randomly
			else {
    			//Horizontal movement
    			if (hdir[i] == 0) {
        			if (h[i]>RIGHT_MAX || rand()%250==0) 
            			hdir[i] = 1;
        			else 
            			h[i]++;
        			}
    			else {
        			if (h[i]<LEFT_MAX || rand()%250==0) 
            			hdir[i] = 0;
        			else 
           				h[i]--;   
        			}
            
                //Vertical movement
                if (vdir[i] == 0) {
                    if (v[i]>BOTTOM_MAX || rand()%250==0) 
                        vdir[i] = 1;
                    else 
                        v[i]++;
                    }
                else {
                    if (v[i]<TOP_MAX || rand()%250==0) 
                        vdir[i] = 0; 
                    else 
                        v[i]--;
                    }
                }//else, duck not hit
    
            //Update horizontal position
            IOWR_16DIRECT(VGA_BASE, 0, i*0x400 | h[i]);
            
            //Update vertical position
            //the &0x2000 puts a 1 in the 13 spot to update the vertical
            IOWR_16DIRECT(VGA_BASE, 0, i*0x400 | 0x2000 | v[i]);
            }//for each duck
        
        //Update duck visibility
        IOWR_16DIRECT(VGA_BASE, 0, duckVisible);
        IOWR_16DIRECT(VGA_BASE, 0, duckVisible);
        IOWR_16DIRECT(VGA_BASE, 0, duckVisible);
        IOWR_16DIRECT(VGA_BASE, 0, duckVisible);
          
        //Check for duck hits
        unsigned int duckHitsHardware = IORD_16DIRECT(VGA_BASE, 0);
        for (i=0; i<8; i++) {
            if ((duckHitsHardware&0x1)==1) {
                if (duckHit[i] == 0) {
                    duckHit[i]=1;
                    hitCount++;
                    }
                }
            else
                duckHit[i]=0;
            duckHitsHardware=duckHitsHardware>>1;
            }

        //Update the number of shots
        shots=IORD_16DIRECT(ZAPPER_BASE, 0);
        printf("shots: %d\n",shots);
		  
		  //Update the shots and timer on the vga
		  IOWR_16DIRECT(VGA_BASE,0,0xa000|(unsigned int)(levels[level].numShots-shots));
		  IOWR_16DIRECT(VGA_BASE,0,0x8000|(unsigned int)((levels[level].timeLimit-count)*HWIDTH/levels[level].timeLimit));

        //Win if all ducks are hit.
        if (hitCount == levels[level].numDucks)
            win = 1;
            
        //Sleep to slow down the movement
        usleep(levels[level].speed);
        
		}//While level not won or lost
    
    //Be sure that the rest of the ducks fly off the level before advancing
    if (win) {
        while (duckVisible!=0x4000) {
            //For each duck
            for (i=0; i<8; i++){
                if (v[i]>TOP_MAX)
                    v[i]-=3;
                //Once the duck hits the top of the screen, make it invisible
                else if (v[i]==TOP_MAX || v[i]==TOP_MAX-1 || v[i]==TOP_MAX-2) {
                    int tmpMask = 0xffff;
                    duckVisible &= tmpMask^(1<<i);
                    }
                IOWR_16DIRECT(VGA_BASE, 0, i*0x400 | 0x2000 | v[i]);
                }
            IOWR_16DIRECT(VGA_BASE, 0, duckVisible);
            usleep(levels[level].speed);
            }
        }
       
    return win;
    }



int main() {
    //Standard
    int i;
    
    //Initialize random
	srand(time(NULL));
    
    //Play the game over and over again
    while (1) {            
        //Assume that we won so that we can play the first level
        int win = 1;
        
        //Reset the game
        IOWR_16DIRECT(VGA_BASE, 0, 0xc005);
        IOWR_16DIRECT(VGA_BASE, 0, 0xc005);
        IOWR_16DIRECT(VGA_BASE, 0, 0xc005);
        IOWR_16DIRECT(VGA_BASE, 0, 0xc005);
        
        usleep(10000);
        
        IOWR_16DIRECT(VGA_BASE, 0, 0xc000);
        IOWR_16DIRECT(VGA_BASE, 0, 0xc000);
        IOWR_16DIRECT(VGA_BASE, 0, 0xc000);
        IOWR_16DIRECT(VGA_BASE, 0, 0xc000);
        
        
        
     	//Go through all 10 levels
    	for (i=0; i<10 && win==1; i++) {
     		win=playLevel(i);
    		}
        }

 
  	return 0;
  	}
