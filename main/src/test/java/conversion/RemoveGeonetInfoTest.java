package conversion;

import au.org.emii.utils.TransformTestRunner;
import org.junit.Test;

/**
 * Run tests configured for the remove-geonet-info process
 */

public class RemoveGeonetInfoTest {
    private static final String XSL_FILE = "conversion/import/RemoveGeonetInfo.xsl";
    private static final String TESTS_DIR = "conversion/RemoveGeonetInfo";
    private final TransformTestRunner testRunner = new TransformTestRunner(XSL_FILE, TESTS_DIR);

    @Test
    public void testRemoveGeonetInfo() {
        testRunner.run("removeGeonetInfo");
    }

}
