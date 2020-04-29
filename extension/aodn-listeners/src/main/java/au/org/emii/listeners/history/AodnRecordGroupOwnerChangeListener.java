package au.org.emii.listeners.history;

import org.fao.geonet.events.history.RecordGroupOwnerChangeEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordGroupOwnerChangeListener extends AodnMetadataEventListener
        implements ApplicationListener<RecordGroupOwnerChangeEvent> {

    @Override
    public void onApplicationEvent(RecordGroupOwnerChangeEvent event) {
        logEvent(event);
    }
}
