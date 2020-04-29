package au.org.emii.listeners.history;


import org.apache.log4j.Logger;
import org.fao.geonet.events.history.AbstractHistoryEvent;

public abstract class AodnMetadataEventListener {

    private static Logger logger = Logger.getLogger(AodnMetadataEventListener.class);

    /**
     * Event handler
     *
     * @param event
     */
    public final void logEvent(AbstractHistoryEvent event) {

        logger.info("Event:: "+event.toString());
        logger.info("Before:: \n"+event.getPreviousState());
        logger.info("After:: \n"+event.getCurrentState());
    }
    
}
