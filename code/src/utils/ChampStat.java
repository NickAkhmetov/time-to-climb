package utils;

import java.util.Objects;

/**
 * Class for storing Champion statistics for easy parsing and displaying of personal performance.
 */
public class ChampStat {
    private String name;
    private double kda;
    private double winrate;
    private int gamesPlayed;
    private double performance;
    private double stdDev;

    public ChampStat(String name, double kda, double winrate, int gamesPlayed, double performance, double stdDev) {
        this.name = name;
        this.kda = kda;
        this.winrate = winrate;
        this.gamesPlayed = gamesPlayed;
        this.performance = performance;
        this.stdDev = stdDev;
    }

    /**
     * @return champion name
     */
    public String getName() {
        return this.name;
    }

    /**
     * @return champion Kill/Death/Assist ratio
     */
    public double getKda() {
        return this.kda;
    }

    /**
     * @return champion winrate
     */
    public double getWinrate() {
        return this.winrate;
    }

    /**
     * @return number of games played on this champion
     */
    public int getGamesPlayed() {
        return this.gamesPlayed;
    }

    /**
     * @return the product of this champion's winrate and kill/death/assist ratio
     */
    public double getPerformance() {
        return this.performance;
    }

    /**
     * @return the standard deviation of this champion's performance rating
     */
    public double getStdDev() {
        return this.stdDev;
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.name, this.kda, this.winrate, this.gamesPlayed, this.performance, this.stdDev);
    }

    @Override
    public boolean equals(Object obj) {
        return (obj instanceof ChampStat) && ((ChampStat) obj).getName().equals(this.getName());
    }

    @Override
    public String toString() {
        String sep = " | ";
        return sep
                + String.format("%-15s", this.getName())
                + sep
                + String.format("%-10s", this.getWinrate())
                + sep
                + String.format("%-10s", this.getKda())
                + sep
                + String.format("%-10s", this.getGamesPlayed())
                + sep
                + String.format("%-10s", this.getPerformance())
                + sep
                + String.format("%-10s", this.getStdDev());
    }
}
