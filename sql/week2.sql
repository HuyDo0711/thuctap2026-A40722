--Week 2
--Q1:1.	Liệt kê các giá trị khác nhau của invoice_type cùng số hóa đơn, tổng actual_amount, số hóa đơn có tiền âm.Dựa vào kết quả, đoán ý nghĩa của từng loại 550, 551, 552, 553.
SELECT  invoice_type, 
        count(invoice_id) as total_order, 
        sum(cast(actual_amount as DECIMAL(18,2))) as total_actual_amount,
        count(CASE when cast(actual_amount as DECIMAL(18,2))<0 then 1 end) as negative_amount
from masked_data.invoice
group by invoice_type;
/*"invoice_type","total_order","total_actual_amount","negative_amount"
"550","230042","129218691042.00","292"
"551","6551","2211711133.00","0"
"552","3204","3469585593.00","0"
"553","12148"," -2113246765.00","7914"
*/
/*
550: normal invoice
551-552: special invoice
553: 
*/

--Q2:2.	Số hóa đơn và doanh thu theo sale_channel. Có bao nhiêu hóa đơn không có kênh bán?
select  sale_channel,
        count(DISTINCT invoice_id) as total_order,
        sum(cast(actual_amount as DECIMAL(18,2))) as total_sales
from masked_data.invoice
group by sale_channel;
/*"sale_channel","total_order","total_sales"
"Adayroi","378","909469.00"
"Haravan","4","1127189.00"
"Shopee","6546","2210344744.00"
"Tại cửa hàng","242778","129108827141.00"
"Tiktok","216","56890430.00"
"","2023","1408642030.00"
*/
/*2023 invoice with no channel*/


--Q3: 10 hóa đơn có actual_amount lớn nhất: invoice_number, ngày, branch_name, sale_channel, số tiền. Có hóa đơn nào bất thường không?
select invoice_number, invoice_date, branch_name, sale_channel, cast(actual_amount as DECIMAL(18,2)) as actual_amount
from masked_data.invoice
order by actual_amount desc
limit 10;
/*"invoice_number","invoice_date","branch_name","sale_channel","actual_amount"
"015-2512020001","2025-12-01 09:41:26.000","PB - Vinatex 25 Bà Triệu","Tại cửa hàng","104066000.00"
"015-2505020001NB","2025-05-26 23:21:00.000","PB - Vinatex 25 Bà Triệu","Tại cửa hàng","98671000.00"
"015-2502020001NB","2025-01-26 00:22:00.000","PB - Vinatex 25 Bà Triệu","Tại cửa hàng","86601000.00"
"015-2510020001NB","2025-10-25 23:17:00.000","PB - Vinatex 25 Bà Triệu","Tại cửa hàng","79436000.00"
"015-2504020001","2025-04-28 13:29:32.000","PB - Vinatex 25 Bà Triệu","Tại cửa hàng","79429000.00"
"015-2506020001NB","2025-06-25 23:30:00.000","PB - Vinatex 25 Bà Triệu","Tại cửa hàng","78569000.00"
"015-2509020001NB","2025-08-25 23:46:00.000","PB - Vinatex 25 Bà Triệu","Tại cửa hàng","73475000.00"
"015-2509020002NB","2025-09-25 23:27:00.000","PB - Vinatex 25 Bà Triệu","Tại cửa hàng","60740000.00"
"060-2507030001","2025-07-28 11:10:44.000","PN - Online HCM","Tại cửa hàng","60326000.00"
"015-2507020001NB","2025-07-26 23:15:00.000","PB - Vinatex 25 Bà Triệu","Tại cửa hàng","60326000.00"
*/
/*
Không có hóa đơn nào bất thường
*/


--Q4:Đếm số điểm bán trong branch theo channel và area. Có bao nhiêu cửa hàng Retail đang hoạt động (status = 'Com')?

select channel, area, count(location_code) as total_branch
from masked_data.branch
--where status = 'Com' and channel = 'Retail'
group by channel, area
limit 10;
/*"channel","area","total_branch"
"Wholesales","WS","36"
"Corp","North","3"
"Corp","","1"
"Ecom","Tiktok","1"
"Ecom","Lazada","1"
"Ecom","Web","1"
"Retail","South","35"
"Ecom","South","2"
"Warehouse","North","2"
"Corp","South","1"
*/

/* Có 30 cửa hàng Retail đang hoạt động */


--Q5:Số khách hàng theo member_level_name trong bảng customer, kèm tỷ lệ % trên tổng.
select  member_level_name,
        count(customer_id) as total_customer,
        round(100.0*count(customer_id)/ sum(count(*)) over(),2) as percent
