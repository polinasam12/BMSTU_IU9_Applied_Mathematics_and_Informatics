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


def score_calculation(seq1, seq2, score_fun, gap_score):
    len_seq1 = len(seq1)
    len_seq2 = len(seq2)
    arr = [i * gap_score for i in range(len_seq1 + 1)]
    res = arr[:]
    for i in range(1, len_seq2 + 1):
        res[0] = i * gap_score
        for j in range(1, len(seq1) + 1):
            score1 = arr[j - 1] + score_fun(seq1[j - 1], seq2[i - 1])
            score2 = arr[j] + gap_score
            score3 = res[j - 1] + gap_score
            res[j] = max(score1, score2, score3)
        arr = res[:]
    return res


def hirschberg(seq1: str,
               seq2: str,
               score_fun: Callable = score_fun,
               gap_score: int = -5) -> Tuple[str, str, int]:

    len_seq1 = len(seq1)
    len_seq2 = len(seq2)

    if len_seq1 == 0:
        return "-" * len_seq2, seq2, gap_score * len_seq2
    if len_seq2 == 0:
        return seq1, "-" * len_seq1, gap_score * len_seq1
    if len_seq1 == 1 or len_seq2 == 1:
        return needleman_wunsch(seq1, seq2, score_fun, gap_score)

    mid_ind = len_seq2 // 2
    score_left = score_calculation(seq1, seq2[:mid_ind], score_fun, gap_score)
    score_right = score_calculation(seq1[::-1], seq2[mid_ind:][::-1], score_fun, gap_score)[::-1]

    maximum = score_left[0] + score_right[0]
    ind_max = 0
    for i in range(1, len(score_left)):
        s = score_left[i] + score_right[i]
        if s > maximum:
            maximum = s
            ind_max = i

    align_left = hirschberg(seq1[:ind_max], seq2[:mid_ind], score_fun=score_fun, gap_score=gap_score)
    align_right = hirschberg(seq1[ind_max:], seq2[mid_ind:], score_fun=score_fun, gap_score=gap_score)

    align1 = align_left[0] + align_right[0]
    align2 = align_left[1] + align_right[1]
    score = 0

    for i in range(len(align1)):
        if align1[i] == '-' or align2[i] == '-':
            score += gap_score
        else:
            score += score_fun(align1[i], align2[i])

    return align1, align2, score


def needleman_wunsch(seq1: str,
                     seq2: str,
                     score_fun: Callable[[str, str], int] = score_fun,
                     gap_penalty: int = -10) -> Tuple[str, str, int]:
    nrow = len(seq1) + 1
    ncol = len(seq2) + 1
    score_matrix = [[0 for _ in range(ncol)] for _ in range(nrow)]
    direction_matrix = [["" for _ in range(ncol)] for _ in range(nrow)]

    # заполнение матрицы скоров и матрицы направлений
    for i in range(1, nrow):
        score_matrix[i][0] = i * gap_penalty
        direction_matrix[i][0] = "up"
    for j in range(1, ncol):
        score_matrix[0][j] = j * gap_penalty
        direction_matrix[0][j] = "left"
    for i in range(1, nrow):
        for j in range(1, ncol):
            score1 = score_matrix[i - 1][j] + gap_penalty
            score2 = score_matrix[i][j - 1] + gap_penalty
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

    return aligned_seq1[::-1], aligned_seq2[::-1], score_matrix[-1][-1]


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
        aln1, aln2, score = hirschberg(args.seq1,
                                             args.seq2,
                                             score_fun=lambda x, y: args.match if x == y else args.mismatch,
                                             gap_score=args.gap)
    else:
        assert not args.match and not args.mismatch, "match and mismatch must be specified together"
        aln1, aln2, score = hirschberg(args.seq1,
                                             args.seq2,
                                             score_fun=score_fun,
                                             gap_score=args.gap)
    print_results(aln1, aln2, score)

    return aln1, aln2, score


if __name__ == '__main__':
    main()
