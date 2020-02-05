package au.org.emii.classifier;

import org.fao.geonet.kernel.ThesaurusFinder;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import java.net.URL;
import static org.junit.Assert.assertEquals;

public class AodnThesaurusTest {

    private static final String MISSING_THESAURUS = "http://www.my.com/missing_thesaurus";
    private static ThesaurusFinder thesaurusFinder;

    @BeforeClass
    static public void loadThesauri() {
        URL thesauriDirectory = LabelClassifier.class.getResource("/thesauri");
        thesaurusFinder = new ThesaurusDirectoryLoader(thesauriDirectory.getFile());
    }
    
    @Before
    public void setup() {
    }

    @Test
    public void testMissingScheme() {
        AodnThesaurus thesaurus = new AodnThesaurus(thesaurusFinder.getThesaurusByConceptScheme(MISSING_THESAURUS), MISSING_THESAURUS);
        assertEquals(thesaurus.getThesaurusTitle(), "Missing thesaurus");
    }

}
