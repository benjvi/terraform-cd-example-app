package com.elderstudios;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * Created by tony on 29/06/17.
 */

@SpringBootApplication
@EnableJpaAuditing
public class Application {

    public static void main (String[] args) {
        SpringApplication.run (Application.class, args);
    }
}
