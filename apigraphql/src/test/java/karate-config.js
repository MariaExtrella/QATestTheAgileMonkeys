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