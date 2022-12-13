/*
 * Copyright 2004 - 2012 Mirko Nasato and contributors
 *           2016 - 2020 Simon Braconnier and contributors
 *
 * This file is part of JODConverter - Java OpenDocument Converter.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.jodconverter.sample.webapp;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Objects;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.jodconverter.core.DocumentConverter;
import org.jodconverter.core.util.FileUtils;

/** Converter servlet. */
@WebServlet(urlPatterns = { "/convert-to/pdf", "/converted/document.pdf" })
@MultipartConfig(location="/tmp") //, maxFileSize=5242880)
public class ConverterServlet extends HttpServlet {

  private static final long serialVersionUID = -591469426224201748L;
  private static final Logger LOGGER = LoggerFactory.getLogger(ConverterServlet.class);

  @Override
  public void init() {
    LOGGER.info("Servlet {} has started", this.getServletName());
  }

  @Override
  public void destroy() {
    LOGGER.info("Servlet {} has stopped", this.getServletName());
  }

  @Override
  protected void doPost(final HttpServletRequest request, final HttpServletResponse response)
      throws ServletException, IOException {
	request.getParts().stream()
		.filter(p -> p.getSubmittedFileName() != null)
		.forEach(p -> {
	    	System.out.println(String.format(
	    			"ConverterServlet.doPost: Part => name=[%s],file=[%s],type=[%s]",
	    			p.getName(), p.getSubmittedFileName(), p.getContentType()));
			try {
				convert(request, response, p);
			} catch (IOException | ServletException e) {
				e.printStackTrace();
			}
		});
  }
  
  private boolean convert(final HttpServletRequest request
		  , final HttpServletResponse response
		  , final Part uploadedFile)
		  throws IOException, ServletException {
	  boolean rc = false;

	final WebappContext webappContext = WebappContext.get(getServletContext());
    final String inputExtension = FileUtils.getExtension(uploadedFile.getSubmittedFileName());

    final String baseName = Objects.requireNonNull(FileUtils.getBaseName(uploadedFile.getSubmittedFileName()));
    final File inputFile = File.createTempFile(baseName, "." + inputExtension);
    FileUtils.deleteQuietly(inputFile);
    writeUploadedFile(uploadedFile, inputFile);

    final String outputExtension =
        Objects.requireNonNull(
        		FileUtils.getExtension(request.getRequestURI()).isEmpty() ?
                FileUtils.getBaseName(request.getRequestURI()) :
                FileUtils.getExtension(request.getRequestURI())
        		);
    final File outputFile = File.createTempFile(baseName, "." + outputExtension);
    FileUtils.deleteQuietly(outputFile);
    try {
      final DocumentConverter converter = webappContext.getDocumentConverter();
      final long startTime = System.currentTimeMillis();
      converter.convert(inputFile).to(outputFile).execute();
      if (LOGGER.isInfoEnabled()) {
        LOGGER.info(
            String.format(
                "Successful conversion: %s [%db] to %s in %dms",
                inputExtension,
                inputFile.length(),
                outputExtension,
                System.currentTimeMillis() - startTime));
      }
      response.setContentType(
          Objects.requireNonNull(
                  converter.getFormatRegistry().getFormatByExtension(outputExtension))
              .getMediaType());
      response.setHeader(
          "Content-Disposition", "attachment; filename=" + baseName + "." + outputExtension);
      sendFile(outputFile, response);
      rc = true;
    } catch (Exception exception) {
      LOGGER.error(
          String.format(
              "Failed conversion: %s [%db] to %s; %s; input file: %s",
              inputExtension, inputFile.length(), outputExtension, exception, inputFile.getName()));
      throw new ServletException("Conversion failed", exception);
    } finally {
      FileUtils.deleteQuietly(outputFile);
      FileUtils.deleteQuietly(inputFile);
    }
    return rc;
  }

  private void sendFile(final File file, final HttpServletResponse response) throws IOException {
    response.setContentLength((int) file.length());
    Files.copy(file.toPath(), response.getOutputStream());
  }

  private void writeUploadedFile(final Part uploadedFile, final File destinationFile)
      throws ServletException {
    try {
        uploadedFile.write(destinationFile.getAbsolutePath());
    } catch (Exception exception) {
      throw new ServletException("Error writing uploaded file", exception);
    }
    try {
    	uploadedFile.delete();
    } catch (Exception exception) {
        throw new ServletException("Error deleting uploaded file", exception);
    }
  }
}
