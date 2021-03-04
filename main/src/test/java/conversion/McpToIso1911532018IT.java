package conversion;

import au.org.emii.utils.TransformTestRunner;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

/**
 * Run tests configured for the MCP-to-ISO19115-3-2018 conversion
 */

public class McpToIso1911532018IT {
    private static final String XSL_FILE = "iso19115-3.2018/convert/ISO19139.MCP/fromMCP.xsl";
    private static final String TESTS_DIR = "conversion/McpToIso1911532018";
    private final TransformTestRunner testRunner = new TransformTestRunner(XSL_FILE, TESTS_DIR);

    @ParameterizedTest
    @ValueSource(strings = {
            "acquisitionInformation",
            "aggregationInfo",
            "aggregationInfo2",
            "aggregationInfo3",
            "citation",
            "citation2",
            "citation3",
            "codelistlocation",
            "codelistlocation2",
            "codelistlocation3",
            "codelistlocation4",
            "codelistlocation5",
            "contact",
            "contact2",
            "credit",
            "dataParameters",
            "dataParameters2",
            "dataParameters3",
            "dataQualityInfo",
            "dataQualityInfo2",
            "datasetUri",
            "descriptiveKeywords",
            "descriptiveKeywords2",
            "descriptiveKeywords3",
            "distributionInfo",
            "environmentDescription",
            "environmentDescription2",
            "extent",
            "extent2",
            "hierarchyLevel",
            "hierarchyLevel2",
            "metadataConstraints",
            "metadataContact",
            "metadataLinkage",
            "metadataMaintenance",
            "metadataMaintenance2",
            "onlineResource",
            "pointOfContact",
            "prodSubstitutions",
            "resourceConstraints",
            "resourceFormat",
            "resourceMaintenance",
            "samplingFrequency",
            "spatialRepresentationType",
            "spatialResolution",
            "spatialResolution2",
            "temporalExtent"
    })
    public void testAcquisitionInformationMapping(String test) {
        testRunner.run(test);
    }

}
