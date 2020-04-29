package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordUpdatedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordUpdatedListener extends AodnMetadataEventListener implements ApplicationListener<RecordUpdatedEvent> {

    @Override
    public void onApplicationEvent(RecordUpdatedEvent event) {
        logEvent(event);
    }
}
