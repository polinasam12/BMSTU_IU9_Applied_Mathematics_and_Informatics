package lex_analyze;

public class Fragment {
    private String image;
    private Coords start, follow;

    public Fragment(String image, Coords start, Coords follow) {
        this.image = image;
        this.start = start;
        this.follow = follow;
    }

    public Fragment(Coords start) {
        this.image = "";
        this.start = start;
        this.follow = start;
    }

    @Override
    public String toString(){
        return String.format("COMMENT %s-%s %s",
                start.toString(), follow.toString(), image);
    }
}
