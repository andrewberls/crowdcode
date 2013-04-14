# CrowdCode

CrowdCode is a platform for crowdsourced code reviews. Ever wanted strangers on the Internet to tell you why your code sucks?
CrowdCode is the perfect tool for you. Our goal is to create a full-featured Q&A-style tool for developers to get feedback,
explore others' code, contribute to discussions, and pick up some neat tricks along the way. For now, the app is still very much a work in progress,
but the foundations are in place.

Some of what's been done so far:
* Platform authentication with GitHub and native accounts
* Votes stored in Redis
* Full-text search with Sunspot/Solr
* Tagging with autocompletion
* Ajax comments

Some of what's to be done:
* Code detection and highlighting
* Main dashboard view
* Better tag integration - 'suggested for you: ...' 


## Running a local copy
If you want to hack on the project, here's what you'll need to do to get a copy up and running. 
You'll need a local install of [Redis](http://redis.io/)

```
git clone https://github.com/andrewberls/crowdcode.git
cd crowdcode/
bundle install
rake db:migrate
redis-server
rake sunspot:solr:start
rails server
```


CrowdCode is brought to you by [Andrew Berls](https://github.com/andrewberls) and [Pete Cruz](https://github.com/petesta)
