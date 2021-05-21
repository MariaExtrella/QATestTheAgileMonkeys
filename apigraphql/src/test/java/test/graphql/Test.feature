Feature: Test the graphql API for admin and not admin users 

Background: 
  * url httpUrl
  
  Scenario: Test if the API met the acceptance criteria for users admin
    * def testResuls = call read('TestAdmin.feature')
    
  Scenario: Test if the API met the acceptance criteria for users not admin
    * def testResults = call read('TestNotAdmin.feature')  
    
  Scenario: Test if the API met the acceptance criteria in wrong cases
    * def testResults = call read('TestFailures.feature')