FROM masked_data.customer
group by member_level_name;
/*"member_level_name","total_customer","percent"
"Thỏ Bạc","95223","19.23"
"Thỏ Bạch Kim","4049","0.82"
"Thỏ Kim Cương","2032","0.41"
"Thỏ Nhí","362375","73.17"
"Thỏ Vàng","27394","5.53"
"","3155","0.64"
*/

--Q6: Trong item: số mẫu sản phẩm theo group_cat và gender. Nhóm nào có nhiều mẫu nhất?

select group_cat , gender, count(product_name) as total_sample
from masked_data.item
group by group_cat, gender
order by total_sample desc
limit 10;

/*"group_cat","gender","total_sample"
"03. Dress (đầm & yếm)","Bé gái","3170"
"01. Top (áo)","Bé trai","2512"
"01. Top (áo)","Bé gái","1596"
"02. Bottom (quần & chân váy)","Bé trai","1174"
"06. Others","Unisex","1153"
"04. Set (bộ)","Bé trai","1133"
"04. Set (bộ)","Bé gái","948"
"02. Bottom (quần & chân váy)","Bé gái","934"
"06. Others","Bé gái","525"
"04. Set (bộ)","Trẻ em","489"
*/

/*Dress là nhóm có nhiều mẫu nhất */

--Q7: Doanh thu, số hóa đơn và giá trị đơn trung bình (AOV) theo từng tháng năm 2025.

select  EXTRACT(MONTH from invoice_date::timestamp) as month,
        sum(actual_amount::numeric) as total_actual_amount,
        count(invoice_id) as total_order,
        round(avg(actual_amount::numeric),2) as aov
from masked_data.invoice
where   is_revenue_valid::boolean = TRUE 
        and is_cancelled::boolean = FALSE 
        and invoice_date::TIMESTAMP >= DATE '2025-01-01'
        AND invoice_date::TIMESTAMP <  DATE '2026-01-01'  
group by EXTRACT(MONTH from invoice_date::timestamp);
/*"month","total_actual_amount","total_order","aov"
"1","19516834824.0","31273","624079.39"
"2","4257738630.0","8655","491939.76"
"3","7022835559.0","13591","516726.92"
"4","11170038157.0","21104","529285.36"
"5","11636484435.0","21878","531880.63"
"6","11420971460.0","19149","596426.52"
"7","9290261717.0","16562","560938.40"
"8","11657225571.0","22294","522886.23"
"9","9639014653.0","20324","474267.60"
"10","10417564970.0","20048","519631.13"
*/

--q8:Doanh thu theo thứ trong tuần (EXTRACT(ISODOW ...)). Ngày nào bán tốt nhất?

select  EXTRACT(isodow from invoice_date::timestamp) as day_of_week,
        sum(actual_amount::numeric) as total_sales
from masked_data.invoice
group by  EXTRACT(isodow from invoice_date::timestamp)
order by total_sales desc;

/*"day_of_week","total_sales"
"7","29032513734.0"
"6","28635659868.0"
"5","16312317032.0"
"3","15170243199.0"
"4","14719830369.0"
"1","14513156137.0"
"2","14403020664.0"
*/

-- Sunday is the day with the highest sales of the week

--Q9:9.	Số hóa đơn theo khung giờ trong ngày (EXTRACT(HOUR ...)). Giờ cao điểm là giờ nào?

select  extract(hour from invoice_date::timestamp) as hour,
        count(invoice_id) as total_order
from masked_data.invoice
group by extract(hour from invoice_date::timestamp)
order by total_order desc
limit 10;

/*"hour","total_order"
"20","26414"
"21","26263"
"15","25096"
"16","23753"
"14","22458"
"19","20567"
"11","19262"
"17","18024"
"18","16514"
"13","15954"
*/
/*8 pm là giờ cao điểm */

--q10: Tỷ lệ hóa đơn có customer_id (khách thành viên) so với khách vãng lai, theo tháng.
select  extract(month from invoice_date::timestamp) as month,
        round(count(case when customer_id is not null then 1 end)*100.0/count(*), 2) as percent_member,
        round(count(case when customer_id is null then 1 end)*100.0/count(*), 2) as percent_non_member
from masked_data.invoice
group by extract(month from invoice_date::timestamp)
order by month;

/*"month","percent_member","percent_non_member"
"1","49.41","50.59"
"2","36.16","63.84"
"3","39.61","60.39"
"4","40.38","59.62"
"5","39.01","60.99"
"6","40.98","59.02"
"7","36.01","63.99"
"8","40.83","59.17"
"9","36.64","63.36"
"10","40.56","59.44"
"11","42.01","57.99"
"12","31.09","68.91"
*/

