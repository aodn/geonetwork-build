package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.AttachmentAddedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnAttachmentAddedListener extends AodnMetadataEventListener implements ApplicationListener<AttachmentAddedEvent> {

    private String changeMessage = "";
    private String eventType = StatusValue.Events.ATTACHMENTADDED;

    @Override
    public String getChangeMessage() {
        return changeMessage;
    }

    @Override
    public String getEventType() {
        return eventType;
    }

    @Override
    public void onApplicationEvent(AttachmentAddedEvent event) {
        logEvent(event);
    }
}
