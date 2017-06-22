package models;

import com.sun.istack.internal.Nullable;
import jdk.nashorn.internal.parser.JSONParser;
import utils.ChampStat;

import java.io.InputStreamReader;
import java.io.Reader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.json.*;

/**
 * Abstract class for a SQL-based implementation of the back-end code.
 */
public abstract class ASQLModel implements IModel {

    public Connection connection;
    public String apiKey;

    @Override
    @Nullable
    public ResultSet requestData(String query) {
        ResultSet result;
        try {
            Statement statement = this.connection.createStatement();
            result = statement.executeQuery(query);
            return result;
        } catch (java.sql.SQLException e) {
            System.out.println("Unable to retrieve results while querying server in requestData(" + query + "). " + e);
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
            System.out.println("Unable to reach server in sendQuery(" + query + "). " + e);
            System.exit(1);
        }
    }

    @Override
    public void stopConnection() throws SQLException {
        this.connection.close();
    }

    @Override
    public long getSummonerID(String sumName) {
        String proc = "CALL retrieve_summoner(" + sumName + ")";
        long sumID = -1;
        ResultSet summonerInfo = requestData(proc);
        // Get the summonerID out of this info
        try {
            if (summonerInfo.next()) {
                sumID = summonerInfo.getLong(1);
            }
        } catch (SQLException e) {
            System.out.println("Error retrieving summoner ID in getSummonerID(" + sumName + "). " + e);
        }
        // Get the SummonerID out of this info
        return sumID;
    }

    @Override
    public ResultSet getLeagues(long sumID) {
        String proc = "CALL retrieve_league(" + sumID + ")";
        return requestData(proc);
        // return something else? List of list of int (season) and list of string (rank)?
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
        List<ResultSet> results = new ArrayList<ResultSet>(5) {{
            add(requestData(proc_top));
            add(requestData(proc_jng));
            add(requestData(proc_mid));
            add(requestData(proc_adc));
            add(requestData(proc_sup));
        }};
        // Instantiate list of ChampStats
        List<List<ChampStat>> champs = new ArrayList<List<ChampStat>>(5);
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

    @Override
    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    @Override
    public void getMatchInfo(int sumID) {
        String infoRequest = "https://na1.api.riotgames.com/lol/match/v3/matchlists/by-account/";
        String command = "curl --request GET " + infoRequest + sumID + "api_key=" + this.apiKey;
        JSONObject matchList;
        JSONArray matches;
        List<Long> matchIDs = new ArrayList<Long>();
        Reader reader;
        try {
            reader = new InputStreamReader(
                    Runtime.getRuntime().exec(command).getInputStream());
            try {
                matchList = new JSONObject(reader.toString());
                matches = matchList.getJSONArray("matches");
                for (int i = 0; i < matches.length(); i++) {
                    matchIDs.add(matches.getLong(2)); // index 2 in the json array should be the gameIDs
                }
                // TODO: Got list of match ID's.
                // TODO: Time to call for each match, determine which participant is our user, get KDA and win/loss
                // TODO: then upload to server

            } catch (org.json.JSONException je) { // catch JSON errors
                System.out.println("JSON exception encountered in getMatchInfo(" + sumID + "). " + je);
                System.exit(1);
            }
        } catch (java.io.IOException e) { // catch inputstream errors
            System.out.println("Input stream reader runtime exception encountered in getMatchInfo(." + sumID + "). " + e);
            System.exit(1);
        }
    }
}
