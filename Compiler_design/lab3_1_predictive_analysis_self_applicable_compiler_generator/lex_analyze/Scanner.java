package lex_analyze;

import syntax_analyze.symbols.Term;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class Scanner {
    public String NEWLINE = "newline";
    public String BLANK   = "blank";
    public String newline_epxr = "\\R";
    public String blank_expr = "[ \\t]+";

    public ArrayList<Token> tokens_list  = new ArrayList<>();

    public int index;


    protected HashMap<String, String> regexp = new HashMap<>();

    protected String text = "";
    private Pattern p ;
    protected Matcher m;
    public Coords coord;
    protected String image = "";
    protected StringBuilder log = new StringBuilder();

    private ArrayList<Fragment> comments  = new ArrayList<>();

    public static String makeGroup(String name, String expr) {
        return "(?<" + name + ">(" + expr + "))";
    }

    public String setPattern() {
        StringBuilder res =
//                makeGroup(BLANK, blank_expr) + "|" +
//                makeGroup(NEWLINE, newline_epxr);
                new StringBuilder(makeGroup(BLANK, blank_expr)+ "|" +
//                makeGroup("newline", "\\R") + "|" +
                        makeGroup("comments", "\\*[^\\*\\n]*\\n"));
        for (Map.Entry<String, String> e: regexp.entrySet()) {
            res.append("|").append(makeGroup(e.getKey(), e.getValue()));
        }
        return res.toString();

    }

    public Scanner(String filepath, HashMap<String, String> termsexpr) {
        File file = new File(filepath);
        try {
            text = new String(Files.readAllBytes(file.toPath()));
        } catch (IOException e) {
            System.err.printf("file %s cannot be read\n", file.toPath());
        }
        regexp = termsexpr;
        String pattern = setPattern();
        p = Pattern.compile(pattern, Pattern.DOTALL);
        m = p.matcher(text);
        coord = Coords.start();
        Token t = getNextToken();
        tokens_list.add(t);
        while (!Objects.equals(t.getType(), "$")) {
            t = getNextToken();
            tokens_list.add(t);
        }
        index = 0;
    }

    public Scanner(HashMap<String, String> termsexpr, String filepath){
        File file = new File(filepath);
        try {
            text = new String(Files.readAllBytes(file.toPath()));
        } catch (IOException e) {
            System.err.printf("file %s cannot be read\n", file.toPath());
        }
        regexp = termsexpr;
        String pattern = setPattern();
        p = Pattern.compile(pattern, Pattern.DOTALL);
//        text = text.replaceAll("\\+", "'\\+'").replaceAll("\\(", "'\\('")
//                .replaceAll("\\*", "'\\*'").replaceAll("\\)", "'\\)'");
        m = p.matcher(text);
        coord = Coords.start();
        Token t = getNextToken();
        tokens_list.add(t);
        while (!Objects.equals(t.getType(), "$")) {
            t = getNextToken();
            tokens_list.add(t);
        }
        index = 0;
    }

    protected boolean isType(String type) {
        return (image = m.group(type)) != null;
    }

    public String getText() {
        return text;
    }

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
            if ((image = m.group("comments")) != null) {
                Coords last = coord;
                coord = coord.shift(image.length() - 1);
                comments.add(new Fragment(image, last, coord));
                coord = coord.newline();
                return getNextToken();
            }
//            if ((image = m.group(NEWLINE)) != null) {
//                coord = coord.newline();
//                coord = coord.shift(image.length() - 1);
//                return nextToken();
//            }
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

    public Token nextToken() {
        if (index < tokens_list.size() - 1) {
            if ((Objects.equals(tokens_list.get(index).getType(), "NewLine")) && (Objects.equals(tokens_list.get(index + 1).getType(), "AxiomKeyword") || Objects.equals(tokens_list.get(index + 1).getType(), "NTermKeyword") || Objects.equals(tokens_list.get(index + 1).getType(), "TermKeyword") || Objects.equals(tokens_list.get(index + 1).getType(), "RuleKeyword"))) {
                index++;
            }
            index++;
            return tokens_list.get(index - 1);
        } else if ((index == (tokens_list.size() - 1)) && (!(Objects.equals(tokens_list.get(index).getType(), "NewLine")))) {
            index++;
            return tokens_list.get(index - 1);
        } else {
            return new Token(Term.EOF, coord);
        }
    }
}