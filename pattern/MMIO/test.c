#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>



#define RAND (rand())
#define N 100
int main(){
    uint32_t a[N][8][8], b[N][8][8], t[N][8][8], gold[N][8][8];
    uint32_t a0[N][11][4], a1[N][11][4], b0[N][11][4], b1[N][11][4];
    for (int n = 0; n < N; ++n) {
        for (int i = 0; i < 8; ++i) {
            for (int j = 0; j < 8; ++j) {
            a[n][i][j] = (RAND % 64) - 32;
            b[n][i][j] = (RAND % 64) - 32;
            }
        }

        for (int i = 0; i < 11; ++i) {
            for (int j = 0; j < 4; ++j) {
            a0[n][i][j]=0;
            a1[n][i][j]=0;
            b0[n][i][j]=0;
            b1[n][i][j]=0;
            // t[i][j]=0;
            }
        }

        
        for (int i = 0; i < 8; ++i) {
            for (int j = 0; j < 8; ++j) {
            t[n][j][i] = a[n][i][j];
            gold[n][i][j] = 0;
            }
        }

        //b->a0,a1 a->b0,b1
        for (int i = 0; i < 8; ++i) {
            a0[n][i  ][0] = b[n][i][0];
            a0[n][i+1][1] = b[n][i][1];
            a0[n][i+2][2] = b[n][i][2];
            a0[n][i+3][3] = b[n][i][3];
            a1[n][i  ][0] = b[n][i][4];
            a1[n][i+1][1] = b[n][i][5];
            a1[n][i+2][2] = b[n][i][6];
            a1[n][i+3][3] = b[n][i][7];
            b0[n][i  ][0] = t[n][i][0];
            b0[n][i+1][1] = t[n][i][1];
            b0[n][i+2][2] = t[n][i][2];
            b0[n][i+3][3] = t[n][i][3];
            b1[n][i  ][0] = t[n][i][4];
            b1[n][i+1][1] = t[n][i][5];
            b1[n][i+2][2] = t[n][i][6];
            b1[n][i+3][3] = t[n][i][7];
        }

        for (int r = 0; r < 8; r++) for (int c = 0; c < 8; c++)  for (int k = 0; k < 8; k++)
        gold[n][r][c] += a[n][r][k]*b[n][k][c];
    }

    FILE *fptr;

    fptr = fopen("pattern.h", "w");
  
    fprintf(fptr, "uint32_t a0[%d][11][4] = {\n", N);
    for (int n = 0; n < N; n++){
        fprintf(fptr, "{");
        for (int i = 0; i < 11; ++i) {
            fprintf(fptr, "{");
            for (int j = 0; j < 4; ++j) {
                if(j==3) fprintf(fptr, "%5d", a0[n][i][j]);
                else fprintf(fptr, "%5d, ", a0[n][i][j]);
            }
            if(i==10) fprintf(fptr, "}");
            else fprintf(fptr, "},\n");
        }
        if(n==N-1) fprintf(fptr, "}\n");
        else fprintf(fptr, "},\n");
    }
    fprintf(fptr, "};\n");

    fprintf(fptr, "uint32_t a1[%d][11][4] = {\n", N);
    for (int n = 0; n < N; n++){
        fprintf(fptr, "{");
        for (int i = 0; i < 11; ++i) {
            fprintf(fptr, "{");
            for (int j = 0; j < 4; ++j) {
                if(j==3) fprintf(fptr, "%5d", a1[n][i][j]);
                else fprintf(fptr, "%5d, ", a1[n][i][j]);
            }
            if(i==10) fprintf(fptr, "}");
            else fprintf(fptr, "},\n");
        }
        if(n==N-1) fprintf(fptr, "}\n");
        else fprintf(fptr, "},\n");
    }
    fprintf(fptr, "};\n");

    fprintf(fptr, "uint32_t b0[%d][11][4] = {\n", N);
    for (int n = 0; n < N; n++){
        fprintf(fptr, "{");
        for (int i = 0; i < 11; ++i) {
            fprintf(fptr, "{");
            for (int j = 0; j < 4; ++j) {
                if(j==3) fprintf(fptr, "%5d", b0[n][i][j]);
                else fprintf(fptr, "%5d, ", b0[n][i][j]);
            }
            if(i==10) fprintf(fptr, "}");
            else fprintf(fptr, "},\n");
        }
        if(n==N-1) fprintf(fptr, "}\n");
        else fprintf(fptr, "},\n");
    }
    fprintf(fptr, "};\n");

    fprintf(fptr, "uint32_t b1[%d][11][4] = {\n", N);
    for (int n = 0; n < N; n++){
        fprintf(fptr, "{");
        for (int i = 0; i < 11; ++i) {
            fprintf(fptr, "{");
            for (int j = 0; j < 4; ++j) {
                if(j==3) fprintf(fptr, "%5d", b1[n][i][j]);
                else fprintf(fptr, "%5d, ", b1[n][i][j]);
            }
            if(i==10) fprintf(fptr, "}");
            else fprintf(fptr, "},\n");
        }
        if(n==N-1) fprintf(fptr, "}\n");
        else fprintf(fptr, "},\n");
    }
    fprintf(fptr, "};\n");

    fprintf(fptr, "uint32_t a[%d][8][8] = {\n", N);
    for (int n = 0; n < N; n++){
        fprintf(fptr, "{");
        for (int i = 0; i < 8; ++i) {
            fprintf(fptr, "{");
            for (int j = 0; j < 8; ++j) {
                if(j==7) fprintf(fptr, "%5d", a[n][i][j]);
                else fprintf(fptr, "%5d, ", a[n][i][j]);
            }
            if(i==7) fprintf(fptr, "}");
            else fprintf(fptr, "},\n");
        }
        if(n==N-1) fprintf(fptr, "}\n");
        else fprintf(fptr, "},\n");
    }
    fprintf(fptr, "};\n");

    fprintf(fptr, "uint32_t b[%d][8][8] = {\n", N);
    for (int n = 0; n < N; n++){
        fprintf(fptr, "{");
        for (int i = 0; i < 8; ++i) {
            fprintf(fptr, "{");
            for (int j = 0; j < 8; ++j) {
                if(j==7) fprintf(fptr, "%5d", b[n][i][j]);
                else fprintf(fptr, "%5d, ", b[n][i][j]);
            }
            if(i==7) fprintf(fptr, "}");
            else fprintf(fptr, "},\n");
        }
        if(n==N-1) fprintf(fptr, "}\n");
        else fprintf(fptr, "},\n");
    }
    fprintf(fptr, "};\n");

    fprintf(fptr, "int32_t g[%d][8][8] = {\n", N);
    for (int n = 0; n < N; n++){
        fprintf(fptr, "{");
        for (int i = 0; i < 8; ++i) {
            fprintf(fptr, "{");
            for (int j = 0; j < 8; ++j) {
                if(j==7) fprintf(fptr, "%8d", gold[n][i][j]);
                else fprintf(fptr, "%8d, ", gold[n][i][j]);
            }
            if(i==7) fprintf(fptr, "}");
            else fprintf(fptr, "},\n");
        }
        if(n==N-1) fprintf(fptr, "}\n");
        else fprintf(fptr, "},\n");
    }
    fprintf(fptr, "};\n");
    
    fclose(fptr);   
    return 0;
}