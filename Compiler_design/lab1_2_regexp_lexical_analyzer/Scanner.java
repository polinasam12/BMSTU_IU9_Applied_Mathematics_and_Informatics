import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Scanner {
    private Position cur;

    public Scanner(String text) {
        cur = new Position(text);
    }

    public Token nextToken() {

        String substance =
                "[A-Z](([0-9]+[A-Z]+)|([A-Z]+)|([a-z]+))*[0-9]*";
        String number = "[0-9]+";
        String operator = "(\\+)|(->)";
        String pattern = "(?<substance>^" + substance + ")|(?<number>^" + number + ")|(?<operator>^" + operator + ")";

        Pattern p = Pattern.compile(pattern);
        Matcher m;

        while (!cur.isEndOfFile()) {
            m = p.matcher(cur.getText());
            if (cur.isWhitespace()) {
                cur = cur.next();
            } else if (m.find()) {
                String m_substance = m.group("substance");
                String m_number = m.group("number");
                String m_operator = m.group("operator");
                Token token = null;
                if (m_substance != null) {
                    token = new SubstanceToken(m_substance, cur);
                    cur = cur.next_x(m_substance.length());
                } else if (m_number != null) {
                    token = new NumberToken(m_number, cur);
                    cur = cur.next_x(m_number.length());
                } else if (m_operator != null) {
                    token = new OperatorToken(m_operator, cur);
                    cur = cur.next_x(m_operator.length());
                }
                return token;
            } else {
                Token token = new UnknownToken(DomainTag.UNKNOWN, cur);
                while (!cur.isEndOfFile() && !p.matcher(cur.getText()).find() && !cur.isWhitespace()) {
                    cur = cur.next();
                }
                return token;
            }
        }
        return new UnknownToken(DomainTag.END_OF_PROGRAM, cur);

    }
}
