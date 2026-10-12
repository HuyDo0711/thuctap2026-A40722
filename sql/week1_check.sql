--Q1:Đếm số dòng của cả 7 bảng trong một câu truy vấn
SELECT COUNT(*) as invoice_count FROM masked_data.invoice
---121
union all
SELECT COUNT(*) as invoice_detail_count FROM masked_data.invoice_detail
---15606
union all
SELECT COUNT(*) as sku_count  FROM masked_data.sku
---36109
union all
SELECT COUNT(*) as customer_count FROM masked_data.customer
---270300
union all
SELECT COUNT(*) as item_count FROM masked_data.item
---251945
union all
SELECT COUNT(*) as branch_count FROM masked_data.branch
---495263
union all
SELECT COUNT(*) as customer_points_count FROM masked_data.customer_points;
---730888

--Q2:
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'masked_data'
  AND table_name = 'invoice'
ORDER BY ordinal_position;
/*"column_name","data_type"
"invoice_id","text"
"invoice_number","text"
"invoice_type","text"
"invoice_date","text"
"invoice_time","text"
"branch_id","text"
"branch_name","text"
"total_item_amount","text"
"total_amount","text"
"actual_amount","text"
"discount_amount","text"
"vat_amount","text"
"cost_amount","text"
"cash_amount","text"
"card_amount","text"
"customer_id","text"
"cashier","text"
"sale_staff","text"
"sale_channel","text"
"member_level","text"
"payment_status","text"
"payment_status_label","text"
"is_cancelled","text"
"is_failed","text"
"is_revenue_valid","text"
"is_cod","text"
"delivery_date","text"
"shipping_partner_name","text"
"updated_at","text"
"ingested_at","text"
"branch_code","text"
*/
---Cột ngày và giờ và cột tiền đang được lưu dưới dạng text, cần convert sang date và numeric để phục vụ cho việc phân tích, tính toán dữ liệu

--Q3:
SELECT * FROM masked_data.invoice limit 10;
---một dòng của bảng này là một hóa đơn, chứa những thông tin trong hóa đơn
SELECT * FROM masked_data.invoice_detail LIMIT 10;
---một dòng của bảng này mô tả chi tiết những sản phẩm có trong hóa đơn, chiết khấu khuyến mãi,...
SELECT * FROM masked_data.sku LIMIT 10;
---một dòng của bảng này mô tả thông tin về một sản phẩm, bao gồm tên, giá, loại sản phẩm, thương hiệu,...
SELECT * FROM masked_data.customer LIMIT 10;
---mot dòng của bảng này mô tả thông tin về một khách hàng, bao gồm tên, địa chỉ, số điện thoại, email,...
SELECT * FROM masked_data.item LIMIT 10;
---một dòng của bảng này mô tả thông tin về một mặt hàng, bao gồm tên, giá, loại sản phẩm, thương hiệu,...
SELECT * FROM masked_data.branch LIMIT 10;
---một dòng của bảng này mô tả thông tin về một chi nhánh, bao gồm tên, địa chỉ, số điện thoại, email,...
SELECT * FROM masked_data.customer_points LIMIT 10;
---một dòng của bảng này mô tả thông tin về điểm thưởng của một khách hàng, bao gồm số điểm, ngày hết hạn, trạng thái,...
select count(distinct invoice_id) from masked_data.invoice;

--Q4:
--- kết quả khớp với số dòng trong mô tả dữ liệu, vì thế khóa chính của invoice là duy nhất, không bị trùng lặp giá trị nào.
select count(distinct sku) from masked_data.sku;
---  kết quả khớp với số dòng trong mô tả dữ liệu, vì thế khóa chính của sku là duy nhất, không bị trùng lặp giá trị nào.

--Q5:
select count(item_code)*100.0/count(*) from masked_data.invoice_detail ;
---"99.9979477019734898% số dòng trong bảng invoice_detail tìm được sku tương ứng"
select count(branch_id)*100.0/count(*) from masked_data.invoice;
---100% số dòng trong bảng invoice tìm được branch tương ứng

--Q6:
select min(invoice_date), max(invoice_date) from masked_data.invoice;
---"min":"2025-01-01 08:58:07.000" ,"max": "2025-12-30 22:00:00.000"

