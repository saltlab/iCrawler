iCrawler
========
We presented our reverse engineering technique to automatically navigate a given iPhone application and infer a model of its user interface states. We implemented our approach in iCrawler, which is capable of exercising and analyzing UI changes and generate a state model of an iPhone application.



Usage
-----

Add the `iCrawler` class files to your project, add the QuartzCore framework if needed.  To start:

    [window makeKeyAndDisplay]
    
    // always call after makeKeyAndDisplay.
    [[ICrawlerController sharedICrawler] start];
    

A a demo app is included to test it out n the Applications folder.

