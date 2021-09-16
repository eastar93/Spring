package org.ict.controller;

import java.util.List;

import org.ict.domain.BoardVO;
import org.ict.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

// 의존성 , 로깅기능 추가해주세요.
@Controller // 컨트롤러이므로 컨트롤러로 빈컨테이너에 컴포넌트 스캔
@Log4j // 로깅기능 추가
@RequestMapping("/board/*") // 클래스 위에 작성시
// 이 클래스를 사용하는 모든 메서드의 연결주소 앞에 /board/ 추가
@AllArgsConstructor // 의존성 주입 설정을 위해 생성자만 생성
public class BoardController {
	
	// 컨트롤러는 서비스를 호출합니다. / 서비스는 매퍼를 호출합니다.
	@Autowired
	private BoardService service;
	
	@GetMapping("/list") // Get방식으로만 주소 연결
	public void list(Model model) {
		
		log.info("list로직 접속");
		// 전체 글 정보를 얻어와서
		List<BoardVO> boardList = service.getList();
		// view파일에 list라는 이름으로 넘겨주기
		model.addAttribute("list", boardList);
		
		// 1. views 하위에 경로에 맞게 폴더 및 .jsp 파일 생성
		// 2. 부트스트랩을 적용해 게시글 목록을 화면에 표시.
	}
	
	// 아래 주소로 데이터를 보내줄 수 있는 form을 작성해주세요.
	// register.jsp 파일명으로 작성해주시면 되고
	// @GetMapping으로 register.jsp에 접근할 수 있는
	// 컨트롤러 메서드도 아래에 작성해주세요.
	
	@PostMapping("/register") // Post방식으로만 접속 허용
	public String register(BoardVO vo, RedirectAttributes rttr) {
		
		// 글을 썼으면 상세페이지나 혹은 글목록으로 이동시켜야 합니다.
		
		// 1. 글 쓰는 로직 실행후, 다시 목록을 DB에서 꺼내온 다음
		service.register(vo);
		// 2. list주소로 강제로 이동을 시킵니다.
		// 이동을 시킬때 몇 번 글을 썼는지 안내해주는 로직을 추가합니다.
		// addFlashAttribute는 redirect시에 컨트롤러에서
		// .jsp파일로 데이터를 보내줄 때 사용합니다.
		// model.addAttribute()를 쓴다면
		// 일반 이동이 아닌 redirect 이동시는 데이터가 소실됩니다.
		// 이를 막기 위해 rttr.addFlashAttribute로 대체합니다.
		rttr.addFlashAttribute("result", vo.getBno());
		
		// views 폴더 하위 board폴더의 list.jsp 출력
		// redirect로 이동시킬때는 "redirect:파일명"
		return "redirect:/board/list";
	}
	
	// get방식으로만 접속되는 /board/register 
	@GetMapping("/register")
	public String register() {
		return "/board/register";
		
	}
	
	// 상세 페이지 조회는 Long bno에 적힌 글번호를 이용해서 합니다.
	// /get 을 주소로 getmapping을 사용하는 메서드 get을 만들어주세요.
	// /get?파라미터명=글번호 형식으로 가져옵니다(get방식이므로)
	// service에서 get()을 호출해 가져온 글 하나의 정보를
	// get.jsp로 보내줍니다.
	// get.jsp에는 글 본문을 포함한 정보를 조회할 수 있도록 만들어주세요.
	@GetMapping("/get")
	public String get(Long bno, Model model) {
		// 모든 로직 실행 전 bno가 null로 들어오는 경우
		if(bno == null) {
			return "redirect:/board/list";
		}
		// 현재 윗라인 기준으로는 글 번호만 전달받은 상황임
		// 번호를 이용해 전체 글 정보를 받아오는게 우선 진행할 사항임.
		// bno번 글의 전체 정보를 board에 저장함.
		BoardVO board = service.get(bno);
		
		// .jsp파일로 board를 보내기 위해 
		model.addAttribute("detail", board);
		
		// board폴더의 get.jsp로 연결
		return "/board/get";
	}
	
	
}
