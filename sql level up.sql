--set statistics io on
/*
------------cross apply
select o.id orderid,
       quantity, 
	   t.*
from [order] o
cross apply
		(
			select top 1 *
			from orderItem od
			where o.Id = od.OrderId
			order by od.quantity desc
		) t
order by o.id

select  o.id orderid,
        od.quantity, 
		od.*
from [order] o join
(
	select row_number() over (partition by orderid order by oi.quantity desc) num
	       ,*
	from orderitem oi
) od on o.id = od.OrderId
where od.num = 1
order by o.id
*/



/*
--------partition by

select distinct 
       o.Id,
       o.ShippingMethod,
	   o.CustomerId,
	   o.PaidDateUtc,
       sum(od.quantity) over(partition by od.orderId) quantity,
	   sum(od.priceInclTax) over(partition by od.orderId) total,
	   o.OrderTotal
from OrderItem od join [Order] o on od.OrderId = o.Id

select o.Id,
       o.ShippingMethod,
	   o.CustomerId,
	   o.PaidDateUtc,
	   ord.quantity,
	   ord.total,
	   o.OrderTotal
from [Order] o join(select od.OrderId,
                           sum(od.quantity) quantity,
						   sum(od.priceInclTax) total
					from OrderItem od
					group by od.OrderId) ord on o.Id = ord.OrderId
*/

/*
-----------grouping sets
select CustomerId,
       null as shippingMethod, 
       sum(ordertotal) total
from [Order] o
group by CustomerId
union all
select null as CustomerId, 
       shippingMethod,
       sum(ordertotal) total
from [Order] o
group by shippingMethod

select customerId,
       shippingmethod
	   ,sum(ordertotal)
from [Order] o
group by grouping sets (customerId, shippingmethod)
*/


/*
----------lead
select  o1.id
       ,o1.r1
	   ,o1.customerId
	   ,o1.c1
	   ,o1.orderTotal
	   ,'|' '|'
	   ,o2.id
	   ,o2.r2
	   ,o2.customerId
	   ,o2.c2
	   ,o2.orderTotal
from (
	      select o.Id,
          	     row_number() over (order by o.id) r1,
				 orderTotal,
				 o.customerId,
		         row_number() over (partition by o.customerId order by o.id) c1
          from [Order] o
	  ) o1 left join 
	  (
	      select o.Id, 
	             row_number() over (order by o.id) r2,
				 orderTotal,
				 o.customerId,
		         row_number() over (partition by o.customerId order by o.id) c2
	      from [order] o
	   ) o2 on o1.c1 = o2.c2 - 1 and o1.CustomerId = o2.CustomerId --on o1.r1 = o2.r2 - 1
where o1.c1 = 1 and o1.ordertotal <= o2.ordertotal
order by o1.r1

select orderTotal, *
from
(
select
	row_number() over (partition by customerId order by id) as num,
	lead(orderTotal, 1, -1) over (partition by customerId order by id) as leadOrderTotal
	,*
from [order]
) o
where orderTotal <= leadOrderTotal and 
      leadOrderTotal <> -1 and
	  num = 1
*/


--select id, customerid, ordertotal
--from [Order]
--order by customerid, id

--select customerid
--from [order]
--group by customerid
--having count(*) > 1

--select CustomerId,
--       null as shippingMethod, 
--       sum(ordertotal) total
--from [Order] o
--group by CustomerId with rollup

/*
select o.Id,
       o.ShippingMethod,
	   o.CustomerId,
	   o.PaidDateUtc
from 

select *
from OrderItem

select *
from [Order]
*/