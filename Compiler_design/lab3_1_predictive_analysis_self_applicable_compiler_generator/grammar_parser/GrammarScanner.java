package grammar_parser;

import lex_analyze.Coords;
import lex_analyze.Scanner;
import lex_analyze.Token;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Objects;


public class GrammarScanner extends Scanner {

    public final static HashMap<String, String> regexp = staticRegExpressions();
//    public final static String NONTERMINAL = "N";
//    public final static String TERMINAL = "T";

    private static HashMap<String, String> staticRegExpressions() {
        LinkedHashMap<String, String> exprs = new LinkedHashMap<>();
        exprs.put("AxiomKeyword", "\\$AXIOM");
        exprs.put("NTermKeyword", "\\$NTERM");
        exprs.put("TermKeyword", "\\$TERM");
        exprs.put("RuleKeyword", "\\$RULE");
        exprs.put("EpsKeyword", "\\$EPS");
        exprs.put("Nterm", "[A-Z]'|[A-Z][0-9]|[A-Z]");
        exprs.put("Term", "\"[a-zA-Z\\+\\*\\(\\)]+\"");
        exprs.put("Equal", "=");
        exprs.put("NewLine", "\\n+");
        return exprs;
    }
    public GrammarScanner(String filepath) {
        super(filepath, regexp);
    }
    @Override
    protected Token returnToken (String type) {
        Coords last = coord;
        if (Objects.equals(type, "NewLine")) {
            for (int i = 0; i < image.length(); i++) {
                coord = coord.newline();
            }
        } else {
            coord = coord.shift(image.length());
        }
        log.append(type).append(' ').append(last.toString()).append('-').append(coord.toString())
                .append(": <").append(image).append(">\n");
        return new Token(type, image, last, coord);
    }
}
