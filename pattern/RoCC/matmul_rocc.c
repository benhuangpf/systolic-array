// See LICENSE for license details.

#include <stdint.h>
#include <stddef.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#ifndef BAREMETAL
#include <sys/mman.h>
#endif
#include <time.h>
#include "include/gemmini_testutils.h"

#include "include/pattern.h"

#define AINIT NO_ACTIVATION
#define SINIT 0
#define N 5


int main() {
#ifndef BAREMETAL
    if (mlockall(MCL_CURRENT | MCL_FUTURE) != 0) {
      perror("mlockall failed");
      exit(1);
    }
#endif

  gemmini_flush(0);
  gemmini_config_ld(DIM * sizeof(elem_t));
  gemmini_config_st(DIM * sizeof(elem_t));

  int activation = AINIT;
  int shift = 4;
  // printf("activation: %d, shift: %d\n", activation, shift);

  static elem_t A[N][DIM][DIM] row_align(1);
  static elem_t B[N][DIM][DIM] row_align(1);

  static elem_t C[N][DIM][DIM] row_align(1);
  static elem_t gold[N][DIM][DIM];
  // static elem_t gold_test[DIM][DIM];
  static full_t gold_full[N][DIM][DIM];
  // static full_t gold_full_test[DIM][DIM];
  for (size_t n = 0; n < N; ++n) {
    for (size_t i = 0; i < DIM; ++i) {
      for (size_t j = 0; j < DIM; ++j) {
        A[n][i][j] = a[n][i][j];
        B[n][i][j] = b[n][i][j];
        gold_full[n][i][j] = g[n][i][j];
      }
    }
  }
  // static elem_t ZERO[DIM][DIM];

  // matmul(A, B, ZERO, gold_full_test);
  for (size_t n = 0; n < N; ++n) matshift(gold_full[n], gold[n], shift);
  // matshift(gold_full_test, gold_test, shift);
  // printf("Gold:\n");
  // printMatrix(gold);
  // printf("Gold test:\n");
  // printMatrix(gold_test);
  // printf("A:\n");
  // printMatrix(A);
  // printf("B:\n");
  // printMatrix(B);

  // uint32_t A_addr = 0;
  // uint32_t B_addr = DIM;
  // uint32_t C_addr = (1 << (ADDR_LEN-1))+3*DIM;

  int A_addr = 0;
  int B_addr = N*DIM;
  int C_addr = 2*N*DIM;

  int start, end, write = 0, execute = 0, read = 0;

  // printf("Moving in\n");
  start = read_cycles();
  for (size_t n = 0; n < N; ++n) gemmini_mvin(A[n], A_addr + n*DIM);
  for (size_t n = 0; n < N; ++n) gemmini_mvin(B[n], B_addr + n*DIM);
  end = read_cycles();
  write = end - start;

  // printf("Setting mode\n");
  gemmini_config_ex(OUTPUT_STATIONARY, activation, shift);
  // gemmini_config_ex(WEIGHT_STATIONARY, activation, shift);

  // printf("Matmulling\n");
  uint64_t out_addr;
  start = read_cycles();
  for (size_t n = 0; n < N; ++n) {
    out_addr = C_addr + n*DIM;
    gemmini_preload_zeros(out_addr);
    gemmini_compute_preloaded(A_addr + n*DIM, B_addr + n*DIM);
  }
  end = read_cycles();
  execute = end - start;

  // gemmini_preload(B_addr, C_addr);
  // gemmini_compute_preloaded(A_addr, GARBAGE_ADDR);

  // printf("Moving out\n");
  start = read_cycles();
  for (size_t n = 0; n < N; ++n) gemmini_mvout(C[n], C_addr + n*DIM);
  end = read_cycles();
  read = end - start;

  // printf("Fencing\n");
  gemmini_fence();

  // printf("Moved out\n");
  // printf("C:\n");
  // printMatrix(C);
  // printf("Gold:\n");
  // printMatrix(gold);
  // printf("\n");

  // printf("Checking\n");
  // if (is_equal(C, gold)) {
  //     printf("correct\n");
  // }
  // else printf("wrong\n");

  for (size_t n = 0; n < N; ++n){    
    printf("Test: %d\n", n+1);
    int counter=0;
    for(int i=0;i<8;i++) for(int j=0;j<8;j++) if(C[n][i][j] != gold[n][i][j]) counter++;
    if(counter==0) printf("Correct\n\n");
    else{
      printf("Wrong elements: %d\n", counter);
      printf("Output:\n");
      printMatrix(C[n]);
      printf("Gold:\n");
      printMatrix(gold[n]);
      printf("\n");
    }    
  }
  printf("Write Cycle: %d\n", write);
  printf("Execute Cycle: %d\n", execute);
  printf("Read Cycle: %d\n", read);

  exit(0);
}

