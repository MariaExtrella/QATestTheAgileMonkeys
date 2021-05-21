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
        
	### Test that the admin user can save new users
    
    * def saveUsers = call read('SaveUsers.feature') userToken          
     # Check that the query doesn't fail
     * match saveUsers.response.errors == '#notpresent' 
    
    # List all the users of the API
    * def listUsers = call read('UserReadModels.feature') userToken 
    * match listUsers.response.errors == '#notpresent'   
    
    ### Change the role of one user
    # Take the first user of the response to change the role    
    * def first_user = listUsers.response.data.UserReadModels[0]
      
    * set first_user.role = "role changed"
    * def userChangeRole = 
    """
    {
      "username": "#(first_user.id)",
      "role": "#(first_user.role)"
    }
    """
    * def change_role = call read('ChangeUserRole.feature') userToken
    * match change_role.response.errors == '#notpresent'  
 
    ### List one user by id to check that the role has been changed 
    # Define the id for the query
    * def id = 
    """
    {
    	"id": "#(first_user.id)"
    }
    """
    * def listUserbyId = call read('UserReadModel.feature') userToken    
    * match listUserbyId.response.data.UserReadModel == {id: '#(first_user.id)', role: '#(first_user.role)' }
    
 
    ### Create new customers
    # It is necessary to define the userId as the username of the user who create the customers to be read as id in the feature
    * def id = adminDatas.username
    * def saveCustomers = call read('SaveCustomers.feature') userToken 
 
    
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
###    * match listCustomerId.response.data.CustomerReadModel == {id: '#(first_customer.id)', name: '#(first_customer.name)', surname: '#(first_customer.surname)', photoUrl: '#(first_customer.photoURL)', userId: '#(adminDatas.username)' }
    
    
    ### Delete user
    # Get the last user from the list obtained before 'listUsers' to delete
    * def numUsers = listUsers.response.data.UserReadModels.length - 1
    * def userToDelete = listUsers.response.data.UserReadModels[numUsers]
    * print userToDelete
    
    * def usernameDelete = 
    """
    {
       "username": "#(userToDelete.id)"
    }
    """
    * def deleteUser = call read('DeleteUser.feature') userToken
    * match deleteUser.response.errors == '#notpresent'  
    
    
    ### List the user by id to check if it was properly delete
    * def id = 
    """
    {
    	"id": "#(userToDelete.id)"
    }
    """
    * def listUserDelete = call read('UserReadModel.feature') userToken    
    * match listUserDelete.response.data.UserReadModel != {id: '#(userToDelete.id)', role: '#(userToDelete.role)' }  
    
    
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
    * def id_Customer = customerDelete
    * def listCustomerDelete = call read('CustomerReadModel.feature') userToken    
    * match listCustomerDelete.response.data.CusotmerReadModel == '#notpresent'
 