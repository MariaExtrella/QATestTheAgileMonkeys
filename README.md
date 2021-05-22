# QATestTheAgileMonkeys

The goal of this practice is to test the backend side for a CRM tool. 

I have choosen [Karate](https://intuit.github.io/karate), an open-source test automation suite by Intuit, for automatizing the tests of the GraphQL API so that it could be easily integrated in a CI/CD process.

# Requirements

To execute this test, it is needed to have installed:
- [JDK 16.0.1](https://www.oracle.com/java/technologies/javase-jdk16-downloads.html)
- [Maven](http://maven.apache.org/)
- [Eclipse](https://www.eclipse.org/ )


# Getting started

For the test I have created a maven project in Eclipse using the Karate Maven archetype because it was easier for me to have already the project skeleton, but if you see the oficial respository of [Karate](https://intuit.github.io/karate), it is possible to do with one command:

      mvn archetype:generate \
      -DarchetypeGroupId=com.intuit.karate \
      -DarchetypeArtifactId=karate-archetype \
      -DarchetypeVersion=1.0.1 \
      -DgroupId=com.mycompany \
      -DartifactId=myproject

For me, the schema of the project attached in this repository is displayed in this picture:

![image](https://user-images.githubusercontent.com/83512148/119107469-8b5fdc80-ba1f-11eb-8bba-7cb68533800c.png)

And the file [pom.xml](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/pom.xml) has this configuration after creating the project: 

    <groupId>com.testqagraphql</groupId>
    <artifactId>apigraphql</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>jar</packaging> 
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <java.version>1.8</java.version>
        <maven.compiler.version>3.8.1</maven.compiler.version>
        <maven.surefire.version>2.22.2</maven.surefire.version>        
        <karate.version>1.0.1</karate.version>
    </properties>    

As Karate support [Junit 5](https://github.com/intuit/karate#junit-5), it is also configured as a dependency in the [pom.xml](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/pom.xml):

          <dependencies>         
              <dependency>
                  <groupId>com.intuit.karate</groupId>
                  <artifactId>karate-junit5</artifactId>
                  <version>${karate.version}</version>
                  <scope>test</scope>
              </dependency>		
          </dependencies>
          
In the java class [TestRunner.java](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestRunner.java) we only need an import: 

      package test.graphql;
      import com.intuit.karate.junit5.Karate;

      class TestRunner {     
          @Karate.Test
          Karate testUsers() {
            System.setProperty("karate.env", "prod");   // set the environment to test
            // Test that the API met the acceptance criteria for an user different from the admin
              return Karate.run("Test").relativeTo(getClass());
          }  
      }


# Files of the package
  
I have built the test on three kind of files:

   - *.features: contain the steps of the tests. Some of them are callable and needed an input parameter, in the case of this parctice, it whould be a JSON field.
   - *.graphql: contain the queries and mutations graphql to send via POST to the graphql API.
   - *.json: files with datas for the users and customers used in the tests.
   - *.java: the java file which contains the class that ran the karate test.


# Set the environment to test

In this parctice, there are two different environments: 'Dev' and 'Prod', where an user will have to sign in order to get a token for using the GraphQL API. 

The file [karate-config.js](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/karate-config.js) has the configuration of environment, so we can configure there the values of the urls. For this, I have configured the [karate-config.js](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/karate-config.js) file according to the value that I set in the java class [TestRunner.java](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestRunner.java) like this:

      function fn() {
        var env = karate.env; // get system property 'karate.env'
        karate.log('karate.env system property was:', env);
        if (!env) {
          env = 'dev'; // set the dev environment by default
        }
        var config = {
          env: env,
          httpUrl: 'someValue'
        }
        if (env == 'dev') {    // set the http URL for the dev environment
          config.httpUrl = 'https://zk5uudpsvd.execute-api.eu-west-1.amazonaws.com/test-qa-estrella-dev';

        } else if (env == 'prod') {   // set the http URL for the prod environment
          config.httpUrl = 'https://pnbbxqm2y9.execute-api.eu-west-1.amazonaws.com/test-qa-estrella-prod';
        }
        return config;
      }

so that when any environment is set, the 'Dev' environment whould set by default.

To set the value of 'env', I have introduce this line in the java calss [TestRunner.java](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestRunner.java):

    @Karate.Test
    Karate testUsers() {
    	System.setProperty("karate.env", "prod");   // set the environment to test


In this example, I am testing the 'Pro' environment and so the http url will have the value configured in the [karate-config.js](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/karate-config.js):

    } else if (env == 'prod') {   // set the http URL for the prod environment
        config.httpUrl = 'https://pnbbxqm2y9.execute-api.eu-west-1.amazonaws.com/test-qa-estrella-prod';
    }



# Feature files

A *.feature in Karate has the [syntax](https://github.com/intuit/karate#syntax-guide) Feature, Background and Scenario in Karate. 
Background is optional, but it is where we can define global variables for all the scenarios and in the case of this practice, I used it for the endpoint.

A Feature can have different Scenarios and Scenarios Online, which will receive input paremeters.

A Feature can receive input paremeters and I have use this to pass the authorization token to the Features and can use the same Features for the admin or a different user.

The way to sent a request in [Karate](https://intuit.github.io/karate) is using keywords [Given - When - Then](https://github.com/intuit/karate#given-when-then) for this tests they have the gaphql query as text in the body of the request and in case that the query need input paramenters, they whould be also passed as text in a variable.

In this example it is displayed a graphql query:

![image](https://user-images.githubusercontent.com/83512148/119192692-d3fbb200-ba80-11eb-8f29-7cad69b1c2ef.png)



# Test step by step


- # Signing in the API to get an authorization token for the admin user:

There are three main Features in this test: [TestAdmin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestAdmin.feature), [TestNotAdmin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestNotAdmin.feature) and [TestFailures.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestFailures.feature) and they are called from the main Feature [Test.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/Test.feature) run as Karate test in the java class [TestRunner.java](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestRunner.java):

      @Karate.Test
          Karate testUsers() {
            System.setProperty("karate.env", "prod");   // set the environment to test
            // Test that the API met the acceptance criteria for an user different from the admin
              return Karate.run("Test").relativeTo(getClass());
          }


The three Features are called from [Test.feature]((https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/Test.feature)). They are called using the keyword [call](https://github.com/intuit/karate#call) and each of them is a new Scenario:

      Feature: Test the graphql API for admin and not admin users 
      Background: 
        * url httpUrl

        Scenario: Test if the API met the acceptance criteria for users admin
          * def testResuls = call read('TestAdmin.feature')

        Scenario: Test if the API met the acceptance criteria for users not admin
          * def testResults = call read('TestNotAdmin.feature')  

        Scenario: Test if the API met the acceptance criteria in wrong cases
          * def testResults = call read('TestFailures.feature')


When one of them is called, the first that the Feature does is called the [signin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/signin.feature). 


We have the [signinDatasUser.json](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/signinDatasUser.json) file with the JSON body that it is going to be post in the request to get a token for the admin user: 

      {
        "clientId": "799hogucm363v55l7dk2n1l5u0",
        "username": "admin@theagilemonkeys.com",
        "password": "Admin.2020"
      }

I have prefered to use a json file for the parameters, but it also could be writen in the file *.feature that contains the request, but it whould be done as text, because in [Karate](https://intuit.github.io/karate), the body of the request has to go as text.


The *.feature file to sign in the API to get a token is [signin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/signin.feature). There, the values of the json file are taken and put into text, so it is the same as write them as text from the begining, but as it is the admin user and it won't change, I have used the json file.


In the [signin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/signin.feature) file we define the body of the query as text, as said before, and set the endpoint according to the value of the url set in [karate-config.js](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/karate-config.js):


      Feature: Get a token for the user to sign in the API
      Background: Get the environment global variable
          * url httpUrl


The [signinDatasUser.json](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/signinDatasUser.json) file is read as text in the Features that call the [signin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/signin.feature)  


    # Read the admin datas from a *.json file
    * def adminDatas = read('signinDatasUser.json') 
    ### Call the feature to sign in the API with the JSON file that contains the admin's datas
    * def signIn = call read('signin.feature') adminDatas

The response of the post, if everything goes fine has the idToken which we will use in every query. As it is a JSON response, it is saved in a variable an from it we'll get the authentication:

        Scenario: obtain a token for the admin user
           * def query = 
           """ 
           {
                  "clientId": "#(clientId)",
                  "username": "#(username)",
                  "password": "#(password)"
            }
          """
          Given path '/auth/sign-in'
          And request query
          And header Content-Type = 'application/json'
          When method post
          Then status 200
          #Get the idToken for the user
          * def tokenid = response.idToken

This is an example of the response to the sign in query:

      1 < X-Amz-Cf-Id: dHUylYCV1VCP_MFRZ9sdOJr2otbAy6c0pU4v2I8n_ig-C8zjHenujg==              {"expiresIn":"3600","idToken":"eyJraWQiOiJb20ROZ0[...]","accessToken":"eyJraWQiOiJIcWFQ[...]","tokenType":"Bearer","refreshToken":"eyJjdHkiOiJKV1Q[...]"}  

Once the user has the token, the queries can be post to the endpoint.


- # Queries:

We need to test that the API met the acceptance criteria for the admin user and for that I have created the following *.feature files:

[UserReadModels.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/UserReadModels.feature):

The admin user can list all the users of the API and for testing it I have created this file in which the body of the post request is the [UserReadModels.graphql](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/UserReadModels.graphql) file. For the post request the authentication header is set with the tokenType and the idToken of the response to the [signin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/signin.feature):

     Scenario: List the users
        # The query is read from a *.graphql file
        * def queryUserReadModels = read('UserReadModels.graphql')    
        
        Given path 'graphql'
        And header Authorization = userToken.tokenType + ' ' + userToken.idToken  	 
        And request { query: '#(queryUserReadModels)'} 
        When method post
        Then status 200


If we take a look at the [UserReadModels.graphql](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/UserReadModels.graphql) file, it is a simple graphql query which we have to define as text to can be post to the endpoint:

      query UserReadModels {
          UserReadModels {
              id
              role
          }
      }
      
 According to the acceptance criteria, that query isn't allowed to a not admin user. 
 
 
 [UserReadModel.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/UserReadModels.feature):
 
 This is a query allowed only for the admin user and it is called passing the id of the user wanted to list as input parameter.
 
 The body of the query is the [UserReadModel.graphql](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/UserReadModel.graphql) file that contains the graphql query. It is called from the main three Features ([TestAdmin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestAdmin.feature), [TestNotAdmin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestNotAdmin.feature) and [TestFailures.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestFailures.feature)) like this:
 
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
 
 The response must be a JSON with the username and the role of the user in the case that it exists or with a error.message full in the case that the user doesn't.
 
 This is an example of the response of this query:
 
       1 < X-Amz-Cf-Id: JqnTX9kzJKiKwtt2ABa8bjK7oeqUfH-o7LKsFv7ZElX1gnQttjNoVQ==
      {"data":{"UserReadModel":{"role":"role changed","id":"username0@test.com"}}}
      
 
 This test must response an error in the case of a not admin user telling that the access is denied:
 
       1 < X-Amz-Cf-Id: 9BVtJkYaWWIOAj4s0ScmLFOarOZcKwkivk-LjC7QLAOTEp8N77-wFw==
      {"data":{"UserReadModel":null},"errors":[{"path":["UserReadModel"],"locations":[{"line":2,"column":5}],"message":"Access denied for read model UserReadModel"}]}


[CustomerReadModels.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/CustomerReadModels.feature):

This is a feature allowed both admin and not admin users. The body of the request is the [CustomerReadModel.graphql](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/CustomerReadModel.graphql) which contains the graphql query:

      query CustomerReadModels {
          CustomerReadModels {
              id
              name
              surname
              photoUrl
              userId
          }
      }
            
This Feature is called from the three main Features and it hasn't input parameters:

     * def queryCustomerReadModels = read('CustomerReadModels.graphql')    
     Given path 'graphql'
     And header Authorization = userToken.tokenType + ' ' + userToken.idToken  	 
     And request { query: '#(queryCustomerReadModels)'} 
     When method post
     Then status 200


[CustomerReadModel.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/CustomerReadModel.feature):

This query is also allowed both admin and not admin users and it has the id of the customer as input parameter. The body of the request is the [CustomerReadModel.graphql](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/CustomerReadModel.graphql):

      query CustomerReadModel($id: ID!) {
          CustomerReadModel(id: $id) {
              id
              name
              surname
              photoUrl
              userId
          }
      }

It is called from the three main Features in the same way:

    Scenario: List a customer by id
       # The query is read from a *.graphql file
       * def queryCustomerReadModel = read('CustomerReadModel.graphql')    
       Given path 'graphql'
  	 And header Authorization = userToken.tokenType + ' ' + userToken.idToken  	 
  	 And request { query: '#(queryCustomerReadModel)', variables: '#(id_Customer)'} 
  	 When method post
       Then status 200
       
The response is a JSON with the customer datas or a null value in the case that it doesn't exist, but not an error.


- # Mutations:


We need to test that the API met the acceptance criteria for these commands and for that I have created the following files:


[SaveUsers.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/SaveUsers.feature):

This file contains a JavaScript function to create some new user. It contains a [Scenario Outline](https://github.com/intuit/karate#dynamic-scenario-outline), what it means that it receives dinamic datas as JSON. This function is defined in the Backgroud part of the Feature file:

        # Define a function to generate Users  
        * def generatorUser = function(i){ if (i == 3) return null; return { username: 'username' + i + '@test.com', password: 'Password_1', role: 'User' } }  
        
and it is called defining like text every JSON returned and using it in the body of the post request:


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
             Examples:
            | generatorUser |	
  
  
As result of this Feature we have three new users created by three post requests like this:

      {"password":"Password_1","role":"User","username":"username2@test.com"}
      
      
This request is only allowed to the admin user and in the case of not admin users it must return an error message of 'Access denied'. THis response it is matched in the test in this way:

    * def saveUser = call read('SaveUser.feature') userToken 
    * def expected = 
    """
    {
       "message": "Access denied for command 'SaveUser'"
    }
    """
    * match saveUser.response.errors contains deep expected   


[SaveUser.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/SaveUser.feature):

This Feature file is just like the above, but it doesn't generate a new user but it receives datas through a text created in the main Feature that calls:

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


[ChangeUserRole.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/ChangeUserRole.feature):

This file changes the role of a given user and it is allowed only for admin datas.

To test it, this file get the username of the user and the new role we want to configure as a text created in the main Feature that calls it:

    * def userChangeRole = 
    """
    {
      "username": "#(first_user.id)",
      "role": "#(first_user.role)"
    }
    """
    * def change_role = call read('ChangeUserRole.feature') userToken


The body of the request is read from the [ChangeUserRole.graphql](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/ChangeUserRole.graphql) file which contais the graphql query:

      mutation ChangeUserRole($username: String, $role: String) {
        ChangeUserRole(input: {username: $username, role: $role})
      }


The response of the post query must contain an 'Access denied' error message in the case of not admin users, which it is matched like this:

    * def saveUser = call read('SaveUser.feature') userToken 
    * def expected = 
    """
    {
       "message": "Access denied for command 'SaveUser'"
    }
    """
    * match saveUser.response.errors contains deep expected   
    

[DeleteUser.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/DeleteUser.feature):

This Feature gets the username of the wanted to delete user and it post the request with the graphql query and the username as the body:

       Scenario: Delete a user
          # The query is read from a *.graphql file
          * def queryDeleteUser = read('DeleteUser.graphql') 
          Given path 'graphql'
          And header Authorization = userToken.tokenType + ' ' + userToken.idToken
          And request { query: '#(queryDeleteUser)',  variables: '#(usernameDelete)'  } 
          When method post
          Then status 200
 
 
The query is read from the [DeleteUser.graphql](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/DeleteUser.graphql) file:

      mutation DeleteUser($username: String) {
          DeleteUser(input: {username: $username})
      }

 This query isn't allowed for not admin users and it must response with an "Access denied" message error:
 
    * def expected = 
    """
    {
       "message": "Access denied for command 'DeleteUser'"
    }
    """    
    * match deleteUser.response.errors contains deep expected
    
    
 
