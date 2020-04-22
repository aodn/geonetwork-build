package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordOwnerChangeEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordOwnerChangeListener extends AodnMetadataEventListener implements ApplicationListener<RecordOwnerChangeEvent> {

    private String changeMessage = "";
    private String eventType = StatusValue.Events.RECORDOWNERCHANGE;

    @Override
    public String getChangeMessage() {
        return changeMessage;
    }

    @Override
    public String getEventType() {
        return eventType;
    }

    @Override
    public void onApplicationEvent(RecordOwnerChangeEvent event) {
        logEvent(event);
    }
}
