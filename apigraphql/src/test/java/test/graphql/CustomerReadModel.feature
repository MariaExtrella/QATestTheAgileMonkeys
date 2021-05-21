Feature: List a customer by Id of the graphql API

Background: 
  * url httpUrl
  
  Scenario: List a customer by id
    # The query is read from a *.graphql file
    * def queryCustomerReadModel = read('CustomerReadModel.graphql')
    
     Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(queryCustomerReadModel)', variables: '#(id_Customer)'} 
  	 When method post
     Then status 200

     # if the response status is not 200, the test finish
     * if (responseStatus != 200) karate.abort()   
     
     # Check that the query doesn't fail
     * match response.errors == '#notpresent' 
      
	 # Print the response
	 * print response.data.CustomerReadModel