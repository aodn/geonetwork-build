package au.org.emii.listeners.history;

import org.fao.geonet.events.history.RecordCreateEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordCreatedListener extends AodnMetadataEventListener implements ApplicationListener<RecordCreateEvent> {

    @Override
    public void onApplicationEvent(RecordCreateEvent event) {
        logEvent(event);
    }

}
