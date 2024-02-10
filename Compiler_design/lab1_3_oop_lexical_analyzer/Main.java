import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class Main {
    public static void main(String[] args) throws IOException {
        Compiler compiler = new Compiler();
        String program = new String(Files.readAllBytes(Paths.get(args[0])));
        Scanner scanner = new Scanner(program, compiler);
        System.out.println("TOKENS:");
        Token token = scanner.nextToken();
        while (token.tag != DomainTag.END_OF_PROGRAM) {
            System.out.println(token);
            token = scanner.nextToken();
        }
        if (compiler.isErrors()) {
            System.out.println("MESSAGES:");
            compiler.outputMessages();
        }
    }
}
