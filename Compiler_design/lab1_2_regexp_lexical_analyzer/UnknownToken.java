public class UnknownToken extends Token {

    public UnknownToken(DomainTag tag, Position starting) {
        super(tag, starting);
    }

    @Override
    public String toString() {
        return "syntax error " + super.toString();
    }
}
