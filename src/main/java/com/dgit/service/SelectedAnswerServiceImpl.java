package com.dgit.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dgit.domain.SelectedAnswerVO;
import com.dgit.persistence.SelectedAnswerDao;

@Service
public class SelectedAnswerServiceImpl implements SelectedAnswerService{
	@Autowired
	private SelectedAnswerDao dao;

	@Override
	public List<SelectedAnswerVO> selectAllAnswerByTnoDate(SelectedAnswerVO vo) throws Exception {
		return dao.selectAllAnswerByTnoDate(vo);
	}

	@Override
	public void insertSelectedAnswer(SelectedAnswerVO vo) throws Exception {
		dao.insertSelectedAnswer(vo);
	}

}
