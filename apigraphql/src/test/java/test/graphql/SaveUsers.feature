Feature: Generate and save new users

Background: 
  * url httpUrl
  
  # Define a function to introduce a sleep in the test
  * def wait = function(pause){ java.lang.Thread.sleep(pause) }  
  
  # Define a function to generate Users  
  * def generatorUser = function(i){ if (i == 3) return null; return { username: 'username' + i + '@test.com', password: 'Password_1', role: 'User' } }  
  
  Scenario Outline: Save a new User
    # The query is read from a *.graphql file
    * def querySaveUser = read('SaveUser.graphql') 
    
    # The body of the graphql request is a JSON with the generated values
    * def newUser = 
	 """
	 { 
	 	"username": "#(username)", 
	 	"password": "#(password)", 
	 	"role": "#(role)"
	 }
	 """
	 
  	 Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(querySaveUser)',  variables: '#(newUser)'  } 
  	 When method post
     Then status 200
     # Introduce a pause so the user can be saved before the next test
     * wait(4000)     
         
     # if the response status is not 200, the test finish
     * if (responseStatus != 200) karate.abort()   

     Examples:
    | generatorUser |	 