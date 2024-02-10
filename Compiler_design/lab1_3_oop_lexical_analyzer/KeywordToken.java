public class KeywordToken extends Token {
    public final String value;

    protected KeywordToken(String value, Position starting, Position following) {
        super(DomainTag.KEYWORD, starting, following);
        this.value = value;
    }

    @Override
    public String toString() {
            return "KEYWORD " + super.toString() + ": " + value;
    }
}
