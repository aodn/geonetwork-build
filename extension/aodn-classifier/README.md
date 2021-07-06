### AODN Classifiers

This project contains
[AODN classifiers](https://geonetwork-opensource.org/manuals/trunk/fra/users/customizing-application/configuring-faceted-search.html#configuration)
used to index Portal specific facets.

There are two classifiers included in this extension:

* LabelClassifier - return facets (categories) for a vocabulary term given its label or alternative label
* UriClassifier - return facets (categories) for a vocabulary term given its uri

Both classifiers use the same logic (AodnTermClassifier) to determine facets once the referenced term is found
either by its label/alternate label or its uri.

In summary, broader relationships for the referenced term in the vocabulary thesaurus are followed until the top concept(s) 
in that thesaurus is(are) found.

BroadMatch relationships to terms in the classification scheme for the top concept(s) in the vocabulary thesaurus are then followed.

And, finally broader relationships in the classification scheme thesaurus are then followed to the top concepts in that thesaurus.

All possible routes to top terms in the classification scheme are returned as category paths to be indexed by GeoNetwork. 

### Vocabulary Thesauri

The vocabulary thesaurus defines the terms we use in metadata and their relationships to other terms in that thesaurus.

### Classification Thesaruri

The classification thesaurus defines how terms in the vocabulary thesaurus should be grouped into categories for display as facets in 
the portal. 

### Additional information

Also refer to the [original proposal](https://github.com/geonetwork/core-geonetwork/wiki/201411HierarchicalFacetSupport) for 
more detail on how to write classifiers/what's expected by GeoNetwork.