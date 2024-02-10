from typing import Callable, Tuple
import argparse
import sys

PRINT_MAX_LINE_LENGTH = 80
DEBUG = False


def score_fun(a: str,
              b: str,
              match_score: int = 5,
              mismatch_score: int = -4) -> int:
    return match_score if a == b else mismatch_score


def k_banded_needleman_wunsch(seq1: str,
                     seq2: str,
                     score_fun: Callable[[str, str], int],
                     gap_penalty,
                     k: int) -> Tuple[int, str, str]:
    nrow = len(seq1) + 1
    ncol = len(seq2) + 1
    score_matrix = [[0 for _ in range(ncol)] for _ in range(nrow)]
    direction_matrix = [["" for _ in range(ncol)] for _ in range(nrow)]

    # заполнение матрицы скоров и матрицы направлений
    for i in range(1, min(nrow, k + 1)):
        score_matrix[i][0] = i * gap_penalty
        direction_matrix[i][0] = "up"
    for j in range(1, min(ncol, k + 1)):
        score_matrix[0][j] = j * gap_penalty
        direction_matrix[0][j] = "left"
    for i in range(1, nrow):
        for j in range(max(1, i - k), min(ncol, i + k + 1)):
            if abs(i - 1 - j) <= k:
                score1 = score_matrix[i - 1][j] + gap_penalty
            else:
                score1 = float('-inf')
            if abs(i - j + 1) <= k:
                score2 = score_matrix[i][j - 1] + gap_penalty
            else:
                score2 = float('-inf')
            score3 = score_matrix[i - 1][j - 1] + score_fun(seq1[i - 1], seq2[j - 1])
            max_score = max(score1, score2, score3)
            if max_score == score1:
                direction_matrix[i][j] = "up"
            elif max_score == score2:
                direction_matrix[i][j] = "left"
            else:
                direction_matrix[i][j] = "diag"
            score_matrix[i][j] = max_score

    # восстановление выровненных последовательностей
    i = nrow - 1
    j = ncol - 1
    aligned_seq1 = ""
    aligned_seq2 = ""
    while i != 0 or j != 0:
        if direction_matrix[i][j] == "up":
            aligned_seq2 += "-"
            aligned_seq1 += seq1[i - 1]
            i -= 1
        elif direction_matrix[i][j] == "left":
            aligned_seq1 += "-"
            aligned_seq2 += seq2[j - 1]
            j -= 1
        else:
            aligned_seq1 += seq1[i - 1]
            aligned_seq2 += seq2[j - 1]
            i -= 1
            j -= 1

    return score_matrix[-1][-1], aligned_seq1[::-1], aligned_seq2[::-1]


def print_array(matrix: list):
    for row in matrix:
        for element in row:
            print(f"{element:6}", end="")
        print()


def print_results(seq1: str, seq2: str, score: int, file=None):
    if file is None:
        file = sys.stdout

    def print_subseq(i, n, s):
        print("%s: %s" % (n, s[i: i + PRINT_MAX_LINE_LENGTH]), file=file)

    print("Pairwise alignment:", file=file)
    for i in range(0, len(seq1), PRINT_MAX_LINE_LENGTH):
        print_subseq(i, 'seq1', seq1)
        print_subseq(i, 'seq2', seq2)
        print(file=file)
    print("Score: %s" % score, file=file)


def main():
    parser = argparse.ArgumentParser(description='Needleman-Wunsch algorithm')
    parser.add_argument('seq1', help='first sequence')
    parser.add_argument('seq2', help='second sequence')
    parser.add_argument('--match', type=int, help='match score')
    parser.add_argument('--mismatch', type=int, help='mismatch score')
    parser.add_argument('--gap', type=int, default=-10, help='gap penalty')
    parser.add_argument('--debug', action='store_true', help='debug mode')
    args = parser.parse_args()

    global DEBUG
    DEBUG = args.debug
    print(args.match, args.mismatch, args.gap)

    if args.match and args.mismatch:
        score, aln1, aln2 = k_banded_needleman_wunsch(args.seq1,
                                             args.seq2,
                                             score_fun=lambda x, y: args.match if x == y else args.mismatch,
                                             gap_penalty=args.gap)
    else:
        assert not args.match and not args.mismatch, "match and mismatch must be specified together"
        score, aln1, aln2 = k_banded_needleman_wunsch(args.seq1,
                                             args.seq2,
                                             score_fun=score_fun,
                                             gap_penalty=args.gap)
    print_results(aln1, aln2, score)

    return score, aln1, aln2


if __name__ == '__main__':
    main()
