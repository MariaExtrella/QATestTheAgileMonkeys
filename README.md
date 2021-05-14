# QATestTheAgileMonkeys

The goal of this practice is to test the backend side for a CRM tool. I have choosen Karate (https://intuit.github.io/karate), an open-source test automation suite by Intuit, for automatizing the tests of the GraphQL API.

In this case of the practice, there are two different environments Dev and Prod in which a user will have to sign in order to get a token for using the GraphQL API.

# Getting started:


To get a Token in Hoppscotch https://hoppscotch.io/graphql : 
   In the Inicio menu, import the cURL:
    
    curl -X POST \
      '{environment-httpUrl}/auth/sign-in' \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d '{
      "clientId": {clientId},
      "username": {email},
      "password": {password}
    }
    '
   where we fill the fields with the following values:
   {envirnoment-httpUrl} is https://pnbbxqm2y9.execute-api.eu-west-1.amazonaws.com/test-qa-estrella-prod/auth/sign-in
   {clientId} is 799hogucm363v55l7dk2n1l5u0
   {email} is admin@theagilemonkeys.com
   {password} is Admin.2020
   
   We get the token and we can take the idToken with which we can connect to graphql in the URL https://pnbbxqm2y9.execute-api.eu-west-1.amazonaws.com/test-qa-estrella-prod/graphql      adding a Authorization header with the value "Bearer" and the idToken obtained before.
   
   Test 1 - Execute SaveUser mutation with an invalid password.
        I try to execute the query with the following values:
        
        mutation {    
            SaveUser(input: {
                username: "userTest1@test8.com"
                password: "passwTest1"
                role: "User"
            })
        }
 
 The password is wrong because it hasn't got a symbol and we get the error as it is expected:
 
 {
  "errors": [
    {
      "message": "Password does not conform to policy: Password must have symbol characters",
      "locations": [
        {
          "line": 2,
          "column": 5
        }
      ],
      "path": [
        "SaveUser"
      ]
    }
  ],
  "data": {
    "SaveUser": null
  }
}

So, it should be expected that the next time that we try it with the same "username" and "role" but a correct "password", the user is saved, but instead of that, we get the next error:
{
  "errors": [
    {
      "message": "An account with the given email already exists.",
      "locations": [
        {
          "line": 2,
          "column": 5
        }
      ],
      "path": [
        "SaveUser"
      ]
    }
  ],
  "data": {
    "SaveUser": null
  }
}

But if I execute the query UserReadModels, we don't find any account with that email.
    

