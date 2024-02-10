public class SubstanceToken extends Token {
    public final String value;

    protected SubstanceToken(String value, Position starting) {
        super(DomainTag.SUBSTANCE, starting);
        this.value = value;
    }

    @Override
    public String toString() {
        return "SUBSTANCE " + super.toString() + ": " + value;
    }
}
