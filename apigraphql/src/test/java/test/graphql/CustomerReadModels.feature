Feature: List all the customers created by users in the graphql API

Background: 
  * url httpUrl
  
  Scenario: List the customers
    # The query is read from a *.graphql file
    * def queryCustomerReadModels = read('CustomerReadModels.graphql')
    
     Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(queryCustomerReadModels)'} 
  	 When method post
     Then status 200

     # if the response status is not 200, the test finish
     * if (responseStatus != 200) karate.abort()   
     
     # Check that the query doesn't fail
     * match response.errors == '#notpresent' 
      
	 # Print the response
	 * print response.data.CustomerReadModels
	 * match response.data.CustomerReadModels contains {id: '#ignore', name: '#ignore', surname: '#ignore', photoUrl: '#ignore', userId: '#ignore' }