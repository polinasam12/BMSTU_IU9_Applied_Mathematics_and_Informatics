import hirschberg.align as align

def test_hirschberg_1():
    seq1 = 'ATGC'
    seq2 = 'ATGC'
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == 20
    assert aligned_seq1 == 'ATGC'
    assert aligned_seq2 == 'ATGC'


def test_hirschberg_2():
    seq1 = 'ATG'
    seq2 = 'ATGC'
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == 5
    assert aligned_seq1 == 'ATG-'
    assert aligned_seq2 == 'ATGC'


def test_hirschberg_3():
    seq1 = 'ATGC'
    seq2 = 'ATG'
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == 5
    assert aligned_seq1 == 'ATGC'
    assert aligned_seq2 == 'ATG-'


def test_hirschberg_4():
    seq1 = 'ATGC'
    seq2 = 'AATTGGCC'
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == -20
    assert aligned_seq1 == 'A-T-G-C-'
    assert aligned_seq2 == 'AATTGGCC'


def test_hirschberg_5():
    seq1 = 'ATGC'
    seq2 = 'TATGCA'
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == 0
    assert aligned_seq1 == '-ATGC-'
    assert aligned_seq2 == 'TATGCA'


def test_hirschberg_6():
    seq1 = 'ATGC'
    seq2 = 'TGCA'
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == -5
    assert aligned_seq1 == 'ATGC-'
    assert aligned_seq2 == '-TGCA'


def test_hirschberg_7():
    seq1 = 'ATAGC'
    seq2 = 'ATGC'
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == 10
    assert aligned_seq1 == 'ATAGC'
    assert aligned_seq2 == 'AT-GC'


def test_hirschberg_8():
    seq1 = 'AT'
    seq2 = 'GC'
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == -8
    assert aligned_seq1 == 'AT'
    assert aligned_seq2 == 'GC'


def test_hirschberg_9():
    seq1 = 'ATGC'
    seq2 = ''
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == -40
    assert aligned_seq1 == 'ATGC'
    assert aligned_seq2 == '----'


def test_hirschberg_10():
    seq1 = 'T'
    seq2 = 'ATGC'
    aligned_seq1, aligned_seq2, score = align.hirschberg(seq1,
                                                 seq2,
                                                 score_fun=lambda x, y: 5 if x == y else -4,
                                                 gap_score=-10)
    assert score == -25
    assert aligned_seq1 == '-T--'
    assert aligned_seq2 == 'ATGC'


test_hirschberg_1()
test_hirschberg_2()
test_hirschberg_3()
test_hirschberg_4()
test_hirschberg_5()
test_hirschberg_6()
test_hirschberg_7()
test_hirschberg_8()
test_hirschberg_9()
test_hirschberg_10()
