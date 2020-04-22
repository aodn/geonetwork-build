package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordDeletedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordDeletedListener extends AodnMetadataEventListener implements ApplicationListener<RecordDeletedEvent> {

    private String changeMessage = "";
    private String eventType = StatusValue.Events.RECORDDELETED;

    @Override
    public String getChangeMessage() {
        return changeMessage;
    }

    @Override
    public String getEventType() {
        return eventType;
    }

    @Override
    public void onApplicationEvent(RecordDeletedEvent event) {
        // Delete event is not supported
    }
}
