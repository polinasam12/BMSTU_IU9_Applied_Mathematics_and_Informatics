package grammar_parser;

import lex_analyze.Token;
import semantic_analize.Interpreter;
import syntax_analyze.ParseNode;
import syntax_analyze.ParseTree;
import syntax_analyze.rules.RHS;
import syntax_analyze.rules.Rules;
import syntax_analyze.symbols.Nonterm;
import syntax_analyze.symbols.Symbol;
import syntax_analyze.symbols.Term;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class GrammarInterpreter extends Interpreter {
    private ArrayList<String> terms = new ArrayList<>();
    private ArrayList<String> nonterms = new ArrayList<>();
    private Nonterm axiom = new Nonterm("S");
    private RHS[][] q = null;
    private ParseTree tree = null;
    private HashMap<String, Rules> grammar_list = new HashMap<>();

    public GrammarInterpreter (ParseTree parse_tree) {
        super(parse_tree);
        tree = parse_tree;
        interpretTree();
        checkForUndefinedNonterms();

        System.out.println("TERMS: " + terms);
        System.out.println("NONTERMS: " + nonterms);
        System.out.println("AXIOM: " + axiom);
        System.out.println("GRAMMAR: " + grammar_list + "\n");
    }

    public CompilerGenerator getCompilerGenerator() {
        return new CompilerGenerator(terms, nonterms, axiom, grammar_list);
    }

    private void addNonterm(Token token) {
        if (nonterms.contains(token.getImage())) {
            System.out.println("*** Nonterminal <" + token.getImage() + "> " +
                    "defined twice at " + token.coordsToString() + " ***");
            System.exit(1);
        }
        nonterms.add(token.getImage());
        grammar_list.put(token.getImage(), new Rules());
    }

    private void addTerm(Token token) {
//        token.setImage(token.getImage().replaceAll("[\\s']+", ""));
        if (terms.contains(token.getImage())) {
            System.out.println("*** Terminal <" + token.getImage() + "> " +
                    "defined twice at " + token.coordsToString() + " ***");
            System.exit(1);
        }
        terms.add(token.getImage());
//        grammar_list.put(token.getImage(), new Rules());
    }

    private void checkForUndefinedNonterms() {
        boolean error = false;
        for (Map.Entry<String, Rules> entry: grammar_list.entrySet()) {
            Rules rule = entry.getValue();
            if (rule.isEmpty()) {
                System.out.println("*** No rules found for nonterminal <" + entry.getKey() + "> ***");
                error = true;
            }
            for (RHS chunk: rule) {
                for (Symbol symbol: chunk) {
                    if (symbol instanceof Nonterm && !nonterms.contains(symbol.getType())) {
                        System.out.println("*** Undefined nonterminal <" + symbol.getType() + "> " +
                                "at " + symbol.coordsToString() + " ***");
                        error = true;
                    }
                }
            }
        }
        if (error) {
            System.exit(2);
        }
    }

    // $RULE S = "AxiomKeyword" "Nterm" "NTermKeyword" "Nterm" N T R
    private void interpretS(ParseNode root) {
        ParseNode axiom_name = (ParseNode)root.getChildAt(1);
        Token symbol = (Token)axiom_name.getSymbol();
        addNonterm(symbol);
        this.axiom = new Nonterm(symbol.getImage());
        Symbol symbol1 = ((ParseNode)root.getChildAt(3)).getSymbol();
        addNonterm((Token)symbol1);
        scanN((ParseNode)root.getChildAt(4));
        scanT((ParseNode)root.getChildAt(5));
        scanR((ParseNode)root.getChildAt(6));
    }

    // $RULE N = "Nterm" N
    //            $EPS
    private void scanN(ParseNode N) {
        if (!N.isLeaf()) {
            Symbol symbol = ((ParseNode)N.getChildAt(0)).getSymbol();
            addNonterm((Token)symbol);
            scanN((ParseNode)N.getChildAt(1));
        }
    }

    // $RULE T = "TermKeyword" "Term" T1
    private void scanT(ParseNode T) {
        Symbol symbol = ((ParseNode)T.getChildAt(1)).getSymbol();
        addTerm((Token)symbol);
        scanT1((ParseNode)T.getChildAt(2));
    }

    // $RULE T1 = "Term" T1
    //            $EPS

    private void scanT1(ParseNode T1) {
        if (!T1.isLeaf()) {
            Symbol symbol = ((ParseNode)T1.getChildAt(0)).getSymbol();
            addTerm((Token)symbol);
            scanT1((ParseNode)T1.getChildAt(1));
        }
    }

    // $RULE R = R' R1
    private void scanR(ParseNode R) {
        scanRS((ParseNode)R.getChildAt(0));
        scanR1((ParseNode)R.getChildAt(1));
    }

    // $RULE R1 = R' R1
    //            $EPS

    private void scanR1(ParseNode R1) {
        if (!R1.isLeaf()) {
            scanRS((ParseNode)R1.getChildAt(0));
            scanR1((ParseNode)R1.getChildAt(1));
        }
    }

    // $RULE R' = "RuleKeyword" "Nterm" "Equal" V

    private void scanRS(ParseNode RS) {
        String Nterm = ((Token)(RS.getSymbolAt(1))).getImage();
        if (grammar_list.containsKey(Nterm)) {
            Rules rules = scanV((ParseNode)RS.getChildAt(3));
            Rules union_rules_list = grammar_list.get(Nterm);
            union_rules_list.addAll(rules);
            grammar_list.put(Nterm, union_rules_list);
        } else {
            Token tok = (Token)(RS.getSymbolAt(1));
            System.out.println("*** A rule for undefined nonterminal <" + tok.getImage() + "> "+
                    "at " + tok.coordsToString() + " ***");
        }
    }

    // $RULE V = V1 V2
    private Rules scanV(ParseNode V) {
        Rules rules = new Rules();
        rules.add(scanV1((ParseNode)V.getChildAt(0)));
        rules.addAll(scanV2((ParseNode)V.getChildAt(1)));
        return rules;
    }

    // $RULE V1 = "Term" V3
    //            "Nterm" V3
    //            "EpsKeyword"
    private RHS scanV1(ParseNode V1) {
        if (V1.getChildCount() == 1) {
            RHS res = new RHS(RHS.EPSILON);
            res.setCoords(V1.getSymbolAt(0).getStart());
            return res;
        } else {
            RHS res = new RHS();
            Token sym = (Token)V1.getSymbolAt(0);
            if (Objects.equals(sym.getType(), "Term")) {
                res.add(new Term(sym.getImage(), sym.getStart(), sym.getFollow()));
            } else {
                res.add(new Nonterm(sym.getImage(), sym.getStart(), sym.getFollow()));
            }
            res.addAll(scanV3((ParseNode)V1.getChildAt(1)));
            return res;
        }
    }

    // $RULE V3 = "Term" V3
    //            "Nterm" V3
    //            $EPS

    private RHS scanV3(ParseNode V3) {
        RHS res = new RHS();
        while (!V3.isLeaf()) {
            Token sym = (Token)V3.getSymbolAt(0);
            if (Objects.equals(sym.getType(), "Term")) {
                res.add(new Term(sym.getImage(), sym.getStart(), sym.getFollow()));
            } else {
                res.add(new Nonterm(sym.getImage(), sym.getStart(), sym.getFollow()));
            }
            V3 = (ParseNode)V3.getChildAt(1);
        }
        return res;
    }

    // $RULE V2 = "NewLine" V
    //            $EPS

    private Rules scanV2(ParseNode V2) {
        Rules rules = new Rules();
        if (!V2.isLeaf()) {
            rules.addAll(scanV((ParseNode)V2.getChildAt(1)));
        }
        return rules;
    }

    private void interpretTree() {
        interpretS((ParseNode)tree.getRoot());
    }
}
