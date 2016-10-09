select   DocumentName as DOCUMENTNAME
		,Number as NUMBER
		,dbo.fnFormatDate([Date], 'YYYY-MM-DD') as [DATE]
		,dbo.fnFormatDate(DeliveryDate, 'YYYY-MM-DD') as DELIVERYDATE
		,Info as INFO
		,'GRN' as CURRENCY
		,(
			select
					 c_supplier.Code  SUPPLIER
					,c_buyer.Code as BUYER 
					,c_buyer.Code as DELIVERYPLACE 
					,c_supplier.Code as SENDER 
					,c_buyer.Code as RECIPIENT 
			
					,(
						select  od.PositionNumber as POSITIONNUMBER
							   ,pf.BarCode as PRODUCT
							   ,FORMAT(od.Quantity,'N','ru-RU' ) as ORDEREDQUANTITY
							   ,FORMAT(od.UnitPrice,'N','ru-RU' ) as ORDERPRICE
							   ,20 as VAT --!!!!!!!!!!!!!!!!
						from OrderDetails od
							join [dbo].[TradeOfferProduct] tp on tp.Id = od.TradeOfferProductId
							join [dbo].[CompanyProduct] cp on cp.id = tp.CompanyProductId
							join [dbo].[ProductFactory] pf on pf.id = cp.ProductFactoryId
						where od.Orderid=o.id
						--for xml path('POSITION'), type
					) 
		 )nn
from [dbo].[Order] o join dbo.Company c_supplier
	on c_supplier.Id = o.SupplierId
	join dbo.Company c_buyer
	on c_buyer.Id = o.BuyerId






select 
	DocumentName as DOCUMENTNAME
	,Number as NUMBER
	,dbo.fnFormatDate([Date], 'YYYY-MM-DD') as [DATE]
	,dbo.fnFormatDate(DeliveryDate, 'YYYY-MM-DD') as DELIVERYDATE
	,Info as INFO
	,'GRN' as CURRENCY --!!!!!!!!!!!!!!!!
	,(
		select 
		(select code from [dbo].[Company] where id=ord.SupplierId) as SUPPLIER 
		,(select code from [dbo].[Company] where id=ord.BuyerId) as BUYER 
		,(select code from [dbo].[Company] where id=ord.BuyerId) as DELIVERYPLACE 
		,(select code from [dbo].[Company] where id=ord.SupplierId) as SENDER 
		,(select code from [dbo].[Company] where id=ord.BuyerId) as RECIPIENT, 
		(
			select ofd.PositionNumber as POSITIONNUMBER, pf.BarCode as PRODUCT
			,FORMAT(ofd.Quantity,'N','ru-RU' ) as ORDEREDQUANTITY
			,FORMAT(ofd.UnitPrice,'N','ru-RU' ) as ORDERPRICE
			,20 as VAT --!!!!!!!!!!!!!!!!
			from OrderDetails ofd
			inner join [dbo].[TradeOfferProduct] op on op.Id = ofd.TradeOfferProductId
			join [dbo].[CompanyProduct] cp on cp.id = op.CompanyProductId
			join [dbo].[ProductFactory] pf on pf.id = cp.ProductFactoryId
			where ofd.Orderid=ord.id
			for xml path('POSITION'), type
		) 
		for xml path('HEAD'), type
	)

from [dbo].[Order] as ord

for xml path ('ORDER'), type