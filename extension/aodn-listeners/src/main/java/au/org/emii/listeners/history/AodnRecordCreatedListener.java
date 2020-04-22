package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordCreateEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordCreatedListener extends AodnMetadataEventListener implements ApplicationListener<RecordCreateEvent> {

    private String changeMessage = "";
    private String eventType = StatusValue.Events.RECORDCREATED;

    @Override
    public String getChangeMessage() {
        return changeMessage;
    }

    @Override
    public String getEventType() {
        return eventType;
    }

    @Override
    public void onApplicationEvent(RecordCreateEvent event) {
        logEvent(event);
    }

}
