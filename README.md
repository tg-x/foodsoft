Foodsoft
=========
[![Build Status](https://travis-ci.org/foodcoop-adam/foodsoft.png?branch=master)](https://travis-ci.org/foodcoop-adam/foodsoft)
[![Coverage Status](https://coveralls.io/repos/foodcoop-adam/foodsoft/badge.png?branch=master)](https://coveralls.io/r/foodcoop-adam/foodsoft?branch=master)
[![Code Climate](https://codeclimate.com/github/foodcoop-adam/foodsoft.png)](https://codeclimate.com/github/foodcoop-adam/foodsoft)
[![Dependency Status](https://gemnasium.com/foodcoop-adam/foodsoft.png)](https://gemnasium.com/foodcoop-adam/foodsoft)

Web-based software to manage a non-profit food coop (product catalog, ordering, accounting, job scheduling).

A food cooperative is a group of people that buy food from suppliers of their own choosing. A collective do-it-yourself supermarket. Members  order their products online and collect them on a specified day. And all put in a bit of work to make that possible. Foodsoft facilitates the process.

This branch contains the version we use at [Foodcoop NL](http://www.foodcoop.nl). We track [foodcoops/foodsoft](https://github.com/foodcoops/foodsoft), and merge in some features found in branches of this repository, as well as some local changes.

If you're a food coop considering to use foodsoft, you're welcome to [contact us]. Or look at the [wiki page for foodcoops](https://github.com/foodcoops/foodsoft/wiki/For-foodcoops). When you'd like to experiment with or develop foodsoft, you can read [how to set it up](https://github.com/foodcoop-adam/foodsoft/blob/master/doc/SETUP_DEVELOPMENT.md) on your own computer.

More information about using this software and contributing can be found on [our wiki](https://github.com/foodcoop-adam/foodsoft/wiki), as wel [foodsoft's wiki](https://github.com/foodcoops/foodsoft/wiki).


Developing
----------

Get foodsoft [running locally](https://github.com/foodcoop-adam/foodsoft/blob/master/doc/SETUP_DEVELOPMENT.md),
then visit our [Developing Guidelines](https://github.com/foodcoops/foodsoft/wiki/Developing-Guidelines)
page on the wiki.


Deploying
---------

Setup foodsoft to [run in production](https://github.com/foodcoop-adam/foodsoft/blob/master/doc/SETUP_PRODUCTION.md),
and automate [deployment](https://github.com/foodcoop-adam/foodsoft/blob/master/doc/DEPLOYMENT.md). This section is
very much a work in progress.


Notes specific to this fork
---------------------------

* This fork has enabled some plugins that aren't upstream. To make migration easier, we have included database migrations for these plugins. As a developer, that means: when you add a migration to an enabled plugin, please use `rake railties:install:migrations` and commit to install those in "db/migrate" as well.

* The master branch is a combination of many merges and ad-hoc changes. A new version is being worked on in branch foodcoop-adam-rails4, based on Foodsoft 4.0.0. This is working, but does not yet contain all features present in the master branch. At some point, this branch will be abandoned in favour of foodcoop-adam-rails4.


License
-------

GPL version 3 or later, please see
[LICENSE](https://github.com/foodcoops/foodsoft/blob/master/LICENSE)
for the full text.

