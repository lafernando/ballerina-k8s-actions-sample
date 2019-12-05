import ballerina/http;
import ballerina/kubernetes;

@kubernetes:Service {
    serviceType: "LoadBalancer",
    port: 80
}
@kubernetes:Deployment {
    image: "$env{docker_username}/ballerina-k8s-actions-sample-$env{GITHUB_SHA}",
    push: true,
    username: "$env{docker_username}",
    password: "$env{docker_password}",
    imagePullPolicy: "Always"
}
@http:ServiceConfig {
    basePath: "/"
}
service hellosvc on new http:Listener(8080) {

    @http:ResourceConfig {
        path: "/"
    }
    resource function hello(http:Caller caller, http:Request request) returns error? {
        check caller->respond("Hello, Jack!");
    }

}
