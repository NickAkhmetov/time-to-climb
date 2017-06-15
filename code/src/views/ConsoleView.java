package views;

import controllers.ConsoleController;
import controllers.IController;
import models.MySQLModel;

/**
 * CommandLine View for the project.
 */
public class ConsoleView extends AView{
    MySQLModel model;
    Appendable ap;

    public ConsoleView(MySQLModel model, Appendable ap) {
        this.model = model;
        this.ap = ap;
    }

    @Override
    public void display(IController controller) {

    }
}
