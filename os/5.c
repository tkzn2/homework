#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/time.h>

#define N 10000

int sum;

int level[3] = { -1, -1, -1 };	//スレッドのレベル　優先度みたいなもん
int priority[3] = { 0, 0, 0 };	//priority[n]はnレベルに滞在しているidを表す

int fun(int id)
{
	int nid[2];
	nid[0] = id == 0 ? 1
		: id == 1 ? 0 : 0;
	nid[1] = id == 0 ? 2
		: id == 1 ? 2 : 1;
	for (int i = 0; i < N; i++)
	{
		for (int lev = 0; lev < 3; lev++)
		{
			level[id] = lev;
			priority[lev] = id;
			while ((level[nid[0]] >= lev || level[nid[1]] >= lev) && priority[lev] == id);
			/*自分より高レベルのスレッドがいない、もしくは自分と同じレベルに誰かがなったらレベルが1つ上がる*/
		}
		sum = sum + 1;
		printf("%d", id);
		fflush(stdout);
		level[id] = -1;
	}

	return sum;
}

int main()
{
	long dt;
	struct timeval tp[2];
	pthread_t t0, t1, t2;
	void *th0_return, *th1_return, *th2_return;

	sum = 0;

	gettimeofday(&tp[0], NULL);

	pthread_create(&t0, NULL, (void*)fun, (void*)0);
	pthread_create(&t1, NULL, (void*)fun, (void*)1);
	pthread_create(&t2, NULL, (void*)fun, (void*)2);

	pthread_join(t0, &th0_return);
	pthread_join(t1, &th1_return);
	pthread_join(t2, &th2_return);

	printf("\nthread0_return = %d\n", (int*)th0_return);
	printf("\nthread1_return = %d\n", (int*)th1_return);
	printf("\nthread2_return = %d\n", (int*)th2_return);

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