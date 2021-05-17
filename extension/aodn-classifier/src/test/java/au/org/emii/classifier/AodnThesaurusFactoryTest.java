package au.org.emii.classifier;

import org.fao.geonet.kernel.ThesaurusFinder;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import java.net.URL;

import static org.junit.Assert.assertEquals;

public class AodnThesaurusFactoryTest {


    private static final String MISSING_SCHEME = "http://www.my.com/missing_thesaurus";
    private static ThesaurusFinder thesaurusFinder;

    @BeforeClass
    static public void loadThesauri() {
        URL thesauriDirectory = LabelClassifier.class.getResource("/thesauri");
        thesaurusFinder = new ThesaurusDirectoryLoader(thesauriDirectory.getFile());
    }

    @Before
    public void setup() {
    }


//    @Test
//    public void testFindMissingThesaurus() {
//
//        AodnThesaurusFactory thesaurusFactory = new AodnThesaurusFactory(thesaurusFinder);
//        IAodnThesaurus thesaurus = thesaurusFactory.findThesaurus(MISSING_SCHEME);
//        assertEquals(thesaurus.getThesaurusTitle(), "No title found. Missing thesaurus.");
//
//    }

}
