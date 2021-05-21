Feature: Delete a user

Background: 
  * url httpUrl
  
  # Define a function to introduce a sleep in the test
  * def wait = function(pause){ java.lang.Thread.sleep(pause) }  
  
  Scenario: Delete a user
    # The query is read from a *.graphql file
    * def queryDeleteUser = read('DeleteUser.graphql') 
	 
  	 Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(queryDeleteUser)',  variables: '#(usernameDelete)'  } 
  	 When method post
     Then status 200
     # Introduce a pause so the user can be delete before the next test
     * wait(4000)     
         
     # if the response status is not 200, the test finish
     * if (responseStatus != 200) karate.abort()   

    
    