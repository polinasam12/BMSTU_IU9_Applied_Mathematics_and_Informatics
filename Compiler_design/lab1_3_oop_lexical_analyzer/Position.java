public class Position {
    private String text;

    private int line, pos, index;

    public String getText() {
        return text;
    }

    public int getLine() {
        return line;
    }

    public int getPos() {
        return pos;
    }

    public int getIndex() {
        return index;
    }

    public Position(String text) {
        this.text = text;
        line = pos = 1;
        index = 0;
    }

    public Position(Position p) {
        this.text = p.getText();
        this.line = p.getLine();
        this.pos = p.getPos();
        this.index = p.getIndex();
    }

    @Override
    public String toString() {
        return "(" + line + ", " + pos + ')';
    }

    public boolean isEndOfFile() {
        return index == text.length();
    }

    public int getCode() {
        return isEndOfFile() ? -1 : text.codePointAt(index);
    }

    public boolean isWhitespace() {
        return !isEndOfFile() && Character.isWhitespace(getCode());
    }

    public boolean isDecimalDigit() {
        return !isEndOfFile() && text.charAt(index) >= '0' && text.charAt(index) <= '9';
    }

    public boolean isBinaryDigit() {
        return !isEndOfFile() && text.charAt(index) >= '0' && text.charAt(index) <= '1';
    }

    public boolean isOctalDigit() {
        return !isEndOfFile() && text.charAt(index) >= '0' && text.charAt(index) <= '7';
    }

    public boolean isHexDigit() {
        return !isEndOfFile() && ((text.charAt(index) >= '0' && text.charAt(index) <= '9') || (text.charAt(index) >= 'A' && text.charAt(index) <= 'F') || (text.charAt(index) >= 'a' && text.charAt(index) <= 'f'));
    }

    public boolean isLetter() {
        return !isEndOfFile() && Character.isLetter(getCode());
    }

    public boolean isBracket() {
        return !isEndOfFile() && ((text.charAt(index) == '(') || text.charAt(index) == ')');
    }

    public boolean isBinaryInd() {
        return !isEndOfFile() && text.charAt(index) == 'b';
    }

    public boolean isOctalInd() {
        return !isEndOfFile() && text.charAt(index) == 't';
    }

    public boolean isHexInd() {
        return !isEndOfFile() && text.charAt(index) == 'x';
    }

    public boolean isZero() {
        return !isEndOfFile() && text.charAt(index) == '0';
    }

    public boolean isNewLine() {
        if (index == text.length()) {
            return true;
        } else {
            return (text.charAt(index) == '\n');
        }
    }

    public Position next() {
        Position p = new Position(this);
        if (!p.isEndOfFile()) {
            if (p.isNewLine()) {
                p.line++;
                p.pos = 1;
            } else {
                if (Character.isHighSurrogate(p.text.charAt(p.index)))
                    p.index++;
                p.pos++;
            }
            p.index++;
        }
        return p;
    }

}
