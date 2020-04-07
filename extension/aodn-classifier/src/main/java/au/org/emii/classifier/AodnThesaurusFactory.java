package au.org.emii.classifier;

import org.apache.log4j.Logger;
import org.fao.geonet.kernel.Thesaurus;
import org.fao.geonet.kernel.ThesaurusFinder;

public class AodnThesaurusFactory {

    private static Logger logger = Logger.getLogger(AodnThesaurusFactory.class);
    private static ThesaurusFinder thesaurusFinder;

    public AodnThesaurusFactory(ThesaurusFinder thesaurusFinder) {
        this.thesaurusFinder = thesaurusFinder;
    }

    public IAodnThesaurus findThesaurus(String scheme) {

        Thesaurus thesaurus = thesaurusFinder.getThesaurusByConceptScheme(scheme);
        if (thesaurus == null) {
            logger.warn(String.format("Thesaurus not found for scheme='%s'", scheme));
            return new NullThesaurus();
        } else {
            return new AodnTermsThesaurus(thesaurus);
        }

    }

}
