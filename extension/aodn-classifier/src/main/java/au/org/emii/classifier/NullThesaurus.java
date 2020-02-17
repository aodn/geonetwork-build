package au.org.emii.classifier;

import org.apache.log4j.Logger;
import org.fao.geonet.kernel.rdf.Query;
import org.openrdf.sesame.config.AccessDeniedException;
import org.openrdf.sesame.query.MalformedQueryException;
import org.openrdf.sesame.query.QueryEvaluationException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class NullThesaurus implements IAodnThesaurus {

    @Override
    public String getThesaurusTitle() {
        return "No title found. Missing thesaurus.";
    }

    @Override
    public List<AodnTerm> getTerms(Query<AodnTerm> query) {
        return new ArrayList<AodnTerm>();
    }

    @Override
    public List<String> getAltLabels(String uri) throws IOException, MalformedQueryException, QueryEvaluationException, AccessDeniedException {
        return new ArrayList<String>();
    }

    @Override
    public List<AodnTerm> getTermWithLabel(String label) {
        return new ArrayList<AodnTerm>();
    }

    @Override
    public boolean hasRelatedTerms(AodnTerm aodnTerm, SkosRelation relation) {
        return false;
    }

    @Override
    public List<AodnTerm> getRelatedTerms(AodnTerm aodnTerm, SkosRelation relationshipType) {
        return new ArrayList<AodnTerm>();
    }

    @Override
    public AodnTerm getTerm(String value) {
        return null;
    }

}
