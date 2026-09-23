-- Data migration: Unit enum NT1/NT2/XN_BO/TT_BTSC/BAN_CO_GIOI → KOUN_MOM/SNOUL/NAM_LAO
-- Chạy TRƯỚC khi alter enum để tránh constraint violation

-- 1. Users: BAN_CO_GIOI + TX-NL- prefix → NAM_LAO
UPDATE users SET unit = 'NAM_LAO' WHERE unit = 'BAN_CO_GIOI' AND code LIKE 'TX-NL-%';

-- 2. Users: BAN_CO_GIOI + TX-SN- prefix → SNOUL
UPDATE users SET unit = 'SNOUL' WHERE unit = 'BAN_CO_GIOI' AND code LIKE 'TX-SN-%';

-- 3. Users: NT1, NT2 → KOUN_MOM
UPDATE users SET unit = 'KOUN_MOM' WHERE unit IN ('NT1', 'NT2');

-- 4. Users: BAN_CO_GIOI còn lại (admin, CB không rõ KLH) → KOUN_MOM
UPDATE users SET unit = 'KOUN_MOM' WHERE unit IN ('BAN_CO_GIOI', 'XN_BO', 'TT_BTSC');

-- 5. Vehicles: theo complexCode
UPDATE vehicles SET unit = 'SNOUL' WHERE unit IN ('NT1','NT2','BAN_CO_GIOI','XN_BO','TT_BTSC') AND complex_code = 'SNOUL';
UPDATE vehicles SET unit = 'NAM_LAO' WHERE unit IN ('NT1','NT2','BAN_CO_GIOI','XN_BO','TT_BTSC') AND complex_code = 'NAM_LAO';
UPDATE vehicles SET unit = 'KOUN_MOM' WHERE unit IN ('NT1','NT2','BAN_CO_GIOI','XN_BO','TT_BTSC');

-- 6. Production plans
UPDATE production_plans SET unit = 'KOUN_MOM' WHERE unit IN ('NT1','NT2','BAN_CO_GIOI','XN_BO','TT_BTSC');

-- 7. Dispatch orders
UPDATE dispatch_orders SET unit = 'KOUN_MOM' WHERE unit IN ('NT1','NT2','BAN_CO_GIOI','XN_BO','TT_BTSC');

-- 8. Transport orders
UPDATE transport_orders SET unit = 'KOUN_MOM' WHERE unit IN ('NT1','NT2','BAN_CO_GIOI','XN_BO','TT_BTSC');

-- 9. Fuel warehouses
UPDATE fuel_warehouses SET unit = 'KOUN_MOM' WHERE unit IN ('NT1','NT2','BAN_CO_GIOI','XN_BO','TT_BTSC');

-- 10. Agricultural implements
UPDATE agricultural_implements SET unit = 'KOUN_MOM' WHERE unit IN ('NT1','NT2','BAN_CO_GIOI','XN_BO','TT_BTSC');

-- 11. Scheduling policies: update/upsert cho unit mới
-- Giữ nguyên BAN_CO_GIOI policy → copy sang 3 KLH
INSERT IGNORE INTO scheduling_policies (unit, vehicle_buffer_minutes, driver_buffer_minutes, created_at, updated_at)
SELECT 'KOUN_MOM', vehicle_buffer_minutes, driver_buffer_minutes, NOW(), NOW()
FROM scheduling_policies WHERE unit = 'BAN_CO_GIOI';

INSERT IGNORE INTO scheduling_policies (unit, vehicle_buffer_minutes, driver_buffer_minutes, created_at, updated_at)
SELECT 'SNOUL', vehicle_buffer_minutes, driver_buffer_minutes, NOW(), NOW()
FROM scheduling_policies WHERE unit = 'BAN_CO_GIOI';

INSERT IGNORE INTO scheduling_policies (unit, vehicle_buffer_minutes, driver_buffer_minutes, created_at, updated_at)
SELECT 'NAM_LAO', vehicle_buffer_minutes, driver_buffer_minutes, NOW(), NOW()
FROM scheduling_policies WHERE unit = 'BAN_CO_GIOI';

INSERT IGNORE INTO scheduling_policies (unit, vehicle_buffer_minutes, driver_buffer_minutes, created_at, updated_at)
SELECT 'TOAN_KLH', vehicle_buffer_minutes, driver_buffer_minutes, NOW(), NOW()
FROM scheduling_policies WHERE unit = 'BAN_CO_GIOI';
