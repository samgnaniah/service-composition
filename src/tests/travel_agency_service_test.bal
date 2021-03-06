// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

package TravelAgency;

import ballerina/test;
import ballerina/http;

@test:BeforeSuite
function beforeFunc() {
    // Start the 'travelAgencyService' before running the test
    _ = test:startServices("TravelAgency");

    // 'travelAgencyService' needs to communicate with airline reservation, hotel reservation and car rental services
    // Therefore, start these three services before running the test
    // Start the 'airlineReservationService'
    _ = test:startServices("AirlineReservation");

    // Start the 'hotelReservationService'
    _ = test:startServices("HotelReservation");

    // Start the 'carRentalService'
    _ = test:startServices("CarRental");
}

// Client endpoint
endpoint http:Client clientEP {
    targets:[{url:"http://localhost:9090/travel"}]
};

// Function to test Travel agency service
@test:Config
function testTravelAgencyService() {
    // Initialize the empty http requests and responses
    http:Request request;

    // Test the 'arrangeTour' resource
    // Construct a request payload
    json payload = {
        "Name":"Alice",
        "ArrivalDate":"12-03-2018",
        "DepartureDate":"13-04-2018",
        "Preference":{"Airline":"Business", "Accommodation":"Air Conditioned", "Car":"Air Conditioned"}
    };

    request.setJsonPayload(payload);
    // Send a 'post' request and obtain the response
    http:Response response = check clientEP -> post("/arrangeTour", request);
    // Expected response code is 200
    test:assertEquals(response.statusCode, 200, msg = "Travel agency service did not respond with 200 OK signal!");
    // Check whether the response is as expected
    json resPayload = check response.getJsonPayload();
    json expected = {"Message":"Congratulations! Your journey is ready!!"};
    test:assertEquals(resPayload, expected, msg = "Response mismatch!");
}

@test:AfterSuite
function afterFunc() {
    // Stop the 'travelAgencyService' after running the test
    test:stopServices("TravelAgency");

    // Stop the 'airlineReservationService'
    test:stopServices("AirlineReservation");

    // Stop the 'hotelReservationService'
    test:stopServices("HotelReservation");

    // Stop the 'carRentalService'
    test:stopServices("CarRental");
}
