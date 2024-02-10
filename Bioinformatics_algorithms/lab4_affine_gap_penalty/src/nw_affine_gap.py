from typing import Callable, Tuple

DEBUG = False


def score_fun(a: str,
              b: str,
              match_score: int = 5,
              mismatch_score: int = -4) -> int:
    return match_score if a == b else mismatch_score


def needleman_wunsch_affine(seq1: str,
                            seq2: str,
                            score_fun: Callable = score_fun,
                            gap_open: int = -10,
                            gap_extend: int = -1) -> Tuple[str, str, int]:
    inf = float('-inf')

    n = len(seq1) + 1
    m = len(seq2) + 1

    match_mis = [[0] * m for i in range(n)]
    insertion = [[0] * m for i in range(n)]
    deletion = [[0] * m for i in range(n)]

    res = [[0] * m for i in range(n)]

    for i in range(n):
        match_mis[i][0] = inf
        insertion[i][0] = gap_open + (i - 1) * gap_extend
        deletion[i][0] = inf

        res[i][0] = insertion[i][0]

    for j in range(m):
        match_mis[0][j] = inf
        insertion[0][j] = inf
        deletion[0][j] = gap_open + (j - 1) * gap_extend

        res[0][j] = deletion[0][j]

    match_mis[0][0] = 0
    insertion[0][0] = inf
    deletion[0][0] = inf

    res[0][0] = 0

    for i in range(1, n):
        for j in range(1, m):
            match_mis[i][j] = max(match_mis[i - 1][j - 1], insertion[i - 1][j - 1], deletion[i - 1][j - 1]) + score_fun(
                seq1[i - 1], seq2[j - 1])
            insertion[i][j] = max(insertion[i][j - 1] + gap_extend, match_mis[i][j - 1] + gap_open)
            deletion[i][j] = max(deletion[i - 1][j] + gap_extend, match_mis[i - 1][j] + gap_open)

            res[i][j] = max(match_mis[i][j], insertion[i][j], deletion[i][j])

    i = len(seq1)
    j = len(seq2)

    n -= 1
    m -= 1

    aln1 = ""
    aln2 = ""

    f = False

    while i > 0 or j > 0:

        if i > 0 and j > 0 and res[i][j] == res[i - 1][j - 1] + score_fun(seq1[i - 1], seq2[j - 1]) and not f:
            aln1 += seq1[i - 1]
            aln2 += seq2[j - 1]
            i -= 1
            j -= 1
        elif i > 0 and res[i][j] == res[i - 1][j] + gap_open:
            f = False
            aln1 += seq1[i - 1]
            aln2 += "-"
            i -= 1
        elif i > 0 and res[i][j] == res[i - 1][j] + gap_extend:
            f = True
            aln1 += seq1[i - 1]
            aln2 += "-"
            i -= 1
        elif j > 0 and res[i][j] == res[i][j - 1] + gap_open:
            f = False
            aln1 += "-"
            aln2 += seq2[j - 1]
            j -= 1
        elif j > 0 and res[i][j] == res[i][j - 1] + gap_extend:
            f = True
            aln1 += "-"
            aln2 += seq2[j - 1]
            j -= 1
        else:
            break

    ans = max(match_mis[n][m], insertion[n][m], deletion[n][m])

    return aln1[::-1], aln2[::-1], ans


def print_array(matrix: list):
    for row in matrix:
        for element in row:
            print(f"{element:6}", end="")
        print()


def main():
    aln1, aln2, score = needleman_wunsch_affine("ACGT", "TAGT", gap_open=-10, gap_extend=-1)
    print(f'str 1: {aln1}')
    print(f'str 2: {aln2}')
    print(f'score: {score}')


if __name__ == "__main__":
    main()
