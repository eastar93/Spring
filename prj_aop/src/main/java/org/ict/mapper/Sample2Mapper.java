package org.ict.mapper;

import org.apache.ibatis.annotations.Insert;

public interface Sample2Mapper {

	@Insert("Insert Into tbl_test2 (col2) values (#{data})")
	public int insertCol2(String data);
	
}
