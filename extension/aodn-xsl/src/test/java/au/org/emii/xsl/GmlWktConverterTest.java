package au.org.emii.xsl;

import static org.junit.Assert.*;

import org.fao.geonet.constants.Geonet;
import org.junit.Test;

public class GmlWktConverterTest {

    private static final String GML_NAMESPACE_URI = Geonet.Namespaces.GML.getURI();
    private static final String GML32_NAMESPACE_URI = Geonet.Namespaces.GML32.getURI();

    private static final String GML_INPUT_TEMPLATE = "<gml:Polygon  xmlns:gml=\"%s\" srsName=\"CRS:84\">" +
        "<gml:exterior>" +
        "<gml:LinearRing>" +
        "<gml:posList srsDimension=\"2\">146 -42 146 -41 145 -41 145 -40 144 -40 144 -39 144 -38 144 -37 145 -37 145 -38 146 -38 146 -39 146 -40 147 -40 147 -41 147 -42 146 -42</gml:posList>" +
        "</gml:LinearRing>" +
        "</gml:exterior>" +
        "</gml:Polygon>";

    private static final String EXPECTED_WKT =
        "POLYGON ((146 -42, 146 -41, 145 -41, 145 -40, 144 -40, 144 -39, 144 -38, 144 -37, 145 -37, 145 -38, 146 -38, 146 -39, 146 -40, 147 -40, 147 -41, 147 -42, 146 -42))";

//    @Test
//    public void testConvertGmlWithGmlNamespaceToWkt() {
//        String gml21 = String.format(GML_INPUT_TEMPLATE, GML_NAMESPACE_URI);
//        String wkt = GmlWktConverter.gmlToWkt(gml21);
//        assertEquals(EXPECTED_WKT, wkt);
//    }
//
//    @Test
//    public void testConvertGmlWithGml32NamespaceToWkt() {
//        String gml32 = String.format(GML_INPUT_TEMPLATE, GML32_NAMESPACE_URI);
//        String wkt = GmlWktConverter.gmlToWkt(gml32);
//        assertEquals(EXPECTED_WKT, wkt);
//    }

}
