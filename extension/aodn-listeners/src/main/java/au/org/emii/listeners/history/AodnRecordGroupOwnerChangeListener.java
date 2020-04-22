package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordGroupOwnerChangeEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordGroupOwnerChangeListener extends AodnMetadataEventListener
        implements ApplicationListener<RecordGroupOwnerChangeEvent> {

    private String changeMessage = "";
    private String eventType = StatusValue.Events.RECORDGROUPOWNERCHANGE;

    @Override
    public String getChangeMessage() {
        return changeMessage;
    }

    @Override
    public String getEventType() {
        return eventType;
    }

    @Override
    public void onApplicationEvent(RecordGroupOwnerChangeEvent event) {
        logEvent(event);
    }
}
