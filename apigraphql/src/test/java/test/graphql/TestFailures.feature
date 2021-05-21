Feature: Test the graphql API for admin and not admin users in wrong cases

Background: 
  * url httpUrl
  
  Scenario: Test if the API met the acceptance criteria for an admin user
    # It is necessary to sign in the API as admin to create a new user
    # Read the admin datas from a *.json file
    * def adminDatas = read('signinDatasUser.json')  
   
    ### Call the feature to sign in the API with the JSON file that contains the admin's datas
    * def signIn = call read('signin.feature') adminDatas
    * print signIn.response
    # The token for the admin user is the input parameter for the callable feature where are defined the steps of the tests    
    * def userToken = signIn.response
        
	### Test to create a user with a wrong password
    * def newUser = 
	 """
	 { 
	 	"username": "userNotAdmin@test.com", 
	 	"password": "Pass", 
	 	"role": "user"
	 }
	 """	    
#    * def saveUser = call read('SaveUser.feature') userToken          
     # Check that the query fail because the password is too short
     * def expected = 
     """
     {
        "message": "Password does not conform to policy: Password not long enough"
     }
     """
#     * match saveUser.response.errors contains deep expected
     
     # Try to create again but with another wrong password
     * def newUser = 
	 """
	 { 
	 	"username": "userNotAdmin@test.com", 
	 	"password": "Password111", 
	 	"role": "User"
	 }
	 """	    
#     * def saveUser = call read('SaveUser.feature') userToken          
     # Check that the query fail because the password is too short
     * def expected = 
     """
     {
        "message": "Password does not conform to policy: Password must have symbol characters"
     }
     """
#     * match saveUser.response.errors contains deep expected    

 
     # Try to create a new user with the role empty
     * def newUser = 
	 """
	 { 
	 	"username": "userNotAdmin@test.com", 
	 	"password": "Password_1" 
	 }
	 """	    
     * def saveUser = call read('SaveUser.feature') userToken          
     # The user is created and the default value fo the role is 'User'
     * match saveUser.response.errors == '#notpresent'    


     # Try to create a new user whith a username that already exist
     * def newUser = 
	 """
	 { 
	 	"username": "userNotAdmin@test.com", 
	 	"password": "Password_1",
	 	"role": "User"
	 }
	 """	    
     * def saveUser = call read('SaveUser.feature') userToken          
     # Check that the default value is 'User'
     * def expected = 
     """
     {
        "message":"An account with the given email already exists."
     }
     """
    
     * match saveUser.response.errors contains deep expected  

    ### Create a new customers without name and surname
    # It should fail because they are mandatory fields
    * def newCustomer = 
    """
    {
       "id": "idCustomer"
    }
    """"    
    * def saveCustomer = call read('SaveCustomer.feature') userToken 
#    * match saveCustomer.response.errors != '#notpresent'  

    
    ### Delete a customer who doesn't exist
    * def customerDelete = 
    """
    {
       "id": "cusrtomerNotExist"
    }
    """
    * def deleteCustomer = call read('DeleteCustomer.feature') userToken    
    * match deleteCustomer.response.errors != '#notpresent'  
     