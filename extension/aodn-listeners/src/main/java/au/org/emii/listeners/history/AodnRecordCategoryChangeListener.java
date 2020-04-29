package au.org.emii.listeners.history;

import org.fao.geonet.domain.StatusValue;
import org.fao.geonet.events.history.RecordCategoryChangeEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

@Component
public class AodnRecordCategoryChangeListener extends AodnMetadataEventListener implements ApplicationListener<RecordCategoryChangeEvent> {

    @Override
    public void onApplicationEvent(RecordCategoryChangeEvent event) {
        logEvent(event);
    }
}
