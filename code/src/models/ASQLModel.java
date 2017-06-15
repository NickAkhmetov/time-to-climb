package models;

import utils.ChampStat;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Abstract class for a SQL-based implementation of the back-end code.
 */
public abstract class ASQLModel implements IModel {

    Connection connection;

    public ResultSet requestData(String query) {
        ResultSet result;
        try {
            Statement statement = this.connection.createStatement();
            result = statement.executeQuery(query);
            return result;
        } catch (java.sql.SQLException e) {
            System.out.println(e);
            System.out.println("Unable to retrieve results while querying server.");
            System.out.println("Retrying...");
            try {
                Thread.sleep(1000);
            } catch (java.lang.InterruptedException i) {
                System.out.println("wake me up inside");
            }
            requestData(query);
        }
        // Won't be reached during proper operation.
        return null;
    }

    @Override
    public void sendQuery(String query) {
        try {
            Statement statement = this.connection.createStatement();
            statement.executeQuery(query);
        } catch (java.sql.SQLException e) {
            System.out.println("Unable to reach server.");
            System.out.println("Retrying...");
            sendQuery(query);
        }
    }

    @Override
    public void stopConnection() throws SQLException {
        this.connection.close();
    }

    @Override
    public List<List<ChampStat>> getTopThree() throws SQLException {
        // Instantiate the procedure calls for toplane, jungle, midlane, AD carry, and support statistics
        String proc_top = "CALL top_three_top";
        String proc_jng = "CALL top_three_jng";
        String proc_mid = "CALL top_three_mid";
        String proc_adc = "CALL top_three_adc";
        String proc_sup = "CALL top_three_sup";

        // Call the procedures and add the results to a list
        // FORMATTING FOR RESULTS LIST MUST BE
        // STRING name, DOUBLE kda, DOUBLE winrate, INT gamesPlayed, DOUBLE performance, DOUBLE stdDev
        List<ResultSet> results = new ArrayList<ResultSet>();
        results.addAll(Arrays.asList(
                this.requestData(proc_top),
                this.requestData(proc_jng),
                this.requestData(proc_mid),
                this.requestData(proc_adc),
                this.requestData(proc_sup)));

        // Instantiate list of ChampStats
        List<List<ChampStat>> champs = new ArrayList<List<ChampStat>>();
        for (int i = 0; i < 5; i++) {
            champs.add(new ArrayList<ChampStat>());
        }
        // index 0 is top, 1 is jungle, 2 is mid, 3 is adc, 4 is support

        // Populate list of ChampStats
        for (int i = 0; i < results.size(); i++) {
            while (results.get(i).next()) {
                String name = results.get(i).getString(1);
                double kda = results.get(i).getDouble(2);
                double winrate = results.get(i).getDouble(3);
                int gamesPlayed = results.get(i).getInt(4);
                double performance = results.get(i).getDouble(5);
                double stdDev = results.get(i).getDouble(6);
                ChampStat champ = new ChampStat(name, kda, winrate, gamesPlayed, performance, stdDev);
                champs.get(i).add(champ);
            }
        }

        return champs;
    }
}
