
--exec ad_loadBnFromCSV3

alter procedure ad_loadBnFromCSV3
as
declare
	@name varchar(500) --='НОВЫЕ СТУЛЬЯ ООО (7733186670%5C773301001)_СКАРАБЕЙ_РЕАЛИЗАЦИИ (АКТЫ) №СРБ17032102 ОТ 21 МАРТА 2017 Г 2.csv'

IF OBJECT_ID('tempdb.dbo.#csv_import') IS NOT NULL
	drop table #csv_import	

CREATE TABLE [dbo].[#CSV_import](
	[F1] [varchar](500) NULL,
	[F2] [varchar](500) NULL,
	[F3] [varchar](500) NULL,
	[F4] [varchar](500) NULL,
	[F5] [varchar](500) NULL,
	[F6] [varchar](500) NULL,
	[F7] [varchar](500) NULL,
	[F8] [varchar](500) NULL,
	[F9] [varchar](500) NULL,
	[F10] [varchar](500) NULL,
	[F11] [varchar](500) NULL,
	[F12] [varchar](500) NULL,
	[F13] [varchar](500) NULL,
	[F14] [varchar](500) NULL,
	[F15] [varchar](500) NULL,
	[F16] [varchar](500) NULL,
	[F17] [varchar](500) NULL,
	[F18] [varchar](500) NULL,
	[F19] [varchar](500) NULL,
	[F20] [varchar](500) NULL,
	[F21] [varchar](500) NULL,
	[F22] [varchar](500) NULL,
	[F23] [varchar](500) NULL,
	[F24] [varchar](500) NULL,
	[F25] [varchar](500) NULL,
	[F26] [varchar](500) NULL,
	[F27] [varchar](500) NULL,
	[F28] [varchar](500) NULL
) ON [PRIMARY]

IF OBJECT_ID('tempdb.dbo.#Doc') IS NOT NULL
	drop table #Doc	

CREATE TABLE [dbo].[#Doc](
	tovarname [varchar](500) NULL,
	tovarcount int,
	tovar int,
	quantity int,
	price money,
	country varchar(50),
	GTD varchar(50)
) ON [PRIMARY]

IF OBJECT_ID('tempdb.dbo.#Nom') IS NOT NULL
	drop table #Nom

CREATE TABLE [dbo].[#Nom](
	code int,
	name varchar(500),
	GTD varchar(50)
) ON [PRIMARY]


BULK INSERT #csv_import FROM 'E:\sql_bulk\boxberryfile.txt'
WITH (FIELDTERMINATOR ='	', codepage=1251);
--select * from #csv_import
select 
	trecknum=cast(F11 AS varchar(250)),
	dat=cast(F21 AS date),
	summ=CAST(replace(isnull(F27,0),'"','') as varchar(250))
	--summ=cast(CASE WHEN ISNUMERIC(replace(F24,' ',''))=1 THEN replace(F24,' ','') ELSE '0' END AS money)


from #CSV_import where len(f21)=10

--INSERT INTO #Doc (tovarname,quantity,price,country,GTD)
--SELECT REPLACE(i.f2,'"',''), CAST(CAST(replace(replace(i.F9,'"',''),'.000','')AS money) AS int), CAST(REPLACE(REPLACE(i.F23,'"',''),' ','') AS money), CASE i.f26 WHEN '--' THEN 'РОССИЯ' ELSE i.f26 END, CASE i.F27 WHEN '--' THEN '' ELSE i.F27 END
--FROM #csv_import i
--WHERE ISNULL(F17,'')='18%'
--UPDATE #Doc SET price=CASE WHEN quantity=0 THEN price ELSE ROUND(price/quantity,4) END
--DECLARE @inn1 char(20), @inn2 char(20), @doc_ref int,
--@c_from int, @c_to int, @nn varchar(10), @date date, @date2 varchar(30)

--SELECT
--	@date2=LTRIM(RTRIM(SUBSTRING(F2,CHARINDEX('от',F2)+3, LEN(F2)-CHARINDEX('от',F2)-5))),
--	@nn=LTRIM(RTRIM(SUBSTRING(F2,CHARINDEX('№',F2)+2, CHARINDEX('от',F2,10)-CHARINDEX('№',F2)-2))) FROM #csv_import i WHERE F2 like '%Счет-фактура №%'
--SELECT 
--	@inn1=SUBSTRING(F2,CHARINDEX(':',F2)+2, CHARINDEX('/',F2,10)-CHARINDEX(':',F2)-2) FROM #csv_import i WHERE F2 like '%ИНН/КПП продавца:%'
--SELECT 
--	@inn2=SUBSTRING(F2,CHARINDEX(':',F2)+2, CHARINDEX('/',F2,10)-CHARINDEX(':',F2)-2) FROM #csv_import i WHERE F2 like '%ИНН/КПП покупателя:%'

