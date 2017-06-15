package models;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Model where the MySQL Server is hosted locally.
 */
public class MySQLModel extends ASQLModel {

    /**
     * Constructor for a MySQL Model.
     */
    public MySQLModel() {

    }

    @Override // Since this is a MySQL specific connection (in the URL)
    public void startConnection(String username, String password, String server, int port, boolean useSSL)
            throws SQLException {
        Properties connectionProps = new Properties();
        connectionProps.put("user", username);
        connectionProps.put("password", password);

        connection = DriverManager.getConnection("jdbc:mysql://"
                        + server
                        + ":"
                        + port
                        + "/"
                        + "lol"
                        + "?characterEncoding=UTF-8&useSSL="
                        + useSSL,
                connectionProps);
    }
}
