public class NumberToken extends Token {
    public final String value;

    protected NumberToken(String value, Position starting) {
        super(DomainTag.NUMBER, starting);
        this.value = value;
    }

    @Override
    public String toString() {
        return "NUMBER " + super.toString() + ": " + value;
    }
}
