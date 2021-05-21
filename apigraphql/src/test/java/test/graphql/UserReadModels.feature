Feature: List all the users of the graphql API

Background: 
  * url httpUrl
  
  Scenario: List the users
    # The query is read from a *.graphql file
    * def queryUserReadModels = read('UserReadModels.graphql')
    
     Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(queryUserReadModels)'} 
  	 When method post
     Then status 200

     # if the response status is not 200, the test finish
     * if (responseStatus != 200) karate.abort()   
