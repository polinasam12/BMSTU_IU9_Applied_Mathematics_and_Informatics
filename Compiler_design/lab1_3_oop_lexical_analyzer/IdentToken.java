public class IdentToken extends Token {
    public final int value;

    protected IdentToken(int value, Position starting, Position following) {
        super(DomainTag.IDENT, starting, following);
        this.value = value;
    }

    @Override
    public String toString() {
        return "IDENT " + super.toString() + ": " + value;
    }
}
