<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- alert -->
<script src="${pageContext.request.contextPath}/resources/alert/dist/sweetalert-dev.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/alert/dist/sweetalert.css">
<style>
.sweet-alert{
	width:400px !important;
	top:40% !important;
	margin-left: -217px !important;
}
.mocktest-box{width:84%;float:left;}
.omr-box{width:15%;float:right;}

/*------------
	보기 클릭 
------------*/
.answer-selected{color:#CC0000 !important;font-weight:bold;}
.changeColor{color:#ff0000 !important;}

/*-------------- 
	로딩 이미지 
--------------*/
.table, .omr-box{display:none;}
.loading-box{display:none;}

</style>
<div class="wrapper">
	<%@ include file="../include/header.jsp" %>
	<section class="section">
		<div class="width1400">
			<div class="inner-section">
				<div class="mocktest-box">
					<table class='table'>
						<tr>
							<td colspan="2" id="testName">${testName.tname} <small>(${subject})</small></td>
						</tr>
						<tr class="first-table">
							<td class="table-left">
								<table></table>
							</td>
							<td class="table-right">
								<table></table>
							</td>
						</tr>
						<tr>
							<td colspan="2" id="paging">
								<button id="prev" class='same-button-style'>이전</button>
								<span id="count"></span> / <span id="allPage"></span>
								<button id="next" class='same-button-style'>다음</button>
							</td>
						</tr>
					</table>
				</div>
				<div class="omr-box">
					<!-- form영역 -->
					<form action="${pageContext.request.contextPath}/subject_test/result_subjectTest" method="post" id="formSendAnswer">
						<input type="hidden" name="tno" value="${testName.tno}" />
						<input type="hidden" name="tq_subject" value="${subject}" />
						<table class="table">
							<tr>
								<td colspan="5" id="time-zone">00 : 00 : 00</td>
							</tr>
						</table>
					</form>
				</div>
				<div class="clear"></div>
				<!-- ajax로딩 될 때 뜨는 이미지 -->
				<div class="loading-box">
					<div class="load-wrapp">
						<div class="loading-message">기출문제 불러오는 중</div>
						<div class="load-3">
							<div class="line"></div>
							<div class="line"></div>
							<div class="line"></div>
						</div>
					</div>
					<div class="clear"></div>
				</div>
			</div>
		</div>
	</section>
</div>
<script>
var tno = ${testName.tno};
var subject = "${subject}";
var originalName = "${testName.tname}";
var substrName;
if(originalName.indexOf("정보처리기사") > -1){
	substrName = "정보처리기사";
}else if(originalName.indexOf("컴퓨터활용능력 1급") > -1){
	substrName = "컴퓨터활용능력 1급";
}
	
$(function(){
	/* 로딩이미지띄우기 */
	$(window).ajaxStart(function(){
		$(".loading-box").css("display", "block");
	}).ajaxComplete(function(){
		$(".loading-box").css("display", "none");
		$(".table").css("display","table");
		$(".omr-box").css("display","table");
	});
	
	getQueAndExBySubjectAjax();
	clickEachExampleButton();
});

/*--------------------------- 
	문제 및 보기 불러오기(과목별) 
---------------------------*/
function getQueAndExBySubjectAjax(){
	$.ajax({
		url:"${pageContext.request.contextPath}/subject_test/getQueAndExBySubject/",
		data:{"tno":tno, "tq_subject":subject},
		type:"post",
		success:function(result){
			if(result.length < 1){
				swal({
					html:true,
					title:"죄송합니다 시험 문제가 준비 중입니다",
					confirmButtonText: "확인",
					closeOnConfirm: false
				}, function(isConfirm){
					if(isConfirm){
						location.replace("${pageContext.request.contextPath}/subject_test/");
					}
				});
			}else{
				makeTags(result);
				swal({
					html:true,
					title:"지금 보시는 시험은 "+substrName+" 입니다",
					text:"제한 시간은 총 <b>2시간 30분</b>이며,<br>한 과목당 제한 시간은 <b>30분</b>입니다<br>확인을 누르면 시험이 시작됩니다",
					confirmButtonText: "확인"
				}, function(isConfirm){
					setTimer(result[0].testName.tname);
				});
			}
			
			
		},
		error:function(e){
			alert("에러가 발생하였습니다.");
		}
	});
}

/*------------------------
	문제 및 보기 태그로 만들기
------------------------*/
function makeTags(result){
	for(var i=0; i<result.length; i++){
		var obj = result[i];
		
		//테이블 생성 (좌 : 5개, 우 : 5개)
		var $table;
		if(i == 0){
			$table = $(".first-table").find(".table-left").find("table");
		}else if(i == 5){
			$table = $(".first-table").find(".table-right").find("table");
		}else if(i == 10){
			//.first-table을 더 생성
			var $copy_table = $(".first-table").html();
			var $new_table = $("<tr>").html($copy_table);
			$(".first-table").after($new_table);
			$new_table.addClass("added-table");
			$new_table.find("table").html("");
			
			$table = $(".added-table").last().find(".table-left").find("table");
		}else if(i == 15){
			$table = $(".added-table").last().find(".table-right").find("table");
		}else if(i == 20 || i == 30 || i == 40 || i== 50 || i == 60 || i == 70 || i == 80 || i == 90){
			var $copy_table = $(".first-table").html();
			var $new_table = $("<tr>").html($copy_table);
			$(".added-table").last().after($new_table);
			$new_table.addClass("added-table");
			$new_table.find("table").html("");
			
			$table = $(".added-table").last().find(".table-left").find("table");
		}else if(i == 25 || i == 35 || i == 45 || i == 55 || i == 65 || i == 75 || i == 85 || i == 95){
			$table = $(".added-table").last().find(".table-right").find("table");
		}
		
		//과목(과목명이 이전과 달라지면 그 때 과목명을 한 번 더 삽입)
		/* var $tr_subject = $("<tr>").html("<td colspan='2' class='subject'>"+obj.tq_subject+"</td>");
		if( i == 0 ){
			$table.append($tr_subject);
		}else if( (i>0) && (result[i-1].tq_subject != result[i].tq_subject) ){
			$table.append($tr_subject);
		} */
		
		//문제
		var $tr_question = $("<tr class='question'>");
		$tr_question.append("<td>"+obj.tq_small_no+". </td>");
		$tr_question.append("<td>"+obj.tq_question+"</td>");
		$tr_question.attr("tqno", obj.tq_no);
		$tr_question.attr("tno", obj.testName.tno);
		$tr_question.attr("tqsubject", obj.tq_subject);
		$tr_question.attr("tqsmallno", obj.tq_small_no);
		$tr_question.attr("tqper", obj.tq_per);
		$tr_question.attr("tqanswer", obj.tq_answer);
		
		$table.append($tr_question);
		
		//이미지(이미지가 있을때만 삽입)
		var imageList = obj.imageList; 
		if(imageList.length > 0){
			for(var j=0; j<imageList.length; j++){
				var $tr_image = $("<tr>");
				$tr_image.append("<td></td>");
				$tr_image.append("<td><img src='${pageContext.request.contextPath}/resources/upload/"+imageList[j].imgsource+"'/></td>");
				$tr_image.attr("tqno", imageList[j].tq_no);
				
				$table.append($tr_image);
			}
		}
		
		//보기
		var exampleList = obj.exampleList;
		for(var j=0; j<exampleList.length; j++){
			var example = exampleList[j];
			var $tr_example = $("<tr class='example'>");
			$tr_example.append("<td></td>");
			$tr_example.append("<td><a href=''><span class='te_small_no'>"+example.te_small_no+"</span>"+example.te_content+"</a></td>");
			$tr_example.attr("teno", example.te_no);
			$tr_example.attr("tqno", example.question.tq_no);
			$tr_example.attr("tesmallno", example.te_small_no);
			
			$table.append($tr_example);
		}
		
		//omr
		var $table_omr = $(".omr-box .table");
		var $tr_num = $("<tr class='num'>");
		var $tr_answer = $("<tr class='answer'>");
		if(i % 5 == 0){
			$table_omr.append($tr_num);
			$table_omr.append($tr_answer);	
		}
		if(i == result.length - 1){
			$table_omr.append("<tr><td colspan='5' id='btnSendAnswer'><a href=''>답안 제출</a></td></tr>");
		}
		
	}//end of for
	
	//omr
	for(var i = 0; i < result.length; i++){
		var obj = result[i];
		var index = 0;
		
		if(i < 5){ index = 0; }
		else if(i < 10){ index = 1; }
		else if(i < 15){ index = 2; }
		else if(i < 20){ index = 3; }
		else if(i < 25){ index = 4; }
		else if(i < 30){ index = 5; }
		else if(i < 35){ index = 6; }
		else if(i < 40){ index = 7; }
		else if(i < 45){ index = 8; }
		else if(i < 50){ index = 9; }
		else if(i < 55){ index = 10; }
		else if(i < 60){ index = 11; }
		else if(i < 65){ index = 12; }
		else if(i < 70){ index = 13; }
		else if(i < 75){ index = 14; }
		else if(i < 80){ index = 15; }
		else if(i < 85){ index = 16; }
		else if(i < 90){ index = 17; }
		else if(i < 95){ index = 18; }
		else if(i < 100){ index = 19; }
		
		var $tr_num = $(".omr-box .table").find("tr.num").eq(index);
		var $tr_answer = $(".omr-box .table").find("tr.answer").eq(index);
		
		$tr_num.append("<td tqno='"+obj.tq_no+"'>"+obj.tq_small_no+"</td>");
		
		var $td = $("<td tqno='"+obj.tq_no+"'>");
		$td.append("<span></span>");
		$td.append("<input type='hidden' name='sa_answer'/>");
		$td.append("<input type='hidden' name='tq_no' value='"+obj.tq_no+"'/>");
		$tr_answer.append($td);
	}
	
	//페이징
	$("td#paging").find("#count").html("1");
	var lastNum = 0;
	if(result.length-1 < 10) lastNum = 1
	else if(result.length-1 < 20) lastNum = 2
	else if(result.length-1 < 30) lastNum = 3
	else if(result.length-1 < 40) lastNum = 4
	else if(result.length-1 < 50) lastNum = 5
	else if(result.length-1 < 60) lastNum = 6
	else if(result.length-1 < 70) lastNum = 7
	else if(result.length-1 < 80) lastNum = 8
	else if(result.length-1 < 90) lastNum = 9
	else if(result.length-1 < 100) lastNum = 10
	$("td#paging").find("#allPage").text(lastNum);
	
	clickPagingButton();
}
</script>

<script src="${pageContext.request.contextPath}/resources/js/subject_test_start.js"></script>