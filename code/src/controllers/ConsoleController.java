package controllers;

import models.MySQLModel;
import views.ConsoleView;

/**
 * Text-based Controller for the project.
 */
public class ConsoleController extends AController {
    private MySQLModel model;
    private Readable rd;
    private Appendable ap;
    private ConsoleView view;

    public ConsoleController(Readable rd, Appendable ap) {
        this.rd = rd;
        this.ap = ap;
        this.model = new MySQLModel();
        this.view = new ConsoleView(this.model, this.ap);
    }


    @Override
    public void enterSummonerName() {

    }

    @Override
    public void enterRegion() {

    }
}
