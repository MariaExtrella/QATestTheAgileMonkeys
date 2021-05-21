Feature: Test the graphql API for admin and not admin users

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
        
	### Create a new user different from admin to sign in the API
    # The body of the graphql request is a JSON with the generated values
    * def newUser = 
	 """
	 { 
	 	"username": "userNotAdmin@test.com", 
	 	"password": "Password_1", 
	 	"role": "user"
	 }
	 """	
    
    * def saveUser = call read('SaveUser.feature') userToken 
    * match saveUser.response.errors == '#notpresent'
    
    ### Sign now with the new user to get a new authorization token
    # To call the feature it is necessary to over write the sign in values with the new user's
    * def newUserSign = 
    """
    {
         "clientId": "#(adminDatas.clientId)",
         "username": "#(newUser.username)",
         "password": "#(newUser.password)" 
    }
    """
    * def signIn = call read('signin.feature') newUserSign
    * print signIn.response    
    * def userToken = signIn.response
    
    # The token for the admin user is the input parameter for the callable feature where are defined the steps of the tests    
    * def userToken = signIn.response    

 
    ### Create new customers
    # It is necessary to define the userId as the username of the user who create the customers to be read as id in the feature
    * def id = adminDatas.username
    * def saveCustomers = call read('SaveCustomersNotAdmin.feature') userToken 
 
    
    ### List all customers
    * def listCustomers = call read('CustomerReadModels.feature') userToken 
 
    
    ### Update customers
    # Take the first customer of the above response to modify    
    * def first_customer = listCustomers.response.data.CustomerReadModels[0]
      
    * set first_customer.name = "name changed"
    * set first_customer.surname = "surname changed" 
    * set first_customer.photoURL = "newPhoto.jpg"   
    

    * def updateCustomer = call read('SaveCustomer.feature') userToken   
    
    
    ### List a customer by id
    # Check if the customer was updated properly and it has the reference of the last user who modified
    * def id_Customer = 
    """
    {
       "id": "#(first_customer.id)" 
    }
    """ 
    * def listCustomerId = call read('CustomerReadModel.feature') userToken 
#    * match listCustomerId.response.data.CustomerReadModel == {id: '#(first_customer.id)', name: '#(first_customer.name)', surname: '#(first_customer.surname)', photoUrl: '#(first_customer.photoURL)', userId: '#(newUser.username)' }
    * match listCustomerId.response.data.CustomerReadModel == {id: '#(first_customer.id)', name: '#(first_customer.name)', surname: '#(first_customer.surname)', photoUrl: '#ignore', userId: '#(newUser.username)' }
       
    
    ### Delete a customer
    # Get the last customer from the list obtained before 'listCustomers' to delete
    * def numCustomers = listCustomers.response.data.CustomerReadModels.length - 1
    * def customerToDelete = listCustomers.response.data.CustomerReadModels[numCustomers]
    
    * def customerDelete = 
    """
    {
       "id": "#(customerToDelete.id)"
    }
    """
    * def deleteCustomer = call read('DeleteCustomer.feature') userToken      
    
    ### List the customer to check that it was properly delete
    * def id_Customer = 
    """
    {
       "id": "#(customerToDelete.id)" 
    }
    """ 
    * def listCustomerDelete = call read('CustomerReadModel.feature') userToken    
    * match listCustomerDelete.response.data.CusotmerReadModel == '#notpresent'
    
    
    
    ### Test the features not allowed to a not admin user  
          
    ### Read user models
    # List all the users of the API, it should fail because it is not an admin user
    * def listUsers = call read('UserReadModels.feature') userToken 
    * match listUsers.response.errors contains deep { message: 'Access denied for read model UserReadModel'} 
  

	### Save new users 
    * def newUser = 
	 """
	 { 
	 	"username": "user@test.com", 
	 	"password": "Password_1", 
	 	"role": "user"
	 }
	 """	   
    * def saveUser = call read('SaveUser.feature') userToken 
    * def expected = 
    """
    {
       "message": "Access denied for command 'SaveUser'"
    }
    """
    * match saveUser.response.errors contains deep expected   
       
    ### Delete user
    # It isn't necessary that the user exist because it should response with a message of 'Access denied'    
    * def usernameDelete = 
    """
    {
       "username": "user@test.com"
    }
    """
    * def deleteUser = call read('DeleteUser.feature') userToken
    * def expected = 
    """
    {
       "message": "Access denied for command 'DeleteUser'"
    }
    """    
    * match deleteUser.response.errors contains deep expected
    
    ### List a user by id 
    # It isn't necessary that the user exist because it should response with a message of 'Access denied'
    * def id = 
    """
    {
    	"id": "user@test.com"
    }
    """
    * def listUserDelete = call read('UserReadModel.feature') userToken    
    * match listUserDelete.response.errors contains deep { message: 'Access denied for read model UserReadModel'} 
    
    ### Change the role of one user
    # It isn't necessary that the user exist because it should response with a message of 'Access denied'    
    * def userChangeRole = 
    """
    {
      "username": "user@test.com",
      "role": "role"
    }
    """
    * def change_role = call read('ChangeUserRole.feature') userToken
    * def expected = 
    """
    {
       "message": "Access denied for command 'ChangeUserRole'"
    }
    """       
    * match change_role.response.errors contains deep expected
     