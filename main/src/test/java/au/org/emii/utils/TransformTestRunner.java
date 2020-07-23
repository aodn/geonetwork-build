package au.org.emii.utils;

import net.sf.saxon.s9api.*;
import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import suggestions.AddMissingParametersAndPlatformsTest;

import javax.xml.transform.stream.StreamSource;
import java.io.ByteArrayOutputStream;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Path;
import java.nio.file.Paths;

public class TransformTestRunner {
    private final String xslFile;
    private final String testDir;

    public TransformTestRunner(String xslFile, String testDir) {
        this.xslFile = xslFile;
        this.testDir = testDir;
    }

    public void run(String testName) {
        Path xslFilePath = getPathFromResources(xslFile);
        Path testDirPath = getPathFromResources(testDir).resolve(testName);
        Path inputFile = testDirPath.resolve("metadata.xml");
        Path expectedFile = testDirPath.resolve("expected.xml");
        try {
            String result = runTransform(xslFilePath, inputFile);
            String expected = FileUtils.readFileToString(expectedFile.toFile());
            Assert.assertEquals(expected, result);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Path getPathFromResources(String fileName) {
        ClassLoader classLoader = TransformTestRunner.class.getClassLoader();
        URL resource = classLoader.getResource(fileName);

        if (resource == null) {
            throw new IllegalArgumentException("file is not found!");
        }

        try {
            return Paths.get(resource.toURI());
        } catch (URISyntaxException e) {
            throw new IllegalArgumentException("file is invalid", e);
        }
    }

    public String runTransform(Path xslFile, Path inputFile) throws SaxonApiException {
        Processor processor = new Processor(false);
        XsltCompiler compiler = processor.newXsltCompiler();
        XsltExecutable stylesheet = compiler.compile(new StreamSource(xslFile.toFile()));
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        Serializer out = processor.newSerializer(stream);
        Xslt30Transformer transformer = stylesheet.load30();
        transformer.transform(new StreamSource(inputFile.toFile()), out);
        return stream.toString();
    }

}