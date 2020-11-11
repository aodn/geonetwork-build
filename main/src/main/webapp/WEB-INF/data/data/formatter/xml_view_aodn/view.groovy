import groovy.xml.XmlUtil

handlers.add {true} { el ->
    def out = new StringWriter()
    new XmlNodePrinter(new PrintWriter(out)).print(new XmlParser().parseText(XmlUtil.serialize(el)))
    def xmlString = XmlUtil.escapeXml(out.toString())
    """
 <pre>
  <code class='html'>
  $xmlString
  </code>
 </pre>
"""
}
