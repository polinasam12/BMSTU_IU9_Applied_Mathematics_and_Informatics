import calculator.*;
import lex_analyze.Scanner;
import syntax_analyze.Parser;

import java.io.File;

public class CalcMain {
    public static void main(String[] args) {
        String expr_src = args[0];

        Parser parser = ArithmeticStructure.getParser();
        Scanner scanner = new ArithmeticScanner(expr_src);
        parser.topDownParse(scanner);

        parser.addFile("parse_output2" + File.separator + "expr_parse_graph.dot");
        ArithmeticInterpreter evaluator = new ArithmeticInterpreter(parser.getParseTree());
        String expression = scanner.getText();
        System.out.println(expression.replaceAll("\n", "") + " = " + evaluator.getResult());
    }
}
