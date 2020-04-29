package au.org.emii.listeners.history;

import org.fao.geonet.events.history.RecordImportedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordImportedListener extends AodnMetadataEventListener implements ApplicationListener<RecordImportedEvent> {

    @Override
    public void onApplicationEvent(RecordImportedEvent event) {
        logEvent(event);
    }

}
