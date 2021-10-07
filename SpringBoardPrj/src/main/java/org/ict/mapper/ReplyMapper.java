package org.ict.mapper;

import java.util.List;

import org.ict.domain.ReplyVO;

public interface ReplyMapper {
	
	// 특정 게시판 bno번의 글의 전체 댓글 목록 가져오기
	public List<ReplyVO> getList(Long bno);
	
	public void create(ReplyVO vo);
	
	public void update(ReplyVO vo);
	
	public void delete(Long rno);
	
	public Long getBno(Long rno);

}
