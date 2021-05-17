package au.org.emii.xsl;

import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.io.WKTWriter;
import org.apache.log4j.Logger;
import org.fao.geonet.constants.Geonet;
import org.geotools.geometry.jts.JTS;
import org.geotools.gml3.GMLConfiguration;
import org.geotools.referencing.CRS;
import org.geotools.referencing.crs.DefaultGeographicCRS;
import org.geotools.xml.Parser;

import org.opengis.referencing.crs.CoordinateReferenceSystem;
import org.opengis.referencing.operation.MathTransform;

import java.io.StringReader;


/**
 * Utility class for converting GML to WKT
 *
 * Handles both the old style of namespacing gml used by iso19139 and mcp (http://www.opengis.net/gml)
 * and the new style of namespacing used by 19115-3 (http://www.opengis.net/gml/3.2) - better
 * because it includes the version
 *
 * Both namespaces refer to gml 3.2 but require different parsers due to namespacing
 */

public class GmlWktConverter {
    private static Logger logger = Logger.getLogger(GmlWktConverter.class);

    private static final String GML32_NAMESPACE_URI = Geonet.Namespaces.GML32.getURI();

    /**
     * Returns a WKT representation of the passed GML string
     *
     * @param  gml a geometry encoded as gml
     * @return wkt representation of the passed gml geometry in WGS 84
     */
    static public String gmlToWkt(String gml) {
        try {
            /* parse provide gml */
            Parser parser = getParser(gml);
            Geometry geom = (Geometry) parser.parse(new StringReader(gml));
            /* convert to WGS84 if not already WGS84 */
            Geometry wgs84Geom = toWgs84(geom);
            /* 	write WKT */
            WKTWriter writer = new WKTWriter();
            return writer.write(wgs84Geom);
        } catch (Exception e) {
            logger.error("Could not parse " + gml + " " + e.getMessage());
            return ""; // xsl friendly return value in the event of an error
        }
    }

    /* Return required parser for gml based on presence of http://www.opengis.net/gml/3.2 namespace */

    private static Parser getParser(String gml) {
        Parser parser;
        if (gml.contains(GML32_NAMESPACE_URI)) {
            /* use a http://www.opengis.net/gml/3.2 parser */
            parser = new Parser(new org.geotools.gml3.v3_2.GMLConfiguration());
        } else {
            /* use a http://www.opengis.net/gml parser */
            parser = new Parser(new GMLConfiguration());
        }
        parser.setStrict(false);
        parser.setValidating(false);
        return parser;
    }

    /* Convert geometry to WGS 84 if not already WGS 84 */

    static private Geometry toWgs84(Geometry geom) throws Exception {
        // Return input geometry if CRS isn't available
        if (!(geom.getUserData() instanceof CoordinateReferenceSystem)) return geom;

        CoordinateReferenceSystem sourceCrs = (CoordinateReferenceSystem) geom.getUserData();

        // Return the input geometry if input geometry's CRS is already WGS84
        if (CRS.equalsIgnoreMetadata(sourceCrs, DefaultGeographicCRS.WGS84)) return geom;

        // Otherwise return input geometry transformed to WGS84 CRS
        MathTransform tform = CRS.findMathTransform(sourceCrs, DefaultGeographicCRS.WGS84);
        return JTS.transform(geom, tform);
    }

}
