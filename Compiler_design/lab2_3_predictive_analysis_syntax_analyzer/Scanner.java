import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Scanner {

    private HashMap<String, String> regexp = new HashMap<>();

    private String text = "";
    private Pattern p ;
    private Matcher m;
    public Position coord;
    private String image = "";

    private int index;
    private ArrayList<Fragment> comments  = new ArrayList<>();

    private ArrayList<Token> tokens_list  = new ArrayList<>();

    public static String makeGroup(String name, String expr) {
        return "(?<" + name + ">(" + expr + "))";
    }

    public String setPattern() {
        String res =
                makeGroup("tab", "[ \\t]+") + "|" +
//                makeGroup("newline", "\\R") + "|" +
                makeGroup("comments", "\\*[^\\*\\n]*\\n");
        for (Map.Entry<String, String> e: regexp.entrySet()) {
            res += "|" + makeGroup(e.getKey(), e.getValue());
        }
        return res;
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
        coord = Position.start();
        Token t = getNextToken();
        tokens_list.add(t);
        while (!Objects.equals(t.name, "$")) {
            t = getNextToken();
            tokens_list.add(t);
        }
        index = 0;
    }

    private boolean isType(String type) {
        return (image = m.group(type)) != null;
    }

    private Token returnToken (String type) {
        Position last = coord;
        if (Objects.equals(type, "NewLine")) {
            for (int i = 0; i < image.length(); i++) {
                coord = coord.newline();
            }
        } else {
            coord = coord.shift(image.length());
        }
        return new Token(type, image, last, coord);
    }

    public Token getNextToken() {
        if (coord.getPos() >= text.length()) {
            return new Token(Term.EOF, coord);
        }
        String image;
        if (m.find()) {
            if (m.start() != coord.getPos()) {
                System.out.println(String.format("ERROR: SYNTAX %d - %d",
                        m.start(), coord.getPos()) + coord.toString());
                coord = coord.shift(m.start() - coord.getPos());
            }
            for (String s: regexp.keySet()) {
                if (isType(s)) {
                    return returnToken(s);
                }
            }
            if ((image = m.group("tab")) != null) {
                coord = coord.shift(image.length());
                return getNextToken();
            }
//            if ((image = m.group("newline")) != null) {
//                coord = coord.newline();
//                coord = coord.shift(image.length() - 1);
//                return nextToken();
//            }
            if ((image = m.group("comments")) != null) {
                Position last = coord;
                coord = coord.shift(image.length() - 1);
                comments.add(new Fragment(image, last, coord));
                coord = coord.newline();
                return getNextToken();
            } else {
                System.out.println("ERROR: " + coord.toString() + " " + text.substring(coord.getPos()));
                return getNextToken();
            }
        } else {
//            System.out.println("ERROR: SYNTAX" + coord.toString());
            return new Token(Term.EOF, coord);
        }
    }

    public Token nextToken() {
        if (index < tokens_list.size() - 1) {
            if ((Objects.equals(tokens_list.get(index).name, "NewLine"))
                    && (Objects.equals(tokens_list.get(index + 1).name, "AxiomKeyword")
                        || Objects.equals(tokens_list.get(index + 1).name, "NTermKeyword")
                        || Objects.equals(tokens_list.get(index + 1).name, "TermKeyword")
                        || Objects.equals(tokens_list.get(index + 1).name, "RuleKeyword"))) {
                index++;
            }
            index++;
            return tokens_list.get(index - 1);
        } else if ((index == (tokens_list.size() - 1)) && (!(Objects.equals(tokens_list.get(index).name, "NewLine")))) {
            index++;
            return tokens_list.get(index - 1);
        } else {
            return new Token(Term.EOF, coord);
        }
    }

    public ArrayList<Fragment> getComments() {
        return this.comments;
    }
}