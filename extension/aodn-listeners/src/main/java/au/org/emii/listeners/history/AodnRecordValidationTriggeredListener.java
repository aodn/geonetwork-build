package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordValidationTriggeredEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordValidationTriggeredListener extends AodnMetadataEventListener
        implements ApplicationListener<RecordValidationTriggeredEvent> {

    private String changeMessage = "";
    private String eventType = StatusValue.Events.RECORDVALIDATIONTRIGGERED;

    @Override
    public String getChangeMessage() {
        return changeMessage;
    }

    @Override
    public String getEventType() {
        return eventType;
    }

    @Override
    public void onApplicationEvent(RecordValidationTriggeredEvent event) {
        logEvent(event);
    }
}
