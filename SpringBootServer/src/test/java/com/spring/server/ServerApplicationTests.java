package com.spring.server;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static com.spring.utils.Constants.RESPONSE_OK;

@SpringBootTest
class ServerApplicationTests {

	@Test
	void testSimpleRequest() {
		ServerApplication app = new ServerApplication();
		Assertions.assertEquals(app.simpleRequest(), RESPONSE_OK);
	}
}
