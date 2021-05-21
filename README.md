# QATestTheAgileMonkeys

The goal of this practice is to test the backend side for a CRM tool. 

I have choosen [Karate](https://intuit.github.io/karate), an open-source test automation suite by Intuit, for automatizing the tests of the GraphQL API so that it could be easily integrated in a CI/CD process.

# Requirements

To execute this test, it is needed to have installed:
- [JDK 16.0.1](https://www.oracle.com/java/technologies/javase-jdk16-downloads.html)
- [Maven](http://maven.apache.org/)
- [Eclipse](https://www.eclipse.org/ )


# Getting started

For the test I have created a maven project in Eclipse using the Karate Maven archetype because it was easier for me to have already the project skeleton, but if you see the oficial respository of Karate, it is possible to do with one command:

      mvn archetype:generate \
      -DarchetypeGroupId=com.intuit.karate \
      -DarchetypeArtifactId=karate-archetype \
      -DarchetypeVersion=1.0.1 \
      -DgroupId=com.mycompany \
      -DartifactId=myproject

For me, the schema of the project is displayed in this picture:

![image](https://user-images.githubusercontent.com/83512148/119107469-8b5fdc80-ba1f-11eb-8bba-7cb68533800c.png)


Adn the file [pom.xml](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/pom.xml) has this configuration after creating the project: 

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


# Set the environment to test

In this parctice, there are two different environments: 'Dev' and 'Prod', where an user will have to sign in order to get a token for using the GraphQL API. 

The file [karate-config.js](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/karate-config.js) has the configuration of environment, so we can configure there the values of the urls. For this, I have configured the [karate-config.js](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/karate-config.js) file according to the value that I set in the java class [TestRunner.java](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/TestRunner.java) like this:

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

To set the value of 'env', I have introduce this line in the java calss [TestRunner.java](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/graphql/TestRunner.java):

    @Karate.Test
    Karate testUsers() {
    	System.setProperty("karate.env", "prod");   // set the environment to test


In this example, I am testing the 'Pro' environment and so the http url will have the value configured in the [karate-config.js](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/karate-config.js):

    } else if (env == 'prod') {   // set the http URL for the prod environment
        config.httpUrl = 'https://pnbbxqm2y9.execute-api.eu-west-1.amazonaws.com/test-qa-estrella-prod';
    }



# Files of the package

  - Signing in the API to get an authorization token for the admin user:
  
I have built the test on three kind of files:

   - *.features: contain the steps of the tests. Some of them are callable and needed an input parameter, in the case of this parctice, it whould be a JSON field.
   - *.graphql: contain the queries and mutations graphql to send via POST to the graphql API.
   - *.json: files with datas for the users and customers used in the tests.
   - *.java: the java file which contains the class that ran the karate test.


# Test step by step

- # Signing in the API to get an authorization token for the admin user:

The first file is [signinDatasUser.json](https://github.com/MariaExtrella/QATestTheAgileMonkeys/blob/main/apigraphql/src/test/java/test/graphql/signinDataUser.json) whih the JSON body that it is going to be sent in the request to get a token for the admin user: 

      {
        "clientId": "799hogucm363v55l7dk2n1l5u0",
        "username": "admin@theagilemonkeys.com",
        "password": "Admin.2020"
      }

I have prefered to use the json file, but it also could be write in the file .feature that send the request, but it whould be done as text like this:

 	* def query = 
	""" 
	{
  		"clientId": "799hogucm363v55l7dk2n1l5u0",
        "username": "admin@theagilemonkeys.com",
  		"password": "admin@theagilemonkeys.com"
	}
    """
   
because in Karate, the body of the request has to go as text.

The feature file to sign in the API to get a token is signin.feature. Here, the values of the json file are taken and put into text, so it is the same as write them as text from the begining, but as it is the admin user and it won't change, I have used the json file.

In the signin.feature field we define the body of the query as text, as I have said before, and set the environment point according to the value of the url set in karate-config.js:

![image](https://user-images.githubusercontent.com/83512148/119137167-cc1c1d80-ba40-11eb-90b1-ef554c0dd027.png)



