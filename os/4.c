#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/time.h>
#include <stdbool.h>

#define N 10000

int sum;

int flag[2] = { false, false };
int turn = 0;

int fun(int id)
{
	int nid = id == 1 ? 0 : 1;
	for (int i = 0; i < N; i++)
	{
		flag[id] = true;
		turn = nid;
		while (flag[nid] && turn == nid);
		sum = sum + 1;
		printf("%d", id);
		fflush(stdout);
		flag[id] = false;
	}

	return sum;
}

int main()
{
	long dt;
	struct timeval tp[2];
	pthread_t t0, t1;
	void *th0_return, *th1_return;

	sum = 0;

	gettimeofday(&tp[0], NULL);

	pthread_create(&t0, NULL, (void*)fun, (void*)0);
	pthread_create(&t1, NULL, (void*)fun, (void*)1);

	pthread_join(t0, &th0_return);
	pthread_join(t1, &th1_return);
	
	printf("\nthread0_return = %d\n", (int*)th0_return);
	printf("\nthread1_return = %d\n", (int*)th1_return);

	gettimeofday(&tp[1], NULL);

	dt = (tp[1].tv_sec - tp[0].tv_sec) * 1000000 + (tp[1].tv_usec - tp[0].tv_usec);

	if (dt % 10000 == 0){
		printf("\n%ld usec (suspect this is not high-resolution timer)\n", dt);
	}
	else{
		printf("\n%ld usec\n", dt);
	}

	printf("\nsum = %d\n", sum);
	
	exit(0);
}