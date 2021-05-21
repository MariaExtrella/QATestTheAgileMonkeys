Feature: Change the role of one user

Background: 
  * url httpUrl
  
  # Define a function to introduce a sleep in the test
  * def wait = function(pause){ java.lang.Thread.sleep(pause) }  
  

  Scenario: Change the role of a user
    # The query is read from a *.graphql file
    * def queryChangeUserRole = read('ChangeUserRole.graphql') 
	 
  	 Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(queryChangeUserRole)',  variables: '#(userChangeRole)'  } 
  	 When method post
     Then status 200
     # Introduce a pause so the user can be saved before the next test
     * wait(4000)     
     

	 