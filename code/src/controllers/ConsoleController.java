package controllers;

import models.MySQLModel;
import views.ConsoleView;

import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * Text-based Controller for the project..
 */
public class ConsoleController extends AController {
    private MySQLModel model;
    private Readable rd;
    private Appendable ap;
    private ConsoleView view;
    private String summonerName;
    private String region;

    /**
     * Constructs a Console Controller
     *
     * @param rd A readable source of input
     * @param ap An output for information to be appended
     */
    private ConsoleController(Readable rd, Appendable ap) {
        this.rd = rd;
        this.ap = ap;
    }

    @Override
    public void enterSummonerName() {
        Scanner sc = new Scanner(rd);
        try {
            ap.append("Enter Summoner Name: ");

        } catch (IOException e) {
            e.printStackTrace();
        }
        summonerName = sc.next();
    }

    @Override
    public void enterRegion() {
        Scanner sc = new Scanner(rd);
        try {
            ap.append("Enter Region: ");

        } catch (IOException e) {
            e.printStackTrace();
        }
        region = sc.next();
    }

    public static void main(String[] args) throws IOException {
        // Initialize Controller and start connection
        ConsoleController controller =
                new ConsoleController(new InputStreamReader(System.in), System.out);
        controller.model = new MySQLModel();
        try {
            controller.model.startConnection("root", "563571rT", "localhost", 3306, false);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Request first few inputs from user
        ResultSet rs;
        controller.enterSummonerName();
        controller.enterRegion();
        ConsoleView view = new ConsoleView(controller.model, controller.ap);
        view.display(controller);
        //Queries for summoner name based on user inputted summonerName
        rs = controller.model.requestData("SELECT * " +
                "FROM summoners " +
                "WHERE summoner_name = " + "\"" + controller.summonerName + "\"");

        //Attempt to print ResultSet of above query
        ResultSetMetaData rsmd;
        int columnsNumber;
        try {
            rsmd = rs.getMetaData();
            columnsNumber = rsmd.getColumnCount();
            while (rs.next()) {
                for (int i = 1; i <= columnsNumber; i++) {
                    if (i > 1) System.out.print(",  ");
                    String columnValue = rs.getString(i);
                    System.out.print(columnValue + " " + rsmd.getColumnName(i));
                }
                System.out.println("");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        //Use summonerName to activate that summoner in the SQL table active_summoner
        //(Displays all matches for the summoner the user just entered)
        try {
            String query = "UPDATE active_summoner SET active = TRUE WHERE summoner_name = ?";
            PreparedStatement preparedStatement = controller.model.connection.prepareStatement(query);
            preparedStatement.setString(1, controller.summonerName);
            preparedStatement.executeUpdate();
            //Print the matches table
            rs = controller.model.requestData("SELECT * " +
                    "FROM matches");
            rsmd = rs.getMetaData();
            columnsNumber = rsmd.getColumnCount();
            while (rs.next()) {
                for (int i = 1; i <= columnsNumber; i++) {
                    if (i > 1) System.out.print(",  ");
                    String columnValue = rs.getString(i);
                    System.out.print(columnValue + " " + rsmd.getColumnName(i));
                }
                System.out.println("");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // While loop for Entering Commands - set flag to false when EXIT is run
        boolean flag = true;
        while (flag) {
            Scanner sc = new Scanner(controller.rd);
            System.out.println("Enter a Command (CREATE/READ/UPDATE/DELETE/EXIT)");
            String command = sc.next();
            // CREATE Command (Summoner/Match)
            if (command.equals("CREATE") || command.equals("create")) {
                System.out.println("What do you want to create? (summoner/match)");
                String create = sc.next();
                if (create.equals("summoner")) {
                    System.out.println("Insert Summoner ID");
                    String sumID = sc.next();
                    System.out.println("Insert Account ID");
                    String accID = sc.next();
                    System.out.println("Insert Summoner Name");
                    String sumName = sc.next();
                    System.out.println("Insert Summoner Level");
                    String sumLevel = sc.next();
                    String query = "INSERT INTO summoners VALUES (?, ?, ?, ?)";
                    try {
                        PreparedStatement preparedStatement = controller.model.connection.prepareStatement(query);
                        preparedStatement.setInt(1, Integer.parseInt(sumID));
                        preparedStatement.setInt(2, Integer.parseInt(accID));
                        preparedStatement.setString(3, sumName);
                        preparedStatement.setInt(4, Integer.parseInt(sumLevel));
                        preparedStatement.executeUpdate();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    System.out.println("Created a level " + sumLevel + " " + create + " named " + sumName + ". Summoner/Account ID:" + sumID + "/" + accID);
                } else if (create.equals("match")) {
                    System.out.println("Which summoner? (Richard/Nick)");
                    String summoner = sc.next();
                    System.out.println("Insert Match ID (Must be Unique)");
                    String matchID = sc.next();
                    System.out.println("Insert Season (1-7)");
                    String season = sc.next();
                    System.out.println("Insert Lane (top, jng, mid, adc, sup)");
                    String lane = sc.next();
                    System.out.println("Insert win (TRUE/FALSE)");
                    String win = sc.next();
                    Boolean bwin = null;
                    if (win.equals("TRUE") || win.equals("true")) {
                        bwin = true;
                    } else if (win.equals("FALSE") || win.equals("false")) {
                        bwin = false;
                    } else {
                        System.out.println("Invalid input for win");
                    }
                    System.out.println("Insert kills");
                    String kills = sc.next();
                    System.out.println("Insert deaths");
                    String deaths = sc.next();
                    System.out.println("Insert assists");
                    String assists = sc.next();
                    System.out.println("Insert CS");
                    String cs = sc.next();
                    System.out.println("Insert ChampionID (refer to champions table)");
                    String champID = sc.next();
                    try {
                        PreparedStatement preparedStatement;
                        if (summoner.equals("Richard")) {
                            String query = "INSERT INTO richard_history VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 123456789)";
                            preparedStatement = controller.model.connection.prepareStatement(query);
                        } else if (summoner.equals("Nick")) {
                            String query = "INSERT INTO nick_history VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 234567890)";
                            preparedStatement = controller.model.connection.prepareStatement(query);
                        } else {
                            break;
                        }
                        preparedStatement.setInt(1, Integer.parseInt(matchID));
                        preparedStatement.setInt(2, Integer.parseInt(season));
                        preparedStatement.setString(3, lane);
                        preparedStatement.setBoolean(4, bwin);
                        preparedStatement.setInt(5, Integer.parseInt(kills));
                        preparedStatement.setInt(6, Integer.parseInt(deaths));
                        preparedStatement.setInt(7, Integer.parseInt(assists));
                        preparedStatement.setInt(8, Integer.parseInt(cs));
                        preparedStatement.setInt(9, Integer.parseInt(champID));
                        preparedStatement.executeUpdate();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    System.out.println("Created a " + create + " for " + summoner);
                } else {
                    System.out.println("Invalid Input");
                }

            }
            // READ command (summoners/matches/champions/leagues/active_summoners/richard_history/nick_history)
            else if (command.equals("READ") || command.equals("read")) {
                System.out.println("Which table? (summoners/leagues/champions/matches/nick_history/richard_history/active_summoner)");
                String table = sc.next();
                try {
                   rs = controller.model.requestData("SELECT * FROM " + table);
                   rsmd = rs.getMetaData();
                   columnsNumber = rsmd.getColumnCount();
                   System.out.println("Displaying table " + table + ":");
                    while (rs.next()) {
                        for (int i = 1; i <= columnsNumber; i++) {
                            if (i > 1) System.out.print(",  ");
                            String columnValue = rs.getString(i);
                            System.out.print(columnValue + " " + rsmd.getColumnName(i));
                        }
                        System.out.println("");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            //UPDATE command (summoner/match/active_summoners [true/false])
            else if (command.equals("UPDATE") || command.equals("update")) {
                System.out.println("Enter summoner to update activity (Richard/Nick) or enter a table to update (summoners/matches)");
                String input = sc.next();
                if(input.equals("Richard") || input.equals("richard") || input.equals("Nick") || input.equals("nick")) {
                    System.out.println("Enter activity (true/false)");
                    String activity = sc.next();
                    try {
                        String query = "UPDATE active_summoner SET active = ? WHERE summoner_name = ?";
                        PreparedStatement preparedStatement = controller.model.connection.prepareStatement(query);
                        preparedStatement.setBoolean(1, Boolean.parseBoolean(activity));
                        preparedStatement.setString(2, input);
                        preparedStatement.executeUpdate();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    System.out.println("Summoner " + input + "'s activity updated to be " + activity);
                } else if (input.equals("summoners")) {
                    System.out.println("Which summoner do you want to update? (SummonerID)");
                    String sumID = sc.next();
                    System.out.println("Which field do you want to update? (account_id/summoner_level)");
                    String field = sc.next();
                    System.out.println("What do you want to set " + field + " to?");
                    String update = sc.next();
                    try {
                        String query = "UPDATE summoners SET " + field + " = ? WHERE summoner_id = ?";
                        PreparedStatement preparedStatement = controller.model.connection.prepareStatement(query);
                        if (field.equals("account_id") || field.equals("summoner_level")) {
                            preparedStatement.setInt(1, Integer.parseInt(update));
                        } else {
                            preparedStatement.setString(1, update);
                        }
                        preparedStatement.setInt(2, Integer.parseInt(sumID));
                        preparedStatement.executeUpdate();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    System.out.println("Summoner " + sumID + "'s " + field + " changed to " + update);
                } else if (input.equals("matches")) {
                    System.out.println("Which match do you want to update? (MatchID)");
                    String matchID = sc.next();
                    System.out.println("Which field do you want to update? (match_season/match_lane/match_win/match_kills/match_deaths/match_assists/match_cs)");
                    String field = sc.next();
                    System.out.println("What do you want to set " + field + " to?");
                    String update = sc.next();
                    try {
                        String query = "UPDATE matches SET " + field + " = ? WHERE match_id = ?";
                        PreparedStatement preparedStatement = controller.model.connection.prepareStatement(query);
                        if (field.equals("match_lane")) {
                            preparedStatement.setString(1, update);
                        } else if (field.equals("match_win")) {
                            preparedStatement.setBoolean(1, Boolean.parseBoolean(update));
                        } else {
                            preparedStatement.setInt(1, Integer.parseInt(update));
                        }
                        preparedStatement.setString(2, matchID);
                        preparedStatement.executeUpdate();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    System.out.println("Match " + matchID + "'s " + field + " changed to " + update);
                } else {
                    System.out.println("Invalid Input");
                }
            }
            //DELETE command (summoner/match)
            else if (command.equals("DELETE") || command.equals("delete")) {
                System.out.println("What do you want to delete? (summoner/match)");
                String delete = sc.next();
                if (delete.equals("summoner")) {
                    System.out.println("Insert Summoner ID");
                    String sumID = sc.next();
                    String query = "DELETE FROM summoners WHERE summoners.summoner_id = ?";
                    try {
                        PreparedStatement preparedStatement = controller.model.connection.prepareStatement(query);
                        preparedStatement.setString(1, sumID);
                        preparedStatement.executeUpdate();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    System.out.println("Summoner " + sumID + " deleted");
                } else if (delete.equals("match")) {
                    System.out.println("Insert Match ID");
                    String matchID = sc.next();
                    try {
                        String query = "DELETE FROM richard_history WHERE richard_history.match_id = ?";
                        PreparedStatement preparedStatement = controller.model.connection.prepareStatement(query);
                        preparedStatement.setInt(1, Integer.parseInt(matchID));
                        preparedStatement.executeUpdate();
                        query = "DELETE FROM nick_history WHERE nick_history.match_id = ?";
                        preparedStatement = controller.model.connection.prepareStatement(query);
                        preparedStatement.setInt(1, Integer.parseInt(matchID));
                        preparedStatement.executeUpdate();
                        query = "DELETE FROM matches WHERE matches.match_id = ?";
                        preparedStatement = controller.model.connection.prepareStatement(query);
                        preparedStatement.setInt(1, Integer.parseInt(matchID));
                        preparedStatement.executeUpdate();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    System.out.println("Match " + matchID + " deleted");
                } else {
                    System.out.println("Invalid Input");
                }

            }
            //EXIT command
            else if (command.equals("EXIT") || command.equals("exit")) {
                try {
                    controller.model.connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                System.out.println("Closing Connection...");
                flag = false;
            } else {
                System.out.println("Unknown Command - Please Try Again");
            }

        }
    }
}
