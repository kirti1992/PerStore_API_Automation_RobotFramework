*** Settings ***
Documentation    API Testing for user endpoint for petstore app.
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary


*** Variables ***
${base_url}=   https://petstore.swagger.io/v2
${id}=   100
${username}=   kkumari2
${firstName}=  kirti
${lastName}=  kumari
${email}=  kirti@swagger.com
${password}=  swagger@123
${phone}=  1234567890
${userStatus}=  1
${updated_username}  kkumari3
${updated_id}=   500


*** Test Cases ***

TC1_createUser: Do a POST Request to create user and validate the response code, response body, and response headers
    [documentation]  This test case verifies that the response code of the POST Request should be 200,
    ...  the response body contains the id,
    ...  and the response header 'Content-Type' has the value 'application/json'.

    [Tags]  regression      userCreation

    create session      mysession        ${base_url}
    ${body}=        create dictionary       id=${id}    username=${username}   firstName=${firstName}    lastName=${lastName}    email=${email}    password=${password}    phone=${phone}     userStatus=${userStatus}
    ${header}=      create dictionary       Content-Type=application/json
    ${response}=     post request    mysession       /user       data=${body}       headers=${header}

    BuiltIn.Log To Console   ${response.status_code}
    BuiltIn.Log To Console   ${response.content}


    #validations
    #Check Status as 200
    ${status_code}=         convert to string       ${response.status_code}
    should be equal         ${status_code}          200

    #Check id as 100 from Response Body
    ${res_body}=        convert to string       ${response.content}
    should contain      ${res_body}         ${id}

    #Check the value of the header Content-Type
    ${contentTypeValue}=    get from dictionary   ${response.headers}   Content-Type
    should be equal     ${contentTypeValue}   application/json


TC2_readUser: Do a GET Request to read user details and validate the response code and response body
    [documentation]  This test case verifies that the response code of the GET Request should be 200,
    ...  the response body contains username',
    ...  and the response header 'Content-Type' has the value 'application/json'.
    ...  and the status should not be 400 or 404

    [Tags]  regression      reading

    create session  my_session  ${base_url}
    ${response}=     get request    my_session  /user/${username}
    BuiltIn.Log To Console   ${response.status_code}
    BuiltIn.Log To Console   ${response.content}
    BuiltIn.Log To Console   ${response.headers}


    #validations
    ${status_code}=  convert to string    ${response.status_code}
    should be equal     ${status_code}     200   #Check Status as 200

    ${body}=        convert to string    ${response.content}
    should contain    ${body}      ${username}

    #Check the value of the header Content-Type
    ${contentTypeValue}=    get from dictionary   ${response.headers}   Content-Type
    should be equal     ${contentTypeValue}   application/json

    #negative validations
    ${status_code}=  convert to string    ${response.status_code}
    should not be equal     ${status_code}     400   #Check Status should not be 400

    ${status_code}=  convert to string    ${response.status_code}
    should not be equal     ${status_code}     404    #Check Status should not be 404



TC3_updateUser: Do a PUT Request to update user details and validate the response code and response body
    [documentation]  This test case verifies that the response code of the PUT Request should be 200,
    ...  the response body contains updated id',
    ...  and the response header 'Content-Type' has the value 'application/json'.
    ...  and the status should not be 400 or 404 and should not contain original id in response body

    [Tags]  regression      updating

    create session      mysession        ${base_url}
    ${body}=        create dictionary   id=${updated_id}    username=${updated_username}   firstName=${firstName}    lastName=${lastName}    email=${email}    password=${password}    phone=${phone}     userStatus=${userStatus}
    ${header}=      create dictionary       Content-Type=application/json
    ${response}=     put request    mysession       /user/${username}       data=${body}       headers=${header}

    BuiltIn.Log To Console   ${response.status_code}
    BuiltIn.Log To Console   ${response.content}


    #VALIDATIONS
    ${status_code}=         convert to string       ${response.status_code}
    should be equal         ${status_code}          200         #Check Status as 200


    ${res_body}=        convert to string       ${response.content}
    should contain      ${res_body}             ${updated_id}

    #Check the value of the header Content-Type
    ${contentTypeValue}=    get from dictionary   ${response.headers}   Content-Type
    should be equal     ${contentTypeValue}   application/json


#negative validations
    ${status_code}=  convert to string    ${response.status_code}
    should not be equal     ${status_code}     400      #Check Status should not be 400

    ${status_code}=  convert to string    ${response.status_code}
    should not be equal     ${status_code}     404  #Check Status should not be 404

    ${res_body}=        convert to string       ${response.content}
    should not contain      ${res_body}             ${id}       #Check response should not contain the original id



TC4_deleteUser: Do a DELETE Request to delete user details and validate the response code and response body
    [documentation]  This test case verifies that the response code of the DELETE Request should be 200,
    ...  the response body contains updated username,
    ...  and the response header 'Content-Type' has the value 'application/json'.
    ...  and the status should not be 400 or 404

    [Tags]  regression      deleting

    create session  my_session  ${base_url}
    ${response}=    delete request     my_session  /user/${updated_username}
    BuiltIn.Log To Console   ${response.status_code}
    BuiltIn.Log To Console   ${response.content}
    BuiltIn.Log To Console   ${response.headers}

    #VALIDATIONS
    ${status_code}=  convert to string    ${response.status_code}
    should be equal     ${status_code}     200      #Check Status as 200

    ${body}=        convert to string    ${response.content}
    should contain    ${body}      ${updated_username}

    #Check the value of the header Content-Type
    ${contentTypeValue}=    get from dictionary   ${response.headers}   Content-Type
    should be equal     ${contentTypeValue}   application/json

#negative validations
    ${status_code}=  convert to string    ${response.status_code}
    should not be equal     ${status_code}     400      #Check Status should not be 400

    ${status_code}=  convert to string    ${response.status_code}
    should not be equal     ${status_code}     404      #Check Status should not be 404






