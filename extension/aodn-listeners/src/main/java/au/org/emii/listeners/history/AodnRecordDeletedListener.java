package au.org.emii.listeners.history;

import org.fao.geonet.events.history.RecordDeletedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordDeletedListener extends AodnMetadataEventListener implements ApplicationListener<RecordDeletedEvent> {

    @Override
    public void onApplicationEvent(RecordDeletedEvent event) {
        // Delete event is not supported
        logEvent(event);
    }
}
