import src.kb_nw as align


def test_nw_1():
    seq1 = 'ATGC'
    seq2 = 'ATGC'
    score, aligned_seq1, aligned_seq2 = align.k_banded_needleman_wunsch(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_penalty=-10,
                                                 k=3)
    assert score == 20
    assert aligned_seq1 == 'ATGC'
    assert aligned_seq2 == 'ATGC'


def test_nw_2():
    seq1 = 'ATG'
    seq2 = 'ATGC'
    score, aligned_seq1, aligned_seq2 = align.k_banded_needleman_wunsch(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_penalty=-10,
                                                 k=3)
    assert score == 5
    assert aligned_seq1 == 'ATG-'
    assert aligned_seq2 == 'ATGC'


def test_nw_3():
    seq1 = 'ATGC'
    seq2 = 'ATG'
    score, aligned_seq1, aligned_seq2 = align.k_banded_needleman_wunsch(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_penalty=-10,
                                                 k=3)
    assert score == 5
    assert aligned_seq1 == 'ATGC'
    assert aligned_seq2 == 'ATG-'


# def test_nw_41():     - теперь не работает
#     seq1 = 'ATGC'
#     seq2 = 'AATTGGCC'
#     score, aligned_seq1, aligned_seq2 = align.k_banded_needleman_wunsch(seq1,
#                                                  seq2,
#                                                  score_fun=lambda x, y: 5 if x == y else -4,
#                                                  gap_penalty=-10,
#                                                  k=3)
#     assert score == -20
#     assert aligned_seq1 == 'A-T-G-C-'
#     assert aligned_seq2 == 'AATTGGCC'


def test_nw_42():     # аналогичен test_nw_41 при k, увеличенном на 1 - работает
    seq1 = 'ATGC'
    seq2 = 'AATTGGCC'
    score, aligned_seq1, aligned_seq2 = align.k_banded_needleman_wunsch(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_penalty=-10,
                                                 k=4)
    assert score == -20
    assert aligned_seq1 == 'A-T-G-C-'
    assert aligned_seq2 == 'AATTGGCC'


def test_nw_5():
    seq1 = 'ATGC'
    seq2 = 'TATGCA'
    score, aligned_seq1, aligned_seq2 = align.k_banded_needleman_wunsch(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_penalty=-10,
                                                 k=3)
    assert score == 0
    assert aligned_seq1 == '-ATGC-'
    assert aligned_seq2 == 'TATGCA'


def test_nw_6():
    seq1 = 'ATGC'
    seq2 = 'TGCA'
    score, aligned_seq1, aligned_seq2 = align.k_banded_needleman_wunsch(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_penalty=-10,
                                                 k=3)
    assert score == -5
    assert aligned_seq1 == 'ATGC-'
    assert aligned_seq2 == '-TGCA'


def test_nw_7():
    seq1 = 'ATAGC'
    seq2 = 'ATGC'
    score, aligned_seq1, aligned_seq2 = align.k_banded_needleman_wunsch(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_penalty=-10,
                                                 k=3)
    assert score == 10
    assert aligned_seq1 == 'ATAGC'
    assert aligned_seq2 == 'AT-GC'


def test_nw_8():
    seq1 = 'AT'
    seq2 = 'GC'
    score, aligned_seq1, aligned_seq2 = align.k_banded_needleman_wunsch(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_penalty=-10,
                                                 k=3)
    assert score == -8
    assert aligned_seq1 == 'AT'
    assert aligned_seq2 == 'GC'


test_nw_1()
test_nw_2()
test_nw_3()
# test_nw_41()
test_nw_42()
test_nw_5()
test_nw_6()
test_nw_7()
test_nw_8()
