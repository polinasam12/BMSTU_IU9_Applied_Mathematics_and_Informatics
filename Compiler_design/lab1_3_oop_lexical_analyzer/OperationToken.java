public class OperationToken extends Token {
    public final String value;

    protected OperationToken(String value, Position starting, Position following) {
        super(DomainTag.OPERATION, starting, following);
        this.value = value;
    }

    @Override
    public String toString() {
        return "OPERATION " + super.toString() + ": " + value;
    }
}
