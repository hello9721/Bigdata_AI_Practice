USE WORK;

/* Join Query  => ( Many TABLE -> 1 TABLE ) */

SELECT u.uID, u.uName, u.uAge, p.pName, p.pCode, s.sCount, p.pPrice
	FROM shopuser u, shopsale s, shopproduct p
	WHERE u.uID = s.uID AND s.pCode = p.pCode;
	

/* 2번이 구매한 내역 => 성명 | 상품명 | 수량 조회 */

SELECT u.uName, p.pName, s.sCount
	FROM shopuser u, shopsale s, shopproduct p 
	WHERE u.uID = s.uID AND  p.pCode = s.pCode AND u.uID = 'A2';


/* 새로운 열 생성 | 열 연산 | 열 이름 변경 */

SELECT u.uID ID, u.uName AS Name, u.uAge Age, p.pName Product, p.pCode AS Code, s.sCount Count, p.pPrice * s.sCount AS Total_Price
	FROM shopuser u, shopsale s, shopproduct p
	WHERE u.uID = s.uID AND s.pCode = p.pCode;
	
/* Sub Query == Join Query */
/* 조회한 결과를 다른 조회 구문의 입력으로 사용 = 부분 조회 */

/* 세탁기를 구매한 고객의 이름 */
/* 구매 내역은 shopsale에 상품명은 shopproduct에 고객명은 shopuser에 있기에 까다롭다. */

SELECT uName FROM shopuser WHERE uID = 
	(SELECT	uID FROM shopsale WHERE pCode = 
		(SELECT pCode FROM shopproduct WHERE pName = '세탁기'));
