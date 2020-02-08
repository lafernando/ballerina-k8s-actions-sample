import ballerina/http;
import ballerina/kubernetes;
import ballerina/system;
import wso2/azurecv;

azurecv:Configuration conf = {
    key: system:getEnv("CV_KEY"),
    region: "eastus"
};

azurecv:Client cvClient = new(conf);

@kubernetes:Service {
    serviceType: "LoadBalancer",
    port: 80
}
@kubernetes:Deployment {
    image: "$env{docker_username}/ballerina-k8s-actions-sample-$env{GITHUB_SHA}",
    push: true,
    username: "$env{docker_username}",
    password: "$env{docker_password}",
    imagePullPolicy: "Always",
    env: { "CV_KEY": "$env{CV_KEY}" }
}
@http:ServiceConfig {
    basePath: "/image2Text"
}
service Image2Text on new http:Listener(8080) {

    @http:ResourceConfig {
        path: "/"
    }
    resource function process(http:Caller caller, http:Request request) returns @tainted error? {
        byte[] payload = check request.getBinaryPayload();
        string result = check cvClient->ocr(<@untainted> payload);
        check caller->respond(<@untainted> result);
    }

}
