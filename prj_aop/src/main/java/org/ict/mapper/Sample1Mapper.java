package org.ict.mapper;

import org.apache.ibatis.annotations.Insert;

public interface Sample1Mapper {

	@Insert("Insert Into tbl_test1 (col1) values (#{data})")
	public int insertCol1(String data);
}

