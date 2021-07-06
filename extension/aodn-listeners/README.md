### AODN Listeners

This maven project contains AODN listeners used to log
[GeoNetwork metadata events](https://geonetwork-opensource.org/manuals/3.10.x/en/tutorials/hookcustomizations/events/index.html).

This was added for an extra measure of protection when performing the catalogue-imos upgrade to ensure
any changes made after go-live were captured.  In theory, they could be used to record changes that were made
post go-live in case they were required to rollback and replay changes and for audit purposes
(e.g. for determining when change was made and by who).
