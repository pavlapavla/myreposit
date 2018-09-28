select n.code, dc.quantity from doc_ref dr
inner join document dc
	on dc.upcode=dr.code
inner join nomencl n
	on n.code=dc.tovar AND n.upcode!=19350
	where dr.code=738015
	


select ncd.*
from nomencl n
	INNER JOIN
		nomparam np (NOLOCK) 
			ON n.code=np.upcode
	INNER JOIN
		nom_complect_ref ncr (NOLOCK) 
			ON ncr.code=np.idComplect 
	INNER JOIN 
		nom_complect_det ncd (NOLOCK) 
			ON ncr.code=ncd.upcode and (quantity1!=0 OR quantity2!=0)
WHERE 
n.code=49916

select ncd.*
from nomencl n
	INNER JOIN
		nomparam np (NOLOCK) 
			ON n.code=np.upcode
	INNER JOIN
		nom_complect_ref ncr (NOLOCK) 
			ON ncr.code=np.idComplect 
	INNER JOIN 
		nom_complect_det ncd (NOLOCK) 
			ON ncr.code=ncd.upcode and (quantity1!=0 OR quantity2!=0)
WHERE 
n.code=52068


--49916 

/*
1 стул
weight1 = 7600

2 стул
weight1 = 8100 
weight2 = 6600

3 стула
weight1 = 10800
weight2 = 8800

*/
/*
weight1 = 10800
weight2 = 8800
weight3 = 11000
weight4 = 11000
*/


