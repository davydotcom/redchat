package redchat

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.context.annotation.ComponentScan
import org.springframework.context.annotation.Configuration

@Configuration
@ComponentScan(['asset.pipeline','redchat','redchat.config'])
@EnableAutoConfiguration
class Application {

    static void main(String[] args) {
        SpringApplication.run Application, args
    }
}
