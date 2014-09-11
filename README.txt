= teamwork

== DESCRIPTION:

A gem wrapper for the TeamworkPM API

TeamworkPM: http://www.teamworkpm.net/
API: http://developer.teamworkpm.net/api

== REQUIREMENTS:

    ruby 2.x

== INSTALL:

    gem install teamwork

== API EXAMPLES:

    require 'teamwork'
    
    api = Teamwork::API.new project_name: 'your-site-name', api_key: 'your-api-key'

    api.people pageSize: 100
    api.people pageSize: 100, page: 2

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.


