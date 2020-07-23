package suggestions;

import au.org.emii.utils.TransformTestRunner;
import org.junit.Test;

public class AddMissingInstrumentsTest {
    private static final String XSL_FILE = "iso19115-3.2018/process/add-missing-instruments.xsl";
    private static final String TESTS_DIR = "suggestions/AddMissingInstruments";
    private final TransformTestRunner testRunner = new TransformTestRunner(XSL_FILE, TESTS_DIR);

    @Test
    public void testAddMissingInstruments() {
        testRunner.run("addMissingInstruments");
    }

}
