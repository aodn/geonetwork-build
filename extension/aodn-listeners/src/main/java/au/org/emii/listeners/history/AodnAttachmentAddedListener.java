package au.org.emii.listeners.history;

import org.fao.geonet.events.history.AttachmentAddedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnAttachmentAddedListener extends AodnMetadataEventListener implements ApplicationListener<AttachmentAddedEvent> {

    @Override
    public void onApplicationEvent(AttachmentAddedEvent event) {
        logEvent(event);
    }
}
