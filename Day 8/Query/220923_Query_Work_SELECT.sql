USE WORK;

/* Join Query  => ( 3 TABLE -> 1 TABLE ) */

SELECT u.uID, u.uName, u.uAge, p.pName, p.pCode, s.sCount, p.pPrice
	FROM shopuser u, shopsale s, shopproduct p
	WHERE u.uID = s.uID AND s.pCode = p.pCode;
	

/* 2번이 구매한 내역 => 성명 | 상품명 | 수량 조회 */

SELECT u.uName, p.pName, s.sCount
	FROM shopuser u, shopsale s, shopproduct p 
	WHERE u.uID = s.uID AND  p.pCode = s.pCode AND u.uID = 'A2';

