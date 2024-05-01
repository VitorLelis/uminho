CC = gcc
SRC = src/
CFLAGS = -pg -O3 -ftree-vectorize -Wall

.DEFAULT_GOAL = all

all: MDseq.exe MDpar.exe

MDseq.exe: $(SRC)/MDseq.cpp
	$(CC) $(CFLAGS) $(SRC)MDseq.cpp -lm -o MDseq.exe

MDpar.exe: $(SRC)/MDpar.cpp
	module load gcc/11.2.0; \
	$(CC) $(CFLAGS) $(SRC)MDpar.cpp -lm -fopenmp -o MDpar.exe

callgraph:
	gprof ./MDseq.exe > seq.gprof
	gprof ./MDpar.exe > par.gprof

clean:
	rm ./MD*.exe cp_* *.gprof gmon.out seq_*

seqres:
	cp cp_average.txt seq_average.txt
	cp cp_output.txt seq_output.txt

runseq:
	./MDseq.exe < inputdata.txt

runpar:
	./MDpar.exe < inputdata.txt

send:
	sshpass -p "dof7Ga1Z" ssh "pg54273"@s7edu.di.uminho.pt "rm -rf ~/entrega3/*"
	rsync -avz -e "sshpass -p 'dof7Ga1Z' ssh" ./ "pg54273"@s7edu.di.uminho.pt:~/entrega3/
	sshpass -p "dof7Ga1Z" ssh "pg54273"@s7edu.di.uminho.pt

run:
	make clean
	make
	sbatch --partition cpar --constraint=c20 --ntasks=1 --time=5:00  ./runperf.sh
	