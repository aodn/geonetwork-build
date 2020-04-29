package au.org.emii.listeners.history;

import org.fao.geonet.events.history.RecordValidationTriggeredEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordValidationTriggeredListener extends AodnMetadataEventListener
        implements ApplicationListener<RecordValidationTriggeredEvent> {

    @Override
    public void onApplicationEvent(RecordValidationTriggeredEvent event) {
        logEvent(event);
    }
}
