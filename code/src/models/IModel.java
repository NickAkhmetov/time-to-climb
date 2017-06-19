package models;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import utils.ChampStat;

/**
 * Interface for implementations of TimeToClimb's back-end code.
 */
public interface IModel {

    /**
     * Creates a connection with the passed SQL server.
     * @param username The username with which to log in to the SQL server
     * @param password The password with which to log in to the SQL server
     * @param server The address of the SQL server
     * @param port The port of the SQL server which traffic is routed through
     * @param useSSL Select whether to use SSL encryption
     */
    void startConnection(String username, String password, String server, int port, boolean useSSL) throws SQLException;

    /**
     * Stops and shuts down the current connection to the SQL server.
     */
    void stopConnection() throws SQLException;

    /**
     * Requests data from the SQL database with the given query, using the model's connection.
     * @param query The SQL query to send to the database.
     */
    ResultSet requestData(String query);

    /**
     * Sends DDL query to the SQL database to create or edit database.
     *
     * @param query The SQL query to send to the database.
     * @throws SQLException
     */
    void sendQuery(String query) throws SQLException;

    /**
     * Returns the summoner's ID by running a procedure
     * @param sumName summoner name that will be entered into the procedure
     */
    public long getSummonerID(String sumName);

    /**
     * Returns the league history of a summoner
     * @param sumID summoner id that will be entered into the procedure
     */
    public ResultSet getLeagues(long sumID);

    /**
     * Returns the top three champions for each role for the user.
     */
    List<List<ChampStat>> getTopThree() throws SQLException;
}
