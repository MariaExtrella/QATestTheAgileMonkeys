package test.graphql;

import com.intuit.karate.junit5.Karate;

class TestRunner {    
  
    @Karate.Test
    Karate testUsers() {
    	System.setProperty("karate.env", "prod");   // set the environment to test
    	// Test that the API met the acceptance criteria for an user different from the admin
        return Karate.run("Test").relativeTo(getClass());
    }  
    
/*    @Karate.Test
    Karate testUsers2() {
    	System.setProperty("karate.env", "prod");   // set the environment to test
    	// Test that the API met the acceptance criteria for an user different from the admin
        return Karate.run("TestUsers").relativeTo(getClass());
    }      */
}
