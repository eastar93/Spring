package org.ict.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

// 빈 컨테이너에 넣어주세요. (등록된 컨트롤러만 실제로 작동됨)
@Controller
public class MVCController {
	
	// 기본주소(localhost:8181)뒤에 /goA를 붙이면 goA()메서드 실행
	@RequestMapping(value="/goA")
	// retrun타입이 String인 경우 결과 페이지를 지정할 수 있음
	public String goA() {
		System.out.println("goA 주소 접속 감지");
		// 결과 페이지는 views 폴더 아래의 A.jsp
		return "A";
	}
	// goB를 생성해주세요.
	// 결과 페이지는 B.jsp입니다.
	@RequestMapping(value="/goB")
	
	public String goB() {
		System.out.println("goB 주소 접속 감지");
		
		return "B";
	}
	
	// goC는 파라미터를 입력받을수 있도록 해보겠습니다.
	@RequestMapping(value="/goC")
	// 주소 뒤 ?cNum=값 형태로 들어오는 값을 로직 내 cNum으로 처리합니다.
	public String goC(int cNum, Model model) {
		System.out.println("주소로 전달받은 값 : " + cNum);
		
		model.addAttribute("cNum", cNum);
		
		// 전달받은 cNum을 C.jsp에 출력하는 로직을 작성해주세요.
		return "C";
	}
	
	// goD는 requestParam을 이용해 변수명과 받는 이름이 일치하지 않게 해보겠습니다.
	@RequestMapping(value="/goD")
	// @RequestParam("대체이름")은 변수 왼쪽에 선언합니다.
	// 이렇게 되면 적힌 변수명 대신 대체이름으로 치환해 받아옵니다.
	public String goD(@RequestParam("D") int dNum, Model model) {
		 
		System.out.println("D 변수명으로 받은게 dNum에 저장 : " + dNum);
		
		model.addAttribute("dNum", dNum);
		
		return "D";
	}
	
	// cToF 메서드를 만들겠습니다.
	// 섭씨 온도를 입력받아 화씨 온도를 바꿔서 출력해주는 로직을 작성해주세요.
	// 섭씨 = (화씨 -32) / 1.8 입니다.
	// 화씨 = (섭씨 * 1.8) + 32
	// 폼에서 post방식으로 제출했응ㄹ때에만 결과페이지로 넘어오도록 설계
	@RequestMapping(value="/cToF", method=RequestMethod.POST)
	public String cToF(@RequestParam("Cel") double Celsius, Model model) {
		System.out.println("주소로 전달받은 화씨온도 : " + ((Celsius*1.8) + 32) + "도");
		
		double Fahrenheit = (Celsius * 1.8) + 32;
		
		model.addAttribute("Fahrenheit", Fahrenheit);
		model.addAttribute("Celsius", Celsius);
		
		return "cToF";
	}
	
	// 폼으로 연결하는 메서드도 만들겠습니다.
	// 폼과 결과페이지가 같은 주소를 공유하게 하기 위해허 폼쪽을 Get방식 접근 허용	
	@RequestMapping(value="/cToF", method=RequestMethod.GET)
	public String cToFForm() {
		
		// cToFform을 이용해 섭씨온도를 입력하고 제출버튼을 누르면
		// 결과값이 나오는 로직을 작성해주세요.
		// input 태그의 name속성은 cel로 주시면 되고
		// action은 value에 적힌 주소값으로 넘겨주시면 됩니다. 
		
		return "cToFform";
	}
	
	// 위와 같이 bmi 측정페이지를 만들어보겠습니다.
	// 폼과 결과페이지로 구성해주시면 되고
	// bmi 공식은 체중 / (키(m) ^ 2) 으로 나오는 결과입니다.
	@RequestMapping(value="/bmi", method=RequestMethod.POST)
	public String bmi(double height, double weight, Model model) {
		// 결과 페이지
		// 키는 cm로 세는것이 일반적
		double m = height/100;
		double bmi = (weight/(m * m));
		System.out.println("주소로 전달받은 bmi : " + (weight/(m * m)));
		
		model.addAttribute("Height", height);
		model.addAttribute("Weight", weight);
		model.addAttribute("Bmi", bmi);
		
		return "bmi";
	}
	
	@RequestMapping(value="/bmi", method=RequestMethod.GET)
	public String bmiForm() {
		
		return "bmiForm";
	}

	// PathVariable을 이용하면 url 패턴만으로도 특정 파라미터를 받아올 수 있습니다.
	// rest방식으로 url을 처리할때 주로 사용하는 방식입니다.
	// /pathtest/숫자 중 숫자 위치에 온 것은 page라는 변수값으로 간주
	@RequestMapping(value="/pathtest/{page}")
	// int page 왼쪽에 @PathVariable을 붙여서 처리해야 연동됨
	public String pathTest(@PathVariable int page, Model model) {
		
		// 받아온 page 변수를 path.jsp로 보내주세요.
		// path.jsp에는 {path} 페이지 조회중입니다 라는 문장이 뜨게 해주세요.
		
		model.addAttribute("page", page);
		
		return "path";
	}
	
	// cTof 로직을 PathVariable을 적용해서 만들어주세요.
	// ctofpv.jsp에 결과가 나오면 됩니다.
	@RequestMapping(value="/cTofPv/{Cels}")
	
	public String ctofpath(@PathVariable double Cels, Model model) {
	
		double Fahr = (Cels * 1.8) + 32;
		model.addAttribute("Cels", Cels);
		model.addAttribute("Fahr", Fahr);
		
		return "cTofPv";
	}
	
	// void타입 컨트롤러의 특징
	// void타입은 return구문 뒤에 자료를 기입할 수 없는 만큼
	// view파일의 이름을 그냥 url패턴.jsp로 자동 지정 해버립니다.
	// 간단한 작성은 void타입으로 해도 되지만 메서드명에 제약이 생겨서 잘 안씁니다.
	@RequestMapping(value="/voidReturn")
	public void voidTest(int num, Model model) {
		System.out.println("void 컨트롤러는 리턴구문이 필요없습니다.");
		// 1. 파라미터를 아무거나 받아오게 임의로 설정해주세요.
		// 2. 현 메서드에 맞는 view파일을 생성해주세요.
		// 3. 1에서 얻어온 파라미터를 2에 출력되도록 설정해주세요.
		model.addAttribute("num", num);
		
	}
	
}