--q11: Doanh thu theo area (North / South / Middle…) bằng cách nối invoice với branch.
select b.area, 
       sum(i.actual_amount::numeric) as total_sales
from masked_data.invoice as i
left join masked_data.branch as b on i.branch_code = b.location_code
group by b.area;
/*"area","total_sales"
"Middle","7997187583.0"
"North","46125612535.0"
"South","78281474515.0"
"","382466370.0"
*/

--q12: Top 10 cửa hàng Retail theo doanh thu, kèm số hóa đơn và AOV.

select  i.branch_name,
        sum(i.actual_amount::numeric) as total_sales,
        count(i.invoice_id) as total_order,
        round(avg(i.actual_amount::numeric),2) as aov
from masked_data.invoice as i
left join masked_data.branch as b on i.branch_code = b.location_code
where b.channel = 'Retail'
group by i.branch_name
order by total_sales desc
limit 10;

/*"branch_name","total_sales","total_order","aov"
"PN - Vincom Đà Nẵng","6336760789.0","8848","716180.02"
"PN - Sense City Phạm Văn Đồng","6218302369.0","9351","664987.96"
"PN - Aeon Tân Phú S57","5576849380.0","8933","624297.48"
"PN - Hai Bà Trưng","5267893308.0","5733","918872.02"
"PN - Vạn Hạnh","4829870580.0","7217","669235.22"
"PB - Aeon T225 Long Biên","4723214770.0","9007","524393.78"
"PB - Siêu Thị Aeon Long Biên","4067803193.0","4242","958935.22"
"PN - Aeon Bình Tân S17","3926763264.0","6386","614901.86"
"PN - Takashimaya","3830215700.0","4164","919840.47"
"PB - Siêu Thị Aeon Hà Đông","3656674588.0","6356","575310.67"
*/

--q13: Top 10 SKU bán chạy nhất theo tổng số lượng (invoice_detail nối sku): mã SKU, tên, màu, size, số lượng.

select 
        id.item_code as sku_code,
        s.sku_name,
        s.color_name,
        s.size_name,
        sum(id.quantity::numeric) as total_quantity
from masked_data.invoice_detail as id
left join masked_data.sku as s on id.item_code = s.sku
group by id.item_code, s.sku_name, s.color_name, s.size_name
order by total_quantity desc
limit 10;

/*"sku_code","sku_name","color_name","size_name","total_quantity"
"","","","",""
"20001000","Túi đựng hàng Rabity loại nhỏ","(blank)","Free size","66608.0"
"20002000","Túi đựng hàng Rabity loại vừa","(blank)","Free size","33211.0"
"99200125","992.001 Túi giấy Rabity nhỏ","Xanh lá cây","1Y-9-11kg","30368.0"
"99200225","Túi giấy Rabity trung - 992.002","Xanh lá cây","2Y-11-12kg","14893.0"
"70032000","Quà tặng kẹo túi Cham quà bí mật - 70.032","Túi ngẫu nhiên","Free size","6667.0"
"33036040","Set 2 quần lót BG 33.036 (size 4)","Màu Ngẫu Nhiên","4Y-14-16kg","5105.0"
"33036060","Set 2 quần lót BG 33.036 (size 6)","Màu Ngẫu Nhiên","6Y-19-21kg","4824.0"
"33036020","Set 2 quần lót BG 33.036 (size 2)","Màu Ngẫu Nhiên","2Y-11-12kg","4566.0"
"20003000","Túi đựng hàng Rabity loại to","(blank)","Free size","4228.0"
*/

--Q14: Doanh thu dòng hàng (invoice_detail.total_amount) theo group_cat (nối invoice_detail → sku → item).
select  i.group_cat,
        sum(id.total_amount::numeric) as total_sales
from masked_data.invoice_detail as id
left join masked_data.sku as s on id.item_code = s.sku
left join masked_data.item as i on s.item_no = i.item
group by i.group_cat;

--Q15: 15.	Doanh thu theo item.gender (Bé gái, Bé trai, Trẻ em, Unisex) và theo season.
select  i.gender,
        i.season,
        sum(id.total_amount::numeric) as total_sales
from masked_data.invoice_detail as id
left join masked_data.sku as s on id.item_code = s.sku
left join masked_data.item as i on s.item_no = i.item
group by i.gender, i.season;

/*"gender","season","total_sales"
"Bé gái","Fall - Winter","13842950927.0"
"Bé gái","Others","38223025.0"
"Bé gái","Spring - Summer","60459544220.0"
"Bé gái","Year-round","9945916157.0"
"Bé trai","Fall - Winter","11024762134.0"
"Bé trai","Others","46126687.0"
"Bé trai","Spring - Summer","28839198550.0"
"Bé trai","Year-round","3935329091.0"
*/