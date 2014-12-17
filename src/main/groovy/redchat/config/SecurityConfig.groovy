package redchat.config

import org.apache.tomcat.jdbc.pool.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.configuration.*;


/**
 * An extremely basic auth setup for the sake of a demo project
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
 
  @Autowired
  public void configureForDevelopment(AuthenticationManagerBuilder auth, Environment env) throws Exception {
    auth.inMemoryAuthentication().withUser("destes").password("password").roles("USER");
    auth.inMemoryAuthentication().withUser("user2").password("password").roles("USER");
  }

//  @Autowired
//  public void configureForProduction(AuthenticationManagerBuilder auth, DataSource dataSource, Environment env) throws Exception {
//    // auth.inMemoryAuthentication().withUser("destes").password("password").roles("USER");
//    // auth.inMemoryAuthentication().withUser("user2").password("password").roles("USER");
//  }
}