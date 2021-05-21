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

As Karate support [Junit 5](https://github.com/intuit/karate#junit-5), it is also configured as a dependency in the [pom.xml](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/pom.xml)

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

We have the [signinDatasUser.json](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/signinDatasUser.json) file whih the JSON body that it is going to be post in the request to get a token for the admin user: 

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

There are three main Features in this test: [TestAdmin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestAdmin.feature), [TestNotAdmin.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestNotAdmin.feature) and [TestFailures.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestFailures.feature) and they are called from the main Feature [Test.feature](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/Test.feature) run as Karate test in the java class [TestRunner.java](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/TestRunner.java):

      @Karate.Test
          Karate testUsers() {
            System.setProperty("karate.env", "prod");   // set the environment to test
            // Test that the API met the acceptance criteria for an user different from the admin
              return Karate.run("Test").relativeTo(getClass());
          }




