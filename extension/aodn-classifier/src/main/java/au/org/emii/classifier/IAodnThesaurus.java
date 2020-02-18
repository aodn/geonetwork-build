package au.org.emii.classifier;

import org.fao.geonet.kernel.rdf.Query;
import org.openrdf.sesame.config.AccessDeniedException;
import org.openrdf.sesame.query.MalformedQueryException;
import org.openrdf.sesame.query.QueryEvaluationException;

import java.io.IOException;
import java.util.List;

public interface IAodnThesaurus {

    String getThesaurusTitle();
    List<AodnTerm> getTerms(Query<AodnTerm> query);
    List<String> getAltLabels(String uri) throws IOException, MalformedQueryException, QueryEvaluationException, AccessDeniedException;
    List<AodnTerm> getTermWithLabel(String label);
    boolean hasRelatedTerms(AodnTerm aodnTerm, SkosRelation relation);
    List<AodnTerm> getRelatedTerms(AodnTerm aodnTerm, SkosRelation relationshipType);
    AodnTerm getTerm(String value);

}
