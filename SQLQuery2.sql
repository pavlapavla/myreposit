-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
alter PROCEDURE Getdocument(@docrefcode int)
AS

declare @code int,@quantity  int
create table ##Weight(lc_weight varchar(30),lc_weight1 varchar(30),lc_weight2 varchar(30),lc_weight3 varchar(30),lc_weight4 varchar(30),lc_weight5 varchar(30))

DECLARE CurDocument CURSOR 
   LOCAL FORWARD_ONLY STATIC READ_ONLY
   FOR select n.code, dc.quantity from doc_ref dr
inner join document dc
	on dc.upcode=dr.code
inner join nomencl n
	on n.code=dc.tovar AND n.upcode!=19350
	where dr.code=@docrefcode
OPEN CurDocument

FETCH NEXT FROM CurDocument INTO @code,@quantity
WHILE (@@FETCH_STATUS = 0)
BEGIN




 FETCH NEXT FROM CurDocument INTO @code,@quantity
END

CLOSE CurDocument
DEALLOCATE CurDocument
GO
