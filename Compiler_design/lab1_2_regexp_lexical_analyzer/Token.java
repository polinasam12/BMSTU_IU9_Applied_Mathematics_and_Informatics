abstract public class Token {
    public final DomainTag tag;
    public final Position starting;

    protected Token(DomainTag tag, Position starting) {
        this.tag = tag;
        this.starting = starting;
    }

    @Override
    public String toString() {
        return starting.toString();
    }
}
