Feature: Generate a new user

Background: 
  * url httpUrl
  
  # Define a function to introduce a sleep in the test
  * def wait = function(pause){ java.lang.Thread.sleep(pause) }  
  
  Scenario: Save a new User
    # The query is read from a *.graphql file
    * def querySaveUser = read('SaveUser.graphql') 
	 
  	 Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(querySaveUser)',  variables: '#(newUser)'  } 
  	 When method post
     Then status 200
     # Introduce a pause so the user can be saved before the next test
     * wait(4000)     
         
     # if the response status is not 200, the test finish
     * if (responseStatus != 200) karate.abort()   

