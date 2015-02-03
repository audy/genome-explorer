# -i input
# -o output
# -c identity
# -G 1 = global, 2 = local
# -M = memory limit, 0 = unlimited
# -T = threads
# -g = 1 - slow, 0 - greedy


cd-hit \
  -i test.fasta \
  -o cdhitout.txt \
  -c 0.9 \
  -G 1 \
  -M 0 \
  -T 8 \
  -g 0
