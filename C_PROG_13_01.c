#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void makeMatrix(FILE*, int**, int);

void countRing(int**, int, int*, int, int*);


int main(int argc, char *argv[])
{
	int **atom;
	int *v;
	int atomNum;
	int ringNum = 0;
	char str[256];
	FILE *fp;
	int i,j;

	if (argc != 2){
		return 1;
	}
	
	fp = fopen(argv[1],"r");

	if (fp == NULL){
		printf("File cannot open\n");
		return 1;
	}

	fgets(str,256, fp);

	sscanf(str, "%d", &atomNum);

	for (i = 0; i < atomNum; i++)
	{
		fgets(str,256, fp);
	}
	fgets(str,256, fp);

	atom = (int**)malloc(sizeof(int*)*(atomNum + 1));

	for (i = 0; i <= atomNum; i++)
	{
		*(atom + i) = (int*)malloc(sizeof(int)*(atomNum + 1));
	}

	v = (int*)malloc(sizeof(int)*atomNum);

	for (i = 0; i < atomNum; i++)
	{
		v[i] = 0;
	}

	makeMatrix(fp, atom, atomNum);

			countRing(atom, atomNum, v, 1, &ringNum);

	printf("atomNum = %d,RingNum = %d\n",atomNum, ringNum);
	/*
	for (i = 0; i <= atomNum; i++)
	{
		for (j = 0; j <= atomNum; j++)
		{
			printf("%d ", *(*(atom + i) + j));
		}
		printf("@\n");
	}
	*/
	return 0;
}

void makeMatrix(FILE *fp, int **a, int Num)
{
	int i, j;
	int now, next;
	char buf[256];
	for (i = 0; i <= Num; i++)
	{
		for (j = 0; j <= Num; j++)
		{
			*(*(a + i) + j) = 0;
		}
	}
	for (i = 0; i < Num; i++)
	{
		fgets(buf, 256, fp);
		sscanf(buf, "%d %d", &now, &next);
		*(*(a + now) + next) = 1;
		*(*(a + next) + now) = 1;
	}
}

void countRing(int **atom,int num, int *v, int now,int *ring)
{
	int next;
	v[now] = 1;
	for (next = 0; next <= num; next++)
	{
		if ((*(*(atom + now) + next)) == 1){
			*(*(atom + next) + now) = 0;
			printf("%d->%d ", now, next);
			if (v[next] != 1){
				countRing(atom, num, v, next, ring);
			}
			else if (v[next] == 1){

				(*ring)++;
				printf("ring\n");
			}
		}
	}
}