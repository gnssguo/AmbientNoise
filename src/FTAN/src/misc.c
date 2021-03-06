/*
 * Read SAC header and seismogram and make output
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <string.h>
#include "aftan.h"

/*---------------------------------------------------------------*/
void readdata(int sac,char *name,int *n,double *dt,double *delta,
              double *t0,float *sei, float *user0)
/*---------------------------------------------------------------*/
{
int   i,nn, iswap, *ih, *nsam;
float hed[158];       // the SAC header
float dumm,dum[2];
float lat1=0.0, lat2=0.0, long1=0.0, long2=0.0;
int   i1=0,i2=0,idelta=0;
char *p;
FILE  *fd;

      for(i=0; i < 6000; i++) sei[i]=0.0f;
      iswap = 0;
      if((fd = fopen(name,"r")) == NULL) {
          printf("Can not find file %s.\n",name);
          exit(1);
      }
   if(sac) {
//       The header
      fread(hed,sizeof(float),158,fd);
      ih = (int *)(&hed[76]);
      if(*ih > 100 || *ih < -100) iswap = 1;
      if(iswap) swapn((unsigned char *)hed,(int)(sizeof(float)),158);
      *dt = hed[0];
      *delta = hed[50];
      nsam = (int *)(&hed[79]);
      *t0 = hed[5];
      lat1 = hed[31];
      long1 = hed[32];
      lat2 = hed[35];
      long2 = hed[36];
      *user0 = hed[40];
//       The body
      fread(sei,sizeof(float),*nsam,fd);
      if(iswap) swapn((unsigned char *)sei,(int)(sizeof(float)),*nsam);
      *n = *nsam;
   } else {
/*
 * Read test data from ascii file
 */
      i = 0;
      while((nn = fscanf(fd,"%f %f",&dumm,&sei[i])) == 2) {
          if(i < 2) dum[i] = dumm; i++;
      }
// extract delta from file name
      p = strrchr(name,'/');
      sscanf(p+1,"proba_%d_%d_%d.SAC",&i1,&i2,&idelta);
      *delta = idelta;
      *dt = dum[1]-dum[0];
      *n = i;
      *t0 = 0.0;
   }
      fclose(fd);

// seismogram is ready
/*

//compute the distance in degrees
float degree_dist(float lat1, float long1, float lat2, float long2) {
        return acos(sin(lat1 * PI / 180.0) * sin(lat2 * PI / 180.0) + cos(lat1 *PI / 180.0) *cos(lat2 * PI / 180.0) * cos((long2 - long1) * PI / 180.0)) * 180.0 / PI;
}
//END


//compute the distance in kilometers
float km_dist(float lat1, float long1, float lat2, float long2) {
        return degree_dist(lat1,long1,lat2,long2) * PI / 180.0 * EARTH_RADIUS;
}
//END

*/
     if (*delta < 0) {
        *delta = acos(sin(lat1 * 3.14159265 / 180.0) * sin(lat2 * 3.14159265 / 180.0) + cos(lat1 * 3.14159265 / 180.0) *cos(lat2 * 3.14159265 / 180.0) * cos((long2 - long1) * 3.14159265 / 180.0)) * 6371;
     }
//     printf("Delta= %lf, Dt= %lf, Nsamples= %d\n",*delta,*dt,*n);
}
/*
 * print completion result
 */
void printres(double dt,int nfout1,double arr1[100][8],int nfout2,
              double arr2[100][7],double tamp, int nrow,int ncol,
              double ampo[32][32768],int ierr, char *name,char *pref, double delta, int amp_flag)
{
 int i;
 FILE *out;
 char name2[160];
      if(ierr  ==  0 ) {
          printf("O.K.\n");
      } else if(ierr == 1) {
          printf("SOME PROBLEMS\n");
      } else {
          printf("NO FINAL RESULT\n");
      }
      //printf("Start:\n");
      //for(i = 0; i < nfout1; i++) {
      //    printf("%4d %10.4lf %10.4lf %12.4lf %12.4lf %12.4lf %12.4lf %8.3lf %8.3lf\n",
      //                i+1,arr1[i][0],arr1[i][1],arr1[i][2],arr1[i][3],
      //                    arr1[i][4],arr1[i][5], arr1[i][6], arr1[i][7]);
      //}
      //if(nfout2 != 0) {
      //printf("Final:\n");
      //    for(i = 0; i < nfout2; i++) {
      //        printf("%4d %10.4lf %10.4lf %12.4lf %12.4lf %12.4lf %8.3lf %8.3lf\n",
      //             i+1,arr2[i][0],arr2[i][1],arr2[i][2],arr2[i][3],
      //                 arr2[i][4], arr2[i][5], arr2[i][6]);
      //    }
      //}
//  write results to hard drive
// file ...DISP.0 contains preliminary result
//      strcpy(name2,name);
//      strcat(name2,pref);
//      strcat(name2,"_DISP.0");
//      if((out = fopen(name2,"w")) == NULL) {
//          printf("Can not open file %s.\n",name2);
//          exit(1);
//      }
//      for(i = 0; i < nfout1; i++) {
//          fprintf(out,"%4d %10.4lf %10.4lf %12.4lf %12.4lf %12.4lf %12.4lf %8.3lf\n",
//                      i,arr1[i][0],arr1[i][1],arr1[i][2],arr1[i][3],
//                        arr1[i][4],arr1[i][5],arr1[i][6]);
//      }
//      fclose(out);
// file ...DISP.1 includes final results
      if(nfout2 != 0) {
          strcpy(name2,name);
          strcat(name2,pref);
          strcat(name2,"_DISP.1");
          if((out = fopen(name2,"w")) == NULL) {
              printf("Can not open file %s.\n",name2);
              exit(1);
          }
          for(i = 0; i < nfout2; i++) {
              fprintf(out,"%4d %10.4lf %10.4lf %12.4lf %12.4lf %12.4lf %8.3lf\n",
                   i,arr2[i][0],arr2[i][1],arr2[i][2],arr2[i][3],
                     arr2[i][4],arr2[i][5]);
          }
          fclose(out);
      }
// Output amplitude array into file on hard drive
   amp_flag=1;
   if (amp_flag == 1) {
      int j;
      strcpy(name2,name);
      strcat(name2,pref);
      strcat(name2,"_AMP");
      if((out = fopen(name2,"w")) == NULL) {
          printf("Can not open file %s.\n",name2);
          exit(1);
      }
      for(i = 0; i < nrow; ++i) {
          for(j = 0; j < ncol; ++j) {
             fprintf(out,"%8.3lf %8.3lf %15.6e\n", (double)(i+1),tamp+j*dt,ampo[i][j]);
            }
         }
      fclose(out);
   }
  }

