package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordPrivilegesChangeEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordPrivilegesChangeListener extends AodnMetadataEventListener
        implements ApplicationListener<RecordPrivilegesChangeEvent> {

    private String changeMessage = "";
    private String eventType = StatusValue.Events.RECORDPRIVILEGESCHANGE;

    @Override
    public String getChangeMessage() {
        return changeMessage;
    }

    @Override
    public String getEventType() {
        return eventType;
    }

    @Override
    public void onApplicationEvent(RecordPrivilegesChangeEvent event) {
        logEvent(event);
    }
}
