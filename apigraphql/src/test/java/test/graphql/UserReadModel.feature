Feature: List a user by Id of the graphql API

Background: 
  * url httpUrl
  
  Scenario: List a user by id
    # The query is read from a *.graphql file
    * def queryUserReadModel = read('UserReadModel.graphql')
    
     Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(queryUserReadModel)', variables: '#(id)'} 
  	 When method post
     Then status 200

     # if the response status is not 200, the test finish
     * if (responseStatus != 200) karate.abort()   
