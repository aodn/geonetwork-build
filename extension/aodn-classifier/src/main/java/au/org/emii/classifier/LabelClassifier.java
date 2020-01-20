package au.org.emii.classifier;

import org.apache.log4j.Logger;
import org.apache.lucene.facet.taxonomy.CategoryPath;
import org.fao.geonet.kernel.ThesaurusFinder;
import org.fao.geonet.kernel.search.classifier.Classifier;
import org.fao.geonet.kernel.search.facet.CategoryHelper;

import java.util.ArrayList;
import java.util.List;

/**
 * This class is used to determine the category paths (facets) to be indexed for an AODN term given its prefLabel or atlLabel
 */

public class LabelClassifier implements Classifier {
    private static Logger logger = Logger.getLogger(LabelClassifier.class);

    private final ThesaurusFinder thesaurusFinder; // thesaurus finder
    private final String vocabularyScheme; // vocabulary in which the term is defined
    private final String classificationScheme; // classifier used to create CategoryPaths for a term
    private final String indexKey; // classifier indexKey

    public LabelClassifier(ThesaurusFinder thesaurusFinder, String vocabularyScheme, String classificationScheme, String indexKey) {
        this.thesaurusFinder = thesaurusFinder;
        this.vocabularyScheme = vocabularyScheme;
        this.classificationScheme = classificationScheme;
        this.indexKey = indexKey;
    }

    public List<CategoryPath> classify(String value) {
        // If value is a piped value, e.g. first|second|third, iterate through and classify each term.
        if(value.indexOf('|') > -1){
            List<CategoryPath> categories = new ArrayList<CategoryPath>();

            for (String term: value.split("\\|")) {
                List<CategoryPath> cp = lookupCategoryPaths(term);
                // If the first item did not yield a category path return empty path (matches original behaviour)
                if(categories.isEmpty() && cp.isEmpty()){
                    logger.warn("Could not find category path as there is no matching term for first item in path.");
                    return cp;
                }
                if(cp.isEmpty()){
                    // For each CategoryPath in categories loop through and add the piped paths
                    List<CategoryPath> newCp = new ArrayList<CategoryPath>();
                    for (CategoryPath innerCP: categories) {
                        newCp.add(CategoryHelper.addSubCategory(innerCP, term));
                    }
                    categories = newCp;
                } else {
                    categories.addAll(cp);
                }
            }
            return categories;
        }

        return lookupCategoryPaths(value);
    }

    private List<CategoryPath> lookupCategoryPaths(String value) {
        AodnThesaurus vocabularyThesaurus = new AodnThesaurus(thesaurusFinder.getThesaurusByConceptScheme(vocabularyScheme));
        AodnThesaurus classificationThesaurus = new AodnThesaurus(thesaurusFinder.getThesaurusByConceptScheme(classificationScheme));
        AodnTermClassifier termClassifier = new AodnTermClassifier(vocabularyThesaurus, classificationThesaurus);

        List<AodnTerm> matchingTerms = vocabularyThesaurus.getTermWithLabel(value);

        if (matchingTerms.isEmpty()) {
            logger.warn(String.format("Could not find term with label='%s' in vocabulary='%s' discoveryParams='%s=%s'",
                    value, vocabularyThesaurus.getThesaurusTitle(), indexKey, value));
            return new ArrayList<CategoryPath>();
        }

        AodnTerm term = getBestMatch(matchingTerms, value);

        return termClassifier.classify(term);
    }

    private AodnTerm getBestMatch(List<AodnTerm> matchingTerms, String label) {
        // If there's only one return that

        if (matchingTerms.size() == 1) {
            return matchingTerms.get(0);
        }

        // Otherwise, return any term found which has not been replaced by another term

        for (AodnTerm aodnTerm: matchingTerms) {
            if (aodnTerm.getReplaces() != null && aodnTerm.getReplacedBy() == null) {
                return aodnTerm;
            }
        }

        // Otherwise, log a warning and return the first

        AodnTerm term = matchingTerms.get(0);

        logger.warn("Multiple matching terms found for '" + label + "' in '"
                + vocabularyScheme + "' returning '" + term.getPrefLabel() + "'");

        return term;

    }
}
