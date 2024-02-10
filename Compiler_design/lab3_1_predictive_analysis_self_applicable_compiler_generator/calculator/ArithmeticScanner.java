package calculator;

import lex_analyze.Coords;
import lex_analyze.Scanner;
import lex_analyze.Token;
import syntax_analyze.symbols.Term;

import java.util.Map;
import java.util.Objects;

public class ArithmeticScanner extends Scanner {
    public ArithmeticScanner(String filepath) {
        super(ArithmeticStructure.staticRegExpressions(), filepath);
    }

    @Override
    public String setPattern() {
        StringBuilder res =
//                makeGroup(BLANK, blank_expr) + "|" +
//                makeGroup(NEWLINE, newline_epxr);
                new StringBuilder(makeGroup(BLANK, blank_expr)+ "|" +
                makeGroup("newline", "\\R") + "|" +
                        makeGroup("comments", "\\*[^\\*\\n]*\\n"));
        for (Map.Entry<String, String> e: regexp.entrySet()) {
            res.append("|").append(makeGroup(e.getKey(), e.getValue()));
        }
        return res.toString();

    }
    @Override
    protected Token returnToken (String type) {
        Coords last = coord;
        coord = coord.shift(image.length());
        log.append(type).append(' ').append(last.toString()).append('-').append(coord.toString())
                .append(": <").append(image).append(">\n");
        if (image.matches("[0-9]+")){
            return new Token(type, image, last, coord);
        }
        return new Token(image, image, last, coord);
    }

    @Override
    public Token getNextToken() {
        if (coord.getPos() >= text.length()) {
            return new Token(Term.EOF, coord);
        }
        String image;
        if (m.find()) {
            if (m.start() != coord.getPos()) {
                log.append(String.format("SYNTAX ERROR: %d",
                        coord.getPos())).append(coord.toString()).append('\n');
                System.out.println(String.format("SYNTAX ERROR: %d",
                        coord.getPos()) + coord.toString());
                System.exit(-1);
            }
            if ((image = m.group(BLANK)) != null) {
                coord = coord.shift(image.length());
                return getNextToken();
            }
            if ((image = m.group(NEWLINE)) != null) {
                coord = coord.newline();
                coord = coord.shift(image.length() - 1);
                return getNextToken();
            }
            for (String s: regexp.keySet()) {
                if (isType(s)) {
                    return returnToken(s);
                }
            }

            System.out.println("ERROR " + coord.toString() + " " + text.substring(coord.getPos()));
            return getNextToken();

        } else {
            log.append("SYNTAX ERROR: ").append(coord.toString()).append('\n');
            log.append("SYNTAX ERROR: ").append(coord.toString()).append('\n');
            System.out.println("SYNTAX ERROR: " + coord.toString());
            return new Token(Term.EOF, coord);
        }
    }

    @Override
    public Token nextToken() {
        if (index <= tokens_list.size() - 1) {
            index++;
            return tokens_list.get(index - 1);
        } else {
            return new Token(Term.EOF, coord);
        }
    }
}
