package models;

import java.sql.ResultSet;
import java.util.ArrayList;

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
    void startConnection(String username, String password, String server, int port, boolean useSSL);

    /**
     * Requests data from the SQL database with the given query, using the model's connection.
     * @param query The SQL query to send to the database.
     */
    ResultSet requestData(String query);

    /**
     * Returns the top three champions for each role for the user.
     * @param results The top three champions for each role: Top, Jungle, Mid, ADC, and Support (in that order)
     */
    ArrayList<ArrayList<String>> getTopThree(ResultSet results);
}
