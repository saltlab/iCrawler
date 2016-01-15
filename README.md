iCrawler
========
iCrawler automatically navigates native iPhone apps and reverse engineers a model of their user interface states. 


Paper
-----

The technique behind iCrawler is published as a research paper at WCRE 2012. It is titled <a href="http://ece.ubc.ca/~amesbah/docs/wcre12.pdf">Reverse Engineering iOS Mobile Applications</a> and is available as a PDF. 


Usage
-----

Add the `iCrawler` class files to your project, add the QuartzCore framework if needed.  To start:

    [window makeKeyAndDisplay]
    
    // always call after makeKeyAndDisplay.
    [[ICrawlerController sharedICrawler] start];
    



