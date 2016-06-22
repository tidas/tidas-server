#Tidas REST API Doc

## API v0.1

#### Check Tidas availability ####

This call is used to check the availability of the Tidas servers. 

**API Call:** `GET /ping`

Parameters:

* **None**

Example Request:  
`curl https://app.passwordlessapps.com/ping`

Example Response:  
`{"successful_result":{"tidas_id":null,"message":"Pong!","returned_data":null}}`

#### Enroll Identity ####

This call is used to store a public key in our database. You can optionally supply a `tidas_id` if you want identity lookups to use your id conventions. Additionally, you can send an `overwrite` option to update an existing ID with a new identity object.

**API Call:**  `POST /identities/enroll`

URL Parameters:  
* **api_key**: API Key assigned by Tidas

Request Body JSON Params:
* **enrollment_data**: `<Tidas::EnrollmentData>`enrollment blob from client device
* **application**: `<String>` application name which you provided to Tidas
* **tidas_id**: `<String>` id to store key info with (optional: if not included, we will return one to you)  
* **overwrite**: `<Boolean>` if a value is provided for this key, along with a tidas_id, Tidas will overwrite the associated user with the new information (optional : if not included, we won't overwrite the user)

Example Request:  

```curl
curl https://app.passwordlessapps.com/identities/enroll?api_key=test-api-key
-d '{ "enrollment_data": "AAEAAAAAAQUAAAB0b2tlbgIIAAAArjLCVQAAAAADFAAAAOampSqv22ZcJqGA8NycnekorHaIBEYAAAAwRAIgR318ZQZ2lZqMCtOmNZJeqaeFM4CXRK1MoV4V2nJoRlACIBQp4Aujc2Ks8t9ouJn//pVOhUFjqXhZltKBbz/GoSC9BUEAAAAELRQfUdYVN0zMrWllimOc9phemEbyqizT2NmPmnAnHrQnE+oTP0CLVFOZjDLhLdyoawcmMT6VurgDCkU9HW9zIg==", "application" : "Javelin", "tidas_id": "test"}'
```

Example Response:  
```curl
{"successful_result":{"tidas_id":"30e132b44167fb0cbf2c735b3d577e1e","message":"Identity successfully saved","returned_data":null}}
```

#### Validate Data ####

This call is used to validate data using a provided hash, signature, and a stored public key from our database. The call works by looking up a user with the provided tidas_id, then validating that the data provided was signed with that users' public key. Upon successful validation, the data is made available in the returned JSON object.

**API Call:** `POST /identities/validate`

URL Parameters:  
* **api_key**: API Key assigned by Tidas

Request Body JSON Params:
* **validation_data**: `<Tidas::EnrollmentData>`enrollment blob from client device
* **application**: `<String>` application name which you provided to Tidas
* **tidas_id**: `<String>` id to check data validation against

Example Request:  

```curl
curl https://app.passwordlessapps.com/identities/validate?api_key=test-api-key
-d '{ "validation_data": "AAEAAAAAAQUAAAB0b2tlbgIIAAAArjLCVQAAAAADFAAAAOampSqv22ZcJqGA8NycnekorHaIBEYAAAAwRAIgR318ZQZ2lZqMCtOmNZJeqaeFM4CXRK1MoV4V2nJoRlACIBQp4Aujc2Ks8t9ouJn//pVOhUFjqXhZltKBbz/GoSC9BUEAAAAELRQfUdYVN0zMrWllimOc9phemEbyqizT2NmPmnAnHrQnE+oTP0CLVFOZjDLhLdyoawcmMT6VurgDCkU9HW9zIg==", "application" : "Javelin", "tidas_id": "test"}'
```

Example Response:  
```curl
{"successful_result":{"tidas_id":"test","message":"Data passes validation","returned_data":"toast"}}
```

#### Deactivate User ####

This call is used to deactivate users which you no longer wish to validate data from. Users are not deleted, but made inactive in case they decide to use the application again

**API Call:** `POST /identities/deactivate`

URL Parameters:  
* **api_key**: API Key assigned by Tidas

Request Body JSON Params:  
* **tidas_id**: `<String>` id of user you wish to deactivate
* **application**: `<String>` application name which you provided to Tidas

Example Request:

```curl
curl https://app.passwordlessapps.com/identities/deactivate?api_key=test-api-key
-d '{"application" : "Javelin", "tidas_id": "test"}'
```

Example Response:

```curl
{"successful_result":{"tidas_id":"test","message":"Identity successfully deactivated","returned_data":null}}
```

#### Activate User####

This call is used to activate users which you previously deactivated, and want to begin validating data from again.

**API Call:** `POST /identities/activate`

URL Parameters:  
* **api_key**: API Key assigned by Tidas

Request Body JSON Params:  
* **tidas_id**: `<String>` id of user you wish to activate
* **application**: `<String>` application name which you provided to Tidas

Example Request:

```curl
curl https://app.passwordlessapps.com/identities/activate?api_key=test-api-key
-d '{"application" : "Javelin", "tidas_id": "test"}'
```

Example Response:

```curl
{"successful_result":{"tidas_id":"test","message":"Identity successfully activated","returned_data":null}}
```

#### List Users ####

This call is used to list users of your application, both active and deactivated. public keys are trimmed for brevity, but the accompanying `get(<tidas_id>)` method will return this info if you ask for a specific user's information

**API Call:** `GET /identities/index`

URL Parameters:  
* **api_key**: API Key assigned by Tidas
* **application**: Application name you provided to Tidas
* **tidas_id**: If provided, returns full information for one user instead of a list

Example Request 1:  
```curl
curl https://app.passwordlessapps.com/identities/index?api_key=test-api-key&application=Javelin
```

Example Response 1:  
```curl
{
  "successful_result":{
    "tidas_id":null,"message":null,"returned_data":"{
      "identities":[
        {"id":"061786916b813c3d32ccbf58b310830c","deactivated":false,"app":"Javelin"},
        {"id":"0f660bc7f28144143e74eb8241b30cf9","deactivated":false,"app":"Javelin"},
        {"id":"30e132b44167fb0cbf2c735b3d577e1e","deactivated":false,"app":"Javelin"},
        {"id":"3dba704a8dbb9971ea9a508733d0f170","deactivated":false,"app":"Javelin"},
        {"id":"e_24323","deactivated":false,"app":"Javelin"},
        {"id":"hello_world_id","deactivated":false,"app":"Javelin"},
        {"id":"test","deactivated":false,"app":"Javelin"}
      ]
    }"
  }
}
```

Example Request 2:  
```curl
curl https://app.passwordlessapps.com/identities/index?api_key=test-api-key&application=Javelin&tidas_id=test
```

Example Response 2:  
```curl
{
  "successful_result":{
    "tidas_id":null,
    "message":null,
    "returned_data":"{
      "identities":[
        {
          "id":"test",
          "deactivated":false,
          "app":"Javelin",
          "public_key":"-----BEGIN PUBLIC KEY-----\\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAELRQfUdYVN0zMrWllimOc9phe\\nmEbyqizT2NmPmnAnHrQnE+oTP0CLVFOZjDLhLdyoawcmMT6VurgDCkU9HW9z\\nIg==\\n-----END PUBLIC KEY-----\\n"
        }
      ]
    }"
  }
}
```
