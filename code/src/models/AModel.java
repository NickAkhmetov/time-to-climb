package models;

import java.sql.*;
import java.util.Properties;

/**
 * Abstract Class for back-end code.
 * Contains universal functions to be implemented in real Models.
 */
public abstract class AModel implements IModel {
    private Connection connection;

    public void startConnection(String username, String password, String server, int port, boolean useSSL) {
        Properties connectionProps = new Properties();
        connectionProps.put("user", username);
        connectionProps.put("password", password);

        try {
            connection = DriverManager.getConnection("jdbc:mysql://"
                            + server
                            + ":"
                            + port
                            + "/"
                            + "time-to-climb"
                            + "?characterEncoding=UTF-8&useSSL="
                            + useSSL,
                    connectionProps);
        }
        catch (java.sql.SQLException e) {
            System.out.println(e);
            System.out.println("Exiting.");
            System.exit(1);
        }
    }

    public ResultSet requestData(String query) {
        ResultSet result;
        try {
            Statement statement = this.connection.createStatement();
            result = statement.executeQuery(query);
            return result;
        }
        catch (java.sql.SQLException e) {
            System.out.println("Unable to retrieve results while querying server.");
            System.out.println(e);
            System.exit(1);
        }
        // Not reachable - will return in the try or exit. This line is only here for compile time error avoidance.
        // Returning result gives "may be uninitialized" error on compile.
        return null;
    }
}
