package grammar_parser;

import syntax_analyze.Parser;
import syntax_analyze.rules.Epsilon;
import syntax_analyze.rules.Error;
import syntax_analyze.rules.RHS;
import syntax_analyze.rules.Rules;
import syntax_analyze.symbols.Nonterm;
import syntax_analyze.symbols.Term;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

public class GrammarStructure {
    public final static ArrayList<String> terms = staticTermList();
    public final static ArrayList<String> nonterms = staticNontermList();
    public final static Nonterm axiom = new Nonterm("S");

    final static HashMap<String, Rules> grammarList = getGrammar();
    public final static RHS[][] q = staticDelta();

    public static Parser getParser() {
        return new Parser(terms, nonterms, axiom, q);
    }

    private static ArrayList<String> staticNontermList() {
        return new ArrayList<>(Arrays.asList(
                "S", "N", "T", "R", "T1", "R'", "R1", "V", "V1", "V2", "V3"
        ));
    }

    private static ArrayList<String> staticTermList() {
        return new ArrayList<>(Arrays.asList(
                "AxiomKeyword", "NTermKeyword", "TermKeyword", "RuleKeyword", "EpsKeyword", "Term",
                "Nterm", "Equal", "NewLine", Term.EOF
        ));
    }

    private static HashMap<String, Rules> getGrammar() {
        HashMap<String, Rules> rules = new HashMap<>();
        rules.put("S", new Rules(new RHS(
                new Term("AxiomKeyword"),
                new Term("Nterm"),
                new Term("NTermKeyword"),
                new Term("Nterm"),
                new Nonterm("N"),
                new Nonterm("T"),
                new Nonterm("R")
        )));
        rules.put("N",
                new Rules(new RHS(
                        new Term("Nterm"),
                        new Nonterm("N")
                ),
                        new Epsilon()));

        rules.put("T", new Rules(new RHS(
                new Term("TermKeyword"),
                new Term("Term"),
                new Nonterm("T1")
        )));
        rules.put("T1", new Rules(
                new RHS(
                        new Term("Term"),
                        new Nonterm("T1")
                ),
                new Epsilon()
        ));
        rules.put("R", new Rules(new RHS(
                new Nonterm("R'"),
                new Nonterm("R1")
        )));
        rules.put("R'", new Rules(new RHS(
                new Term("RuleKeyword"),
                new Term("Nterm"),
                new Term("Equal"),
                new Nonterm("V")
        )));
        rules.put("R1", new Rules(new RHS(
                new Nonterm("R'"),
                new Nonterm("R1")
        ),
                new Epsilon()
        ));
        rules.put("V", new Rules(
                new RHS(
                        new Nonterm("V1"),
                        new Nonterm("V2")
                )
        ));
        rules.put("V1", new Rules(
                new RHS(
                        new Term("Term"),
                        new Nonterm("V3")
                ),
                new RHS(
                        new Term("Nterm"),
                        new Nonterm("V3")
                ),
                new RHS(
                        new Term("EpsKeyword")
                )
        ));
        rules.put("V3", new Rules(
                new RHS(
                        new Term("Term"),
                        new Nonterm("V3")
                ),
                new RHS(
                        new Term("Nterm"),
                        new Nonterm("V3")
                ),
                new Epsilon()
        ));
        rules.put("V2", new Rules(
                new RHS(
                        new Term("NewLine"),
                        new Nonterm("V")
                ),
                new Epsilon()
        ));

//        System.out.println(rules.toString());
        return rules;
    }

    private static RHS[][] staticDelta() {
        ArrayList<String> T = terms;
        ArrayList<String> N = nonterms;
        HashMap<String, Rules> rules = grammarList;
        int m = N.size();
        int n = T.size();
        RHS[][] q = new RHS[m][n];
        for (RHS[] line: q) {
            Arrays.fill(line, new Error());
        }

        q[N.indexOf("S")][T.indexOf("AxiomKeyword")] = rules.get("S").get(0);

        q[N.indexOf("N")][T.indexOf("TermKeyword")] = rules.get("N").get(1);
        q[N.indexOf("N")][T.indexOf("Nterm")] = rules.get("N").get(0);

        q[N.indexOf("T")][T.indexOf("TermKeyword")] = rules.get("T").get(0);

        q[N.indexOf("T1")][T.indexOf("Term")] = rules.get("T1").get(0);
        q[N.indexOf("T1")][T.indexOf("RuleKeyword")] = rules.get("T1").get(1);

        q[N.indexOf("R")][T.indexOf("RuleKeyword")] = rules.get("R").get(0);

        q[N.indexOf("R'")][T.indexOf("RuleKeyword")] = rules.get("R'").get(0);

        q[N.indexOf("R1")][T.indexOf("RuleKeyword")] = rules.get("R1").get(0);
        q[N.indexOf("R1")][T.indexOf(Term.EOF)] = rules.get("R1").get(1);

        q[N.indexOf("V")][T.indexOf("Nterm")] = rules.get("V").get(0);
        q[N.indexOf("V")][T.indexOf("EpsKeyword")] = rules.get("V").get(0);
        q[N.indexOf("V")][T.indexOf("Term")] = rules.get("V").get(0);

        q[N.indexOf("V1")][T.indexOf("EpsKeyword")] = rules.get("V1").get(2);
        q[N.indexOf("V1")][T.indexOf("Nterm")] = rules.get("V1").get(1);
        q[N.indexOf("V1")][T.indexOf("Term")] = rules.get("V1").get(0);

        q[N.indexOf("V2")][T.indexOf("RuleKeyword")] = rules.get("V2").get(1);
        q[N.indexOf("V2")][T.indexOf("NewLine")] = rules.get("V2").get(0);
        q[N.indexOf("V2")][T.indexOf(Term.EOF)] = rules.get("V2").get(1);

        q[N.indexOf("V3")][T.indexOf("NewLine")] = rules.get("V3").get(2);
        q[N.indexOf("V3")][T.indexOf(Term.EOF)] = rules.get("V3").get(2);
        q[N.indexOf("V3")][T.indexOf("RuleKeyword")] = rules.get("V3").get(2);
        q[N.indexOf("V3")][T.indexOf("Term")] = rules.get("V3").get(0);
        q[N.indexOf("V3")][T.indexOf("Nterm")] = rules.get("V3").get(1);

        return q;
    }
}
