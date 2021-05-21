Feature: Delete a customer 

Background: 
  * url httpUrl
  
  # Define a function to introduce a sleep in the test
  * def wait = function(pause){ java.lang.Thread.sleep(pause) }  
  
  Scenario: Delete a customer
    # The query is read from a *.graphql file
    * def queryDeleteCustomer = read('DeleteCustomer.graphql') 
	 
  	 Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(queryDeleteCustomer)',  variables: '#(customerDelete)'  } 
  	 When method post
     Then status 200
     # Introduce a pause so the customer can be delete before the next test
     * wait(4000)     
         
     # if the response status is not 200, the test finish
     * if (responseStatus != 200) karate.abort()   
     
     # If the customer was delete, the response shouldn't contain a field "error"
     And match response.errors == '#notpresent' 
    
    