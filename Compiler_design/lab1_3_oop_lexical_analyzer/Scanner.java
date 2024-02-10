public class Scanner {
    public final String program;

    private Compiler compiler;
    private Position cur;

    public Scanner(String program, Compiler compiler) {
        this.compiler = compiler;
        this.program = program;
        cur = new Position(program);
    }

    public Token nextToken() {
        while (!cur.isEndOfFile()) {
            while (cur.isWhitespace()) {
                cur = cur.next();
            }
            Token token;
            if (cur.isBracket()) {
                token = readOperation(cur);
            } else if (cur.isDecimalDigit()) {
                token = readNumber(cur);
            } else if (cur.isLetter()) {
                token = readKeywordOrIdent(cur);
            } else {
                token = new UnknownToken(DomainTag.UNKNOWN, cur, cur.next());
            }
            if (token.tag == DomainTag.UNKNOWN) {
                compiler.addMessage(true, cur, "unknown token");
                cur = token.coords.following;
            } else {
                cur = token.coords.following;
                return token;
            }
        }
        return new UnknownToken(DomainTag.END_OF_PROGRAM, cur, cur);
    }

    private Token readOperation(Position cur) {
        Position p = cur.next();
        return new OperationToken(program.substring(cur.getIndex(), p.getIndex()), cur, p);
    }
    private Token readKeywordOrIdent(Position cur) {
        Position p = new Position(cur);
        while (p.isLetter()) {
            p = p.next();
        }
        String s = program.substring(cur.getIndex(), p.getIndex());
        if ((s.equals("and")) || (s.equals("or"))) {
            return new KeywordToken(program.substring(cur.getIndex(), p.getIndex()), cur, p);
        } else {
            return new IdentToken(compiler.addName(program.substring(cur.getIndex(), p.getIndex())), cur, p);
        }
    }

    private Token readNumber(Position cur) {
        Position p = cur.next();
        boolean error;
        if (cur.isZero()) {
            if (p.isBinaryInd()) {
                p = p.next();
                error = false;
                if (p.isDecimalDigit()) {
                    while (p.isDecimalDigit()) {
                        if (!p.isBinaryDigit()) {
                            error = true;
                        }
                        p = p.next();
                    }
                } else {
                    error = true;
                }
                if (!error) {
                    return new NumberToken(Long.parseLong(program.substring(cur.getIndex() + 2, p.getIndex()), 2), cur, p);
                } else {
                    return new UnknownToken(DomainTag.UNKNOWN, cur, p);
                }
            } else if (p.isOctalInd()) {
                p = p.next();
                error = false;
                if (p.isDecimalDigit()) {
                    while (p.isDecimalDigit()) {
                        if (!p.isOctalDigit()) {
                            error = true;
                        }
                        p = p.next();
                    }
                } else {
                    error = true;
                }
                if (!error) {
                    return new NumberToken(Long.parseLong(program.substring(cur.getIndex() + 2, p.getIndex()), 8), cur, p);
                } else {
                    return new UnknownToken(DomainTag.UNKNOWN, cur, p);
                }
            } else if (p.isHexInd()) {
                p = p.next();
                error = false;
                if (p.isDecimalDigit() || p.isLetter()) {
                    while (p.isDecimalDigit() || p.isLetter()) {
                        if (!p.isHexDigit()) {
                            error = true;
                        }
                        p = p.next();
                    }
                } else {
                    error = true;
                }
                if (!error) {
                    return new NumberToken(Long.parseLong(program.substring(cur.getIndex() + 2, p.getIndex()), 16), cur, p);
                } else {
                    return new UnknownToken(DomainTag.UNKNOWN, cur, p);
                }
            }
        }
        while (p.isDecimalDigit()) {
            p = p.next();
        }
        return new NumberToken(Long.parseLong(program.substring(cur.getIndex(), p.getIndex())), cur, p);
    }

}
