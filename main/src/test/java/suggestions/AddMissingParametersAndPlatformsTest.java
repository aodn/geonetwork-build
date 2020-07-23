package suggestions;

import au.org.emii.utils.TransformTestRunner;
import org.junit.Test;

public class AddMissingParametersAndPlatformsTest {
    private static final String XSL_FILE = "iso19115-3.2018/process/add-missing-parameters-and-platforms.xsl";
    private static final String TESTS_DIR = "suggestions/AddMissingParametersAndPlatforms";
    private final TransformTestRunner testRunner = new TransformTestRunner(XSL_FILE, TESTS_DIR);

    @Test
    public void testAddParameterNoContent() {
        testRunner.run("addParameterNoContent");
    }

    @Test
    public void testAddParameterExistingContent() {
        testRunner.run("addParameterExistingContent");
    }

    @Test
    public void testAddPlatformNoAcquisitionInfo() {
        testRunner.run("addPlatformNoAcquisitionInfo");
    }

    @Test
    public void testAddPlatformExistingAcquisitionInfo() {
        testRunner.run("addPlatformExistingAcquisitionInfo");
    }

}
