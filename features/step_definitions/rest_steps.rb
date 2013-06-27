require 'net/http'
require 'open-uri'
require 'rest_client'


statusCode = "";
xmlData = "";
parsedData = "";
root = "";
var1 = ""
urlPostData = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><events><event consolidationName="NAGIOSEVENT" monitorServer="locahost" monitorStatus="UP" service="local_load" appType="NAGIOS" device="127.0.0.1" severity="SERIOUS" textMessage="This is a serious Nagios Message on Device 127.0.0.1" operationStatus="OPEN" host="localhost" reportDate="2013-06-02T10:55:32.943" errorType="MyError" component="MySubComponent"> <properties><property name="Latency" value="125.1"/> <property name="UpdatedBy" value="UnitTester"/> <property name="Comments" value="This is a test."/> </properties> </event> </events>'

 

Given /^the Rest API is to be tested$/ do

end 

When /^the client requests GET "(.*)" then expected xml data should be "(.*)"$/ do |path, expected_xmldata|

	io = open(path) 
	status = io.status	
	statusCode = status[0]
	res = RestClient.get(path){ |response, request, result, &block|
								case response.code
										 when 200
									  p "It worked status 200!"
								    response
									  when 423
								   raise SomeCustomExceptionIfYouWant
								 else
									response.return!(request, result, &block)
								end
							    }
	xmlData = res.body
   
	
	if xmlData == expected_xmldata
    puts "\nXML Verified"
	else
	puts "\nXML Data Not Verified"
	end
	end


When /^the client requests POST "(.*)" then expected xml data should be "(.*)"$/ do |path, expected_xmldata|

	io = open(path) 
	status = io.status	
	statusCode = status[0]
	res = RestClient.post path, urlPostData, :content_type => 'xml'
	xmlData = res.body
 	if xmlData == expected_xmldata
    puts "\nXML Verified"
	else
	puts "\nXML Data Not Verified"
	end	
end

Then /^response should be "(.*)"$/ do |status|
	
	if status == statusCode
		puts "\nResponse OK"
	else
		puts "\nResponse ERROR"
end
	
end


When /^the client requests PUT "(.*)" and expected xml data "(.*)"$/ do |path, expected_xmldata|

	res = RestClient.put path, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><events><event consolidationName="NAGIOSEVENT" monitorServer="locahost" monitorStatus="UP" service="local_load" appType="NAGIOS" device="127.0.0.1" severity="SERIOUS" textMessage="This is a serious Nagios Message on Device 127.0.0.1" operationStatus="OPEN" host="localhost" reportDate="2013-06-02T10:55:32.943" errorType="MyError" component="MySubComponent"> <properties> <property name="Latency" value="125.31"/> <property name="UpdatedBy" value="UnitTester"/> <property name="Comments" value="This is a test."/> </properties> </event> </events>', :content_type => 'xml' 

	xmlData = res.body
	if xmlData == expected_xmldata
    puts "\nXML Verified"
	else
	puts "\nXML Data Not Verified"
	end	
	
   end 

Then /^response code for PUT should be "(.*)","(.*)"$/ do |path,status|
    io = open(path) 
	status = io.status	
	statusCode = status[0]
	
	if status == statusCode
		puts "\nResponse OK"
	else
		puts "\nResponse ERROR"
end
	
end
	
  
When /^the client requests DELETE "(.*)" then expected xml data should be "(.*)"$/ do |path, expected_xmldata|

	res = RestClient.delete path
	xmlData = res.body
	if xmlData == expected_xmldata
    puts "\nXML Verified"
	else
	puts "\nXML Data Not Verified"
	end	
end 









