package org.ict.controller.di.classfile;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class Satellite {
	
	private Broadcast broadcast;
	
	// @Autowired를 이용한 주입은 생성자에도 적용할 수 있습니다.
	@Autowired
	public Satellite(Broadcast broadcast) {
		this.broadcast = broadcast;
	}
	
	public void satelliteBroadcast() {
		System.out.print("위성 송출용 방송을 하도록하는 ");
		broadcast.broadcast();
	}

}
