Feature: Rest API
  In order to test various Rest APIs
  As a tester
  I want to test basic functionality and XML data verification


Scenario Outline: GET Method
Given the Rest API is to be tested
When the client requests GET "<URL>" then expected xml data should be "<xmldata>"

 Examples:
    |  URL | xmldata|
    | http://qa-rh6-64-2/foundation-webapp/api/hosts/localhost | <?xml version="1.0" encoding="UTF-8" standalone="yes"?><host hostName="localhost" description="localhost" monitorStatus="UP" appType="NAGIOS" deviceName="127.0.0.1" lastCheckTime="2013-06-21T01:41:23-07:00" bubbleUpStatus="UP" serviceAvailability="9.52" acknowledged="false"/> |
	| http://qa-rh6-64-2//foundation-webapp/api/events/12 | <?xml version="1.0" encoding="UTF-8" standalone="yes"?><events><event id="12" device="127.0.0.1" host="localhost" service="local_mem_nagios" operationStatus="OPEN" monitorStatus="OK" severity="OK" applicationSeverity="OK" component="OK" priority="Lowest Priority in a scale from 1 -10" typeRule="UNDEFINED" textMessage="OK - total %MEM for process nagios : 0.0" firstInsertDate="2013-06-17T05:49:48-07:00" lastInsertDate="2013-06-17T05:49:48-07:00" reportDate="2013-06-17T05:50:10.125-07:00" msgCount="1" appType="NAGIOS"><properties><property name="ErrorType" value="SERVICE ALERT"/><property name="SubComponent" value="localhost:local_mem_nagios"/></properties></event></events> |


Scenario Outline: POST Method
Given the Rest API is to be tested
When the client requests POST "<URL>" then expected xml data should be "<xmldata>"
Then response should be "200"

 Examples:
    |  URL | xmldata|
    | http://qa-rh6-64-2//foundation-webapp/api/events/ | <?xml version="1.0" encoding="UTF-8" standalone="yes"?><results successful="1" failed="0" entityType="Event" operation="Update" warning="0" count="1"><result><entity>313</entity><location>http://qa-rh6-64-2/foundation-webapp/api/events/313</location><status>success</status></result></results>|
	

Scenario Outline: PUT Method
Given the Rest API is to be tested
When the client requests PUT "<URL>" and expected xml data "<xmldata>"

 Examples:
     |  URL | xmldata|
     | http://qa-rh6-64-2/foundation-webapp/api/events/50,51,52?opStatus=NOTIFIED | <?xml version="1.0" encoding="UTF-8" standalone="yes"?><results successful="3" failed="0" entityType="Event" operation="Update" warning="0" count="3"><result><entity>50</entity><location>http://qa-rh6-64-2/foundation-webapp/api/events/50</location><status>success</status></result><result><entity>51</entity><location>http://qa-rh6-64-2/foundation-webapp/api/events/51</location><status>success</status></result><result><entity>52</entity><location>http://qa-rh6-64-2/foundation-webapp/api/events/52</location><status>success</status></result></results> |

		 
Scenario Outline: DELETE Method
Given the Rest API is to be tested
When the client requests DELETE "<URL>" then expected xml data should be "<xmldata>"

 Examples:
     |  URL | xmldata|
     | http://qa-rh6-64-2//foundation-webapp/api/events/56 | <?xml version="1.0" encoding="UTF-8" standalone="yes"?><results successful="1" failed="0" entityType="Event" operation="Update" warning="0" count="1"><result><entity>56</entity><location>http://qa-rh6-64-2/foundation-webapp/api/events/56</location><status>success</status></result></results> |


	 