package views;
import controllers.IController;

/**
 * Interface for TimeToClimb's display code.
 * Allows for implementations via command line or GUI.
 */
public interface IView {

    /**
     * Main method for any View - displays output from the controller.
     * @param controller The controller to display output from.
     */
    void display(IController controller);
}
