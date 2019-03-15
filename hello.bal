import ballerina/http;
import ballerinax/kubernetes;

@kubernetes:Service {
    serviceType: "LoadBalancer",
    port: 80
}
listener http:Listener hx = new(8080);

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
service serviceName on hx {

    @http:ResourceConfig {
        path: "/"
    }
    resource function hello(http:Caller caller, http:Request request) returns error? {
        check caller->respond("Hello, Jane!");
    }

}
