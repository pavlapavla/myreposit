USE [uchet_test]
GO
/****** Object:  StoredProcedure [dbo].[ad_getParTovar1]    Script Date: 09/24/2018 13:11:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec ad_getParTovar1  796440  --796431

ALTER procedure [dbo].[ad_getParTovar1]
@drcode int

as

DECLARE @tov table (tovar int, lot int, price money, corr int, quantity int)
DECLARE @result table (tovar int, parcel int, lot int, price money, corr int, quantity int)

DECLARE @tovar1 varchar(max)='Не хватает товаров:'+CHAR(13)+CHAR(10)
DECLARE @q int=0
INSERT INTO @tov
SELECT tovar, lot, price, corr, quantity FROM document WHERE upcode=@drcode--796431

DECLARE @ostatq table (tovar int, company int, parcel int, lot int, quantity int)
INSERT INTO @ostatq

SELECT o.tovar, o.company, o.parcel, o.lot, o.quantity 
FROM ostatq o inner join @tov t on t.tovar=o.tovar AND t.corr=o.company and t.lot=o.lot
WHERE o.balance=23 and o.account='22' and o.quantity>0

;WITH t as (
SELECT DISTINCT tovar,company,parcel,lot,quantity 
 
FROM @ostatq),

t1 as (
SELECT tovar,SUM(quantity) quantity 

FROM t 
GROUP BY tovar),
t2 as (
SELECT tovar,SUM(quantity) quantity1 
 
FROM @tov 
GROUP BY tovar),

t3 as (
SELECT t1.tovar as tovar,isnull(t1.quantity,0)-t2.quantity1 as q  
 
FROM t1 
RIGHT JOIN t2 
ON t1.tovar=t2.tovar
)

	SELECT @tovar1=@tovar1+(case when q<0 then convert(varchar(100),tovar) else '' end)+CHAR(13)+CHAR(10)/*(case when q<0 then convert(varchar(100),tovar)*/ /*else '' end)*/,@q=@q+(case when q<0 then 1 else 0 end) 
	FROM t3 
	IF (@q>0)
	begin
	raiserror(@tovar1,16,1)
	RETURN
	end
	

DECLARE
@tovar int,
@corr int,
@parcel int,
@lot int,
@price money,
@quantity int,
@ost int

WHILE exists(select tovar from @tov where quantity>0) AND exists(select tovar from @ostatq where quantity>0)
BEGIN
	SELECT top 1 @tovar=tovar, @lot=lot, @corr=corr, @price=price, @quantity=quantity FROM @tov WHERE quantity>0
	SELECT top 1 @ost=quantity, @parcel=parcel FROM @ostatq WHERE @tovar=tovar AND @lot=lot AND @corr=company AND quantity>0 ORDER BY parcel
	
	IF @ost>@quantity
	BEGIN
		UPDATE @tov SET quantity=0 WHERE @tovar=tovar AND @lot=lot AND @corr=corr AND @price=price
		INSERT INTO @result (tovar, parcel, lot, price, corr, quantity ) VALUES (@tovar, @parcel, @lot, @price, @corr, @quantity)
		UPDATE @ostatq SET quantity=quantity-@quantity WHERE @tovar=tovar AND @lot=lot AND @corr=company AND @parcel=parcel
	END
	
	ELSE
	BEGIN
		UPDATE @tov SET quantity=quantity-@ost WHERE @tovar=tovar AND @lot=lot AND @corr=corr AND @price=price
		INSERT INTO @result (tovar, parcel, lot, price, corr, quantity ) VALUES (@tovar, @parcel, @lot, @price, @corr, @ost)
		UPDATE @ostatq SET quantity=0 WHERE @tovar=tovar AND @lot=lot AND @corr=company AND @parcel=parcel	
	END
END

SELECT DISTINCT b.*,a.oper 
FROM @result b 
INNER JOIN (SELECT DISTINCT tovar,oper  FROM document WHERE upcode=@drcode) a 
ON b.tovar=a.tovar

if OBJECT_ID('tempdb..#t') is not null
drop table #t
if OBJECT_ID('tempdb..#t1') is not null
drop table #t1
if OBJECT_ID('tempdb..#t2') is not null
drop table #t2
if OBJECT_ID('tempdb..#t3') is not null
drop table #t3