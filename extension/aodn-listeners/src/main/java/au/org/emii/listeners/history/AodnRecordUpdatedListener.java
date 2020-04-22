package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordUpdatedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordUpdatedListener extends AodnMetadataEventListener implements ApplicationListener<RecordUpdatedEvent> {

    private String changeMessage = "";
    private String eventType = StatusValue.Events.RECORDUPDATED;

    @Override
    public String getChangeMessage() {
        return changeMessage;
    }

    @Override
    public String getEventType() {
        return eventType;
    }

    @Override
    public void onApplicationEvent(RecordUpdatedEvent event) {
        logEvent(event);
    }
}
