import syntax_analyze.rules.RHS;
import syntax_analyze.Parser;
import syntax_analyze.symbols.Nonterm;
import syntax_analyze.symbols.Term;

import java.util.ArrayList;
import java.util.Arrays;

public class GrammarStructure {
    public final static ArrayList<String> terms = staticTermList();
    public final static ArrayList<String> nonterms = staticNontermList();
    public final static Nonterm axiom = new Nonterm("S");
    public final static RHS[][] q = staticDelta();

    public static Parser getParser() {
        return new Parser(terms, nonterms, axiom, q);
    }

    private static ArrayList<String> staticNontermList() {
        return new ArrayList<>(Arrays.asList(
                "S", "NTERMS", "TERMS_DEF", "TERMS", "RULES_DEF", "RULES", "RULE", "R", "R1", "R2", "R3"
        ));
    }
    private static ArrayList<String> staticTermList() {
        return new ArrayList<>(Arrays.asList(
                "AxiomKeyword", "Nterm", "Term", "NTermKeyword", "TermKeyword", "RuleKeyword", "EpsKeyword", "NewLine", "Equal", Term.EOF
        ));
    }
    private static RHS[][] staticDelta() {
        ArrayList<String> T = terms;
        ArrayList<String> N = nonterms;
        int m = N.size();
        int n = T.size();
        RHS[][] q = new RHS[m][n];
        for (RHS[] line: q) {
            Arrays.fill(line, RHS.ERROR);
        }
        q[0][0] = new RHS(
                new Term("AxiomKeyword"),
                new Term("Nterm"),
                new Term("NTermKeyword"),
                new Term("Nterm"),
                new Nonterm("NTERMS"),
                new Nonterm("TERMS_DEF"),
                new Nonterm("RULES_DEF")
                );
        q[1][1] = new RHS(
                new Term("Nterm"),
                new Nonterm("NTERMS")
                );
        q[1][4] = RHS.EPSILON;
        q[2][4] = new RHS(
                new Term("TermKeyword"),
                new Term("Term"),
                new Nonterm("TERMS")
                );
        q[3][5] = new RHS(
                new Nonterm("RULE"),
                new Nonterm("RULES")
                );
        q[4][2] = new RHS(
                new Term("Term"),
                new Nonterm("TERMS")
                );
        q[4][5] = RHS.EPSILON;
        q[5][5] = new RHS(
                new Term("RuleKeyword"),
                new Term("Nterm"),
                new Term("Equal"),
                new Nonterm("R")
                );
        q[6][5] = new RHS(
                new Nonterm("RULE"),
                new Nonterm("RULES")
                );
        q[6][9] = RHS.EPSILON;
        q[7][1] = new RHS(
                new Nonterm("R1"),
                new Nonterm("R2")
                );
        q[7][2] = new RHS(
                new Nonterm("R1"),
                new Nonterm("R2")
                );
        q[7][6] = new RHS(
                new Nonterm("R1"),
                new Nonterm("R2")
                );
        q[8][1] = new RHS(
                new Term("Nterm"),
                new Nonterm("R3")
                );
        q[8][2] = new RHS(
                new Term("Term"),
                new Nonterm("R3")
                );
        q[8][6] = new RHS(
                new Term("EpsKeyword")
                );
        q[9][5] = RHS.EPSILON;
        q[9][7] = new RHS(
                new Term("NewLine"),
                new Nonterm("R")
                );
        q[9][9] = RHS.EPSILON;
        q[10][1] = new RHS(
                new Term("Nterm"),
                new Nonterm("V3")
                );
        q[10][2] = new RHS(
                new Term("Term"),
                new Nonterm("R3")
                );
        q[10][5] = RHS.EPSILON;
        q[10][7] = RHS.EPSILON;
        q[10][9] = RHS.EPSILON;
        return q;
    }
}
