package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordProcessingChangeEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordProcessingChangeListener extends AodnMetadataEventListener
        implements ApplicationListener<RecordProcessingChangeEvent> {

    @Override
    public void onApplicationEvent(RecordProcessingChangeEvent event) {
        logEvent(event);
    }
}
