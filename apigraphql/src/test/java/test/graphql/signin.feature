Feature: Get a token for the user to sign in the API

  Background: Get the environment global variable
    * url httpUrl

  Scenario: obtain a token for the admin user
 	* def query = 
	""" 
	{
  		"clientId": "#(clientId)",
        "username": "#(username)",
  		"password": "#(password)"
	}
    """
 	* print query

    Given path '/auth/sign-in'
    And request query
    And header Content-Type = 'application/json'
    When method post
    Then status 200
	
	#Get the idToken for the user
    * def tokenid = response.idToken
    * print tokenid