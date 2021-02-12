//PRODUCER
import ballerina/log;
import ballerina/http;
import ballerina/kafka;
import wso2/gateway;

kafka:ProducerConfig producerConfigs ={
    bootstrapServers: "localhost:9090, localhost:9090" //producer localhost,
    clientId: "voters",
    acks: "all",
    retryCount: 3
}

kafka:Producer kafkaProducer = new (producerConfigs);

public type APIGatewayListener object {
   public {
       EndpointConfiguration config;
       http:Listener httpListener;
   }

};

// Create SQL client for MySQL database
jdbc:Client voterDB = new ({
    url: config:getAsString("DATABASE_URL", "jdbc:mysql://localhost:9090/VOTER_DATA"),
    username: config:getAsString("DATABASE_USERNAME", "root"),
    password: config:getAsString("DATABASE_PASSWORD", "root"),
    poolOptions: { maximumPoolSize: 5 },
    dbOptions: { useSSL: false }
});

@docker:Config{
    name: "testVoTo"
    tag: "V8.3"
}
@docker:Expose{}

@kubernetes:Ingress {
   hostname: "",
   name: "",
   path: "/"
}

@kubernetes:Service {
   serviceType: "NodePort",
   name: ""
}

@kubernetes:Deployment {
   image: "",
   baseImage: "",
   name: "",
   copyFiles: [{ target: "",
               source: <path_to_JDBC_jar> }]
}

@http:ServiceConfig{
    basePath: "/addNew"
}


service candidates on httpListener {
    @http:ResourceConfig{
        path: "/candidates/{name}"
    }

    resource function candidates(http:Caller outboundEP, http:Request request){
        http:Response res = new;

        var payloadJson = request.getJsonPayload();

        if (payloadJson is json) {
            Candidate|error candidateData = Candidate.constructFrom(payloadJson);

            response.setPayload("candidates": [
      {
        "name: Rianne Junius",
        "name: Josemar Lima",
        "name: Uzuvirua Hange",

      },
                } else {
                    json ret = viewData(candidateData.name);
      
);
                    
                    response.setPayload(ret);
                }
            }
        }



service newVoter on httpListener {
    @http:ResourceConfig{
        path: "/voters/{name}"
    }

    resource function newVoter(http:Caller outboundEP, http:Request request){
        http:Response res = new;

        var payloadJson = request.getJsonPayload();

        if (payloadJson is json) {
            Voter|error voterData = Voter.constructFrom(payloadJson);

            if (voterData is Voter) {
                // Validate JSON payload
                if (voterData.name == "" || voterData.address == "" || voterData.voterId == 0 ) {
                        response.statusCode = 400;
                        response.setPayload("Error: JSON payload should contain " +
                        "{name:<string>, address:<address>, voterId:<int>");
                } else {
                    // Invoke addVoters function to save data in the MySQL database
                    json ret = insertData(voterData.name, voterData.address, voterData.citizenship, voterData.gender, voterData.age, voterData.voterId);
                    response.setPayload("data": {
    "allVoters": [
      {
        "id: 1",
        "name": "Peter John ",
        "address": "Rundu, Safari",
        "category": VOTER
      },
      {
        "id: 2",
        "name": "Gerald Luis",
        "address": "Grootfontein, Town View",
        "category": VOTER
      },
      {
        "id: 3",
        "name": "Lucas frederick",
        "address": "Windhoek, windhoek west",
        "category": VOTER
      }
    ]
    };
);
                    
                    response.setPayload(ret);
                }
            } else {
                // Send an error response in case of a conversion failure
                response.statusCode = 500;
                response.setPayload("Error");
            }
        }

    }

}
service viewVoter on httpListener {
    @http:ResourceConfig{
        methods: ["GET"],
        path: "/voters/{id}"
    }

resource function getVotingInfo(grpc:Caller caller, grpc:Headers headers) {
    boolean deadlineExceeded = caller->isDeadlineExceeded(headers);
}
    
    resource function viewVoters(http:Caller outboundEP, http:Request request, voterData){
        http:Response res = new;


var empID = ints:fromString(employeeId);
        if (voterID is int) {
            // Invoke retrieveById function to retrieve data from MYSQL database
            var result = rch.readJson(voterId);

            json viewCurrentInfo = {"id: ",
        "name": " ",
        "address": " ",
        "category": VOTER};

            var sendResult = kafkaProducer->send(message) //topic in kafka;
            // Send the response back to the client with the employee data
            response.setPayload(employeeData);
        } 
        else if(sendResult is error){
            response.statusCode = 500;
            response.setJsonPayload({"The ID entered is not registered in the system!"});
            var responseResult = outboundEP->respond(response);
        }
        //Send a success
        response.setJsonPayload({"Succesfull!"});
        var responseResult = outboundEP->respond(response);
    }
    
}

service fraud on httpListener {
    @http:ResourceConfig{
        methods: ["GET"],
        path: "/voters/{rejects}"
    }

    
    type ProcessedReview record {
    boolean isFraud?;
    Review review?;
    !...;
};

// Listen to port 9092 for recods
listener http:Listener reviewsEP = new(9092);

@http:ServiceConfig { basePath: "/frauds" }
service getFrauds on fraudsEP {

    @http:ResourceConfig { methods: ["PUT"], path: "/submitFrauds" }
    resource function receiveFraud(http:Caller caller, http:Request req) {
        string topic = "processed-frauds";
        json message;
        json successResponse = { success: "true", message: "Voter has no fraudulent records" };
        json failureResponse = { success: "false", message: "Voter has voted more than once! Fraudulent activity recorded" };
        http:Response res = new;

        var requestPayload = req.getJsonPayload();
        if (requestPayload is error) {
            res.setJsonPayload(failureResponse);
            _ = caller->respond(res);
        } else {
            message = requestPayload;

            string header = message.header.toString();
            res.setJsonPayload(successResponse);
            _ = caller->respond(res);
            if (header == "frauds") {
                var review = Frauds.convert(message.body);
                if (review is Frauds) {
                    ProcessedFrauds processedReview = {};
                    processedFrauds.frauds = fraud;
                    
                    //
                    // Mock logic to identify fraudulent reviews.
                    // Set processedReview.isFraud true or false depending the result.
                    //
                    
                    var msg = json.convert(processedReview);
                    if (msg is error) {
                        io:println("[Preprocess]\t[ERROR]\tCouldn't convert to Review json");
                    } else {
                        byte[] messageToPublish = msg.toString().toByteArray("UTF-8");
                        var sendResult = reviewProducer->send(messageToPublish, topic);
                        if (sendResult is error) {
                            io:print("[Preprocess]\t[ERROR]\tSending Received Review failed: ");
                            io:println(sendResult.detail().message);
                        } else {
                            io:println("[Preprocess]\t[INFO]\tSent Received Review");
                        }
                    }
                }
            }
        }
    }
}


resource function getVotingInfo(grpc:Caller caller, string patientId, grpc:Headers headers) {
    boolean deadlineExceeded = caller->isDeadlineExceeded(headers);

    if(deadline is json){
        json resultMessage;
        http:Request votingManagerReq = new;
        json resultjson = check json.convert(result);
        resultManagerReq.setJsonPayload(untaint resultjson);
        http:Response resultResponse=  check resultMgtEP->post("/claims", resultManagerReq);
        json resultResponseJSON = check resultResponse.getJsonPayload();
    }
}

