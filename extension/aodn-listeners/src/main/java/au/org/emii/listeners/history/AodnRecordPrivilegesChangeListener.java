package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordPrivilegesChangeEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordPrivilegesChangeListener extends AodnMetadataEventListener
        implements ApplicationListener<RecordPrivilegesChangeEvent> {

    @Override
    public void onApplicationEvent(RecordPrivilegesChangeEvent event) {
        logEvent(event);
    }
}
