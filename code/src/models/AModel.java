package models;

import java.sql.*;

/**
 * Abstract Class for back-end code.
 * Contains universal functions to be implemented in real Models.
 */
public abstract class AModel implements IModel {
    Connection connection;

    public ResultSet requestData(String query) throws SQLException {
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