--SELECT top 1 @c_from=code FROM uchet..company WHERE inn IN (@inn1)
--SELECT top 1 @c_to=code FROM uchet..company WHERE inn IN (@inn2)
--SET @date=CAST(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@date2
--,' января ','.01.'),' февраля ','.02.'),' марта ','.03.'),' апреля ','.04.'),' мая ','.05.'),' июня ','.06.')
--,' июля ','.07.'),' августа ','.08.'),' сентября ','.09.'),' октября ','.10.'),' ноября ','.11.'),' декабря ','.12.')AS date)

--select date=@date, NN=@nn, c_from=ISNULL(@c_from,1), c_to=ISNULL(@c_to,1), name=@name


--;WITH 
--	nom AS (
--		SELECT distinct code, name FROM uchet.dbo.NomHist (NOLOCK) WHERE name NOT LIKE '%брак%'
--		UNION SELECT distinct code, name FROM uchet.dbo.nomencl	(NOLOCK) WHERE name NOT LIKE '%брак%'
--		),
--	nomgtd AS (
--	SELECT n.code, n.name, d.gtd
--	FROM nom n 
--	LEFT JOIN (
--		SELECT 
--			distinct dc.tovar, gtd=p.name 
--		FROM 
--			uchet.dbo.document dc (NOLOCK)
--		INNER JOIN uchet.dbo.parcel p (NOLOCK)
--			ON p.code=dc.parcel
--		INNER JOIN uchet.dbo.doc_ref dr (NOLOCK)
--			ON dc.upcode=dr.code
--		WHERE dr.type_doc='П/Ни'
--	) AS d ON n.code=d.tovar
--)
--INSERT INTO #Nom
--select * from nomgtd


--;WITH t AS (
--	SELECT i.tovarname, cnt=count(distinct n.code)
--	FROM #Doc i
--	LEFT JOIN #Nom n (NOLOCK)
--	ON n.name LIKE ltrim(rtrim(i.tovarname))+'%'
--	GROUP BY i.tovarname
--)
--UPDATE d SET tovarcount=t.cnt
--FROM #Doc d INNER JOIN t ON d.tovarname=t.tovarname

--UPDATE i SET tovar=n.code
--FROM #Doc i
--LEFT JOIN #Nom n (NOLOCK)
--ON n.name LIKE ltrim(rtrim(i.tovarname))+'%'
--WHERE tovarcount=1

--;WITH t AS (
--	SELECT i.tovarname, cnt=count(distinct n.code), code=MAX(n.code)
--	FROM #Doc i
--	LEFT JOIN #Nom n (NOLOCK)
--		ON n.name LIKE ltrim(rtrim(i.tovarname))+'%' AND i.GTD=n.GTD
--	WHERE tovarcount>1 
--	GROUP BY i.tovarname
--	HAVING count(distinct n.code)=1
--)
--UPDATE d SET tovarcount=t.cnt, tovar=t.code
--FROM #Doc d INNER JOIN t ON d.tovarname=t.tovarname

----select * from #Doc 

--exec InitProcess 555,0

--INSERT INTO uchet.dbo.doc_ref (owner, type_doc, date, nn, dogovor, c_from, c_to, name)
--SELECT 23, 'Бн2', @date, @nn, 0, ISNULL(@c_from,1), ISNULL(@c_to,1), @name

--SET @doc_ref=SCOPE_IDENTITY()

----select @doc_ref

--INSERT INTO uchet.dbo.document (upcode, oper, tovar, quantity, edizm, price, amount, valuta, note, memo)
--SELECT @doc_ref, 207, ISNULL(tovar,1000), quantity, 'шт.', Round(price,2), quantity*Round(price,2), 'руб.', tovarname,dbo.Memoset(dbo.Memoset('',1,GTD),2,country) FROM #Doc 

--UPDATE dr SET total=(SELECT SUM(amount) FROM document dc WHERE dc.upcode=dr.code) FROM doc_ref dr WHERE code=@doc_ref

--RETURN @doc_ref

