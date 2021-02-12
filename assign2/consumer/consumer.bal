//CONSUMER
import ballerina/io;
import ballerina/kafka;
import ballerina/log;
import ballerina/lang;

kafka:ConsumerConfig consumerConfigs
{
    bootstrapServers: "localhost:9090"
    groupId: "voter",
    pollingIntervalMills: 1000,
    autoCommit: false

}


public function main() {
  time:Time|error deadline = time:createTime(2021,02,09, "Windhoek");

  grpc:Headers headers = new;
  headers.addEntry("DEADLINE", deadline);

  var infoResponse = blockingEp->getVotingInfo(data, headers);

}

listener kafka:Consumer consumer = new (consumerConfigs);
service kafkaService on consumer {
     resource function viewVoters(kafka:Consumer kafkaConsumer, kafka:ConsumerRecord[] records) {
         
         foreach var kafkaRecord in records{
             processKafkaRecord(kafkaRecord);
         }

         var commitResult = kafkaConsumer->commit();
         if(commitResult is error) {
             log: printError("Error!", commitResult);
         }
     }

     resource function candidates(kafka:Consumer kafkaConsumer, kafka:ConsumerRecord[] records) {
         
         foreach var kafkaRecord in records{
             processKafkaRecord(kafkaRecord);
         }

         var commitResult = kafkaConsumer->commit();
         if(commitResult is error) {
             log: printError("Error!", commitResult);
         }
     }



 function addVoters(kafka:ConsumerRecord kafkaRecord){


     foreach var entry in records {
         byte[] message =kafkaRecord.value;
         if(message1 is string){
            byte[] serializedMsg = entry.value;
            string msg = encoding:byteArrayToString(serializedMsg);
            io:println("New message received from the product admin");
            // log the retrieved Kafka record
            io:println("//");
            io:println("Database updated with the new voter data");
        }
        else{
         log:printErrror("Error", message1);
     }
     
 }
 }
}
 

