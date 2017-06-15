package models;

import java.sql.ResultSet;
import java.util.ArrayList;

/**
 * Model where the MySQL Server is hosted locally.
 */
public class MySQLModel implements AModel {
    @Override
    public ArrayList<ArrayList<String>> getTopThree(ResultSet results) {
        return null;
    }
}
