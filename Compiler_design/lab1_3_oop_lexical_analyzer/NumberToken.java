public class NumberToken extends Token {
    public final long value;

    protected NumberToken(long value, Position starting, Position following) {
        super(DomainTag.NUMBER, starting, following);
        this.value = value;
    }

    @Override
    public String toString() {
        return "NUMBER " + super.toString() + ": " + value;
    }
}
