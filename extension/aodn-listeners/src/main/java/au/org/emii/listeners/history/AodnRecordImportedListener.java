package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordImportedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordImportedListener extends AodnMetadataEventListener implements ApplicationListener<RecordImportedEvent> {

    private String changeMessage = "";
    private String eventType = StatusValue.Events.RECORDIMPORTED;

    @Override
    public String getChangeMessage() {
        return changeMessage;
    }

    @Override
    public String getEventType() {
        return eventType;
    }

    @Override
    public void onApplicationEvent(RecordImportedEvent event) {
        logEvent(event);
    }

}
