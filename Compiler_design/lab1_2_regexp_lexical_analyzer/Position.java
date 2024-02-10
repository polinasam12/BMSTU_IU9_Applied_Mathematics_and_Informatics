public class Position {

    private String text;
    private int line, pos;
    public String getText() {
        return text;
    }
    public int getLine() {
        return line;
    }
    public int getPos() {
        return pos;
    }

    public Position(String text) {
        this.text = text;
        line = pos = 1;
    }

    public Position(Position p) {
        this.text = p.getText();
        this.line = p.getLine();
        this.pos = p.getPos();
    }

    @Override
    public String toString() {
        return "(" + line + ", " + pos + ')';
    }

    public boolean isEndOfFile() {
        return text.length() == 0;
    }

    public int getCode() {
        return isEndOfFile() ? -1 : text.codePointAt(0);
    }

    public boolean isNewLine() {
        if (isEndOfFile()) {
            return true;
        } else {
            return (text.charAt(0) == '\n');
        }
    }

    public boolean isWhitespace() {
        return !isEndOfFile() && Character.isWhitespace(getCode());
    }
    public Position next() {
        Position p = new Position(this);
        if (!p.isEndOfFile()) {
            if (p.isNewLine()) {
                p.line++;
                p.pos = 1;
            } else {
                if (Character.isHighSurrogate(p.text.charAt(0))) {
                    p.text = p.text.substring(1);
                }
                p.pos++;
            }
            p.text = p.text.substring(1);
        }
        return p;
    }

    public Position next_x(int x) {
        Position p = new Position(this);
        for (int i = 0; i < x; i++) {
            p = p.next();
        }
        return p;
    }

}
