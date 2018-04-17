package com.benjvi;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {

    @GetMapping (value = "/")
    public String displayHelloWorld() {
        return "<html><body><h1>Hello London!</h1></body></html>";
    }
}
