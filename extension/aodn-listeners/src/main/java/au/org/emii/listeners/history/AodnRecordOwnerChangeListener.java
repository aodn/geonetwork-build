package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordOwnerChangeEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordOwnerChangeListener extends AodnMetadataEventListener implements ApplicationListener<RecordOwnerChangeEvent> {

    @Override
    public void onApplicationEvent(RecordOwnerChangeEvent event) {
        logEvent(event);
    }
}
