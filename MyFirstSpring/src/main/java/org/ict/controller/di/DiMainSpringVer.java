package org.ict.controller.di;

import org.ict.controller.di.classfile.Broadcast;
import org.springframework.context.support.GenericXmlApplicationContext;

public class DiMainSpringVer {
	public static void main(String[] args) {
		// �� �����̳ʿ� ȣ���� �ϼ�ǰ ��ü�� �޾ƿ� �����ϴ� �ڵ带 �ۼ��غ��ڽ��ϴ�.
		// ȣ��� ����ϴ� ������ ��ü�� GenericXmlApplicationContext �Դϴ�.
		GenericXmlApplicationContext context =
				new GenericXmlApplicationContext(
						"file:src/main/webapp/WEB-INF/spring/root-context.xml"
						);
		// ���� root-context.xml�̶�� bean-container�� ������ �ϰڴٰ� ������ ������
		// ���� �� ���忡 �ִ� ��ü�� ������� ���� �� �� �ֽ��ϴ�.
		// ������ ����� ���� ������ context ��ü�� �̿���
		// context.getBean("bean�̸�", �ڷ���.class); �Դϴ�.
		Broadcast broadcast = context.getBean("broadcast", Broadcast.class);
		broadcast.broadcast();
		
		// ȣ���� ������ context�� �ݾ���� �մϴ�.
		context.close();
	}
}