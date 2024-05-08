#include "mmio.h"
#include "pattern.h"

#define N 5
// #define MM_STATUS 0x4000
// #define MM_A 0x4004
// #define MM_B 0x4008
// #define MM_RES 0x400C

#define MM_NUM 0x1000
#define MM_RADDR 0x1002
#define MM_RDATA_A0 0x1004
#define MM_RDATA_A1 0x1008
#define MM_RDATA_B0 0x100C
#define MM_RDATA_B1 0x1010


// #define MM_RADDR_A1 0x1012
// #define MM_RADDR_B0 0x1014
// #define MM_RADDR_B1 0x1016
#define MM_C00 0x1018
#define MM_C01 0x1020
#define MM_C10 0x1028
#define MM_C11 0x1030
#define MM_C20 0x1038
#define MM_C21 0x1040
#define MM_C30 0x1048
#define MM_C31 0x1050
#define MM_C40 0x1058
#define MM_C41 0x1060
#define MM_C50 0x1068
#define MM_C51 0x1070
#define MM_C60 0x1078
#define MM_C61 0x1080
#define MM_C70 0x1088
#define MM_C71 0x1090

#define MM_STATUS 0x1098
#define MM_IN 0x1099

static uint64_t read_cycles() {
    uint64_t cycles;
    asm volatile ("rdcycle %0" : "=r" (cycles));
    return cycles;
}

// DOC include start: GCD test
int main(void)
{
  //input ready=1 output valid =0
  // while ((reg_read8(MM_STATUS) & 0x2) == 0) ;
  int start, end, write = 0, execute = 0, read = 0;
  printf("Start writing matrix\n\n");
  start = read_cycles();
  for(int n=0;n<N;n++){      
    for(int i=0;i<11;i++){
      reg_write16(MM_NUM, n);
      reg_write16(MM_RADDR, i);
      reg_write32(MM_RDATA_A0, (uint8_t)a0[n][i][0]<<24|(uint8_t)a0[n][i][1]<<16|(uint8_t)a0[n][i][2]<<8|(uint8_t)a0[n][i][3]);
      // reg_write32(MM_RADDR_A1, i);
      reg_write32(MM_RDATA_A1, (uint8_t)a1[n][i][0]<<24|(uint8_t)a1[n][i][1]<<16|(uint8_t)a1[n][i][2]<<8|(uint8_t)a1[n][i][3]);
      // reg_write32(MM_RADDR_B0, i);
      reg_write32(MM_RDATA_B0, (uint8_t)b0[n][i][0]<<24|(uint8_t)b0[n][i][1]<<16|(uint8_t)b0[n][i][2]<<8|(uint8_t)b0[n][i][3]);
      // reg_write32(MM_RADDR_B1, i);
      reg_write32(MM_RDATA_B1, (uint8_t)b1[n][i][0]<<24|(uint8_t)b1[n][i][1]<<16|(uint8_t)b1[n][i][2]<<8|(uint8_t)b1[n][i][3]);      
    }
  }
  end = read_cycles();
  write = end - start;

  // printf("Done writing matrix\n\n");


  for(int n=0;n<N;n++){
    printf("Test: %d\n", n+1);
    printf("Start computing\n");
    reg_write32(MM_IN, 1);
    execute += 29;
    // printf("Done computing\n");

    //input ready=0 output valid =1
    // while ((reg_read8(MM_STATUS) & 0x1) == 0) ;

    // if(reg_read8(MM_ENABLE_C0) == 0)

    printf("Start reading\n");      
    uint64_t out[8][2];
    start = read_cycles();
    out[0][0] = reg_read64(MM_C00);
    out[0][1] = reg_read64(MM_C01);
    out[1][0] = reg_read64(MM_C10);
    out[1][1] = reg_read64(MM_C11);
    out[2][0] = reg_read64(MM_C20);
    out[2][1] = reg_read64(MM_C21);
    out[3][0] = reg_read64(MM_C30);
    out[3][1] = reg_read64(MM_C31);
    out[4][0] = reg_read64(MM_C40);
    out[4][1] = reg_read64(MM_C41);
    out[5][0] = reg_read64(MM_C50);
    out[5][1] = reg_read64(MM_C51);
    out[6][0] = reg_read64(MM_C60);
    out[6][1] = reg_read64(MM_C61);
    out[7][0] = reg_read64(MM_C70);
    out[7][1] = reg_read64(MM_C71);
    reg_read8(MM_STATUS);
    end = read_cycles();
    read = read + end - start;
    // printf("Done reading\n");

    printf("Start printing\n");
    int16_t *pt[8][2];
    int16_t ans[8][8];
    for(int i=0;i<8;i++) for(int j=0;j<2;j++) pt[i][j] = (int16_t*)&out[i][j];
    for(int i=0;i<8;i++) for(int j=0;j<2;j++) for(int k=3;k>=0;k--) 
    ans[i][4*j+(3-k)] = pt[i][j][k];

    
    int counter=0;
    for(int i=0;i<8;i++) for(int j=0;j<8;j++) if(ans[i][j] != g[n][i][j]) counter++;
    if(counter==0) printf("Correct\n\n");
    else{
      printf("Wrong elements: %d\n", counter);
      printf("Output\n");
      for(int i=0;i<8;i++){
        for(int j=0;j<8;j++) printf("%5d ", ans[i][j]);
        printf("\n");
      }
      printf("\n");
      printf("Gold\n");
      for(int i=0;i<8;i++){
        for(int j=0;j<8;j++) printf("%5d ", g[n][i][j]);
        printf("\n");
      }
      printf("\n");
    }
  }
  printf("Write Cycle: %d\n", write);
  printf("Execute Cycle: %d\n", execute);
  printf("Read Cycle: %d\n", read);
  return 0;
}
// DOC include end: GCD test

