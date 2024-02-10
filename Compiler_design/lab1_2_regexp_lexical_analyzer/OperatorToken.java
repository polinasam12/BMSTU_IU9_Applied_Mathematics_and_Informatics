public class OperatorToken extends Token {
    public final String value;

    protected OperatorToken(String value, Position starting) {
        super(DomainTag.OPERATOR, starting);
        this.value = value;
    }

    @Override
    public String toString() {
        return "OPERATOR " + super.toString() + ": " + value;
    }
}
