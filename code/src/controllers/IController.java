package controllers;

/**
 * Interface for TimeToClimb's front-end code.
 */
public interface IController {

    /**
     * Request user's summoner name, which will be queried for summoner's match history and leagues
     */
    void enterSummonerName();

    /**
     * Request user's region, which will be used alongside summoner name to obtain correct summoner
     */
    void enterRegion();
}
