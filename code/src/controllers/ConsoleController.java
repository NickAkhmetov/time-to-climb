package controllers;

import models.MySQLModel;
import views.ConsoleView;

import java.io.IOException;
import java.io.InputStreamReader;
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

    public ConsoleController(Readable rd, Appendable ap) {
        this.rd = rd;
        this.ap = ap;
    }

    public static void main(String[] args) throws IOException {
        ConsoleController controller =
                new ConsoleController(new InputStreamReader(System.in), System.out);
        controller.model = new MySQLModel();

        try {
            controller.model.startConnection("root", "root", "localhost", 3306, false);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        controller.enterSummonerName();
        controller.enterRegion();
        ConsoleView view = new ConsoleView(controller.model, controller.ap);
        view.display(controller);
        //Queries for summoner name based on user inputted summonerName
        controller.model.requestData("SELECT summoner_name " +
                "FROM summoners " +
                "WHERE summoner_name = " + controller.summonerName);
    }

    @Override
    public void enterSummonerName() {
        Scanner sc = new Scanner(rd);
        try {
            ap.append("Enter Summoner Name:");

        } catch (IOException e) {
            e.printStackTrace();
        }
        summonerName = sc.next();
    }

    @Override
    public void enterRegion() {
        Scanner sc = new Scanner(rd);
        try {
            ap.append("Enter Region:");

        } catch (IOException e) {
            e.printStackTrace();
        }
        region = sc.next();
    }

    /**
     * Retrieves the summoner based on input summonerName and region
     */
    public void retriveSummoner() {
        //Run Query on DataDragon for Summoner information?
    }
}
