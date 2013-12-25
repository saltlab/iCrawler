iCrawler
========
iCrawler automatically navigates native iPhone apps and reverse engineers a model of their user interface states. 



Usage
-----

Add the `iCrawler` class files to your project, add the QuartzCore framework if needed.  To start:

    [window makeKeyAndDisplay]
    
    // always call after makeKeyAndDisplay.
    [[ICrawlerController sharedICrawler] start];
    



