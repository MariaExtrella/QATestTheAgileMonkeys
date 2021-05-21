Feature: Generate and save new customers

Background: 
  * url httpUrl
  
  # Define a function to introduce a sleep in the test
  * def wait = function(pause){ java.lang.Thread.sleep(pause) }  
  
  # Define a function to generate Customers 
  * def generatorCustomer = function(i){ if (i == 3) return null; return { idCust: 'Cust' + i, nameCust: 'Cutomer Name', surnameCust: 'Customer Surname', photoCust: 'photo.jpg' } }  
  
  Scenario Outline: Save a new Customer
    # The query is read from a *.graphql file
    * def querySaveCustomer = read('SaveCustomer.graphql') 
    
    # The body of the graphql request is a JSON with the generated values
    * def newCust = 
	 """
	 { 
	 	"id": "#(idCust)", 
	 	"name": "#(nameCust)", 
	 	"surname": "#(surnameCust)",
	 	"photo": "#(photoCust)"
	 }
	 """
	 
  	 Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken
  	 
  	 And request { query: '#(querySaveCustomer)',  variables: '#(newCust)'  } 
  	 When method post
     Then status 200
     # Introduce a pause so the customer can be saved before the next test
     * wait(4000)     
         
     # if the response status is not 200, the test finish
     * if (responseStatus != 200) karate.abort()   
     
     # If the customer is saved, the response shouldn't contain a field "error"
     And match response.errors == '#notpresent' 
     Examples:
    | generatorCustomer |	 